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
<link href="../css/base.css" type="text/css" rel="stylesheet">
<link href="../css/layout.css" type="text/css" rel="stylesheet">
</head>

<body>
<div class="gl-box">
	<div class="wapper-nav"><a href='mine.jsp' class='goback'></a>
	地址管理</div>
	<div class="add-admin">
    </div>
    <div class="add-address">
		<a href="addAddress.jsp">+ 新增收货地址</a>
	</div>
</div>
<script src="../js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){
	$.ajax({
		url:"GLAddressAction.do?method=cusAddress",
		type:"post",
		data:{
			wheresql:"addresscustomer='"+customer.customerid+"'",
			order:"addressture desc",
			customerxian: customer.customerxian
		},
		success:function(resp){
			var data = JSON.parse(resp).root;
			$.each(data,function(i,item){
				var isDF = item.addressture == '1'?'[默认] ':'';
				$(".add-admin").append('<a href="editAddress.jsp?id='+item.addressid+'"><span>'+item.addressconnect+'</span><span>  '+item.addressphone+' </span><span class="sign"></span>'+isDF+'收货地址:  '+item.addressaddress+'</a>');
			});
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
});
</script>
</body>
</html>
