<?php
// https://dev-pc.abc.com/deploy?type=s1&url=https://rust-1251942975.cos.na-siliconvalley.myqcloud.com/xxx-xxx-20231026095240.tar.gz
$token = $_GET['token'];
$type = $_GET['type'];
$url = $_GET['url'];

//if ($token != 'xxxx') {
//    echo 'token error';
//    die;
//}

if (!function_exists('shell_exec')) {
    echo 'function shell_exec not exist';
    die;
}

$script_path = __DIR__ . '/deploy_spa.sh';
$command = "$script_path $type $url 2>&1";
// $command = "$script_path $type $url";

echo $command;
echo '<br />';

$ret = shell_exec($command);

var_dump($ret);