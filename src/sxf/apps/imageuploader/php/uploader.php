<?php
$destination_folder=""; //上传文件路径
$xmlstr =$GLOBALS[HTTP_RAW_POST_DATA];
if(empty($xmlstr)) $xmlstr = file_get_contents('php://input');
if(!file_exists($destination_folder))
mkdir($destination_folder);

$imgName = $_GET['imgName'];
$imgName2 = explode(".",$imgName);
$jpg = $xmlstr;//得到post过来的二进制原始数据
$imgUrl=$destination_folder.$imgName2[0].time().".jpg";
$file = fopen($imgUrl,"w");//打开文件准备写入
fwrite($file,$jpg);//写入
fclose($file);//关闭
echo $imgUrl;
?>

