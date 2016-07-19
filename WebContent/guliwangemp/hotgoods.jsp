<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Date currentTime = new Date(); 
SimpleDateFormat formatter = new SimpleDateFormat( "yyyy-MM-dd"); 
String dateString = formatter.format(currentTime); 
%>
<!DOCTYPE html>
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
<link href="css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">

#menu{width:100%; overflow:hidden; margin:0 auto;border:1px solid #BF9660;}
#menu #nav {display:block;width:100%;padding:0;margin:0;list-style:none;}
#menu #nav li {float:left;width:33.3%; background-color: white;}
#menu #nav li a {display:block;line-height:27px;text-decoration:none;padding:0 0 0 5px; text-align:center; color:#333;}
#menu_con{ border-top:none}
.tag{ padding:10px; overflow:hidden;}
.selected{background:#D5D5D5; color:#fff;}
</style>
</head>
<body>
<div class="gl-box">
    <div class="wapper-nav"><a onclick='javascript:history.go(-1);' class='goback'></a>
	热销商品<a onclick="docart(this)" href="cart.jsp" class="gwc"><img src="images/gwc.png" ><em id="totalnum">0</em></a></div>
    <!--代码部分begin-->
<div id="menu">
<!--tag标题-->
    <ul id="nav">
        <li><a class="selected" onclick="todayHotGoods(this)">今日热销</a></li>
        <li><a class="" onclick="thisWeekHotGoods(this)">本周热销</a></li>
        <li><a class="" onclick="thisMonthHotGoods(this)">本月热销</a></li>
    </ul>
<!--二级菜单-->
    <div id="menu_con">
        <div class="tag goods-wrapper" style="display:block;">
	        	<ul class="home-hot-commodity">
	        	</ul>
        </div> 
</div>
</div>
</div>
<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="meg">操作成功!</p>
            <a class="cd-popup-close">确定</a>
		</div>
	</div>
</div>
<script src="js/jquery-2.1.4.min.js"></script>
<script src="js/jquery-dropdown.js"></script>
<script src="js/getDate.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
var xian = '${param.xian}';
var dateString = '<%=dateString%>';
$(function(){ 
	//购物车图标上的数量
	if(!window.localStorage.getItem("cartnum")){
		window.localStorage.setItem("cartnum",0);
	}else if(window.localStorage.getItem("cartnum")==0){
		$("#totalnum").hide();
		$("#totalnum").text(0);
	}else{
		$("#totalnum").text(window.localStorage.getItem("cartnum"));
	}
	todayHotGoods();
});

//今日热销
function todayHotGoods(obj){
	$(obj).parent().siblings().children().removeClass('selected');
	$(obj).addClass('selected');
	pageInfo(dateString + ' 00:00:00',dateString + ' 23:59:59');
}
//本周热销
function thisWeekHotGoods(obj){
	$(obj).parent().siblings().children().removeClass('selected');
	$(obj).addClass('selected');
	pageInfo(getWeekStartDate() + ' 00:00:00',getWeekEndDate() + ' 23:59:59');
}
//本月热销
function thisMonthHotGoods(obj){
	$(obj).parent().siblings().children().removeClass('selected');
	$(obj).addClass('selected');
	pageInfo(getMonthStartDate() + ' 00:00:00',getMonthEndDate() + ' 23:59:59');
}
//页面信息
function pageInfo(staTime,endTime){
	if(xian && typeof(xian) != 'undefined'){
		$.getJSON("hotTodayGoodsEmp.action",{
			"cityname":xian,
			"staTime":staTime,
			"endTime":endTime,
			"customertype":customer.customertype,
			"customerlevel":customer.customerlevel
			},initMiaoshaPage);
	} else {
		$.getJSON("hotTodayGoodsEmp.action",{
			"cityname":customer.customerxian,
			"staTime":staTime,
			"endTime":endTime,
			"customertype":customer.customertype,
			"customerlevel":customer.customerlevel
			},initMiaoshaPage);
	}
}
//初始化页面
function initMiaoshaPage(data){
	$(".home-hot-commodity").html("");
	$.each(data,function(i,item){
		if(item.type == '商品'){
			var liObj = '<li onclick="purchaseGoods(\''+item.goods.goodscode+'\')">'+
	         	'<span class="fl"><img src="../'+item.goods.goodsimage+
	         	'" alt="" onerror="javascript:this.src=\'images/default.jpg\'"/></span> '+
	         	'<h1>'+item.goods.goodsname+'<br><span>('+item.goods.goodsunits+')</span></h1>'+
	           '  <div class="block"> </div></li>';
		} else if(item.type == '秒杀'){
			var liObj = '<li onclick="purchaseMiaosha(\''+item.timegoods.timegoodscode+'\')">'+
         	'<span class="fl"><img src="../'+item.timegoods.timegoodsimage+
         	'" alt="" onerror="javascript:this.src=\'images/default.jpg\'"/></span> '+
         	'<h1>'+item.timegoods.timegoodsname+'<br><span>('+item.timegoods.timegoodsunits+')</span></h1>'+
           '  <div class="block"> </div></li>';
		} else {
			var liObj = '<li onclick="purchaseGiveGoods(\''+item.givegoods.givegoodscode+'\')">'+
         	'<span class="fl"><img src="../'+item.givegoods.givegoodsimage+
         	'" alt="" onerror="javascript:this.src=\'images/default.jpg\'"/></span> '+
         	'<h1>'+item.givegoods.givegoodsname+'<br><span>('+item.givegoods.givegoodsunits+')</span></h1>'+
           '  <div class="block"> </div></li>';
		}
		$(".home-hot-commodity").append(liObj);
	});
}
//购买商品
function purchaseGoods(goodscode){
	window.location.href = 'goods.jsp?searchdishes='+goodscode;
}
//购买秒杀商品
function purchaseMiaosha(timegoodscode){
	window.location.href = 'miaosha.jsp?xian='+ xian +'&timegoodscode='+ timegoodscode;
}
//购买买赠商品
function purchaseGiveGoods(givegoodscode){
	window.location.href = 'give.jsp?xian='+ xian +'&givegoodscode='+ givegoodscode;
}
//到购物车页面
function docart(obj){
	if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
		$(obj).attr("href","cartnothing.html");
	}
}
</script>
</body>
</html>