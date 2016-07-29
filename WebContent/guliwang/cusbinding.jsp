<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!doctype html> 
<html>
<head>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>谷粒网</title>
<link href="../css/base.css" type="text/css" rel="stylesheet">
<link href="../css/layout.css" type="text/css" rel="stylesheet">
<link href="../css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">
</style>
</head>

<body>
<div class="gl-box budan-page">
	<div class="home-search-wrapper">
        <input type="text" placeholder="请输入客户名称" onkeydown="entersearch(this);">
    </div>
    <ul id="customerlist">
    	<!-- <li><span hidden="ture">2121</span>
    	<a class="cd-popup-trigger"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cd-popup-trigger"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cd-popup-trigger"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cd-popup-trigger"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li> -->
    </ul>
</div>

<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p>您确定要为其补单吗?</p>
            <a href="#" class="cd-popup-close">取消</a><a href="goodsclass.jsp">确定</a>
		</div>
	</div>
</div>
<script src="../js/jquery-1.8.3.min.js"></script>
<script>
var customer = JSON.parse(window.localStorage.getItem("customer"));
jQuery(document).ready(function($){
	$.ajax({
		url:"CompanyviewAction.do?method=selAll",
		type:"post",
		data:{
			wheresql:"cityname='"+customer.customercity+"'"
		},
		success:function(resp){
			var data = eval('('+resp+')');
			$.each(data.root,function(i,item){
				$(".budan-page ul li").remove();
				$(".budan-page ul").append('<li><a class="cd-popup-trigger"><img src="images/mendian.jpg" > <h2>大福超市</h2><span>王大宝 15865456465</span></a></li>');
			});
		},
		error : function(resp){
			var respText = eval('('+resp+')');
			alert(respText.msg);
		}
	});
});
</script>
</body>
</html>
