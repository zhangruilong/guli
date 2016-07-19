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
	<div class="jiesuan">
    	<div class="wapper-nav">结算 <a href='javascript:history.go(-1)' class="goback"></a></div>
    	<div class="shouhuo-wrap">
        	<a href="">
        	<span>收货人：${requestScope.address.addressconnect } ${requestScope.address.addressphone }</span>
        	<span class="add">收货地址: ${requestScope.address.addressaddress }</span></a>
        	<span id="addressconnect" hidden="ture">${requestScope.address.addressconnect }</span>
        	<span id="addressphone" hidden="ture">${requestScope.address.addressphone }</span>
        	<span id="addressaddress" hidden="ture">${requestScope.address.addressaddress }</span>
        </div>
        <div class="jiesuan-info">
        	<h1>结算信息</h1>
        	<ul id="companylist">
            	<li>供应商: <font class="font-grey">天然粮油有限公司</font> <br>订单金额: <font class="font-oringe">600元</font></li>
                <li>供应商: <font class="font-grey">天然粮油有限公司</font> <br>订单金额: <font class="font-oringe">600元</font></li>
            </ul>
        </div>
        <div class="jiesuan-info">
        	<h1>支付方式</h1>
        	<div class="payment">
                <span>
                    <input type="radio" id="radio-1-2" name="radio-1-set" class="regular-radio" checked/>
                    <label for="radio-1-2">货到付款</label>
                </span>
                <span>
                    <input type="radio" id="radio-1-1" name="radio-1-set" class="regular-radio" />
                    <label for="radio-1-1">微信支付</label>
                </span>
            </div>
        </div>
    </div>
</div>
<div class="footer">
	<div class="jiesuan-foot-info">合计金额: <span id="totalmoney">0</span>元 </div><a class="jiesuan-button cd-popup-trigger">提交</a>
</div>

<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="meg">您确定要货到付款?</p>
            <a href="#" class="cd-popup-close">取消</a><a class="cd-popup-ok" onclick="buy();">确定</a>
		</div>
	</div>
</div>
<script src="js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
<script> 
jQuery(document).ready(function($){
	//open popup
	$('.cd-popup-trigger').on('click', function(event){
		event.preventDefault();
		$('.cd-popup').addClass('is-visible');			//弹窗
	});
	
	//close popup
	$('.cd-popup').on('click', function(event){
		if( $(event.target).is('.cd-popup-close') || $(event.target).is('.cd-popup') ) {
			event.preventDefault();
			$(this).removeClass('is-visible');
		}
	});
});
var customer =  JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){
	$(".shouhuo-wrap a").attr("href","doEmpAddressMana.action?customerId="+customer.customerid+"&message=foBuy");
	if(!window.localStorage.getItem("totalmoney")){
		window.localStorage.setItem("totalmoney",0);
		$("#totalmoney").text(0);
	}else{
		$("#totalmoney").text(window.localStorage.getItem("totalmoney"));
	}
	var scompany = JSON.parse(window.localStorage.getItem("scompany"));
	initDishes(scompany);
});
function initDishes(data){
    $("#companylist").html("");
	$.each(data, function(i, item) {
          $("#companylist").append('<li>供应商: '+
        	  '<font class="font-grey">'+item.companyshop+'</font> '+
        	  '<br>订单金额: '+
        	  '<font class="font-oringe">'+item.ordermmoney+'元</font></li>');
     });
}
function buy(){
	//将购物车写入订单表
	var scompany = JSON.parse(window.localStorage.getItem("scompany"));
	$.each(scompany, function(y, mcompany) {
		var ordermjson = '[{"ordermcustomer":"' + customer.customerid
				+ '","ordermemp":"补单'
				+ '","ordermcompany":"' + mcompany.ordermcompany 
				+ '","ordermnum":"' + mcompany.ordermnum
				+ '","ordermmoney":"' + mcompany.ordermmoney
				+ '","ordermconnect":"' + $("#addressconnect").text()
				+ '","ordermphone":"' + $("#addressphone").text()
				+ '","ordermaddress":"' + $("#addressaddress").text()
				+ '","ordermway":"货到付款"}]';
		var orderdetjson = '[';
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
		$.each(sdishes, function(i, item) {
			if(mcompany.ordermcompany == item.goodscompany)
				orderdetjson += '{"orderdetdishes":"' + item.goodsid
						+ '","orderdcode":"' + item.goodscode
						+ '","orderdtype":"' + item.orderdtype
						+ '","orderdname":"' + item.goodsname
						+ '","orderddetail":"' + item.goodsdetail
						+ '","orderdunits":"' + item.goodsunits
						+ '","orderdprice":"' + item.pricesprice
						+ '","orderdunit":"' + item.pricesunit
						+ '","orderdprice":"' + item.pricesprice
						+ '","orderdclass":"' + item.goodsclassname
						+ '","orderdnum":"' + item.orderdetnum
						+ '","orderdmoney":"' + (item.pricesprice * item.orderdetnum).toFixed(2)
						+ '"},';
		});
		orderdetjson = orderdetjson.substr(0, orderdetjson.length - 1)
				+ ']';
		var timegoodsids = '';				//秒杀商品id
		var timegoodssum = '';				//秒杀商品数量
		$.each(JSON.parse(orderdetjson),function(i,item){	//遍历添加的订单详情
			if(item.orderdtype == '秒杀'){		//如果是秒杀商品
				timegoodsids += item.orderdetdishes + ',';
				timegoodssum += item.orderdnum + ',';
			}
		});
		if(timegoodsids != '' && timegoodssum != ''){
			$.post('editRestAmountEmp.action',
				{'timegoodsids':timegoodsids,'timegoodssum':timegoodssum},
				function(data){
					if(data == 'ok'){
						saveOrder(ordermjson,orderdetjson);
					} else {
						$(".meg").text("您购买的秒杀商品卖完了.......");
						$(".cd-popup-ok").attr("onclick","javascript:window.location.href = 'cart.jsp'");
						$('.cd-popup').addClass('is-visible');			//弹窗
					}
			});
		} else {
			saveOrder(ordermjson,orderdetjson);
		}
		
     });
}
//保存订单和订单详情
function saveOrder(ordermjson,orderdetjson){
	$.ajax({
		url : 'OrdermAction.do?method=addOrder',
		type:"post",
		data : {
			json : ordermjson,
			orderdetjson : orderdetjson
		},
		success : function(resp) {
			var respText = eval('('+resp+')'); 
			if(respText.success == false) 
				alert(respText.msg);
			else {
				window.localStorage.setItem("sdishes", "[]");
				window.localStorage.setItem("totalnum", 0);
				window.localStorage.setItem("totalmoney", 0);
				window.localStorage.setItem("cartnum", 0);
				alert("下单成功！");
				window.location.href = "order.jsp";
			}
		},
		error : function(resp) {
			alert('网络出现问题，请稍后再试');
		}
	});
}
</script>
</body>
</html>

















