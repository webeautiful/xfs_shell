const http = require('http');
const url = require('url');
const { exec } = require('child_process');

const hostname = '127.0.0.1';
const port = 5000;

/**
 * 获取指定时区的时间
 * @param offset 时区
 * @returns {Date} 指定时区的时间信息
 */
function getZoneTime(offset) {
  // 取本地时间
  const localtime = new Date();
  // 取本地毫秒数
  const localmesc = localtime.getTime();
  // 取本地时区与格林尼治所在时区的偏差毫秒数
  const localOffset = localtime.getTimezoneOffset() * 60000;
  // 反推得到格林尼治时间
  const utc = localOffset + localmesc;
  // 得到指定时区时间
  const calctime = utc + (3600000 * offset);
  return new Date(calctime).toLocaleString();
}

function genConfig(spa) {
  const prefix = spa ? 's' : 'v';
  const sPort = spa ? 6001 : 5001;
  const cfg = {};
  [...new Array(10).keys()].forEach(v => cfg[`${prefix}${v+1}`] = {v: `${prefix}${v+1}`, port: sPort+v, sign: v === 0 ? `${prefix}8899` : undefined });
  return cfg;
}

async function deploySPA(cfg, downloadUrl) {
  const command = `cd /root/Project-deploy && ./deploy_spa.sh ${cfg.v} ${downloadUrl}`;
  const { stdout } = await exec(command);
  console.log(`[${getZoneTime(8)}]`,`[${cfg.v}]`, downloadUrl,"\n");
}

async function deploy(cfg, downloadUrl) {
  const command = `cd /root/Project-deploy && ./deploy.sh ${cfg.v} ${cfg.port} ${downloadUrl}`;
  const { stdout } = await exec(command);
  console.log(`[${getZoneTime(8)}]`,`[${cfg.v} ${cfg.port}]`, downloadUrl,"\n");
}

const server = http.createServer((req, res) => {
  res.setHeader("Content-Type", 'text/html; charset=utf-8');
  const { query } = url.parse(req.url, true);

  const downloadUrl = query.url || '';
  if (!downloadUrl.endsWith('.tar.gz')) {
    return res.end('err: 参数url必须为*.tar.gz文件下载地址');
  }

  const type = query.type;
  const spa = type.startsWith('s');
  const VERSION_CONFIG = genConfig(spa);
  const cfg = VERSION_CONFIG[type];
  if (!cfg) {
    return res.end('err: 参数type必须在[v|s]1-[v|s]10之间');
  }
  if (cfg.sign) {
    if (cfg.sign !== query.sign) {
      return res.end('err: sign校验失败');
    }
  }

  if (spa) {
    deploySPA(cfg, downloadUrl);
  } else {
    deploy(cfg, downloadUrl);
  }

  res.statusCode = 200;
  res.end(`ok: [${getZoneTime(8)}][${cfg.v} ${cfg.port}] ${downloadUrl}`);
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
