<%@page import="com.server.pojo.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
		if(null != session.getAttribute("customer")){
			Customer customer = (Customer) session.getAttribute("customer");
			response.sendRedirect("doGuliwangIndex.action?city.cityname="+customer.getCustomerxian()+"&cityname="+customer.getCustomercity());
		}
	 %>
<!doctype html> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="format-detection" content="telephone=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

<title>谷粒网</title>
<link href="../css/base.css" type="text/css" rel="stylesheet">
<link href="../css/layout.css" type="text/css" rel="stylesheet">
</head>

<body>
<div class="login-bg">
    <div class="logo"><img src="images/logo.png" ></div>
    <div class="login-content">
<form action="login.action" method="post">
        <ul>
            <li><i class="user"></i> <input name="customerphone" type="text" placeholder="请输入手机号码"></li>
            <li><i class="pass"></i> <input name="customerpsw" type="password" placeholder="请输入密码"></li>
            <li class="nobd"><a onclick="javascript:document.forms[0].submit()" class="login-btn">登录</a></li>
            <li class="goreg"><a href="doReg.action">尚无账号，立即注册</a></li>
        </ul>
</form>
    </div>
</div>
</body>
</html>
