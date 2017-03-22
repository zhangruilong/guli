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
<link rel="stylesheet" href="../css/swipe.css" type="text/css" />
<link href="../css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">
	.home-search-wrapper .citydrop img{
		margin-top: 10px;
	}
	.personal-center a{
		line-height: 250%;
		font-size: 30px;
		padding: 10px;
	}
</style>
</head>

<body>
	<div class="gl-box">
		<div class="home-search-wrapper">
			<span class="citydrop"><!-- 海盐县<em><img src="../images/dropbg.png"></em> --></span>
			<!-- <div class="menu">
				<div class="host-city">
					<p class="quyu">
						请选择服务区域 <span class="fr"></span>
					</p>
				</div>
				<div class="menu-tags home-city-drop">
					<ul id="citys-menu" name="">
						<li><a href="index.jsp?xian=海盐县city=16">海盐县</a></li>
						<li><a href="index.jsp?xian=南湖区city=16">南湖区</a></li>
						<li><a href="index.jsp?xian=秀洲区city=16">秀洲区</a></li>
						<li><a href="index.jsp?xian=海盐县city=16">嘉善县</a></li>
					</ul>
				</div>
			</div> -->
			<input id="searchdishes" type="text" placeholder="请输入商品名称" onkeydown="submitSearch(this)" />
			<a onclick="docart(this)" href="cart.jsp" class="gwc"><!-- <img src="images/gwc.png"> --><em id="totalnum">0</em></a>
		</div>
		<div class="home-hot-wrap">
<div class="addWrap">
  <div class="swipe" id="mySwipe">
    <div class="swipe-wrap">
      <a style="visibility:visible;" href="javascript:;"><img class="img-responsive" src="../images/banner1.jpg"/></a>
      <!-- <div><a href="javascript:;"><img class="img-responsive" src="../images/banner2.jpg"/></a></div>
      <div><a href="../images/youhuida.jpg"><img class="img-responsive" src="../images/youhui.jpg"/></a></div> -->
    </div>
  </div>
  <ul id="position">
    <!-- <li class="cur"></li> -->
    <!-- <li class=""></li> -->
  </ul>
</div>
			<div class="home-hot">
				<div class="index_xiaotubiao1" onclick="dohrefJump('goodsclass.jsp')"><img src="../images/index_fenlei.png">
				<span>商品分类</span></div>
				<div class="index_xiaotubiao1" onclick="dohrefJump('order.jsp')"><img src="../images/index_dingdan.png">
				<span>我的订单</span></div>
				<div class="index_xiaotubiao1" onclick="dohrefJump('collect.jsp')"><img src="../images/index_goumai.png">
				<span>我的收藏</span></div>
				<div class="index_xiaotubiao1" onclick="dopinpaizhuanqu()"><img src="../images/index_pinpai.png">
				<span>品牌推荐</span></div>
			</div>
			<ul class="home-hot-commodity">
			</ul>
		</div>
		
		<div id="index-area-box" class="" style="padding-top: 10px;margin-bottom: 15%;">
			
	    </div>
		<div class="personal-center-nav">
    	<ul>
        	<li class="active"><a href="index.jsp">
        	<em class="icon-shouye2"></em>首页</a></li>
            <li><a href="goodsclass.jsp"><em class="icon-fenlei1"></em>商城</a></li>
            <li><a onclick="docart(this)" href="cart.jsp"><em class="icon-gwc1"></em>购物车</a></li>
            <li><a href="customerlist.jsp"><em class="ion-android-person"></em>客户</a></li>
        </ul>
    </div>
	</div>
	<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="popup_msg">尚无账号，立即注册？</p>
            <a class="cd-popup-close">取消</a><a class="popup_queding" href="reg.jsp">确定</a>
		</div>
	</div>
</div>
<script src="../js/jquery-1.8.3.min.js"></script>
<script type="text/javascript">
var basePath = '<%=basePath%>';
//var xian = '';
//var city = '';
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){
	$(".citydrop").text(customer.customerxian);
		
	if(!window.localStorage.getItem("totalnum")){
		window.localStorage.setItem("totalnum",0);
	}
	//购物车图标上的数量
	if(!window.localStorage.getItem("cartnum")){
		window.localStorage.setItem("cartnum",0);
	}else if(window.localStorage.getItem("cartnum")==0){
		$("#totalnum").hide();
		$("#totalnum").text(0);
	}else{
		$("#totalnum").text(window.localStorage.getItem("cartnum"));
	}
	$(".citydrop").text(customer.customerxian);
	initCustomer();
});
//跳转
function dohrefJump(url){
	window.location.href = url;
}
//得到客户信息
function initCustomer(){
		//首页图片和首页专区
		$.ajax({
			url:"GLSystem_attachAction.do?method=shouyeImg",
			type:"post",
			data:{
				customerid:customer.customerid,
				customerxian:customer.customerxian
			},
			success:function(resp){
				var pageData = eval('('+resp+')');
				if(pageData.msg=='操作成功'){
					var href = "javascript:;";
					var areaArray = pageData.area;		//首页区
					$.each(areaArray,function(i,item){
						$('#index-area-box').append('<a onclick="" href="'+item.indexareaurl+'"><img alt="'+item.indexareaname+'" src="../'+item.indexareaimage+'"></a>');
					});
				} else {
					alert(pageData.msg);
				}
			},
			error:function(resp){
				var pageData = eval('('+resp+')');
				alert(pageData.msg);
			}
		});
}
//到裸价商品
function doLuoJaGoods(){
	window.localStorage.setItem("goodsclassname","裸价商品");
	$.ajax({
		url:"GLGoodsclassAction.do?method=mselAll",
		type:"post",
		data:{
			wheresql:"goodsclassname='裸价专区'",
			cusid:customer.customerid
		},
		success : function(data){
			window.localStorage.setItem("goodsclassparent",data.root[0].goodsclassid);
			window.location.href = "goodsclass.jsp";
		},
		error : function(resp){
			
		}
	});
}
//到品牌专区
function dopinpaizhuanqu(){
	$.ajax({
		url:"GLGoodsclassAction.do?method=mselAll",
		type:"post",
		data:{
			wheresql:"goodsclassname='品牌专区'",
			cusid:customer.customerid
		},
		success : function(data){
			window.localStorage.setItem("goodsclassparent",data.root[0].goodsclassid);
			window.location.href = "goodsclass.jsp";
		},
		error : function(resp){
			window.location.href = "goodsclass.jsp";
		}
	});
}
	
//提交搜索条件
function submitSearch(obj) {
	var event = window.event || arguments.callee.caller.arguments[0];
	if (event.keyCode == 13) { 												//如果按下的是回车键
		var seachVal = $("#searchdishes").val();							//获取搜索条件
		window.location.href = 'goods.jsp?searchdishes=' + seachVal;

	}
}

//到购物车页面
function docart(obj){
	if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
		$(obj).attr("href","cartnothing.html");
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
<script src="../js/swipe.js"></script> 
</body>
</html>
