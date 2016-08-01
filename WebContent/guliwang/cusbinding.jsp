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
<title>谷粒网</title>
<link href="../css/base.css" type="text/css" rel="stylesheet">
<link href="../css/layout.css" type="text/css" rel="stylesheet">
<link href="../css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">
</style>
</head>

<body>
<div class="gl-box bincompage">
	<div class="home-search-wrapper">
        <input type="text" placeholder="请输入客户名称" onkeydown="entersearch(this);">
    </div>
    <ul id="customerlist">
    	<!-- <li><span hidden="ture">2121</span>
    	<a class="cdpa-bdqu"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cdpa-bdqu"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cdpa-bdqu"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cdpa-bdqu"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li> -->
    </ul>
</div>

<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p>您确定要为其补单吗?</p>
            <a href="#" class="cd-popup-close">取消</a><a href="goodsclass.jsp">确定</a>
		</div>
	</div>
</div>
<script src="../js/jquery-1.8.3.min.js"></script>
<script>
var customer = JSON.parse(window.localStorage.getItem("customer"));
jQuery(document).ready(function($){
	$.ajax({
		url:"CompanyviewAction.do?method=selAll",
		type:"post",
		data:{
			wheresql:"cityparentname='"+customer.customercity+"'"
		},
		success:function(resp){
			var data = eval('('+resp+')');
			$.each(data.root,function(i,item){
				$(".bincompage ul").append('<li><span class="cdpa-bdqu" name="'+item.companyid+'"><span>'+
					item.companyshop+'</span><br/><span>'+
					item.username+' '+
					item.companyphone+'</span></span></li>');
			});
			$.ajax({
				url:"CcustomerAction.do?method=selAll",
				type:"post",
				data:{
					wheresql:"ccustomercustomer='"+customer.customerid+"'"
				},
				success:function(resp2){
					var data2 = eval('('+resp2+')');
					$.each(data2.root,function(i,item){
						$(".bincompage ul li").each(function(i2,item2){
							if($(item2).children(".cdpa-bdqu").attr("name") == item.ccustomercompany){
								$(item2).append('<span class="cdpa-delsp">已绑定<span>');
							}
						});
					});
					$(".bincompage ul li .cdpa-bdqu").click(bindcom);
					$(".bincompage ul li .cdpa-delsp").click(remcombind);
				},
				error : function(resp2){
					var respText = eval('('+resp2+')');
					alert(respText.msg);
				}
			});
			
		},
		error : function(resp){
			var respText = eval('('+resp+')');
			alert(respText.msg);
		}
	});
});
//解绑定
var remcombind = function(){
	$.ajax({
		url:"CcustomerAction.do?method=delCusNexus",
		type:"post",
		data:{
			json:'[{"ccustomercompany":"'+$(this).prev().attr("name")+'","ccustomercustomer":"'+customer.customerid+'"}]'
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
	$.ajax({
		url:"CcustomerAction.do?method=insAll",
		type:"post",
		data:{
			json:'[{"ccustomercompany":"'+$(this).attr("name")+'","ccustomercustomer":"'+customer.customerid+'","ccustomerdetail":"3","creator":"0"}]',
		},
		success:function(resp){
			var data = eval('('+resp+')');
			if(data.code == '202'){
				alert("已成功绑定经销商!");
				window.location.href="index.jsp";
			}
		},
		error : function(resp){
			var respText = eval('('+resp+')');
			alert(respText.msg);
		}
	});
}
</script>
</body>
</html>
