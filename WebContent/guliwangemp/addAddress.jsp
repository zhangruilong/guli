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
<link href="../ExtJS/resources/css/ext-all.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="../ExtJS/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ExtJS/ext-all.js"></script>
<script type="text/javascript" src="../ExtJS/ext-lang-zh_CN.js" charset="UTF-8"></script>
</head>

<body>
<form action="addAddress.action" method="post">
<div class="reg-wrapper">
	<ul>
    	<li><span>收件人</span> <input name="addressconnect" type="text" placeholder="请输入联系人名" /></li>
        <li><span>手机号</span> <input name="addressphone" type="text" placeholder="请输入手机号" /></li>
    </ul>
</div>
<div class="reg-wrapper reg-dianpu-info">
	<ul>
    	<li><span>所在城市</span> <select id="city">
    		<option value="">请选择城市</option>
    		<c:forEach items="${requestScope.cityParents }" var="cyty">
				<option>${cyty.cityname }</option>
			</c:forEach></select><i></i></li>
        <li><span>所在区域</span> <select  id="xian">
        	<option value="">请选择地区</option>
			</select><i></i></li>
        <li><span>详细地址</span> <input id="detaAddressa" type="text" placeholder="请输入详细地址"></li>
    </ul>
</div>
<div class="reg-wrapper">
	<ul>
    	<li><label><input name="addressture" type="checkbox" value="1" class="set-default"> <span>设置默认</span></label></li>
    </ul>
</div>
<input id="addressaddress" type="hidden" name="addressaddress" value="">
<input type="hidden" name="addresscustomer" id="addresscustomer" value="">
    <input type="hidden" name="customerId" id="customerId" value="">
<div class="add-address-btn">
	<a id="add-address-btn-back" >返回</a>
    <a onclick="addAddress()">保存</a>
</div>
</form>
<script src="js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
	function addAddress(){
		
		var city = $("#city").val();
		var xian = $("#xian").val();
		var detaAddressa = $("#detaAddressa").val();
		var addressaddress = $("#addressaddress").val(city+xian+detaAddressa);
		document.forms[0].submit();
	}
	$(function(){
		$("#addresscustomer").val(customer.customerid);
		$("#customerId").val(customer.customerid);
		$("#add-address-btn-back").attr("href","doAddressMana.action?customerId="+customer.customerid);
		$("#city").change(function(){
			var customercity = $("#city").val();
			Ext.Ajax.request({
				url : 'querycity.action',
				method : 'POST',
				params : {
					"cityname" : customercity
				},
				success : function(resp,opts) {
					var result = resp.responseText;
					var $result = Ext.util.JSON.decode(result);
					$("#xian").empty();			//清空select组件内的原始值
					var $option = $("<option value='' >请选择地区</option>");
					$("#xian").append($option);
					for ( var i = 0; i < $result.length; i++) {
						var city = $result[i];
						var $option = $("<option>"+city.cityname+"</option>");
						$("#xian").append($option);
					}
				},
				failure : function(resp,opts) {
					Ext.Msg.alert('提示', '网络出现问题，请稍后再试');
				}
			});
		});	         
	})
</script>
</body>
</html>







