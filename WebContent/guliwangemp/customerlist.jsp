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
<div class="gl-box budan-page">
	<div class="home-search-wrapper">
        <input type="text" placeholder="请输入客户名称" onkeydown="entersearch(this);">
    </div>
    <ul id="customerlist">
    	<!-- <li><span hidden="ture">2121</span>
    	<a class="cd-popup-trigger"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cd-popup-trigger"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cd-popup-trigger"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li>
        <li><a class="cd-popup-trigger"><h2>大福超市</h2><span>王大宝 15865456465</span></a></li> -->
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
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
var emp = JSON.parse(window.localStorage.getItem("emp"));
var basePath = '<%=basePath%>';
$(function(){
	getJson(basePath+"GLCcustomerviewAction.do",{method:"selAll",wheresql:"ccustomercompany='"+emp.empcompany+"'"},initData,null);
});
function initData(data){
    $("#customerlist").html("");
	 $.each(data.root, function(i, item) {
		$("#customerlist").append('<li><a class="cd-popup-trigger"><h2>'+
				item.customershop+'</h2><span>'+
				item.customername+' '+
				item.customerphone+'</span></a><span style="display: none;">'+
				JSON.stringify(item)+'</span></li>');
    });
	//open popup
	$('.cd-popup-trigger').on('click', function(event){
		event.preventDefault();
		$('.cd-popup').addClass('is-visible');
		window.localStorage.setItem("customeremp",$(this).next().text());
	});
	
	//close popup
	$('.cd-popup').on('click', function(event){
		if( $(event.target).is('.cd-popup-close') || $(event.target).is('.cd-popup') ) {
			event.preventDefault();
			$(this).removeClass('is-visible');
		}
	});
}
function entersearch(obj){
    var event = window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == 13)
    {
    	getJson(basePath+"GLCcustomerviewAction.do",{method:"selAll",query:$(obj).val(),wheresql:"ccustomercompany='"+emp.empcompany+"'"},initData,null);
    }
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
