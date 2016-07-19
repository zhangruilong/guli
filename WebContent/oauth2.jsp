<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String openid = (String)request.getParameter("openid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
<script>
var openid = '<%=openid%>';
</script>
</head>
<body>
<script type="text/javascript">
	$(function(){
		if(openid==null||openid=='null'||openid==''){
			alert("微信服务器未响应，请稍后再进。");
		}else{
			window.localStorage.setItem("openid",openid);
			window.location.href = "guliwang/index.jsp";	
		}
	});
</script>
</body>
</html>