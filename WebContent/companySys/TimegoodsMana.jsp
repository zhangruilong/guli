<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="css/tabsty.css" rel="stylesheet" type="text/css">
<link href="css/dig.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../sysjs/jquery.min.js"></script>
<style type="text/css">
.elegant-aero{
	margin-top: 0;
}
.fenyelan_input{
	width: 22px;
	text-align: center;
}
.fenyelan_button{
	width: 40px;height: 20px;font-size:8px; text-align: center;cursor:pointer;
}
.goods_select_popup{
	margin:0px auto;
	margin-top:1%;
	width: 60%;
	background-color: #FBF1E5;
}
</style>
</head>
<body>
<form id="main_form" action="allTimeGoods.action" method="post">
<input type="hidden" name="timegoodscompany" value="${requestScope.timegoodsCon.timegoodscompany }">
<div class="nowposition">当前位置：商品管理》秒杀商品</div>
<div class="navigation">
<input class="button" type="button" value="添加秒杀商品" onclick="addtimegoods()">
<input class="button" type="button" value="刷新" onclick="javascript:window.location.reload()">
</div>
<table class="bordered">
    <thead>
    <tr>
        <th>序号</th>
		<th>商品编号</th>
		<th>商品名称</th>
		<th>规格</th>
		<th>类别</th>
		<th>原价</th>
		<th>现价</th>
		<th>限量</th>
		<th>状态</th>
		<th>创建时间</th>
		<th>创建人</th>
    </tr>
    </thead>
    <c:if test="${fn:length(requestScope.timegoodsList) != 0 }">
	<c:forEach var="timegoods" items="${requestScope.timegoodsList }" varStatus="timegoodsSta">
		<tr>
			<td><c:out value="${timegoodsSta.count}"></c:out></td>
			<td>${timegoods.timegoodscode}</td>
			<td>${timegoods.timegoodsname}</td>
			<td>${timegoods.timegoodsunits}</td>
			<td>${timegoods.timegoodsclass}</td>
			<td>${timegoods.timegoodsprice}</td>
			<td>${timegoods.timegoodsorgprice}</td>
			<td>${timegoods.timegoodsnum}</td>
			<td>${timegoods.timegoodsstatue}</td>
			<td>${timegoods.createtime}</td>
			<td>${timegoods.creator}</td>
		</tr>
	</c:forEach>
	</c:if>
	<c:if test="${fn:length(requestScope.timegoodsList)==0 }">
		<tr><td colspan="14" align="center" style="font-size: 20px;color: red;"> 没有信息</td></tr>
	</c:if>
    	<tr>
		 <td colspan="14" align="center">
		 <c:if test="${requestScope.pagenow > 1 }">
		 	<a onclick="fenye('1')">第一页</a>
		 </c:if>
		 <c:if test="${requestScope.pagenow == 1 }">
		 	<span>第一页</span>
		 </c:if>
		  <c:if test="${requestScope.pagenow > 1 }">
		 	<a onclick="fenye('${requestScope.pagenow - 1 }')">上一页</a>
		 </c:if>
		 <c:if test="${requestScope.pagenow == 1 }">
		 	<span>上一页</span>
		 </c:if>
		 	
		 	<span>当前第${requestScope.pagenow }页</span>
		 	
		 <c:if test="${requestScope.pagenow < requestScope.pageCount }">
		 	<a onclick="fenye('${requestScope.pagenow + 1 }')">下一页</a>
		 </c:if>
		 <c:if test="${requestScope.pagenow == requestScope.pageCount }">
		 	<span>下一页</span>
		 </c:if>
		 <c:if test="${requestScope.pagenow < requestScope.pageCount }">
		 	<a onclick="fenye('${requestScope.pageCount }')">最后一页</a>
		 </c:if>
		 <c:if test="${requestScope.pagenow == requestScope.pageCount }">
		 	<span>最后一页&nbsp;</span>
		 </c:if>
		 	<span>跳转到第<input class="fenyelan_input" size="1" type="text" id="pagenow" name="pagenow" value="${requestScope.pagenow }">页</span>
		 	<input type="button" onclick="timegoodsjump()" value="GO" class="fenyelan_button">
		 	<span>一共 ${requestScope.count } 条数据</span>
		 </td>
	 </tr>       
