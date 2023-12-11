#!/bin/bash
# deploy
# command: ./deploy_spa.sh s1 https://rust-1251942975.cos.na-siliconvalley.myqcloud.com/rust-ssr-20231026095240.tar.gz

# ------ Config -----
WORK_DIR='/www/wwwroot'

# 1. Fetch url
# https://dev-pc.abc.com/deploy?type=s1&url=https://rust-1251942975.cos.na-siliconvalley.myqcloud.com/rust-ssr-20231026095240.tar.gz
v=$1
download_url=$2

DEPLOY_DIR="$WORK_DIR/$v.dev-pc.abc.com"

# 2. Extract files
[ -d "$DEPLOY_DIR" ] || mkdir -p $DEPLOY_DIR
cd $DEPLOY_DIR

rm -rf $DEPLOY_DIR/dist.bak
mkdir -p $DEPLOY_DIR/dist.bak

shopt -s extglob
mv !(dist.bak|dist.tar.gz) $DEPLOY_DIR/dist.bak

curl $download_url -o dist.tar.gz
tar -zxvf dist.tar.gz -C $DEPLOY_DIR


if [ -d "$DEPLOY_DIR/public" ]
then
	mv public/* ./ && rm -rf public
else
	exit 0
fi

# 3. lark robot
# 定义目标URL
url="https://open.larksuite.com/open-apis/bot/v2/hook/245d7xda-3ed4-xxxx-847a-748x83xcb737"

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