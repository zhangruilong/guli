<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%> 
<% 
String path = request.getContextPath(); 
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; 
%> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> 
<html> 
<head> 
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>谷粒网</title>
<style type="text/css">  
body{
	height: 100%;
	padding-top: 25%;
}
#preview, .img, img  {  
	width:200px;  
	height:200px;  
	border-radius: 50%; 
}  
#preview  {  
	margin:0 auto;
	border:1px solid #000; 
	border-radius: 50%; 
}  
.div1{
	box-sizing: border-box;
	padding: 1px 6px;
	float: left;
	height: 41px;
	width: 144px;
	background: #2C77E6;
	position:relative;
	border-radius: 8px;
}

.div2{
	color:white;
	text-align:center;
	padding-top:12px;
	font-size:15px;
	border-radius: 8px;
}

.select_file{
    cursor: pointer;
    font-size: 30px;
    outline: medium none;
    filter:alpha(opacity=0);
    -moz-opacity:0;
    left:0px;
    top: 0px;
    /* 位置和透明度设置 */
    width: 144px;
    height: 41px;
    position: absolute;
    opacity:0; 				
}
.div1:last-child{ float:right}
.btn_line{
	margin-top: 8%;
	padding: 4%;
}
</style>  

</head> 

<body>
<div id="preview" onclick="selectFile()"></div>
<form action="Upload" method="post" enctype="multipart/form-data">
<input class="select_file" type="file" name="fileName" onchange="preview(this)" />
<div class="btn_line">
	<div class="div1">
    	<div class="div2">确定</div>
		<input class="select_file" onclick="uploadimg()" type="button" value="上传"/> 
	</div>
	<div class="div1">
    	<div class="div2" onclick="javascript:history.go(-1)">取消</div>
	</div>
</div>
</form>
<script src="../js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
function uploadimg(){
	if($("[name='fileName']").val() != null && $("[name='fileName']").val() != ''){
		 $('form').attr('action','System_attachAction.do?method=uploadImg&other=getch&json='+'[{"code":"bianma","detail":"","classify":"客户","fid":"'+customer.customerid+',"}]');
		 document.forms[0].submit();
	} else {
		alert("请选择要上传的图片");
	}
}
function selectFile(){
	$("[name='fileName']").trigger("click");
}
function preview(file)  {  
var prevDiv = document.getElementById('preview');  
	if (file.files && file.files[0])  {  
		var reader = new FileReader();  
			reader.onload = function(evt){  
			prevDiv.innerHTML = '<img src="' + evt.target.result + '" />';  
		}    
		reader.readAsDataURL(file.files[0]);  
	}  else    {  
		prevDiv.innerHTML = '<div class="img" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src=\'' + file.value + '\'"></div>';  
	}  
}  
</script>
</body>
</html>