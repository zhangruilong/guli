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
</head>

<body>
<div class="gl-box">
	<div class="jiesuan">
    	<div class="wapper-nav">结算</div>
    	<div class="shouhuo-wrap">
        	<a href="address.jsp"><span>收货人：王金宝 13888888888</span><span class="add">收货地址: 嘉兴市沿海向城东路89号706室</span></a>
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
	<div class="jiesuan-foot-info">合计金额: <span id="totalmoney">0</span>元 </div><a class="jiesuan-button">提交</a>
</div>
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="js/jquery.dialog.js"></script>
<script> 
$(function(){
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
$(".jiesuan-button").click(function(){ 
	//将购物车写入订单表
	$.dialog.message("谷粒网提示", "您确定要货到付款?", true, function() {
		$("#popTips").remove();
		var scompany = JSON.parse(window.localStorage.getItem("scompany"));
		$.each(scompany, function(y, mcompany) {
			var ordermjson = '[{"ordermcustomer":"' + 1
					+ '","ordermcompany":"' + mcompany.ordermcompany 
					+ '","ordermnum":"' + mcompany.ordermnum
					+ '","ordermmoney":"' + mcompany.ordermmoney
					+ '","ordermconnect":"' + "王金宝" 
					+ '","ordermphone":"' + "13888888888" 
					+ '","ordermaddress":"' + "嘉兴市沿海向城东路89号706室" 
					+ '","ordermway":"货到付款"}]';
			var orderdetjson = '[';
			var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
			$.each(sdishes, function(i, item) {
				if(mcompany.ordermcompany == item.goodscompany)
					orderdetjson += '{"orderdetdishes":"' + item.goodsid
							+ '","orderdcode":"' + item.goodscode
							+ '","orderdtype":"' + "商品"
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
			$.ajax({
					url : 'OrdermAction.do?method=addOrder',
					data : {
						json : ordermjson,
						orderdetjson : orderdetjson
					},
					success : function(resp) {
						var respText = eval('('+resp+')'); 
		    			if(respText.success == false) 
		    				$.dialog.alert("操作提示", respText.msg);
		    			else {
		    				window.localStorage.setItem("sdishes", "[]");
							window.localStorage.setItem("totalnum", 0);
							window.localStorage.setItem("totalmoney", 0);
							$.dialog.alert("操作提示", "下单成功！");
							window.location.href = "order.jsp";
		    			}
					},
					error : function(resp) {
						alert('网络出现问题，请稍后再试');
					}
				});
	     });
	}); 
}) 
</script>
</body>
</html>
