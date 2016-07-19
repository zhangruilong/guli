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
.stock-num{width: 30%;margin: 9% 0% 0% 0%;}
</style>
</head>
<body>
<div class="gl-box">
	
    <div class="wapper-nav"><a onclick='javascript:history.go(-1);' class='goback'></a>
	秒杀商品<a onclick="docart(this)" href="cart.jsp" class="gwc"><em id="totalnum">0</em></a></div>
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
<script src="js/jquery-2.1.4.min.js"></script>
<script src="js/jquery-dropdown.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
var xian = '${param.xian}';
var timegoodscode = '${param.timegoodscode}';
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
	//页面信息
	if(xian == ''){
		xian = customer.customerxian
	}
	$.getJSON("miaoshaPageEmp.action",{"city.cityname":xian,"timegoodsList[0].timegoodscode":timegoodscode,"timegoodsList[0].timegoodsscope":customer.customertype},initMiaoshaPage);
});
//到商品详情页
function gotogoodsDetail(companyshop,companydetail,jsonitem){
	window.location.href = 'goodsDetail.jsp?type=秒杀&companyshop='+companyshop+'&companydetail='+companydetail+'&goods='+jsonitem;
}
//初始化页面
function initMiaoshaPage(data){
	$(".home-hot-commodity").html("");
	$.each(data.companyList,function(i,item1){
		$.each(item1.timegoodsList,function(j,item2){
			var jsonitem = JSON.stringify(item2);
			var liObj = '<li><span onclick="gotogoodsDetail(\''+item1.companyshop+'\',\''+item1.companydetail+
			'\',\''+encodeURI(jsonitem)+'\')" class="fl"> <img src="../'+item2.timegoodsimage+
         	'" alt="" onerror="javascript:this.src=\'images/default.jpg\'"/></span>'+
			'<h1 onclick="gotogoodsDetail(\''+item1.companyshop+'\',\''+item1.companydetail+'\',\''+ encodeURI(jsonitem)+ '\');">'+item2.timegoodsname+
				'<span>（'+item2.timegoodsunits+'）</span>'+
			'</h1> <span style="" onclick="gotogoodsDetail(\''+item1.companyshop+'\',\''+item1.companydetail+'\',\''+ encodeURI(jsonitem)+ '\');">';
			if(data.cusOrderdList != null && data.cusOrderdList.length != 0){
				var itemGoodsCount = 0;
				$.each(data.cusOrderdList,function(k,item3){
					if(item3.orderdcode == timegoodscode){
						itemGoodsCount += item3.orderdnum
					}
				});
				liObj += '<font>每日限购'+(item2.timegoodsnum - itemGoodsCount)+item2.timegoodsunit+'</font><br/>';
				if(item2.allnum != '-1'){
					liObj += '<font>，总限量'+item2.allnum+item2.timegoodsunit+'，还剩'+item2.surplusnum+item2.timegoodsunit+'</font>';
				}
			} else {
				liObj += '<font>每日限购'+item2.timegoodsnum+item2.timegoodsunit+'</font>';
				if(item2.allnum != '-1'){
					liObj += '<font>，总限量'+item2.allnum+item2.timegoodsunit+'，还剩'+item2.surplusnum+item2.timegoodsunit+'</font>';
				}
			}
			liObj+='</span><br>';
			liObj += '<div class="miaosha_li_price_div"><strong>￥'+item2.timegoodsorgprice+'/'+item2.timegoodsunit+'</strong>'+
			' <em>￥'+item2.timegoodsprice+'</em></div>'+
				'<div class="stock-num" name="'+item2.timegoodsid+'">'+
	            '<span class="jian min"  onclick="subnum(this,'+item2.timegoodsorgprice+')"></span>'+
	            '<input readonly="readonly" class="text_box shuliang" name="danpin" type="text" value="'+
	             getcurrennumdanpin(item2.timegoodsid)+'"> '+
	            ' <span class="jia add" onclick="addnum(this,'+item2.timegoodsorgprice
				   +',\''+item2.timegoodsname+'\',\''+item2.timegoodsunit+'\',\''+item2.timegoodsunits
				   +'\',\''+item2.timegoodscode+'\',\''+item2.timegoodsclass
				   +'\',\''+item2.timegoodscompany+'\',\''+item1.companyshop+'\',\''+item1.companydetail
				   +'\')"></span>'+
				   '<span hidden="ture">'+JSON.stringify(item2)+'</span>'+
	        	'</div>';
	        liObj += '</li>';
			$(".home-hot-commodity").append(liObj);
		});
	});
}
//判断是否到达限购数量
function judgePurchase(
		timegoodsid,
		timegoodsdetail,
		timegoodscompany,
		companyshop,
		companydetail,
		timegoodsclass,
		timegoodscode,
		timegoodsorgprice,
		timegoodsunit,
		timegoodsname,
		timegoodsimage,
		timegoodsunits,
		timegoodsnum
		) {
	var customer = JSON.parse(window.localStorage.getItem("customer"));
	if(!customer.customerid || customer.customerid == '' || typeof(customer.customerid) == 'undefined'){
		$(".cd-popup").addClass("is-visible");
		return;
	}
	$.getJSON('judgePurchaseEmp.action',{
		'timegoodsnum':timegoodsnum,
		'timegoodscode':timegoodscode,
		'customerid':customer.customerid
	},function(data){
		if(data.result == 'ok'){
			chuancan(
					timegoodsid,
					timegoodsdetail,
					timegoodscompany,
					companyshop,
					companydetail,
					timegoodsclass,
					timegoodscode,
					timegoodsorgprice,
					timegoodsunit,
					timegoodsname,
					timegoodsimage,
					timegoodsunits,
					timegoodsnum
					);
		} else {
			alert('购买数量超过限购数量');
		}
	});
}
//将商品信息存入缓存2
function chuancan(
				timegoodsid,
				timegoodsdetail,
				timegoodscompany,
				companyshop,
				companydetail,
				timegoodsclass,
				timegoodscode,
				timegoodsorgprice,
				timegoodsunit,
				timegoodsname,
				timegoodsimage,
				timegoodsunits,
				timegoodsnum
				) {
	if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
		//没有购物车
		window.localStorage.setItem("sdishes", "[]");					//创建一个购物车
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes")); 	//将缓存中的sdishes(字符串)转换为json对象
		//新增订单
		var mdishes = new Object();
		mdishes.goodsid = timegoodsid;
		mdishes.goodsdetail = timegoodsdetail;
		mdishes.goodscompany = timegoodscompany;
		mdishes.companyshop = companyshop;
		mdishes.companydetail = companydetail;
		mdishes.goodsclassname = timegoodsclass;
		mdishes.goodscode = timegoodscode;
		mdishes.pricesprice = timegoodsorgprice;
		mdishes.pricesunit = timegoodsunit;
		mdishes.goodsname = timegoodsname;
		mdishes.goodsimage = timegoodsimage;
		mdishes.orderdtype = '秒杀';
		mdishes.timegoodsnum = timegoodsnum;
		mdishes.goodsunits = timegoodsunits;
		mdishes.orderdetnum = 1;
		sdishes.push(mdishes); 											//往json对象中添加一个新的元素(订单)
		window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
		
		window.localStorage.setItem("totalnum", 1); 					//设置缓存中的种类数量等于一 
		window.localStorage.setItem("totalmoney", timegoodsorgprice);	//总金额等于商品价
		var cartnum = parseInt(window.localStorage.getItem("cartnum"));
		window.localStorage.setItem("cartnum",cartnum+1);
		window.location.href = "cart.jsp";
	} else {
		
		//有购物车
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));	//将缓存中的sdishes(字符串)转换为json对象
		var tnum = parseInt(window.localStorage.getItem("totalnum"));		//取出商品的总类数
		$.each(sdishes,function(i,item) {								//遍历购物车中的商品
			if( item.goodsid == timegoodsid && item.orderdtype == '秒杀'){
				//如果商品id相同
				window.location.href = "cart.jsp";
				return false;
			} else if(i == (tnum-1)){
				//如果最后一次进入时goodsid不相同
				//新增订单
				var mdishes = new Object();
				mdishes.goodsid = timegoodsid;
				mdishes.goodsdetail = timegoodsdetail;
				mdishes.goodscompany = timegoodscompany;
				mdishes.companyshop = companyshop;
				mdishes.companydetail = companydetail;
				mdishes.goodsclassname = timegoodsclass;
				mdishes.goodscode = timegoodscode;
				mdishes.pricesprice = timegoodsorgprice;
				mdishes.pricesunit = timegoodsunit;
				mdishes.goodsname = timegoodsname;
				mdishes.goodsimage = timegoodsimage;
				mdishes.orderdtype = '秒杀';
				mdishes.timegoodsnum = timegoodsnum;
				mdishes.goodsunits = timegoodsunits;
				mdishes.orderdetnum = 1;
				sdishes.push(mdishes); 												//往json对象中添加一个新的元素(订单)
				window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
				window.localStorage.setItem("totalnum", tnum + 1);					//商品种类数加一
				var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
				var newtmoney = (tmoney+parseFloat(timegoodsorgprice)).toFixed(2);
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
	var item = JSON.parse($(obj).next().text());				//得到商品信息
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
		var restNum = parseInt(item.timegoodsnum) - num;
		if(data){
			$.each(data.miaoshaList,function(i,item2){
				if(item2.orderdcode == item.timegoodscode){
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
				mdishes.goodsimage = item.timegoodsimage;
				mdishes.orderdtype = '秒杀';
				mdishes.timegoodsnum = item.timegoodsnum;
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
//检查客户是否可以购买秒杀商品
function checkCusSecKill(){
	if(!customer.customerid || customer.customerid == 'null' || typeof(customer.customerid) == 'undefined'){		//判断是否注册
		$(".cd-popup").addClass("is-visible");
		return ;
	}
	var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
	var outGoodsName = '';
	$.post('queryCusSecKillOrderdEmp.action',{'orderm.ordermcustomer':customer.customerid},function(data){
		var count = 0;
		if(data.msg == 'no'){																						//判断是否有地址
			$(".popup_msg").text("还没有收货地址,请先添加收货地址。");
			$(".popup_queding").attr("href","mine.jsp");
			$(".cd-popup").addClass("is-visible");
			return;
		}
		$.each(sdishes,function(i,item1){													//遍历购物车现有商品
			alert(item1.orderdtype);
			if(item1.orderdtype == '秒杀'){						
				//如果是限购商品
				var restNum = parseInt(item1.timegoodsnum) - parseInt(item1.orderdetnum);
				if(data){
					$.each(data.miaoshaList,function(i,item2){								//遍历秒杀商品的订单详细集合
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
				//如果是买赠商品
				var restNum = parseInt(item1.timegoodsnum) - parseInt(item1.orderdetnum);
				if(data){
					$.each(data.giveGoodsList,function(i,item2){							//遍历买赠商品的订单详细集合
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