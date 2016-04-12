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
<link href="css/tabsty.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>ExtJS/resources/css/ext-all.css" />
<script type="text/javascript" src="../guliwang/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="<%=basePath%>ExtJS/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=basePath%>ExtJS/ext-all.js"></script>
<script type="text/javascript" src="<%=basePath%>ExtJS/ext-lang-zh_CN.js" charset="GBK"></script>
</head>
<body>
<form action="allOrder.action" method="post">
 <pg:pager maxPageItems="10" url="allOrder.action" export="currentNumber=pageNumber">
 <pg:param name="ordermcompany" value="${sessionScope.company.companyid }"/>
 <pg:param name="ordermway" value="<%=ordermway %>"/>
 <pg:param name="staTime" value="${requestScope.staTime }"/>
 <pg:param name="endTime" value="${requestScope.endTime }"/>
 <pg:param name="ordermcode" value="${requestScope.order.ordermcode }"/>
 <input type="hidden" id="staTime" name="staTime" value="${requestScope.staTime }">
 <input type="hidden" id="endTime" name="endTime" value="${requestScope.endTime }">
 <input type="hidden" id="ordermcompany" name="ordermcompany" value="${sessionScope.company.companyid }">
<div class="nowposition">当前位置：订单管理》全部订单</div>
<div class="navigation">
<div>下单时间:</div><div id="divDate" class="date"></div>
<div>到:</div><div id="divDate2"  class="date"></div>
查询条件:<input type="text" name="ordermcode" value="${requestScope.order.ordermcode }">
<input class="button" type="button" value="查询" onclick="subfor()">
<input class="button" type="button" value="导出报表" onclick="report()">
<input class="button" type="button" value="打印" onclick="return doprint()">
<input class="button" type="button" value="详情" onclick="orderDetail()">
</div>
<br />
<table class="bordered" style="width: 100%;margin-left: 6px;">
    <thead>

    <tr>
    	<th></th>
        <th>序号</th>
		<th>订单编号</th>
		<th>支付方式</th>
		<th>种类数</th>
		<th>下单金额</th>
		<th>实际金额</th>
		<th>订单状态</th>
		<th>下单时间</th>
		<th>修改时间</th>
		<th>客户名称</th>
		<th>联系人</th>
		<th>手机</th>
		<th>地址</th>
    </tr>
    </thead>
    <c:if test="${fn:length(requestScope.allOrder) != 0 }">
	<c:forEach var="order" items="${requestScope.allOrder }" varStatus="orderSta">
	<pg:item>
		<tr>
			<td><input type="checkbox" id="${order.ordermid}"></td>
			<td><c:out value="${orderSta.count}"></c:out></td>
			<td>${order.ordermcode}</td>
			<td>${order.ordermway}</td>
			<td>${order.ordermnum}</td>
			<td>${order.ordermmoney}</td>
			<td>${order.ordermrightmoney}</td>
			<td>${order.ordermstatue}</td>
			<td>${order.ordermtime }</td>
			<td>${order.updtime}</td>
			<td>${order.customershop}</td>
			<td>${order.ordermconnect}</td>
			<td>${order.ordermphone}</td>
			<td>${order.ordermaddress}</td>
		</tr>
		</pg:item>
	</c:forEach>
	</c:if>
	<c:if test="${fn:length(requestScope.allOrder)==0 }">
		<tr><td colspan="15" align="center" style="font-size: 20px;color: red;"> 没有信息</td></tr>
	</c:if>
    	<tr>
		 <td class="td_fenye" colspan="15" align="center">	
			 <pg:index>
			 <pg:first><a href="${pageUrl }">第一页</a></pg:first>
			 <pg:prev><a href="${pageUrl}">上一页</a></pg:prev>
			 <pg:pages>
			 	<c:if test="${currentNumber != pageNumber }">
				 	<a onclick="nowpage(this)" href="${pageUrl}">[${pageNumber }]</a>
			 	</c:if>
			 	<c:if test="${currentNumber == pageNumber }">
			 		<a class="fenye">${pageNumber }</a>
			 	</c:if>
			 </pg:pages>
			 <pg:next><a href="${pageUrl}">下一页</a></pg:next>
			 <pg:last><a href="${pageUrl }">最后一页</a></pg:last>
			 </pg:index><!--  <span>当前页是第${currentNumber }页</span> -->
		 </td>
	 </tr>       
</table>
</pg:pager>
</form>
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
	/* var childs = $(".td_fenye").children();
	$(childs[1]).addClass("fenye"); */
	var hr = window.location.href;
	//alert(hr);
})
//详情
function orderDetail(){
	var count = 0;
	var itemid;
	$("[type='checkbox']").each(function(i,item){
		if(item.checked==true){
			itemid = $(item).attr("id");
			count++;
		}
	});
	if(count > 0 && count < 2){
		window.location.href = "orderDetail.action?ordermid="+itemid+"&ordermcompany=${sessionScope.company.companyid }";
	} else if(count == 0){
		alert("请选择订单");
	} else {
		alert("只能选择一个订单");
	}
}
//打印
function doprint(){
	var count = 0;
	var itemid;
	$("[type='checkbox']").each(function(i,item){
		if(item.checked==true){
			itemid = $(item).attr("id");
			count++;
		}
	});
	if(count > 0 && count < 2){
		window.open("printOrder.action?ordermid="+itemid+"&ordermcompany=${sessionScope.company.companyid }");
	} else if(count == 0){
		alert("请选择订单");
	} else {
		alert("只能选择一个订单");
	}
	return false;
}
var md;						//第一个日期对象
var md2;					//第二个日期对象
   Ext.onReady(function(){
		md = new Ext.form.DateField({
			name:"testDate",
			editable:false, //不允许对日期进行编辑
			width:90,
			format:"Y-m-d",
			emptyText:"${(requestScope.staTime == null || requestScope.staTime == '')?'请选择日期...':requestScope.staTime}"		//默认显示的日期
		});
		md.render('divDate');
		
		md2 = new Ext.form.DateField({
			name:"testDate",
			editable:false, //不允许对日期进行编辑
			width:90,
			format:"Y-m-d",
			emptyText:"${(requestScope.endTime == null || requestScope.endTime == '')?'请选择日期...':requestScope.endTime}"		//默认显示的日期
		});
		md2.render('divDate2');
   });
//导出报表
function report(){
	window.location.href ="exportOrderReport.action?ordermcompany=${sessionScope.company.companyid }"+
	"&staTime=${requestScope.staTime }&endTime=${requestScope.endTime }&ordermcode=${requestScope.order.ordermcode }";
}
//查询
function subfor(){
	var gedt = Ext.util.Format.date(md.getValue(), 'Y-m-d');	//得到查询时间
	var gedt2 = Ext.util.Format.date(md2.getValue(), 'Y-m-d');	
	if(gedt == ''){
		gedt = "${requestScope.staTime}";
	}
	if(gedt2 == ''){
		gedt2 = "${requestScope.endTime}";
	}
	$("#staTime").val(gedt);
	$("#endTime").val(gedt2);
	document.forms[0].submit();
}
</script>
</body>
</html>