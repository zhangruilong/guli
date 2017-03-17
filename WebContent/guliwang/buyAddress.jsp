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
	<div class="wapper-nav">
	<a onclick="javascript:history.back()" class="goback"></a>
	选择地址
	</div>
	<div class="add-admin">
			<!-- <a href="doBuy.action?addressid=${address.addressid }&addresscustomer=${address.addresscustomer }">
			<span>${address.addressconnect }</span><span>  ${address.addressphone } </span><span class="sign">
			</span>${address.addressture == 1?'[默认]':'' }收货地址:${address.addressaddress } </a> -->
    </div>
</div>
<script type="text/javascript" src="../js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
$(function(){
	$.ajax({
		url:"GLAddressAction.do?method=cusAddress",
		type:"post",
		data:{
			wheresql:"addresscustomer='"+customer.customerid+"'",
			order : "addressture desc",
			customerxian: customer.customerxian
		},
		success : function(resp){
			var data = JSON.parse(resp);
			$.each(data.root,function(i,item){
				var moren = item.addressture == '1'?"[默认]":'';
				var jsonitem = JSON.stringify(item);
				$(".add-admin").append('<a href="buy.jsp?address='+encodeURI(jsonitem)+'"><span>'+item.addressconnect+'</span><span>  '+
						item.addressphone+' </span><span class="sign"></span>'+moren+'收货地址:'+item.addressaddress+' </a>');
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
