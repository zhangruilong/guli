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
<link href="../css/base.css" type="text/css" rel="stylesheet">
<link href="../css/layout.css" type="text/css" rel="stylesheet">
</head>

<body>
<div class="reg-wrapper">
	<ul>
    	<li><span>收件人</span> <input name="addressconnect" type="text" placeholder="请输入联系人名" /></li>
        <li><span>手机号</span> <input name="addressphone" type="text" placeholder="请输入手机号" /></li>
    </ul>
</div>
<div class="reg-wrapper reg-dianpu-info">
	<ul>
    	<li><span>所在城市</span> <select id="city">
			</select><i></i></li>
        <li><span>所在区域</span> <select  id="xian">
			</select><i></i></li>
        <li><span>详细地址</span> <input id="detaAddressa" type="text" placeholder="请输入详细地址"></li>
    </ul>
</div>
<div class="reg-wrapper">
	<ul>
    	<li><label><input name="addressture" type="checkbox" value="1" class="set-default" style="margin-top: 3px;"> <span>设置默认</span></label></li>
    </ul>
</div>
<div class="add-address-btn">
	<a onclick="javascript:history.go(-1)" >返回</a>
    <a onclick="addAddress()">保存</a>
</div>
<script src="../js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
	function addAddress(){
		var city = $("#city").text();
		var xian = $("#xian").text();
		var detaAddressa = $("#detaAddressa").val();
		var addressture = "0";
		if($("[name='addressture']:checkbox").get(0).checked){
			addressture = '1';
		}
		$.ajax({
			url:"GLAddressAction.do?method=insertCusAdd",
			type:"post",
			data:{
				json:'[{"addressconnect":"'+$("input[name='addressconnect']").val()+
				'","addressphone":"'+$("input[name='addressphone']").val()+
				'","addressaddress":"'+city+xian+detaAddressa+
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
	$(function(){
		$.ajax({
			url:"GLCityAction.do?method=selAll",
			type:"post",
			data:{
				wheresql:"cityparent='root'"
			},
			success:function(resp){
				var data = JSON.parse(resp).root;
				$("#city option").remove();
				$.each(data,function(i,item){
					$("#city").append('<option value="'+item.cityid+'">'+item.cityname+'</option>');
				});
				cityChaEve()
			},
			error: function(resp){
				var respText = eval('('+resp+')'); 
				alert(respText.msg);
			}
		});
	})
	//绑定更换城市时的事件
	function cityChaEve(){
		$("#city").change(function(){
			 $.ajax({
  			   url:"GLCityAction.do?method=selAll",
  			   type:"post",
  			   data:{
  				   wheresql:"cityparent='"+$(this).val()+"'"
  			   },
  			   success:function(resp){
  				   var data = JSON.parse(resp).root;
 				   $("#xian option").remove();
  				   $.each(data,function(i,item){
  					   $("#xian").append('<option>'+item.cityname+'</option>');
  				   });
  			   },
  			   error: function(resp){
  					var respText = eval('('+resp+')'); 
  					alert(respText.msg);
  			   }
  		   });
		});
	}
</script>
</body>
</html>







