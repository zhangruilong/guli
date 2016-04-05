<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String ordermway = request.getParameter("ordermway");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="../guliwang/js/jquery-2.1.4.min.js"></script>
<link href="css/tabsty.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
var ordermway = '<%=ordermway %>';
$(function(){
	if(ordermway == null || ordermway == ''){
		$(".nowposition").html("当前位置：订单管理》全部订单");
	} else if(ordermway == '在线支付'){
		$(".nowposition").html("当前位置：订单管理》在线支付订单");
	} else if(ordermway == '货到付款'){
		$(".nowposition").html("当前位置：订单管理》货到付款订单");
	}
	//$(".nowposition").style.backgroundSize="1300px";
})
function doprint(ordermid){
	window.open("printOrder.action?ordermid="+ordermid+"&ordermcompany=${sessionScope.company.companyid }");
	return false;
}
</script>
</head>
<body>
 <pg:pager maxPageItems="8" url="allOrder.action">
 <pg:param name="ordermcompany" value="${sessionScope.company.companyid }"/>
 <pg:param name="ordermway" value="<%=ordermway %>"/>
<div class="nowposition">当前位置：订单管理》全部订单</div>
<br />
<table class="bordered" style="width: 1300px;">
    <thead>

    <tr>
        <th>序号</th>
		<th>订单编号</th>
		<th>支付方式</th>
		<th>种类数</th>
		<th>下单金额</th>
		<th>实际金额</th>
		<th>订单状态</th>
		<th style="width: 115px">下单时间</th>
		<th>修改时间</th>
		<th>客户名称</th>
		<th>联系人</th>
		<th>手机</th>
		<th>地址</th>
		<th>打印</th>
		<th>详情</th>
    </tr>
    </thead>
    <c:if test="${fn:length(requestScope.allOrder) != 0 }">
	<c:forEach var="order" items="${requestScope.allOrder }" varStatus="orderSta">
	<pg:item>
		<tr>
			<td><c:out value="${orderSta.count}"></c:out></td>
			<td>${order.ordermcode}</td>
			<td>${order.ordermway}</td>
			<td>${order.ordermnum}</td>
			<td>${order.ordermmoney}</td>
			<td>${order.ordermrightmoney}</td>
			<td>${order.ordermstatue}</td>
			<td>${order.ordermtime}</td>
			<td>${order.updtime}</td>
			<td>${order.orderdCustomer.customershop}</td>
			<td>${order.ordermconnect}</td>
			<td>${order.ordermphone}</td>
			<td>${order.ordermaddress}</td>
			<td><a href="" onclick="return doprint('${order.ordermid}')">打印</a></td>
			<td><a href="orderDetail.action?ordermid=${order.ordermid}&ordermcompany=${sessionScope.company.companyid }">详情</a></td>
		</tr>
		</pg:item>
	</c:forEach>
	</c:if>
	<c:if test="${fn:length(requestScope.allOrder)==0 }">
		<tr><td colspan="15" align="center" style="font-size: 20px;color: red;"> 没有信息</td></tr>
	</c:if>
    	<tr>
		 <td colspan="15" align="center">	
			 <pg:index>
			 <pg:first><a href="${pageUrl }">第一页</a></pg:first>
			 <pg:prev><a href="${pageUrl}">上一页</a></pg:prev>
			 <pg:pages>
			 <a href="${pageUrl}">[${pageNumber }]</a>
			 </pg:pages>
			 <pg:next><a href="${pageUrl}">下一页</a></pg:next>
			 <pg:last><a href="${pageUrl }">最后一页</a></pg:last>
			 </pg:index>
		 </td>
	 </tr>       
</table>
</pg:pager>
</body>
</html>