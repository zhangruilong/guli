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
</head>

<body>
<div class="gl-box">
	<div class="wapper-nav">
	<a onclick="javascript:history.back()" class="goback"></a>
	选择地址
	</div>
	<div class="add-admin">
		<c:forEach items="${requestScope.addressList }" var="address">
			<a href="doBuy.action?addressid=${address.addressid }&addresscustomer=${address.addresscustomer }"><span>${address.addressconnect }</span><span>  ${address.addressphone } </span><span class="sign"></span>${address.addressture == 1?'[默认]':'' }收货地址:${address.addressaddress } </a>
		</c:forEach>
    </div>
</div>
</body>
</html>
