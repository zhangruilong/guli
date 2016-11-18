<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
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
<link href="../css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">
</style>
</head>

<body>
<div class="gl-box bincompage">
	<div class="wapper-nav">我的供货商</div>
    <ul id="customerlist">
    	<!-- <li><span hidden="ture">2121</span>
    	<a class="cdpa-bdqu"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cdpa-bdqu"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cdpa-bdqu"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cdpa-bdqu"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li> -->
    </ul>
</div>

<!--弹框-->
<!-- <div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p>您确定要为其补单吗?</p>
            <a href="#" class="cd-popup-close">取消</a><a href="goodsclass.jsp">确定</a>
		</div>
	</div>
</div> -->
<script src="../js/jquery-1.8.3.min.js"></script>
<script>
var customer = JSON.parse(window.localStorage.getItem("customer"));
jQuery(document).ready(function($){
	companyload();
});
//模糊查询
function companysearch(obj){
	var event = window.event || arguments.callee.caller.arguments[0];
	 if(event.keyCode == 13){
		 companyload(obj.value)
	 }
}
//查询供应商
function companyload(query){
	var data = { wheresql:"createtime like '%"+customer.customerxian+"%'",customerid:customer.customerid };
	$.ajax({
		url:"GLCompanyviewAction.do?method=bdCityCom",
		type:"post",
		data:data,
		success:function(resp){
			var data = eval('('+resp+')');
			$("#customerlist li").remove();
			//alert(resp);
			if(data.msg != '操作成功'){
				alert('没有可以绑定的经销商.');
				return;
			}
			$.each(data.root,function(i,item){
				var bdstr = '点击绑定';
				if(typeof(item.createtime) != "undefined" && item.createtime == '已绑定'){
					bdstr = item.createtime;
				}
				$(".bincompage ul").append('<li name="'+item.companyid+'"><span class="cdpa-bdqu""><span>'+
					item.companyshop+'</span><br/><span>'+
					item.username+' '+
					item.companyphone+'</span></span><span class="cdpa-delsp">'+bdstr+'<span></li>');
			});
			$(".bincompage ul li").click(bindcom);			//启用按钮
			
		},
		error : function(resp){
			var respText = eval('('+resp+')');
			alert(respText.msg);
		}
	});
}
//解绑定
var remcombind = function(){
	$.ajax({
		url:"GLCcustomerAction.do?method=delCusNexus",
		type:"post",
		data:{
			json:'[{"ccustomercompany":"'+$(this).parent().attr("name")+'","ccustomercustomer":"'+customer.customerid+'"}]'
		},
		success:function(resp){
			var data = eval('('+resp+')');
			alert(data.msg);
			history.go(-1);
		},
		error : function(resp){
			var respText = eval('('+resp+')');
			alert(respText.msg);
		}
	});
}
//绑定
var bindcom = function(){
	var spobj = $(this).children("span:eq(1)");
	if(spobj.text() == '已绑定'){
		alert("已经绑定过了,不能重复绑定!");
		return;
	}
	$(".bincompage ul li").unbind('click');				//禁用按钮
	$.ajax({
		url:"GLCcustomerAction.do?method=addCcus",
		type:"post",
		data:{
			json:'[{"ccustomercompany":"'+$(this).attr("name")+'","ccustomercustomer":"'+customer.customerid+'","ccustomerdetail":"3","creator":"0"}]',
		},
		success:function(resp){
			var data = eval('('+resp+')');
			if(data.code == '202'){
				alert("已成功绑定经销商!");
				window.location.href="index.jsp";
			} else {
				alert('绑定失败,请重新绑定。');
				location.reload();			//启用按钮
			}
		},
		error : function(resp){
			var respText = eval('('+resp+')');
			alert(respText.msg);
			location.reload();			//启用按钮
		}
	});
}
</script>
</body>
</html>
