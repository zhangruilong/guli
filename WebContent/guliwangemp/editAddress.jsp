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
<form action="editAddress.action" method="post">
<div class="reg-wrapper">
	<ul>
    	<li><span>收件人</span> <input value="${requestScope.address.addressconnect }"  name="addressconnect" type="text" placeholder="请输入联系人名" /></li>
        <li><span>手机号</span> <input value="${requestScope.address.addressphone }" name="addressphone" type="text" placeholder="请输入手机号" /></li>
    </ul>
</div>
<div class="reg-wrapper reg-dianpu-info">
	<ul>
        <li><span>详细地址</span> <input name="addressaddress" value="${requestScope.address.addressaddress }" id="detaAddressa" type="text" placeholder="请输入详细地址"></li>
    </ul>
</div>
<div class="reg-wrapper">
	<ul>
    	<li><label><input name="addressture" type="checkbox" value="1" class="set-default" ${requestScope.address.addressture == 1?'checked':'' }> 
    	<span>设置默认</span></label></li>
    </ul>
</div>
<input type="hidden" id="addressid" name="addressid" value="${requestScope.address.addressid }">
<input type="hidden" id="addresscustomer" name="addresscustomer" value="${sessionScope.customer.customerid }">
    <input type="hidden" id="customerId" name="customerId" value="${sessionScope.customer.customerid }">
<div class="add-address-btn">
	<a onclick="javascript:document.forms[0].action = 'delAddress.action';document.forms[0].submit();">删除</a>
    <a onclick="addAddress()">保存</a>
</div>
</form>
<script src="js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
$(function(){
	$("#addresscustomer").val(customer.customerid);
	$("#customerId").val(customer.customerid);
});
	function addAddress(){
		document.forms[0].submit();
	}
</script>
</body>
</html>







