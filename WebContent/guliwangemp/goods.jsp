<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
	String searchdishesvalue = request.getParameter("searchdishes");
	String searchclassesvalue = request.getParameter("searchclasses");
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
<link href="css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">
.stock-num{float: left;width: 60%;}
.goods-wrapper .home-hot-commodity li span{margin: 5% 0% 5% 0%;}
</style>
</head>

<body>
<div class="gl-box">
	<div class="home-search-wrapper">
        <span class="citydrop"><span id="curgoodsclass">大米</span> <em><img src="images/dropbg.png"></em></span> 
        <div class="menu">
            <div class="menu-tags home-city-drop">
                <div class="fenlei-tit">食材谱</div>
                <div class="wrapper">
                	<div class="fenlei-left">
                    	<ul id="fenlei-left">
                        </ul>
                    </div>
                    <div class="fenlei-right">
                    </div>
                </div>
            </div>
        </div>
        <input id="searchdishes" type="text" placeholder="请输入商品名称" onkeydown="entersearch()"/>
        <a onclick="docart(this)" href="cart.jsp" class="gwc"><em id="totalnum">0</em></a>
    </div>
    <div class="goods-wrapper">
        <ul class="home-hot-commodity">
        </ul>
    </div>
</div>
<div class="personal-center-nav">
    	<ul>
        	<li><a href="index.jsp">
        	<em class="icon-shouye1"></em>首页</a></li>
            <li class="active"><a href="goodsclass.jsp"><em class="icon-fenlei2"></em>商城</a></li>
            <li><a onclick="docart(this)" href="cart.jsp"><em class="icon-gwc1"></em>购物车</a></li>
            <li class="active"><a href="customerlist.jsp"><em class="ion-android-person"></em>客户</a></li>
        </ul>
    </div>
<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="meg">尚无账号，立即注册？</p>
            <a class="cd-popup-close">取消</a><a class="ok" href="doReg.action" style="display: inline-block;">确定</a>
		</div>
	</div>
</div>
<script src="js/jquery-2.1.4.min.js"></script>
<script src="js/jquery-dropdown.js"></script>
<script> 
var basePath = '<%=basePath%>';
var searchdishesvalue = '<%=searchdishesvalue%>';
var searchclassesvalue = '<%=searchclassesvalue%>';
var emp = JSON.parse(window.localStorage.getItem("emp"));
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){ 
	if(!window.localStorage.getItem("totalnum")){
		window.localStorage.setItem("totalnum",0);
	}
	if(!window.localStorage.getItem("totalmoney")){
		window.localStorage.setItem("totalmoney",0);
	}
	if(!window.localStorage.getItem("cartnum")){
		window.localStorage.setItem("cartnum",0);
	}else if(window.localStorage.getItem("cartnum")==0){
		$("#totalnum").hide();
		$("#totalnum").text(0);
	}else{
		$("#totalnum").text(window.localStorage.getItem("cartnum"));
	}
	//通过ajax查询大类
	getJson(basePath+"GoodsclassAction.do",{method:"mselAll",wheresql:"goodsclassparent='root' and goodsclassstatue='启用'"},initGoodsclass,null);
	if(searchdishesvalue!="null"&&searchdishesvalue!=""){
		getJson(basePath+"GoodsviewAction.do",{method:"mselAll",query:searchdishesvalue,companyid:emp.empcompany,customerid:customer.customerid,customertype:customer.customertype,customerlevel:customer.customerlevel},initDishes,null);
	}else if(searchclassesvalue!="null"&&searchclassesvalue!=""){
		$("#curgoodsclass").html(searchclassesvalue);
		getJson(basePath+"GoodsviewAction.do",{method:"mselAll",companyid:emp.empcompany,customerid:customer.customerid,customertype:customer.customertype,customerlevel:customer.customerlevel,goodsclassname:searchclassesvalue},initDishes,null);
	}else{
		getJson(basePath+"GoodsviewAction.do",{method:"mselAll",companyid:emp.empcompany,customerid:customer.customerid,customertype:customer.customertype,customerlevel:customer.customerlevel,goodsclassname:"大米"},initDishes,null);
	}
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		$(this).removeClass("is-visible");	//移除'is-visible' class
	});
})
function initCustomer(data){			//将customer(客户信息放入缓存)
	window.localStorage.setItem("customer",JSON.stringify(data.root[0]));
	customer = data.root[0];
}
function entersearch(){
    var event = window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == 13)
    {
    	searchdishesvalue = $("#searchdishes").val();
    	getJson(basePath+"GoodsviewAction.do",{method:"mselAll",customerid:customer.customerid,query:searchdishesvalue,customertype:customer.customertype,customerlevel:customer.customerlevel},initDishes,null);
    }
}
//商品大小类
function initGoodsclass(data){																								//初始化商品大小类
	 $("#fenlei-left").html("");
	 $.each(data.root, function(i, item) {				//遍历 data 中的 root 
		if(item.goodsclassid==window.localStorage.getItem("goodsclassparent")){
			$("#fenlei-left").append('<li class="active" name="'+item.goodsclassid+'"><a href="#"><img src="'+item.goodsclassdetail+'" > '+item.goodsclassname+'</a></li>');
			getJson(basePath+"GoodsclassAction.do",{method:"mselAll",wheresql:"goodsclassparent = '"+item.goodsclassid+"' and goodsclassstatue='启用'"},initGoodsclassright,null);
		}else{
			$("#fenlei-left").append('<li name="'+item.goodsclassid+'"><a href="#"><img src="'+item.goodsclassdetail+'" > '+item.goodsclassname+'</a></li>');
		}
    });
 	$("#fenlei-left li").each(function(){				//遍历 li
		$(this).click(function(){
			$(this).addClass('active').siblings().removeClass('active');	//当前元素被点击时添加 class 'active' 同时把其他同级元素 去除  class 'active'
			//ajax查询小类并初始化
			getJson(basePath+"GoodsclassAction.do",{method:"mselAll",wheresql:"goodsclassparent = '"+$(this).attr('name')+"' and goodsclassstatue='启用'"},initGoodsclassright,null);
			window.localStorage.setItem("goodsclassparent",$(this).attr('name'));
		})
	});
}
//小类
function initGoodsclassright(data){																							//大小类右边
	 $(".fenlei-right").html("");
	 $.each(data.root, function(i, item) {
		 if(item.goodsclassname==window.localStorage.getItem("goodsclassname")){
			 $(".fenlei-right").append('<a href="#" style="background-color:#2c77e6; color:#fff" onclick="gotogoods(\''+item.goodsclassname+'\')">'+item.goodsclassname+'</a>');
		}else{
			$(".fenlei-right").append('<a href="#" onclick="gotogoods(\''+item.goodsclassname+'\')">'+item.goodsclassname+'</a>');
		}
    });
}

