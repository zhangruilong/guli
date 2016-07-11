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
	<div class="wapper-nav"><a href='mine.jsp' class='goback'></a>
	地址管理</div>
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
