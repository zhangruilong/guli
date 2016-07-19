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
<link href="css/base.css" type="text/css" rel="stylesheet">
<link href="css/layout.css" type="text/css" rel="stylesheet">
</head>

<body>
<div class="wapper-nav">全部订单<a href="query.jsp">筛选</a></div>
<div class="gl-box">
</div>
<div class="personal-center-nav">
    <ul>
        	<li class="active"><a href="index.jsp">
        	<em class="icon-shouye2"></em>首页</a></li>
            <li><a href="goodsclass.jsp"><em class="icon-fenlei1"></em>商城</a></li>
            <li class="active"><a href="order.jsp"><em class="ion-clipboard"></em>订单</a></li>
            <li class="active"><a href="customerlist.jsp"><em class="ion-android-person"></em>客户</a></li>
    </ul>
</div>
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
<script> 
var basePath = '<%=basePath%>';
$(function(){
	var customer = JSON.parse(window.localStorage.getItem("customeremp"));
	var openid = customer.openid;
	getJson(basePath+"OrdermviewAction.do",{method:"mselQuery",
		openid : openid,
		begindate : "<%=request.getParameter("begindate")%>",
		enddate : "<%=request.getParameter("enddate")%>",
		beginmoney : "<%=request.getParameter("beginmoney")%>",
		endmoney : "<%=request.getParameter("endmoney")%>",
		companyname : "<%=request.getParameter("companyname")%>"},initData,null);
});
function initData(data){
    $(".gl-box").html("");
	 $.each(data.root, function(i, item) {
		$(".gl-box").append('<div class="add-admin">'+
		    	'<div class="all-order-wrapper">'+
	        	'<h1>'+item.companyshop+'<span>'+item.ordermtime+'</span></h1>'+
	            '<a onclick="nextpage(\''+item.ordermid+'\');">'+
	                '<span>订单状态：<font class="font-oringe">'+item.ordermstatue+'</font></span>'+
	                '<span>订单编号：<font class="font-grey">'+item.ordermcode+'</font> </span>'+
	                '<span class="sign"></span>'+
	            '</a>'+
	            '<div class="gopay">'+
	                '<span class="block">品种数量：<font class="font-oringe">'+item.ordermnum+'</font> '+
	                '总价：<font class="font-oringe">'+item.ordermrightmoney+'元</font>	</span>	'+
	            '</div>'+
	        '</div>'+
	    '</div>');
    });
}
function nextpage(ordermid){
	window.location.href = "orderd.jsp?ordermid="+ordermid;
}
function successCB(r, cb) {
	cb && cb(r);
}

function getJson(url, param, sCallback, fCallBack) {
	try
	{
		$.ajax({
			url: url,
			data: param,
			dataType:"json",
			success: function(r) {
				successCB(r, sCallback);
				successCB(r, fCallBack);
			},
			error:function(r) {
				var resp = eval(r); 
				alert(resp.msg);
			}
		});
	}
	catch (ex)
	{
		alert(ex);
	}
}
</script>
</body>
</html>
