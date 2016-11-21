<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>谷粒网</title>
<link href="css/base.css" type="text/css" rel="stylesheet">
<link href="css/layout.css" type="text/css" rel="stylesheet">
<link href="css/dig.css" type="text/css" rel="stylesheet">
<link href="../ExtJS/resources/css/ext-all.css" type="text/css" rel="stylesheet">
<style type="text/css">
#result{ width:auto; position: absolute; right:0; top:0}
#result img{ width:30px; height:30px; border-radius:50px}
input:focus{ outline:none}
.close{ position:absolute; display:none}
.reg-wrapper li i:after{ height:34px; line-height:34px;content: "\f3d3"; font-size:1.2em;float:right; margin-right:2%; color:#aaa}
.reg-wrapper li textarea{width:64%;float:right;  border:none; margin-right:6%; font-size:1.1em; padding-bottom:2%;  font-weight:normal}

#uploadImg{ width:69%; height:34px; float:left; position:relative; font-size:12px; overflow:hidden}
#uploadImg a{ display:block; text-align:right;  height:34px; line-height:34px; font-size:1.4em; color:#aaa}
#file_input{ width:auto; position:absolute; z-index:100; margin-left:-180px; font-size:60px;opacity:0;filter:alpha(opacity=0); margin-top:-5px;}
</style>
</head>

<body>
<form action="editCus.action" method="post">
<input type="hidden" name="customerid" value="${requestScope.customer.customerid }">
<div class="reg-wrapper">
	<ul>
    	<li><span>店铺名称</span> <input name="customershop" type="text" value="${requestScope.customer.customershop }" placeholder="请输入店铺名称"></li>
        <li><span>联系人</span> <input name="customername" type="text" value="${requestScope.customer.customername }" placeholder="请输入联系人"></li>
        <li><span>联系电话</span> <input name="customerphone" type="text" value="${requestScope.customer.customerphone }" placeholder="请输入联系电话"></li>
        <li>
        	<span>店铺照片</span> 
        	<div id="uploadImg">
                <input type="file" id="file_input" />
                <a href="#" id="clo">点击上传</a> 
                <span id="result">
                  <!-- 这里显示读取结果 -->
                </span> 
            </div><i></i>
        </li>
        <li><span>所在城市</span> 
			<span style="position:absolute;overflow:hidden;margin-left: 170px;"> 
			<select id="city" style="width:118px;">
				<option></option>
				<c:forEach items="${requestScope.cityList }" var="cyty">
					<option>${cyty.cityname }</option>
				</c:forEach>
			</select>
			</span><i></i> 
			<span style="position:absolute;display: table;">
				<input id="customercity" name="customercity" type="text" value="${requestScope.customer.customercity }" 
				placeholder="请输入城市" style="width:118px;margin-left: 200px;">
			</span>
			</li>
			<li><span>服务区域</span> 
			<span style="position:absolute;overflow:hidden;margin-left: 170px;"> 
			<select id="xian" style="width:118px;">
				<option></option>
			</select>
			</span><i></i> 
			<span style="position:absolute;display: table;">
				<input id="customerxian" name="customerxian" type="text" value="${requestScope.customer.customerxian }" 
				placeholder="请输入地区" style="width:118px;margin-left: 200px;">
			</span>
			</li>
        <li><span>店铺地址</span> <input name="customeraddress" type="text" value="${requestScope.customer.customeraddress }"
         placeholder="请输入店铺地址"></li>
    </ul>
</div>

<div class="confirm-reg">
	<a onclick="doedit()" class="confirm-reg-btn">保存修改</a>
</div>
</form>
<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="meg">是否现在登录?</p>
            <a class="cd-popup-close">确定</a>
		</div>
	</div>
</div>
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="../ExtJS/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ExtJS/ext-all.js"></script>
<script type="text/javascript" src="../ExtJS/ext-lang-zh_CN.js" charset="UTF-8"></script>
<script type="text/javascript">
$(function(){
	$("#city").change(function(){
		var city = $("#city").val();		//得到城市复选框的值
		$("#city").val("");					//将城市复选框清空
		$("#customercity").val(city);		//将城市输入框的值变为城市复选框的值
		Ext.Ajax.request({
			//通过ajax查询到地区复选框的值
			url:"querycity.action",
			method:"POST",
			params:{
				"cityname":city
			},
			success:function(response,option){
				var result = response.responseText;			//得到返回的文本信息
				var $result = Ext.util.JSON.decode(result);	//转化为json对象
				$("#xian").empty();							//清空
				var $option = $("<option></option>");		//添加第一个option
				$("#xian").append($option);
				for (var i=0; i<$result.length;i++ ){
					var city = $result[i];
					$option = $("<option>"+city.cityname+"</option>");
					$("#xian").append($option);
				}
			},
			failure:function(response,option){
				Ext.Msg.alert("提示","网络出现问题,请稍后再试");
			}
		});
	});
	$("#xian").change(function(){
		var xian = $("#xian").val();
		$("#xian").val("");
		$("#customerxian").val(xian);
	});
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		$(this).removeClass("is-visible");	//移除'is-visible' class
	});
})
function doedit(){
	var count = 0;
	var alt;
	$("input").each(function(i,item){
		if($(item).val() == null || $(item).val() == ''){
			if($(item).attr("id") != "file_input"){
				count++;
				alt=$(item).attr("placeholder");
				return false;
			}
		}
	});
	if(count > 0){
		$(".meg").text(alt);		//修改弹窗信息
		$(".cd-popup").addClass("is-visible");	//弹出窗口
		return;
	}
	//$(".meg").text("以保存修改");		//修改弹窗信息
	//$(".cd-popup").addClass("is-visible");	//弹出窗口
	document.forms[0].submit();
}
var result = document.getElementById("result");
var input = document.getElementById("file_input");
/*function alertMsg()
  {
  document.getElementById("result").innerHTML = "";
  document.getElementById("clo").innerHTML = "点击上传";
  }*/
if(typeof FileReader === 'undefined'){
	result.innerHTML = "抱歉，你的浏览器不支持 FileReader";
	input.setAttribute('disabled','disabled');
}else{
	input.addEventListener('change',readFile,false);
}
			
function readFile(){
	var file = this.files[0];
	if(!/image\/\w+/.test(file.type)){
		alert("请确保文件为图像类型");
		return false;
	}
	var reader = new FileReader();
	reader.readAsDataURL(file);
	reader.onload = function(e){
		result.innerHTML = '<img src="'+this.result+'" alt=""/><div class="close" onclick="alertMsg()" style="display:none">×</div>'
		document.getElementById("clo").innerHTML = "";
	}
}
</script>
</body>
</html>