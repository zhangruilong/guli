<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
.elegant-aero {
	margin-left: 10px auto;
	margin-right: auto;
	background: #D2E9FF;
	padding: 20px 20px 20px 20px;
	font: 12px Arial, Helvetica, sans-serif;
	color: #666;
	width: 700px;
}

.elegant-aero h1 {
	font: 24px "Trebuchet MS", Arial, Helvetica, sans-serif;
	padding: 10px 10px 10px 20px;
	display: block;
	background: #C0E1FF;
	border-bottom: 1px solid #B8DDFF;
	margin: -20px -20px 15px;
	font-weight: bold;
}

.elegant-aero h1>span {
	display: block;
	font-size: 11px;
}

.elegant-aero label>span {
	margin-top: 10px;
	color: #5E5E5E;
	text-align: right;
	padding-right: 8px;
}

.elegant-aero p>span {
	float: left;
	margin-top: 10px;
	color: #5E5E5E;
	text-align: right;
	padding-right: 15px;
	font-weight: bold;
}

.elegant-aero label {
	margin: 0px 0px 5px;
}


.elegant-aero input[type="text"]{
	color: #888;
	padding: 0px 0px 0px 5px;
	border: 1px solid #C5E2FF;
	background: #FBFBFB;
	outline: 0;
	-webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
	box-shadow: inset 0px 1px 6px #ECF3F5;
	font: 200 12px/25px Arial, Helvetica, sans-serif;
	height: 30px;
	line-height: 15px;
	margin: 2px 6px 16px 0px;
}


.elegant-aero .button {
	padding: 10px 30px 10px 30px;
	background: #66C1E4;
	border: none;
	color: #FFF;
	box-shadow: 1px 1px 1px #4C6E91;
	-webkit-box-shadow: 1px 1px 1px #4C6E91;
	-moz-box-shadow: 1px 1px 1px #4C6E91;
	text-shadow: 1px 1px 1px #5079A3;
}

.elegant-aero .button:hover {
	background: #3EB1DD;
}

.elegant-aero p{

}

</style>
<title>Insert title here</title>
</head>
<body>
	<div class="elegant-aero">
		<form action="addGoodsPrices.action" method="post" class="STYLE-NAME">
			<input type="hidden" name="goodsid" value="${requestScope.goodsCon.goodsid }">
			<input type="hidden" name="pricesgoods" value="${requestScope.goodsCon.goodsid }">
			<input type="hidden" name="goodscompany" value="${sessionScope.company.companyid }"/>
			<c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">
				<c:forEach items="${requestScope.goodsCon.pricesList }" var="price">
					<input type="hidden" name=pricesid value="${price.pricesid }">
				</c:forEach>
			</c:if>
			<h1>商品价格设置
			<span>单品单位:<input size="4" type="text" name="pricesunit" value="${requestScope.goodsCon.pricesList[0].pricesunit }">套装单位:<input size="4" type="text" name="pricesunit2" value="${requestScope.goodsCon.pricesList[0].pricesunit2 }"></span>
			</h1>
			<table>
			<tr><td colspan="3"><p><span>餐饮客户价格 :</span></p> </td></tr>
			<tr>	
				
				<td><label><span>单品价等级3 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '餐饮客户' && price.priceslevel == 3}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="1" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
				<td><label><span>单品价等级2 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '餐饮客户' && price.priceslevel == 2}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="2" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
				<td><label><span>单品价等级1 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '餐饮客户' && price.priceslevel == 1}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="3" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
			</tr>
			<tr>
				<td><label><span>套装价等级3 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '餐饮客户' && price.priceslevel == 3}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="10" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
				<td><label><span>套装价等级2 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '餐饮客户' && price.priceslevel == 2}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="11" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
				<td><label><span>套装价等级1 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '餐饮客户' && price.priceslevel == 1}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="12" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
			</tr>
			<tr><td colspan="3"><p><span> 高级客户价格 :</span></p></td></tr>
			<tr>
				<td><label><span>单品价等级3 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '高级客户' && price.priceslevel == 3}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="4" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
				<td><label><span>单品价等级2 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '高级客户' && price.priceslevel == 2}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="5" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
				<td><label><span>单品价等级1 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '高级客户' && price.priceslevel == 1}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="6" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
			</tr>
			<tr>
				<td><label><span>套装价等级3 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '高级客户' && price.priceslevel == 3}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="13" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
				<td><label><span>套装价等级2 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '高级客户' && price.priceslevel == 2}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="14" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
				<td><label><span>套装价等级1 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '高级客户' && price.priceslevel == 1}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="15" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
			</tr>
			<tr><td colspan="3"><p><span> 组织单位客户价格 :</span></p></td></tr>
			<tr>
				<td><label><span>单品价等级3 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '组织单位客户' && price.priceslevel == 3}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="7" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
				<td><label><span>单品价等级2 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '组织单位客户' && price.priceslevel == 2}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="8" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
				<td><label><span>单品价等级1 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '组织单位客户' && price.priceslevel == 1}">${price.pricesprice }</c:if></c:forEach>" 
				size="5" id="9" type="text" name="pricesprice" placeholder="单品价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit }</c:if></span></label></td>
			 </tr>
			 <tr>
				<td><label><span>套装价等级3 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '组织单位客户' && price.priceslevel == 3}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="16" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
				<td><label><span>套装价等级2 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '组织单位客户' && price.priceslevel == 2}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="17" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
				<td><label><span>套装价等级1 :</span><input 
				value="<c:forEach items="${requestScope.goodsCon.pricesList }" var="price"><c:if test="${price.pricesclass == '组织单位客户' && price.priceslevel == 1}">${price.pricesprice2 }</c:if></c:forEach>" 
				size="5" id="18" type="text" name="pricesprice2" placeholder="套装价" />
				<span><c:if test="${requestScope.goodsCon.pricesList[0].pricesunit2 !=null }">/${requestScope.goodsCon.pricesList[0].pricesunit2 }</c:if></span></label></td>
			</tr>
			</table>
			<span>&nbsp;</span> <input type="button" class="button" value="保存" onclick="addData()"/> 
			<input style="margin-left: 30px;" type="button" class="button" value="返回" onclick="javascript:window.parent.main.location.href = 'allGoods.action?goodscompany=${sessionScope.company.companyid }'"/>
			
		</form>
	</div>
	<script type="text/javascript" src="../guliwang/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript">
	function addData(){
		var val1 = $("#1").val();
		var val10 = $("#10").val();
		if(val1 == null || val1 == "" ||　val10 == null || val10 == ""){
			alert("等级为 3 的餐饮客户价格不能为空.");
			return;
		}
		var allInput = $("input");
		$.each(allInput,function(i,item){
			var itemVal = $(item);
				if(itemVal.val() == null || itemVal.val() == ""){
					var itemId = itemVal.attr("id");
					var ofVal = $("#"+(itemId-1)).val();
					itemVal.val(ofVal);
				}
		}); 
		document.forms[0].submit();
	}
	
	</script>
</body>
</html>