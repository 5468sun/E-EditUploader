<?php
$imgFullName = $_FILES['Filedata']['name'];
$imgInfo = explode(".",$imgFullName);
$imgName = $imgInfo[0];
$imgExtenstion = $imgInfo[1];
move_uploaded_file($_FILES['Filedata']['tmp_name'], $imgName.time().".".$imgExtenstion);
?>