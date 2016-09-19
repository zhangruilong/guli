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
<div class="reg-wrapper">
	<ul>
    	<li><span>收件人</span> <input value=""  name="addressconnect" type="text" placeholder="请输入联系人名" /></li>
        <li><span>手机号</span> <input value="" name="addressphone" type="text" placeholder="请输入手机号" /></li>
    </ul>
</div>
<div class="reg-wrapper reg-dianpu-info">
	<ul>
        <li><span>详细地址</span> <input name="addressaddress" value="" id="detaAddressa" type="text" placeholder="请输入详细地址"></li>
    </ul>
</div>
<div class="reg-wrapper">
	<ul>
    	<li><label><input style="margin-top: 4px;" name="addressture" type="checkbox" value="1" class="set-default" > 
    	<span>设置默认</span></label></li>
    </ul>
</div>
<input type="hidden" name="addressid" value=""> 
<div class="add-address-btn">
	<a onclick="delAddress()">删除</a>
    <a onclick="saveAddress()">保存</a>
</div>
<script src="../js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
$(function(){
	$.ajax({
		url:"GLAddressAction.do?method=selAll",
		type:"post",
		data:{
			wheresql:"addressid='${param.id}'"
		},
		success:function(resp){
			var data = JSON.parse(resp).root[0];
			$("input[name='addressconnect']").val(data.addressconnect);
			$("input[name='addressphone']").val(data.addressphone);
			$("input[name='addressaddress']").val(data.addressaddress);
			$("input[name='addressid']").val(data.addressid);
			if(data.addressture == '1'){
				$("[name='addressture']:checkbox").attr("checked",true);
			}
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
});
//保存地址
function saveAddress(){
	var addressture = "0";
	if($("[name='addressture']:checkbox").get(0).checked){
		addressture = '1';
	}
	if(!$("input[name='addressconnect']").val()){
		alert("联系人名不能为空!");
		return;
	}
	if(!$("input[name='addressphone']").val()){
		alert("手机号不能为空!");
		return;
	}
	if(!$("input[name='addressaddress']").val()){
		alert("详细地址不能为空!");
		return;
	}
	$.ajax({
		url:"GLAddressAction.do?method=updCusAdd",
		type:"post",
		data:{
			json:'[{"addressid":"'+$("input[name='addressid']").val()+
				'","addressconnect":"'+$("input[name='addressconnect']").val()+
				'","addressphone":"'+$("input[name='addressphone']").val()+
				'","addressaddress":"'+$("input[name='addressaddress']").val()+
				'","addresscustomer":"'+customer.customerid+
				'","addressture":"'+addressture+
				'"}]'
		},
		success:function(resp){
			var respText = eval('('+resp+')');
			alert(respText.msg);
			history.go(-1);
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
}
//删除地址
function delAddress(){
	$.ajax({
		url:"GLAddressAction.do?method=delAll",
		type:"post",
		data:{
			json:'[{"addressid":"'+$("input[name='addressid']").val()+'"}]'
		},
		success:function(resp){
			var respText = eval('('+resp+')');
			alert(respText.msg);
			history.go(-1);
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
}
</script>
</body>
</html>







