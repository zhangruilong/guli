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
<link href="css/dig.css" type="text/css" rel="stylesheet">
</head>

<body>
<div class="gl-box">
<form id="form1" runat="server">
    <div class="wapper-nav"><a onclick="javascript:history.go(-1);" class='goback'></a>购物车</div>
    <div class="cart-wrapper" id="tab">
    </div>
</form>
</div>
<div class="footer">
	<div class="jiesuan-foot-info"><img src="images/jiesuanbg.png" > 种类数：<span id="totalnum">0</span>总价：<span id="totalmoney">0</span> </div><a onclick="checkCusSecKill();" class="jiesuan-button">结算</a>
</div>
<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="popup_msg">还未注册,是否现在注册?</p>
            <a href="#" class="cd-popup-close">取消</a><a class="popup_queding" href="doReg.action">确定</a>
		</div>
	</div>
</div>
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
<script> 
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){
	if(!window.localStorage.getItem("totalnum")){
		window.localStorage.setItem("totalnum",0);
		$("#totalnum").text(0);
	}else{
		$("#totalnum").text(window.localStorage.getItem("totalnum"));
	}
	if(!window.localStorage.getItem("totalmoney")){
		window.localStorage.setItem("totalmoney",0);
		$("#totalmoney").text(0);
	}else{
		$("#totalmoney").text(window.localStorage.getItem("totalmoney"));
	}
	var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
	initDishes(sdishes);
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		if($(event.target).is(".cd-popup-close") || $(event.target).is(".cd-popup-container")){
			//如果点击的是'取消'或者除'确定'外的其他地方
			$(this).removeClass("is-visible");	//移除'is-visible' class
			
		}
	});
});
//点击结算时执行的方法
function nextpage(){
	setscompany();		//设置供应商信息
	if(customer.customerid != null && customer.customerid != ''){
		window.location.href = "doEmpBuy.action?addresscustomer="+customer.customerid+"&addressture=1";
	} else {
		$(".cd-popup").addClass("is-visible");
	}
}
//检查客户是否可以购买秒杀商品
function checkCusSecKill(){
	var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
	var outGoodsName = '';
	$.post('queryCusSecKillOrderdEmp.action',{'orderm.ordermcustomer':customer.customerid},function(data){
		var count = 0;
		if(data.msg == 'no'){
			$(".popup_msg").text("还没有收货地址,请先添加收货地址。");
			$(".popup_queding").attr("href","mine.jsp");
			$(".cd-popup").addClass("is-visible");
			return;
		}
		$.each(sdishes,function(i,item1){
			if(item1.orderdtype == '秒杀'){
				var restNum = parseInt(item1.timegoodsnum) - parseInt(item1.orderdetnum);
				if(data){
					$.each(data.miaoshaList,function(i,item2){
						if(item2.orderdcode == item1.goodscode){
							restNum -= parseInt(item2.orderdnum);
						}
					});
				}
				if(restNum < 0){		//买的秒杀商品数量超过了个人限量
					count++;
				}
			}
			if(item1.orderdtype == '买赠'){
				var restNum = parseInt(item1.timegoodsnum) - parseInt(item1.orderdetnum);
				if(data){
					$.each(data.giveGoodsList,function(i,item2){
						if(item2.orderdcode == item1.goodscode){
							restNum -= parseInt(item2.orderdnum);
						}
					});
				}
				if(restNum < 0){		//买的商品数量超过了限购数量
					count++;
				}
			}
		});
		if(count > 0){
			alert('您购买的商品超过了限购数量。');
		} else {
			nextpage();
		}
	},'json');
}
//设置供应商信息
function setscompany(){
	var data = JSON.parse(window.localStorage.getItem("sdishes"));
	var scompany = new Array();
	$.each(data, function(i, item) {
		if(scompany.length==0){
			var mcompany = new Object();
			mcompany.ordermcompany = item.goodscompany;
			mcompany.companyshop = item.companyshop;
			mcompany.companydetail = item.companydetail;
			mcompany.ordermnum = 1;
			mcompany.ordermmoney = (item.pricesprice * item.orderdetnum).toFixed(2);
			scompany.push(mcompany);
		}else{
			$.each(scompany, function(y, item2) {
				if(item2.ordermcompany == item.goodscompany){
					item2.ordermnum += 1;
					item2.ordermmoney = (parseFloat(item2.ordermmoney) + item.pricesprice * item.orderdetnum).toFixed(2);
					return false;
				}else if(y==scompany.length-1){
					var mcompany = new Object();
					mcompany.ordermcompany = item.goodscompany;
					mcompany.companyshop = item.companyshop;
					mcompany.companydetail = item.companydetail;
					mcompany.ordermnum = 1;
					mcompany.ordermmoney = (item.pricesprice * item.orderdetnum).toFixed(2);
					scompany.push(mcompany);
				}
			});
		}
	});
	window.localStorage.setItem("scompany",JSON.stringify(scompany));
	return scompany;
}
function initDishes(data){
	var scompany = setscompany();
    $(".cart-wrapper").html("");
    $.each(scompany, function(y, mcompany) {
    	$(".cart-wrapper").append('<h1 name="'+mcompany.companyid +'">'+mcompany.companyshop+'</h1><ul>');
    	$.each(data, function(i, item) {
    		if(mcompany.ordermcompany==item.goodscompany)
            $(".cart-wrapper").append('<li name="'+item.goodsid+'">'+
                      	'<em><img src="../'+item.goodsimage+
         	         	'" alt="" onerror="javascript:this.src=\'images/default.jpg\'"/></em> '+
                      	'<h2>'+item.goodsname+'<span class="price">'+item.pricesprice+'元/'+item.pricesunit+'</span></h2>'+
          				'<span onclick="subnum(this,'+item.pricesprice+')" class="jian min"></span>'+
                          '<input class="text_box shuliang" name="'+item.goodsdetail+'" type="text" value="'+
       	                getcurrennum(item.goodsid,item.goodsdetail)+'"> '+
                          '<span onclick="addnum(this,'+item.pricesprice+',\''+item.goodscode+'\',\''+item.goodsclassname+'\')" class="jia add"></span>'+
                      '</li>');
       });
       $(".cart-wrapper").append('</ul><div class="songda">'+mcompany.companydetail+'</div>');		//添加供应商信息
	});
}
function getcurrennum(dishesid,goodsdetail){
	//订单
	if(window.localStorage.getItem("sdishes")==null){
		return 0;
	}else{
		var orderdetnum = 0;
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
		$.each(sdishes, function(i, item) {
			if(item.goodsid==dishesid
					&&item.goodsdetail==goodsdetail){
				orderdetnum = item.orderdetnum;
				return false;
			}
		});
		return orderdetnum;
	}
}
//增加商品数量
function addnum(obj,dishesprice,goodscode,goodsclassname){
	$.post('queryCusSecKillOrderdEmp.action',{'orderm.ordermcustomer':customer.customerid},function(data){
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
		var count = 0;
		if(data.msg == 'no'){
			$(".popup_msg").text("还没有收货地址,请先添加收货地址。");
			$(".popup_queding").attr("href","mine.jsp");
			$(".cd-popup").addClass("is-visible");
			return;
		}
		$.each(sdishes,function(i,item1){
			if(item1.orderdtype == goodsclassname.substring(0,2) && item1.goodscode == goodscode){
				var restNum = parseInt(item1.timegoodsnum) - parseInt(item1.orderdetnum);
				if(data){
					$.each(data.miaoshaList,function(i,item2){
						if(item2.orderdcode == item1.goodscode){
							restNum -= parseInt(item2.orderdnum);
						}
					});
				}
				if(restNum-1 < 0){		//买的秒杀商品数量超过了个人限量
					count++;
				}
			}
			/* if(item1.orderdtype == '买赠'){
				var restNum = parseInt(item1.timegoodsnum) - parseInt(item1.orderdetnum);
				if(data){
					$.each(data.giveGoodsList,function(i,item2){
						if(item2.orderdcode == item1.goodscode){
							restNum -= parseInt(item2.orderdnum);
						}
					});
				}
				if(restNum < 0){		//买的商品数量超过了限购数量
					count++;
				}
			} */
			
		});
		
		if(count > 0){
			alert('您购买的商品超过了限购数量。');
		} else {
			//总价
			var tmoney = parseFloat(window.localStorage.getItem("totalmoney"));
			var newtmoney = (tmoney+dishesprice).toFixed(2);
			$("#totalmoney").text(newtmoney);
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
			//修改订单
			$.each(sdishes, function(i, item) {
				if(item.goodsid==$(obj).parent().attr('name')
						&&item.goodsdetail==$(obj).prev().attr('name')){
					item.orderdetnum = item.orderdetnum + 1;
					return false;
				}
			});
			window.localStorage.setItem("sdishes",JSON.stringify(sdishes));
			var cartnum = parseInt(window.localStorage.getItem("cartnum"));
			window.localStorage.setItem("cartnum",cartnum+1);
		}
	},'json');
}
//减少商品数量
function subnum(obj,dishesprice){
	var numt = $(obj).next(); 
	var num = parseInt(numt.val());
	if(num > 0){
		//总价
		var tmoney = parseFloat(window.localStorage.getItem("totalmoney"));
		var newtmoney = (tmoney-dishesprice).toFixed(2);
		$("#totalmoney").text(newtmoney);
		window.localStorage.setItem("totalmoney",newtmoney);
		//数量
		numt.val(num-1);
		//订单
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
		var scompany = JSON.parse(window.localStorage.getItem("scompany"));
		var delgoodsid = '-1';
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
			$("#totalnum").text(tnum-1);
			window.localStorage.setItem("totalnum",tnum-1);
			$(obj).parent().remove();
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
		window.localStorage.setItem("cartnum",cartnum-1);
		if(window.localStorage.getItem("sdishes") == "[]"){
			//如果是空购物车
			window.location.href = "cartnothing.html";
		}
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
