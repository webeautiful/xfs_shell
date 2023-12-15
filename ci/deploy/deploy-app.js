/**
 * http://localhost:5000?app=app1&type=s1&url=https://rust-1251942975.cos.na-siliconvalley.myqcloud.com/rust-ssr-20231026095240.tar.gz
 *
 * @query - app: app1,app2
 * @query - type: spa(v[0-9]), ssr(s[0-9])
 * @query - url: 下载地址
 * @query - sign: type为v1/s1代表生产环境，必须校验sign
 */
const http = require('http');
const url = require('url');
const { exec } = require('child_process');
const util = require('util');

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

const DEPLOY_CONFIG = {
  app1: {
    spa: null,
    ssr: {
      cmd: 'cd /xxx/deploy-app && ./app1_ssr.sh %s %s %s',
      startPort: 3001,
    }
  },
  app2: {
    spa: {
      cmd: 'cd /xxx/deploy-app && ./app2_spa.sh %s %s %s',
      startPort: 0,
    },
    ssr: {
      cmd: 'cd /root/deploy-app && ./app2_ssr.sh %s %s %s',
      startPort: 5001,
    }
  }
}

function genArgs(spa, startPort) {
  const prefix = spa ? 's' : 'v';
  const cfg = {};
  [...new Array(10).keys()].forEach(v => cfg[`${prefix}${v+1}`] = {v: `${prefix}${v+1}`, port: startPort === 0 ? 0 : startPort+v, sign: v === 0 ? `${prefix}8899` : undefined });
  return cfg;
}

function genConfig(app, spa) {
  const cfg = DEPLOY_CONFIG[app]
  if (!cfg) return null;
  const type = spa ? 'spa' : 'ssr'
  if (!cfg[type]) return null;
  const { cmd, startPort } = cfg[type]
  return {
    cmd,
    args: genArgs(spa, startPort)
  }
}

async function deploy(command) {
  const { stdout } = await exec(command);
  console.log(`[${getZoneTime(8)}] ${command}`,"\n");
}

const server = http.createServer((req, res) => {
  res.setHeader("Content-Type", 'text/html; charset=utf-8');
  const { query } = url.parse(req.url, true);

  const downloadUrl = query.url || '';
  if (!downloadUrl.endsWith('.tar.gz')) {
    return res.end('err: 参数url必须为*.tar.gz文件下载地址');
  }

  const app = query.app;
  const type = query.type;
  const spa = type.startsWith('s');
  const VERSION_CONFIG = genConfig(app, spa);
  if (!VERSION_CONFIG) {
    return res.end(`err: 参数app错误`);
  }
  const cfg = VERSION_CONFIG.args[type];
  if (!cfg) {
    return res.end('err: 参数type必须在[v|s]1-[v|s]10之间');
  }
  if (cfg.sign) {
    if (cfg.sign !== query.sign) {
      return res.end('err: sign校验失败');
    }
  }

  const command = util.format(VERSION_CONFIG.cmd, ...[cfg.v, cfg.port, downloadUrl]);
  deploy(command);

  res.statusCode = 200;
  res.end(`ok: [${getZoneTime(8)}][${cfg.v} ${cfg.port}] ${downloadUrl}`);
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