</table>
</form>
<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="elegant-aero">
			<h1>添加秒杀商品</h1>
			<input type="hidden" id="timegoodsimage" value="">
			<label><span>编码 :</span><input id="timegoodscode" type="text"
				name="timegoodscode" placeholder="编码" /></label>
			<label><span>名称 :</span><input id="timegoodsname" type="text"
				name="timegoodsname" placeholder="名称" /></label>
			<label><span>规格 :</span><input id="timegoodsunits" type="text"
				name="timegoodsunits" placeholder="规格" /></label>
			<label><span>小类名称 :</span>
			<select name="timegoodsclass" id="timegoodsclass">
				<option value="">请选择</option>
			</select>
			</label>
			<label><span>单位 :</span><input id="timegoodsunit" type="text"
				name="timegoodsunit" placeholder="单位" /></label>
			<label><span>原价 :</span><input id="timegoodsprice" type="text"
				name="timegoodsprice" placeholder="原价" /></label>
			<label><span>现价 :</span><input id="timegoodsorgprice" type="text"
				name="timegoodsorgprice" placeholder="现价" /></label>
			<label><span>个人限量 :</span><input id="timegoodsnum" type="text"
				name="timegoodsnum" placeholder="个人限量" /></label>
			<label><span>全部限量 :</span><input id="allnum" type="text"
				name="allnum" placeholder="全部限量" /></label>
			<p><label><input type="button"
				class="popup_button" value="提交" onclick="popup_formSub()"/>
			</label>
			<label><input type="button"
				class="popup_button" value="从商品中选择" onclick="dobiaopin()"/>
			</label>
			<label><input type="button"
				class="popup_button" value="关闭窗口" onclick="close_popup()"/>
			</label></p>
	</div>
</div>
<!--弹框-->
<div class="cd-popup2" role="alert">
<div class="goods_select_popup">
<div class="navigation">
查询条件:&nbsp;&nbsp;<input type="text" id="goodscode" name="goodscode" value="">
<input class="button" type="button" value="查询" onclick="queryGooods()">
<input class="button" type="button" value="关闭" onclick="closeCdPopup2()">
</div>
	<table class="bordered" id="scant" style="margin: 5% auto 0 auto;">
		<thead>
	    <tr>
	        <th>序号</th>
			<th>商品编码</th>
			<th>商品名称</th>
			<th>规格</th>
			<th>小类名称</th>
			<th>点击选择</th>
	    </tr>
	    </thead>
	</table>
