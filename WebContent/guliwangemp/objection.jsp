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
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>

</head>

<body>
<form action="feedbackof.action" method="post">
<input id="feedbackcustomer" type="hidden" name="feedbackcustomer" value="">
<div class="view-box">
<div class="wapper-nav">意见反馈</div>
<textarea id="feedbackdetail" name="feedbackdetail" cols="" rows="" placeholder="请输入您的反馈意见（字数200字以内）"></textarea>
<a onclick="subform()" class="view-tj">提交</a>
</div>
</form>
<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="meg">意见内容不能为空</p>
            <a class="cd-popup-close">确定</a>
		</div>
	</div>
</div>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
$(function(){
	$("#feedbackcustomer").val(customer.customerid);
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		$(this).removeClass("is-visible");	//移除'is-visible' class
	});
})
function subform(){
	var feedbackdetail = $("#feedbackdetail").val();
	if(feedbackdetail == null || feedbackdetail ==""){
		$(".cd-popup").addClass("is-visible");	//弹出窗口
		return;
	}
	document.forms[0].submit();
}
</script>
</body>
</html>