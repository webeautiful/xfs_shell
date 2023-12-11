#!/bin/bash
# deploy
# command: ./deploy.sh v1 5001 https://rust-1251942975.cos.na-siliconvalley.myqcloud.com/rust-ssr-20231026095240.tar.gz

# ------ Config -----
WORK_DIR='/root/project-deploy'

# 1. Fetch url
# https://dev-pc.abc.com/deploy?type=v1&url=https://rust-1251942975.cos.na-siliconvalley.myqcloud.com/rust-ssr-20231026095240.tar.gz
v=$1
port=$2
download_url=$3

DEPLOY_DIR="$WORK_DIR/$v"

# 2. Extract files
[ -d "$DEPLOY_DIR" ] || mkdir -p $DEPLOY_DIR
cd $DEPLOY_DIR
curl $download_url -o dist.tar.gz

[ -d "$DEPLOY_DIR/dist.bak" ] && rm -rf $DEPLOY_DIR/dist.bak
[ -d "$DEPLOY_DIR/dist" ] && mv $DEPLOY_DIR/dist $DEPLOY_DIR/dist.bak
[ -d "$DEPLOY_DIR/dist" ] || mkdir -p $DEPLOY_DIR/dist

tar -zxvf dist.tar.gz -C $DEPLOY_DIR/dist

# 3. start
grep '^module.exports = {' ecosystem.config.js >/dev/null 2>&1 || cat >> ecosystem.config.js <<PM2CONFIG
module.exports = {
  apps: [
    {
      name: 'Project-$v',
      port: '$port',
      exec_mode: 'cluster',
      instances: '3',
      script: './dist/server/index.mjs',
      env: {
        'NUXT_APP_BASE_URL': '/'
      }
    }
  ]
}
PM2CONFIG

pm2 restart ecosystem.config.js
pm2 save

# 4. lark robot
# 定义目标URL
url="https://open.larksuite.com/open-apis/bot/v2/hook/245d7cda-3ed4-4915-847a-748a83acb737"

# 定义要发送的数据，使用 -d 参数
# 多行 JSON 字符串中包含变量
data=$(cat <<EOF
{
	"msg_type": "interactive",
	"card": {
		"elements": [
			{
				"tag": "div",
				"text": {
					"content": "部署成功,访问链接: http://$v.dev-pc.abc.com",
					"tag": "plain_text"
				}
			},
			{
				"tag": "action",
				"actions": [{
						"tag": "button",
						"text": {
							"tag": "plain_text",
							"content": "查看日志"
						},
						"type": "primary",
						"multi_url": {
							"url": "https://github.com/project-code/abc-pc/actions",
							"pc_url": "",
							"android_url": "",
							"ios_url": ""
						}
					},
					{
						"tag": "button",
						"text": {
							"tag": "plain_text",
							"content": "代码详情"
						},
						"type": "default",
						"multi_url": {
							"url": "https://github.com/project-code/abc-pc",
							"pc_url": "",
							"android_url": "",
							"ios_url": ""
						}
					}
				]
			}
		],
		"header": {
			"template": "blue",
			"title": {
				"content": "【测试】Project-$v 部署成功",
				"tag": "plain_text"
			}
		}
	}
}
EOF
)


# 发送 POST 请求
response=$(curl -X POST -H "Content-Type: application/json" -d "$data" "$url")

# 打印服务器响应
echo "服务器响应:"
echo "$response"