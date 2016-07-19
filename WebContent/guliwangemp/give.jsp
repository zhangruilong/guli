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
<link href="css/base.css" type="text/css" rel="stylesheet">
<link href="css/layout.css" type="text/css" rel="stylesheet">
<link href="css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">
.goods-wrapper .home-hot-commodity li a{padding: 0;}
.stock-num{width: 90px;}
</style>
</head>
<body>
<div class="gl-box">
    <div class="wapper-nav"><a onclick='javascript:history.go(-1);' class='goback'></a>
	买赠商品<a onclick="docart(this)" href="cart.jsp" class="gwc"><img src="images/gwc.png" ><em id="totalnum">0</em></a></div>
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
			<p class="popup_msg">尚无账号，立即注册？</p>
            <a class="cd-popup-close">取消</a><a class="popup_queding" href="doReg.action">确定</a>
		</div>
	</div>
</div>
<script src="js/jquery-2.1.4.min.js"></script>
<script src="js/jquery-dropdown.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
var xian = '${param.xian}';
var givegoodscode = '${param.givegoodscode}';
$(function(){ 
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		if($(event.target).is(".cd-popup-close") || $(event.target).is(".cd-popup-container")){
			//如果点击的是'取消'或者除'确定'外的其他地方
			$(this).removeClass("is-visible");	//移除'is-visible' class
			
		}
	});
	//购物车图标上的数量
	if(!window.localStorage.getItem("cartnum")){
		window.localStorage.setItem("cartnum",0);
	}else if(window.localStorage.getItem("cartnum")==0){
		$("#totalnum").hide();
		$("#totalnum").text(0);
	}else{
		$("#totalnum").text(window.localStorage.getItem("cartnum"));
	}
	//页面信息
	if(!xian || xian==''){
		xian = customer.customerxian;
	}
	$.getJSON("maizengPageEmp.action",{"givegoodcompany.city.cityname":xian,"givegoodscode":givegoodscode,"givegoodsscope":customer.customertype},initMiaoshaPage);
});
//到商品详情页
function gotogoodsDetail(jsonitem){
	window.location.href = 'goodsDetail.jsp?type=买赠&goods='+jsonitem;
}
//初始化页面
function initMiaoshaPage(data){
	$(".home-hot-commodity").html("");
	$.each(data.giveList,function(i,item1){
		var jsonitem = JSON.stringify(item1);
		var liObj = '<li><span onclick="gotogoodsDetail(\''
			+ encodeURI(jsonitem)+ '\');" class="fl"> <img src="../'+item1.givegoodsimage+
         	'" alt="" onerror="javascript:this.src=\'images/default.jpg\'"/></span>'+
			'<h1 onclick="gotogoodsDetail(\''+encodeURI(jsonitem)+ '\');">'+item1.givegoodsname+
				'<span>（'+item1.givegoodsunits+'）</span>'+
			'</h1><div class="block"> <span onclick="gotogoodsDetail(\''+encodeURI(jsonitem)+ '\');" style="font-size: 16px;">'
			+item1.givegoodsdetail+'</span><br> <span class="givegoods_li_priceANDunit"> <strong>￥'+item1.givegoodsprice+'/'+item1.givegoodsunit+
			'</strong> ';
		if(data.cusOrderdList != null && data.cusOrderdList.length != 0){
			var itemGoodsCount = 0;
			$.each(data.cusOrderdList,function(k,item3){
				if(item3.orderdcode == givegoodscode){
					itemGoodsCount += item3.orderdnum
				}
			});
			liObj += '<font>限购'+(item1.givegoodsnum - itemGoodsCount)+item1.givegoodsunit+'</font><br/>';
		} else {
			liObj += '<font>限购'+item1.givegoodsnum+item1.givegoodsunit+'</font><br/>';
		}
		liObj += '</span><span hidden="ture" style="display:none;">'+JSON.stringify(item1)+'</span>';
		liObj += '<div class="stock-num" name="'+item1.givegoodsid+'">'+
            '<span class="jian min"  onclick="subnum(this,'+item1.givegoodsprice+')"></span>'+
            '<input readonly="readonly" class="text_box shuliang" name="'+item1.givegoodsdetail+'" type="text" value="'+
             getcurrennumdanpin(item1.givegoodsid)+'"> '+
            ' <span class="jia add" onclick="addnum(this,'+item1.givegoodsprice
			   +',\''+item1.givegoodsname+'\',\''+item1.givegoodsunit+'\',\''+item1.givegoodsunits
			   +'\',\''+item1.givegoodscode+'\',\''+item1.givegoodsclass
			   +'\',\''+item1.givegoodscompany+'\',\''+item1.givegoodcompany.companyshop+'\',\''+item1.givegoodcompany.companydetail
			   +'\')"></span>'+
        	'</div></div>';
        liObj += '</li>';
		$(".home-hot-commodity").append(liObj);
	});
}
//判断是否到达限购数量
function judgePurchase(
		givegoodsid,
		givegoodsdetail,
		givegoodscompany,
		companyshop,
		companydetail,
		givegoodsclass,
		givegoodscode,
		givegoodsorgprice,
		givegoodsunit,
		givegoodsname,
		givegoodsimage,
		givegoodsunits,
		givegoodsnum
		) {
	if(!customer.customerid || customer.customerid == '' || typeof(customer.customerid) == 'undefined'){
		$(".cd-popup").addClass("is-visible");
		return;
	}
	$.getJSON('judgePurchaseGiveGoodsEmp.action',{
		'givegoodsnum':givegoodsnum,
		'givegoodscode':givegoodscode,
		'customerid':customer.customerid
	},function(data){
		if(data.result == 'ok'){
			chuancan(
					givegoodsid,
					givegoodsdetail,
					givegoodscompany,
					companyshop,
					companydetail,
					givegoodsclass,
					givegoodscode,
					givegoodsorgprice,
					givegoodsunit,
					givegoodsname,
					givegoodsimage,
					givegoodsunits,
					givegoodsnum
					);
		} else {
			alert('您的购买数量超过限购数量');
		}
	});
}
//将商品信息存入缓存2
function chuancan(
				givegoodsid,
				givegoodsdetail,
				givegoodscompany,
				companyshop,
				companydetail,
				givegoodsclass,
				givegoodscode,
				givegoodsorgprice,
				givegoodsunit,
				givegoodsname,
				givegoodsimage,
				givegoodsunits,
				givegoodsnum
				) {
	if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
		//没有购物车
		window.localStorage.setItem("sdishes", "[]");					//创建一个购物车
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes")); 	//将缓存中的sdishes(字符串)转换为json对象
		//新增订单
		var mdishes = new Object();
		mdishes.goodsid = givegoodsid;
		mdishes.goodsdetail = givegoodsdetail;
		mdishes.goodscompany = givegoodscompany;
		mdishes.companyshop = companyshop;
		mdishes.companydetail = companydetail;
		mdishes.goodsclassname = givegoodsclass;
		mdishes.goodscode = givegoodscode;
		mdishes.pricesprice = givegoodsorgprice;
		mdishes.pricesunit = givegoodsunit;
		mdishes.goodsname = givegoodsname;
		mdishes.goodsimage = givegoodsimage;
		mdishes.orderdtype = '买赠';
		mdishes.timegoodsnum = givegoodsnum;
		mdishes.goodsunits = givegoodsunits;
		mdishes.orderdetnum = 1;
		sdishes.push(mdishes); 											//往json对象中添加一个新的元素(订单)
		window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
		
		window.localStorage.setItem("totalnum", 1); 					//设置缓存中的种类数量等于一 
		window.localStorage.setItem("totalmoney", givegoodsorgprice);	//总金额等于商品价
		var cartnum = parseInt(window.localStorage.getItem("cartnum"));
		window.localStorage.setItem("cartnum",cartnum+1);
		window.location.href = "cart.jsp";
	} else {
		
		//有购物车
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));	//将缓存中的sdishes(字符串)转换为json对象
		var tnum = parseInt(window.localStorage.getItem("totalnum"));		//取出商品的总类数
		$.each(sdishes,function(i,item) {								//遍历购物车中的商品
			if( item.goodsid == givegoodsid && item.orderdtype == '买赠'){
				//如果商品id相同
				window.location.href = "cart.jsp";
				return false;
			} else if(i == (tnum-1)){
				//如果最后一次进入时goodsid不相同
				//新增订单
				var mdishes = new Object();
				mdishes.goodsid = givegoodsid;
				mdishes.goodsdetail = givegoodsdetail;
				mdishes.goodscompany = givegoodscompany;
				mdishes.companyshop = companyshop;
				mdishes.companydetail = companydetail;
				mdishes.goodsclassname = givegoodsclass;
				mdishes.goodscode = givegoodscode;
				mdishes.pricesprice = givegoodsorgprice;
				mdishes.pricesunit = givegoodsunit;
				mdishes.goodsname = givegoodsname;
				mdishes.goodsimage = givegoodsimage;
				mdishes.orderdtype = '买赠';
				mdishes.timegoodsnum = givegoodsnum;
				mdishes.goodsunits = givegoodsunits;
				mdishes.orderdetnum = 1;
				sdishes.push(mdishes); 												//往json对象中添加一个新的元素(订单)
				window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
				window.localStorage.setItem("totalnum", tnum + 1);					//商品种类数加一
				var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
				var newtmoney = (tmoney+parseFloat(givegoodsorgprice)).toFixed(2);
				window.localStorage.setItem("totalmoney",newtmoney);	
				var cartnum = parseInt(window.localStorage.getItem("cartnum"));
				window.localStorage.setItem("cartnum",cartnum+1);
				window.location.href = "cart.jsp";
			}	
		})
	}
}
//到购物车页面
function docart(obj){
	if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
		$(obj).attr("href","cartnothing.html");
	}
}
//加号
function addnum(obj,pricesprice,goodsname,pricesunit,goodsunits,goodscode,goodsclassname,goodscompany,companyshop,companydetail){
	var item = JSON.parse($(obj).parent().prev().text());				//得到商品信息
	
	$.post('queryCusSecKillOrderdEmp.action',{'orderm.ordermcustomer':customer.customerid},function(data){
		var count = 0;
		if(data.msg == 'no'){
			$(".popup_msg").text("还没有收货地址,请先添加收货地址。");
			$(".popup_queding").attr("href","mine.jsp");
			$(".cd-popup").addClass("is-visible");
			return;
		}
		//数量
		var numt = $(obj).prev(); 
		var num = parseInt(numt.val());
		var restNum = parseInt(item.givegoodsnum) - num;
		if(data){
			$.each(data.giveGoodsList,function(i,item2){
				if(item2.orderdcode == item.givegoodscode){
					restNum -= parseInt(item2.orderdnum);
				}
			});
		}
		
		if(restNum <= 0){		//买的商品数量超过了限购数量
			count++;
		}
		if(count > 0){
			alert('您购买的商品超过了限购数量。');
		} else {
			if(!window.localStorage.getItem("totalmoney")){
				window.localStorage.setItem("totalmoney","0")
			}
			//总价
			var tmoney = parseFloat(window.localStorage.getItem("totalmoney"));		//总价
			var newtmoney = (tmoney+pricesprice).toFixed(2);						//总价加上商品价格得到新价格
			window.localStorage.setItem("totalmoney",newtmoney);					//设置总价格到缓存
			//数量
			var numt = $(obj).prev(); 							//得到加号前面一个元素(input元素)
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
				mdishes.goodsimage = item.givegoodsimage;
				mdishes.orderdtype = '买赠';
				mdishes.timegoodsnum = item.givegoodsnum;
				sdishes.push(mdishes);
				//种类数
				var tnum = parseInt(window.localStorage.getItem("totalnum"));
				window.localStorage.setItem("totalnum",tnum+1);
			}else{							
				//如果数量不是0
				//修改订单
				$.each(sdishes, function(i, item3) {
					if(item3.goodsid==$(obj).parent().attr('name')
							&&item3.goodsdetail==$(obj).prev().attr('name')){
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
	},'json');
}
//减号
function subnum(obj,pricesprice){
	var numt = $(obj).next(); 			//得到减号后面一个元素(input元素)
	var num = parseInt(numt.val());		//数量
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
</script>
</body>
</html>