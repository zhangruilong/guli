<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html> 
<html>
<head>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<!-- 禁止微信内置浏览器缓存 -->
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>谷粒网</title>
<link href="css/base.css" type="text/css" rel="stylesheet">
<link href="css/layout.css" type="text/css" rel="stylesheet">
<link href="css/dig.css" type="text/css" rel="stylesheet">
</head>

<body>
<div class="gl-box">
	<div class="wapper-nav">我的</div>
    <div style="width:100%; padding:5% 0; color:#fff; text-align:center; background:url(images/minebg.jpg)">
    	<img src="images/mendian.jpg" style="border-radius:50px;" width="70" height="70 ">
        <p id="myshopname"></p>
    </div>
	<div class="personal-center">
    	
        	<a id="a_myshop" href="">我的店铺 <span class="sign"></span></a>
        	<a id="a_mycollect" href="">我的收藏 <span class="sign"></span></a>
        <a href="#">我的谷币 <span class="sign"></span></a>
        	<a id="a_address" href="">收货地址 <span class="sign"></span></a>
    </div>
    <div class="personal-center">
    	<a href="#">谷粒客服 <span class="sign"></span></a>
        <a href="objection.jsp">意见反馈 <span class="sign"></span></a>
    </div>
</div>
<div class="personal-center-nav">
    	<ul>
        	<li><a href="index.jsp">
        	<em class="ion-home"></em>首页</a></li>
            <li><a href="goodsclass.jsp"><em class="ion-bag"></em>商城</a></li>
            <li><a href="order.jsp"><em class="ion-clipboard"></em>订单</a></li>
            <li class="active"><a href="customerlist.jsp"><em class="ion-android-person"></em>客户</a></li>
        </ul>
    </div>
<script src="js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
$(function(){
	$("#myshopname").text(customer.customershop);
	$("#a_myshop").attr("href","doEditCus.action?customerid="+customer.customerid);
	$("#a_mycollect").attr("href","doCollect.action?comid="+customer.customerid);
	$("#a_address").attr("href","doAddressMana.action?customerId="+customer.customerid);
	$(".cd-popup-trigger").on("click",function(event){
		event.preventDefault();				//防止默认事件发生
		$(".cd-popup").addClass("is-visible");
	});
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		if($(event.target).is(".cd-popup-close") || $(event.target).is(".cd-popup-container")){
			//如果点击的是'取消'或者除'确定'外的其他地方
			$(this).removeClass("is-visible");	//移除'is-visible' class
			
		}
	});
})
</script>
</body>
</html>