function gotogoods(goodsclassname){
	window.localStorage.setItem("goodsclassname",goodsclassname);
	window.location.href = "goods.jsp?searchclasses="+goodsclassname;
}

//商品
function initDishes(data){
     $(".home-hot-commodity").html("");
 	 $.each(data.root, function(i, item) {
 		var jsonitem = JSON.stringify(item);
 		//var goods = jsonitem.replace(/\"/g,'\\"');
 		//alert(goods);
 		$(".home-hot-commodity").append('<li>'+
 	         	'<span onclick="gotogoodsDetail(\''+ encodeURI(jsonitem)+ '\');" class="fl"><img src="../'+item.goodsimage+
 	         	'" alt="" onerror="javascript:this.src=\'images/default.jpg\'"/></span> '+
 	         	'<h1 onclick="gotogoodsDetail(\''+encodeURI(jsonitem)+ '\');">'+item.goodsname+'<span>('+item.goodsunits+')</span></h1>'+
 	           '  <div class="block" onclick="gotogoodsDetail(\''+encodeURI(jsonitem)+ '\');"> '+
 	               '  <span>'+
 	                   '  <input type="radio" id="'+item.goodsid+'radio2" name="'+item.goodsid+'radio" class="regular-radio" />'+
 	               '      <label for="'+item.goodsid+'radio2">套装价:<font class="font-oringe">￥'+item.pricesprice2+'</font>/'+item.pricesunit2+'</label>'+
 	               '  </span>'+
 	             	'<span>'+
 	                 '    <input type="radio" id="'+item.goodsid+'radio1" name="'+item.goodsid+'radio" class="regular-radio" checked />'+
 	                '    <label for="'+item.goodsid+'radio1">售价:<font class="font-oringe">￥'+item.pricesprice+'</font>/'+item.pricesunit+'</label>'+
 	               '  </span>'+
 	            ' </div>'+
 	           '  <div class="stock-num" name="'+item.goodsid+'">'+
 	                ' <span class="jian min" onclick="subnum(this,'+item.pricesprice
					   +')"></span>'+
 	                 '<input readonly="readonly" class="text_box shuliang" name="danpin" type="text" value="'+
 	                 getcurrennumdanpin(item.goodsid)+'"> '+
 	                ' <span class="jia add" onclick="addnum(this,'+item.pricesprice
					   +',\''+item.goodsname+'\',\''+item.pricesunit+'\',\''+item.goodsunits
					   +'\',\''+item.goodscode+'\',\''+item.goodsclassname
					   +'\',\''+item.goodscompany+'\',\''+item.companyshop+'\',\''+item.companydetail
					   +'\')"></span>'+
				   '<span hidden="ture">'+jsonitem+'</span>'+
 	               '  <span hidden="ture" class="jian min" onclick="subnum(this,'+item.pricesprice2
				   +')"></span>'+
 	                ' <input readonly="readonly" hidden="ture" class="text_box shuliang" name="taozhuan" type="text" value="'+
 	                getcurrennumtaozhuan(item.goodsid)+'"> '+
 	                ' <span hidden="ture" class="jia add" onclick="addnum(this,'+item.pricesprice2
					   +',\''+item.goodsname+'\',\''+item.pricesunit2+'\',\''+item.goodsunits
					   +'\',\''+item.goodscode+'\',\''+item.goodsclassname
					   +'\',\''+item.goodscompany+'\',\''+item.companyshop+'\',\''+item.companydetail
					   +'\')"></span>'+
					'<span hidden="ture">'+jsonitem+'</span>'+
 	                ' <input type="checkbox" id="'+item.goodsid+'checkbox" class="chk_1" '+item.goodsdetail+'>'+
 	            		'<label for="'+item.goodsid+'checkbox" onclick="checkedgoods(\''+item.goodsid+'\');"></label>'+
 	             '</div>'+
 	         '</li>');
 			if(item.pricesunit2==null||item.pricesunit2==''||item.pricesunit2==undefined){
 				$("#"+item.goodsid+"radio2").parent().css("display","none");
 			}
     });
 	$(".regular-radio").change(function(){ 
		var t = $(this).parent().parent().next().find('input[name*=danpin]');
		t.toggle();
		t.prev().toggle();
		t.next().toggle();
		var t2 = $(this).parent().parent().next().find('input[name*=taozhuan]');
		t2.toggle();
		t2.prev().toggle();
		t2.next().toggle();
	})
}
//到商品详情页
function gotogoodsDetail(jsonitem){
	window.location.href = 'goodsDetail.jsp?type=商品&goods='+jsonitem;
}
//收藏商品
function checkedgoods(goodsid){
	if(!customer.customerid || typeof(customer.customerid) == 'undefined'){
		$("#"+goodsid+"checkbox").prop("checked",false);
		$("#"+goodsid+"checkbox").attr("checked","");
		$(".cd-buttons .meg").text("尚无账号，立即注册？");
		$(".cd-buttons .ok").css("display","inline-block");
		$(".cd-popup-close").text("取消");
		$(".cd-popup").addClass("is-visible");
		return;
	}
	var url = 'CollectAction.do?method=';
	if($("#"+goodsid+"checkbox").is(':checked')){
		url +='delAllByGoodsid';
	}else{
		url +='insAll';
	}
	var json = '[{"collectgoods":"' + goodsid + 
		'","collectcustomer":"' + customer.customerid + '"}]';
	$.ajax({
		url : url,
		data : {
			json : json
		},
		success : function(resp) {
			var respText = eval('('+resp+')'); 
			if(respText.success == false) 
				alert(respText.msg);
			else {
				$(".cd-buttons .meg").text("操作成功!");
				$(".cd-buttons .ok").css("display","none");
				$(".cd-popup-close").text("确定");
				$(".cd-popup").addClass("is-visible");	//弹出窗口
				setTimeout(function () {  
					$(".cd-popup").removeClass("is-visible");	//一秒钟后关闭弹窗
			    }, 1000);
			}
		},
		error : function(resp) {
			alert('网络出现问题，请稍后再试');
		}
	});
}
//初始化加减号的数字
function getcurrennumdanpin(dishesid){
	//订单
	if(window.localStorage.getItem("sdishes")==null){
		return 0;
	}else{
		var orderdetnum = 0;
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
		$.each(sdishes, function(i, item) {
			if(item.goodsid==dishesid
					&&item.goodsdetail=="danpin"){
				orderdetnum = item.orderdetnum;
				return false;
			}
		});
		return orderdetnum;
	}
}
function getcurrennumtaozhuan(dishesid){
	//订单
	if(window.localStorage.getItem("sdishes")==null){
		return 0;
	}else{
		var orderdetnum = 0;
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
		$.each(sdishes, function(i, item) {
			if(item.goodsid==dishesid
					&&item.goodsdetail=="taozhuan"){
				orderdetnum = item.orderdetnum;
				return false;
			}
		});
		return orderdetnum;
	}
}
//加号
function addnum(obj,pricesprice,goodsname,pricesunit,goodsunits,goodscode,goodsclassname,goodscompany,companyshop,companydetail){
	var item = JSON.parse($(obj).next().text());
	//总价
	var tmoney = parseFloat(window.localStorage.getItem("totalmoney"));
	var newtmoney = (tmoney+pricesprice).toFixed(2);
	window.localStorage.setItem("totalmoney",newtmoney);
	//数量
	var numt = $(obj).prev(); 
	var num = parseInt(numt.val());
	numt.val(num+1);
	//订单
	if(window.localStorage.getItem("sdishes")==null){
		window.localStorage.setItem("sdishes","[]");
	}
	var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
	if(num == 0){
		$("#totalnum").show();
		//新增订单
		var mdishes = new Object();
		mdishes.goodsid = $(obj).parent().attr('name');
		mdishes.goodsdetail = $(obj).prev().attr('name');
		mdishes.goodscompany = goodscompany;
		mdishes.companyshop = companyshop;
		mdishes.companydetail = companydetail;
		mdishes.goodsclassname = goodsclassname;
		mdishes.goodscode = goodscode;
		mdishes.pricesprice = pricesprice;
		mdishes.pricesunit = pricesunit;
		mdishes.goodsname = goodsname;
		mdishes.goodsunits = goodsunits;
		mdishes.orderdetnum = num + 1;
		mdishes.goodsimage = item.goodsimage;
		mdishes.orderdtype = '商品';
		sdishes.push(mdishes);
		//种类数
		var tnum = parseInt(window.localStorage.getItem("totalnum"));
		window.localStorage.setItem("totalnum",tnum+1);
	}else{
		//修改订单
		$.each(sdishes, function(i, item) {
			if(item.goodsid==$(obj).parent().attr('name')
					&&item.goodsdetail==$(obj).prev().attr('name')){
				item.orderdetnum = item.orderdetnum + 1;
				return false;
			}
		});
	}
	window.localStorage.setItem("sdishes",JSON.stringify(sdishes));
	
	var cartnum = parseInt(window.localStorage.getItem("cartnum"));
	$("#totalnum").text(cartnum+1);
	window.localStorage.setItem("cartnum",cartnum+1);
}
//减号
function subnum(obj,pricesprice){
	var numt = $(obj).next(); 
	var num = parseInt(numt.val());
	if(num > 0){
		//总价
		var tmoney = parseFloat(window.localStorage.getItem("totalmoney"));
		var newtmoney = (tmoney-pricesprice).toFixed(2);
		window.localStorage.setItem("totalmoney",newtmoney);
		//数量
		numt.val(num-1);
		//订单
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
		if(num == 1){
			//删除订单
			$.each(sdishes,function(i,item){
				if(item.goodsid==$(obj).parent().attr('name')){
					sdishes.splice(i,1);
					return false;
				};
			});
			//种类数
			var tnum = parseInt(window.localStorage.getItem("totalnum"));
			window.localStorage.setItem("totalnum",tnum-1);
			if(tnum == 1)
			$("#totalnum").hide();
		}else{
			//修改订单
			$.each(sdishes, function(i, item) {
				if(item.goodsid==$(obj).parent().attr('name')
						&&item.goodsdetail==$(obj).next().attr('name')){
					item.orderdetnum = item.orderdetnum - 1;
					return false;
				}
			});
		}
		window.localStorage.setItem("sdishes",JSON.stringify(sdishes));
		var cartnum = parseInt(window.localStorage.getItem("cartnum"));
		$("#totalnum").text(cartnum-1);
		window.localStorage.setItem("cartnum",cartnum-1);
	}
	
}
//到购物车页面
function docart(obj){
	if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
		$(obj).attr("href","cartnothing.html");
	}
}
function nextpage(){
	if(window.localStorage.getItem("totalnum")==0)
		window.location.href = "cartnothing.html";
	else
		window.location.href = "cart.jsp";
}

function testJsonp(data){
	//console.log(data);
}

function callbackparam(data){
	//console.log(data);
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
