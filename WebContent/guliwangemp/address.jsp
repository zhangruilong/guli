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
<title>谷粒网</title>
<link href="css/base.css" type="text/css" rel="stylesheet">
<link href="css/layout.css" type="text/css" rel="stylesheet">
<style type="text/css">
.p-a{
	float: left;
	width: 20%;
	position: relative; 
	background-color: #2c77e6; 
	height: 30px; 
	line-height: 30px; 
	color: #fff ; 
	text-align: center ;
}
.p-a a{
	position: static;
	height: 50px; 
	line-height: 20px; 
	text-align: center ;
	font-size: 20px;
}
.pp{
	width: 80%;
}
.wapper-nav{
	padding: 10px 10px 10px 0px ;
}
</style>
</head>

<body>
<div class="gl-box">
	<div class="wapper-nav"><p class="p-a">
	<a href="mine.jsp" >&lt;返回</a></p>
	<p class="pp">地址管理</p></div>
	<div class="add-admin">
		<c:forEach items="${requestScope.addressList }" var="address">
			<a href="doEditAddress.action?addressid=${address.addressid }"><span>${address.addressconnect }</span><span>  ${address.addressphone } </span><span class="sign"></span>${address.addressture == 1?'[默认]':'' }收货地址: ${address.addressaddress } </a>
		</c:forEach>
    </div>
    <div class="add-address">
		<a href="doAddAddress.action">+ 新增收货地址</a>
	</div>
</div>
<script src="js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	
</script>
</body>
</html>
