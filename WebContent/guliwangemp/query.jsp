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
<div class="gl-box bgcol">
<div class="filter-wrapper">
	<div class="wapper-nav">筛选 <a href='javascript:history.go(-1)' class="goback"></a></div>
    <ul>
    	<li><span>按时间</span> <input id="begindate" type="date" placeholder="开始时间"> 至 <input id="enddate" type="date" placeholder="结束时间"></li>
        <li><span>按金额</span> <input id="beginmoney" type="number" placeholder="2000"> 至 <input id="endmoney" type="number" placeholder="3000"></li>
        <li><span>供应商</span> <input id="companyname" type="text" class="supplier-name" placeholder="请输入供应商名称"></li>
    </ul>
</div>
</div>
<div class="footer">
	<div class="filter-footer">
        <a onclick="clearall();">清除</a> <a onclick="nextpage();">确定</a>
    </div>
</div>
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
$(function(){
	$("#begindate").val(window.localStorage.getItem("begindate"));
	$("#enddate").val(window.localStorage.getItem("enddate"));
	$("#beginmoney").val(window.localStorage.getItem("beginmoney"));
	$("#endmoney").val(window.localStorage.getItem("endmoney"));
	$("#companyname").val(window.localStorage.getItem("companyname"));
});
function clearall(){
	$("#begindate").val("");
	$("#enddate").val("");
	$("#beginmoney").val("");
	$("#endmoney").val("");
	$("#companyname").val("");
	window.localStorage.setItem("begindate", $("#begindate").val());
	window.localStorage.setItem("enddate", $("#enddate").val());
	window.localStorage.setItem("beginmoney", $("#beginmoney").val());
	window.localStorage.setItem("endmoney", $("#endmoney").val());
	window.localStorage.setItem("companyname", $("#companyname").val());
}
function nextpage(){
	window.localStorage.setItem("begindate", $("#begindate").val());
	window.localStorage.setItem("enddate", $("#enddate").val());
	window.localStorage.setItem("beginmoney", $("#beginmoney").val());
	window.localStorage.setItem("endmoney", $("#endmoney").val());
	window.localStorage.setItem("companyname", $("#companyname").val());
	window.location.href = "order.jsp?begindate="+$("#begindate").val()+
			"&enddate="+$("#enddate").val()+
			"&beginmoney="+$("#beginmoney").val()+
			"&endmoney="+$("#endmoney").val()+
			"&companyname="+$("#companyname").val();
}
</script>
</body>
</html>