</div>
</div>
<script type="text/javascript">
$(function(){
	$("#main_form").on("submit",function(){
		checkCondition();
	});
})
//检查查询条件是否变化
function checkCondition(){
	if(parseInt($("#pagenow").val()) > '${requestScope.pageCount }' ){
		$("#pagenow").val('${requestScope.pageCount }');
	}
}
//分页
function fenye(targetPage){
	$("#pagenow").val(targetPage);
	checkCondition();
	document.forms[0].submit();
}
//商品分页
function fenyeGoods(targetPage){
	loadGoodsData(targetPage);
}
//秒杀商品跳转到第X页
function timegoodsjump(){
	if(parseInt($("#pagenow").val()) > '${requestScope.pageCount }' ){
		$("#pagenow").val('${requestScope.pageCount }');
	}
	document.forms[0].submit();
}
//商品跳转到第X页
function goodsPageTo(pageCountGoods){
	var pagenowGoods = $("#pagenowGoods").val();
	if(parseInt(pagenowGoods) > parseInt(pageCountGoods)){
		pagenowGoods = pageCountGoods;
	}
	loadGoodsData(pagenowGoods);
}
//弹出添加秒杀商品的窗口
function addtimegoods(){
	$(".cd-popup").addClass("is-visible");	//弹出窗口
	$.getJSON("getallGoodclass.action",function(data){
		$.each(data,function(i,item){
			$("#timegoodsclass").append(
				'<option value="'+item.goodsclassid+'">'+item.goodsclassname+'</option>'
			)
		});
	});
}
//关闭添加秒杀商品窗口
function close_popup(){
	$(".cd-popup").removeClass("is-visible");	//移除'is-visible' class
}
//关闭商品选择窗口
function closeCdPopup2(){
	$(".cd-popup2").removeClass("is-visible");
}
//弹出商品窗口
function dobiaopin(){
	$(".cd-popup2").addClass("is-visible");	//弹出标品窗口
	loadGoodsData(1);
}
//加载商品数据
function loadGoodsData(pagenowGoods){
	var data = {
				'goodscompany':'${sessionScope.company.companyid }',
				'pagenowGoods':pagenowGoods,
				'goodscode':$.trim($("#goodscode").val())
			};
	$.getJSON("getallGoods.action",data,function(data){
		$("#scant td").remove();
		$.each(data.goodsList,function(i,item){
			$("#scant").append(
			'<tr><td>'+(i+1)+'</td>'+
			'<td>'+item.goodscode+'</td>'+
			'<td>'+item.goodsname+'</td>'+
			'<td>'+item.goodsunits+'</td>'+
			'<td>'+item.gClass.goodsclassname+'</td>'+
			'<td><a class="scant_a" onclick="seleScant(\''
					+item.goodscode+
					'\',\''+item.goodsname+
					'\',\''+item.goodsunits+
					'\',\''+item.gClass.goodsclassname+
					'\',\''+item.goodsimage+
					'\')">选择</a></td></tr>'
			);
		});
		var goodsfenye = '<tr><td colspan="7">';
		if(data.pagenowGoods > 1){
			goodsfenye += '<a onclick=fenyeGoods("1")>第一页</a><a onclick=fenyeGoods("'+(parseInt(data.pagenowGoods)-1)+'")>上一页</a>';
			
		} else {
			goodsfenye += '<span>第一页</span><span>上一页</span>';
		}
		goodsfenye += '<span>当前第'+data.pagenowGoods+'页</span>';
		if(data.pagenowGoods < data.pageCountGoods){
			goodsfenye += '<a onclick=fenyeGoods("'+(parseInt(data.pagenowGoods)+1)+'")>下一页</a><a onclick=fenyeGoods("'+data.pageCountGoods+'")>最后一页</a>';
		} else {
			goodsfenye += '<span>下一页</span><span>最后一页&nbsp;</span>';
		}
		goodsfenye += '<span>跳转到第<input class="fenyelan_input" size="1" type="text" id="pagenowGoods" value="'+
			data.pagenowGoods+'">页</span>'+
		 	'<input onclick=goodsPageTo("'+data.pageCountGoods+'") type="button" value="GO" class="fenyelan_button">'+
	 		'<span>一共 '+data.countGoods+' 条数据</span>';
		$("#scant").append(goodsfenye);
	});
}
//选择商品
function seleScant(timegoodscode,timegoodsname,timegoodsunits,goodsclassname,timegoodsimage){
	$("#timegoodscode").val(timegoodscode);
	$("#timegoodsname").val(timegoodsname);
	$("#timegoodsunits").val(timegoodsunits);
	$("#timegoodsclass option").each(function(i,item){
		if($(item).text() == goodsclassname){
			$(item).attr("selected",true);
		}
	});
	$("#timegoodsimage").val(timegoodsimage);
	$(".cd-popup2").removeClass("is-visible");	//移除'is-visible' class
	
}
//提交添加商品的表单
function popup_formSub(){
	var data = '{';
	if($("#timegoodsclass").val() == "" || $("#timegoodsclass").val() == null){
		alert("小类名称不能为空");
		return;
	} else {
		data += '"timegoodsclass":"'+$("#timegoodsclass").val()+'",';
	}
	var count = 0;
	$(".elegant-aero [type='text']").each(function(i,item){
		if($(item).val() == null || $(item).val() == '' ){
			alert($(item).attr('placeholder') + '不能为空');
			count++;
			return false;
		} else {
			data += '"'+$(item).attr("name") + '":"' + $(item).val() + '",';
		}
	});
	if(count == 0){
		data += '"timegoodsimage":"'+$("#timegoodsimage").val()+'","timegoodscompany":"${requestScope.timegoodsCon.timegoodscompany }","creator":"${sessionScope.company.companyshop }"}';
		$.getJSON('addTimeGoods.action',JSON.parse(data),function(){
			alert('添加成功');
			document.forms[0].submit();
		});
	}
}
//条件查询
function queryGooods(){
	loadGoodsData(1);
}
</script>
</body>
</html>