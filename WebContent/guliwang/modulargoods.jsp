<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
<link href="../css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">
.goods-wrapper .home-hot-commodity li a{padding: 0;}
.stock-num{width: 30%;margin: 9% 0% 0% 0%;}
</style>
</head>
<body>
<div class="gl-box">
    <div class="wapper-nav"><a onclick='javascript:history.go(-1);' class='goback'></a>
	组合商品<a onclick="docart(this)" href="cart.jsp" class="gwc"><em id="totalnum">0</em></a></div>
    <div class="goods-wrapper">
        <ul class="home-hot-commodity">
        </ul>
    </div>
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
<script src="../js/jquery-2.1.4.min.js"></script>
<script src="../js/jquery-dropdown.js"></script>
<script src="../js/base.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
var bkgoodscode = '${param.bkgoodscode}';
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
	//弹窗
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		if($(event.target).is(".cd-popup-close") || $(event.target).is(".cd-popup-container")){
			//如果点击的是'取消'或者除'确定'外的其他地方
			$(this).removeClass("is-visible");	//移除'is-visible' class
			
		}
	});
	var companyid = '';
	if(typeof(emp) != 'undefined'){
		//companyid = emp.empcompany;
	}
	$.ajax({
		url:"GLBkgoodsviewAction.do?method=carnivalGoods",	//组合
		type:"post",
		data:{
			companyid:companyid,
			customerid:customer.customerid,
			customertype:customer.customertype,
			bkgoodsclass:'组合商品',
			bkgoodscode:bkgoodscode,
			customerxian: customer.customerxian
		},
		success : initCarnivalPage,
		error: function(resp){
			var respText = eval('('+resp+')'); 
			alert(respText.msg);
		}
	});
});
//到商品详情页
function gotogoodsDetail(jsonitem){
	window.location.href = 'goodsDetail.jsp?type=组合&goods='+jsonitem;
}
//初始化页面
function initCarnivalPage(resp){
	var data = eval('('+resp+')');
	$.ajax({
		url:"GLOrderdAction.do?method=selCusXGOrderd",				//查询客户今天购买的秒杀商品数量
		type:"post",
		data:{
			customerid:customer.customerid,
			wheresql: "bkgoodssurplus>'0'",
			companyid: data.root[0].bkgoodscompany
		},
		success : function(data2){
			var cusOrder = JSON.parse(data2);						//买过的限购商品订单
			$(".home-hot-commodity").html("");
			if(typeof(data.root) == 'undefined' ||　!data.root){
				return;
			}
			$.each(data.root,function(j,item2){
				var jsonitem = JSON.stringify(item2);			
				var dailySur = parseInt(item2.bkgoodsnum);			//剩余的每日限购数量
				var bkgoodsimages = [];								//商品图片
				if(typeof(item2.bkgoodsimage)!='undefined'){
					bkgoodsimages = item2.bkgoodsimage.split(',');
		 		} else {
		 			bkgoodsimages[0] = 'images/default.jpg';
		 		}
				var liObj = '<li><span onclick="gotogoodsDetail(\''+encodeURI(jsonitem)+'\')" class="fl"> <img src="../'+bkgoodsimages[0]+
	         	'" alt="" onerror="javascript:this.src=\'../images/default.jpg\'"/></span>'+
				'<h1 onclick="gotogoodsDetail(\''+encodeURI(jsonitem)+'\')">'+item2.bkgoodsname+
					'<span>（'+item2.bkgoodsunits+'）</span>'+
				'</h1> <span style="" onclick="gotogoodsDetail(\''+encodeURI(jsonitem)+'\')">';
				if(cusOrder && cusOrder.root && cusOrder.root.length >0){
					if(item2.bkgoodsnum != -1){					//如果有每日限购
						var itemGoodsCount = 0;
						$.each(cusOrder.root,function(k,item3){
							if(item3.orderdtype == '组合' && item3.orderdgoods == item2.bkgoodsid ){
								itemGoodsCount += parseInt(item3.orderdclass);
							}
						});
						dailySur = parseInt(item2.bkgoodsnum) - itemGoodsCount;									//每日限购剩余数量
						liObj += '<font>每日限购'+item2.bkgoodsnum+item2.bkgoodsunit+'。</font>';
					}
					if(item2.bkgoodsallnum != '-1'){
						liObj += ' <font>总限量'+item2.bkgoodsallnum+item2.bkgoodsunit+'，还剩'+item2.bkgoodssurplus+item2.bkgoodsunit+'。</font>';
					}
				} else {
					if(item2.bkgoodsnum != -1){					//如果有每日限购
						liObj += '<font>每日限购'+item2.bkgoodsnum+item2.bkgoodsunit+'。</font>';
					}
					if(item2.bkgoodsallnum != '-1' ){
						liObj += '<font>总限量'+item2.bkgoodsallnum+item2.bkgoodsunit+'，还剩'+item2.bkgoodssurplus+item2.bkgoodsunit+'。</font>';
					}
				}
				liObj+='</span><br><span onclick="gotogoodsDetail(\''+encodeURI(jsonitem)+ '\',\''+dailySur+'\');" class="miaosha-detail" >'
				+changeStr(item2.bkgoodsdetail)+'</span>'
				+ '<div class="ms-bottom"><div class="miaosha_li_price_div"><strong>￥'+item2.bkgoodsorgprice+'/'+item2.bkgoodsunit+'</strong>';
				//判断是否有原价
				if(typeof(item2.bkgoodsprice)!='undefined' && item2.bkgoodsprice && item2.bkgoodsprice!=0) {
					liObj += ' <em>￥'+item2.bkgoodsprice+'</em>';
				}
				liObj += '</div>'+
					'<div class="miaosha_stock-num" name="'+item2.bkgoodsid+'">'+
		            '<span class="jian min"  onclick="subnum(this,\''+item2.bkgoodsorgprice+'\',\''+item2.bkgoodsclass+'\')"></span>'+
		            '<input readonly="readonly" class="text_box shuliang" name="miaosha" type="text" value="'+
		             getcurrennumdanpin(item2.bkgoodsid)+'"> '+
		            ' <span name="'+dailySur+'" class="jia add" onclick="addnum(this,'+item2.bkgoodsorgprice
					   +',\''+item2.bkgoodsname+'\',\''+item2.bkgoodsunit+'\',\''+item2.bkgoodsunits
					   +'\',\''+item2.bkgoodscode+'\',\''+item2.bkgoodsclass
					   +'\',\''+item2.bkgoodscompany+'\',\''+item2.companyshop+'\',\''+item2.companydetail
					   +'\',\''+item2.bkgoodssurplus+'\')"></span>'+
					   '<span hidden="ture">'+JSON.stringify(item2)+'</span>'+
		        	'</div></div></li>';
				$(".home-hot-commodity").append(liObj);
			});
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
}
//到购物车页面
function docart(obj){
	if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
		$(obj).attr("href","cartnothing.html");
	}
}
//加号
function addnum(obj,pricesprice,goodsname,pricesunit,goodsunits,goodscode,goodsclassname,goodscompany,companyshop,companydetail){
	if(!customer.customerid || customer.customerid == '' || typeof(customer.customerid) == 'undefined'){
		$(".cd-popup").addClass("is-visible");
		return;
	}
	var item = JSON.parse($(obj).next().text());				//得到商品信息
	//数量
	var numt = $(obj).prev(); 
	var num = parseInt(numt.val());
	var cusMSOrderNum = parseInt($(obj).attr("name"));
	
	if((parseInt(cusMSOrderNum) - num) <= 0 && item.bkgoodsnum != -1){
		alert('您购买的商品超过了限购数量。');
		return;
	} else {
		if(!window.localStorage.getItem("totalmoney")){
			window.localStorage.setItem("totalmoney","0");
		}
		//总价
		var tmoney = parseFloat(window.localStorage.getItem("totalmoney"));		//总价
		var newtmoney = (tmoney+pricesprice).toFixed(2);						//总价加上商品价格得到新价格
		window.localStorage.setItem("totalmoney",newtmoney);					//设置总价格到缓存
		//数量
		var numt = $(obj).prev();
		var num = parseInt(numt.val());						//得到input的值,商品数
		numt.val(num+1);									//input的值加一
		//订单
		if(window.localStorage.getItem("sdishes")==null || !window.localStorage.getItem("sdishes")){
			window.localStorage.setItem("sdishes","[]");
		}
		sdishes = JSON.parse(window.localStorage.getItem("sdishes"));	//得到现有订单
		if(num == 0){
			//如果数量是0
			$("#totalnum").show();
			/* alert(goodsunits.length);
			alert(goodsunits=='（5kg米 1.8L玉米油）*4组/箱'); */
			//新增订单
			var mdishes = new Object();
			mdishes.goodsid = $(obj).parent().attr('name');
			mdishes.goodsdetail = changeStr(item.bkgoodsdetail);
			mdishes.goodscompany = goodscompany;
			mdishes.companyshop = companyshop;
			mdishes.companydetail = companydetail;
			mdishes.goodsclassname = changeStr(goodsclassname);
			mdishes.goodscode = goodscode;
			mdishes.pricesprice = pricesprice;
			mdishes.pricesunit = pricesunit;
			mdishes.goodsname = goodsname;
			mdishes.goodsunits = goodsunits;
			mdishes.orderdetnum = num + 1;
			var bkgoodsimages = [];
			if(typeof(item.bkgoodsimage)!='undefined'){
				bkgoodsimages = item.bkgoodsimage.split(',');
	 		} else {
	 			bkgoodsimages[0] = 'images/default.jpg';
	 		}
			mdishes.goodsimage = bkgoodsimages[0];
			mdishes.orderdtype = '组合';
			mdishes.surplusnum = item.bkgoodssurplus;
			mdishes.timegoodsnum = item.bkgoodsnum;
			mdishes.goodsweight = item.bkgoodsweight;
			mdishes.goodsbrand = item.bkgoodsbrand;
			sdishes.push(mdishes);
			//种类数
			var tnum = parseInt(window.localStorage.getItem("totalnum"));
			window.localStorage.setItem("totalnum",tnum+1);
		}else{							
			//如果数量不是0
			//修改订单
			$.each(sdishes, function(i, item3) {
				if(item3.goodsid==$(obj).parent().attr('name')
						&&item3.orderdtype=='组合'){
					item3.orderdetnum = item3.orderdetnum + 1;
					return false;
				}
			});
		}
		window.localStorage.setItem("sdishes",JSON.stringify(sdishes));
		
		var cartnum = parseInt(window.localStorage.getItem("cartnum"));
		$("#totalnum").text(cartnum+1);
		window.localStorage.setItem("cartnum",cartnum+1);
	}
}
//减号
function subnum(obj,pricesprice,goodsclassname){
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
				if(item.goodsid==$(obj).parent().attr('name')
						&&item.orderdtype=="组合"){
					sdishes.splice(i,1);
					return false;
				}
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
						&&item.orderdtype=="组合"){
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
					&&item.orderdtype=="组合"){
				orderdetnum = item.orderdetnum;
				return false;
			}
		});
		return orderdetnum;
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