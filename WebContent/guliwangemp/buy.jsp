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
<link href="../css/base.css" type="text/css" rel="stylesheet">
<link href="../css/layout.css" type="text/css" rel="stylesheet">
<link href="../css/dig.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="../js/jquery-2.1.4.min.js"></script>
</head>

<body>
<div class="gl-box">
	<div class="jiesuan">
    	<div class="wapper-nav">结算 <a href='javascript:history.go(-1)' class="goback"></a></div>
    	<div class="shouhuo-wrap">
        	<a href="buyAddress.jsp">
        	<span>收货人：</span>
        	<span class="add">收货地址: </span></a>
        	<span id="addressconnect" hidden="ture"></span>
        	<span id="addressphone" hidden="ture"></span>
        	<span id="addressaddress" hidden="ture"></span>
        </div>
        <div class="jiesuan-info">
        	<h1>结算信息</h1>
        	<ul id="companylist">
            	<li>供应商: <font class="font-grey">天然粮油有限公司</font> <br>订单金额: <font class="font-oringe">600元</font></li>
                <!-- <li>供应商: <font class="font-grey">天然粮油有限公司</font> <br>订单金额: <font class="font-oringe">600元</font></li> -->
            </ul>
        </div>
        <div class="jiesuan-info">
        	<h1>留言信息</h1>
        	<!-- <ul id="companylist">
            	<li>供应商: <font class="font-grey">天然粮油有限公司</font> <br>订单金额: <font class="font-oringe">600元</font>
            	<br>买家留言:<input> </li>
            </ul> -->
            <ul>
            	<li><textarea placeholder="关于订单商品、配送时间等，可给供货商留言..." class="liuy-info-ta" onpropertychange= "this.style.posHeight=this.scrollHeight" ></textarea>
    			</li>
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
            <a href="#" class="cd-popup-close">取消</a><a id="buyall" class="cd-popup-ok" onclick="sortingData();">确定</a>
		</div>
	</div>
</div>

<script type="text/javascript" src="../js/buy3.js"></script>
<script type="text/javascript" src="../js/base.js"></script>
<script> 
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
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

$(function(){
	if('${param.address }' != ''){
		var item = JSON.parse('${param.address }');
		$(".shouhuo-wrap a span:eq(0)").text('收货人：'+item.addressconnect+' '+item.addressphone);
		$(".shouhuo-wrap a span:eq(1)").text('收货地址: '+item.addressaddress);
		$("#addressconnect").text(item.addressconnect);
		$("#addressphone").text(item.addressphone);
		$("#addressaddress").text(item.addressaddress);
	} else {
		$.ajax({
			url:"GLAddressAction.do?method=selAll",
			type:"post",
			data:{
				wheresql:"addresscustomer='"+customer.customerid+"'",
				order : "addressture desc"
			},
			success : function(resp){
				var data = JSON.parse(resp);
				var item = data.root[0];
				$(".shouhuo-wrap a span:eq(0)").text('收货人：'+item.addressconnect+' '+item.addressphone);
				$(".shouhuo-wrap a span:eq(1)").text('收货地址: '+item.addressaddress);
				$("#addressconnect").text(item.addressconnect);
				$("#addressphone").text(item.addressphone);
				$("#addressaddress").text(item.addressaddress);
			},
			error : function(resp){
				var respText = eval('('+resp+')');
				alert(respText.msg);
			}
		});
	}
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
//整理购物车数据
function sortingData(){
	$("#buyall").attr('onclick','');											//禁用按钮
	$.ajax({
		url:"GLOrderdAction.do?method=sortingSdiData",
		type:"post",
		data:{
			json:window.localStorage.getItem("sdishes"),
			customerid:customer.customerid
		},
		success:function(resp){
			var respText = eval('('+resp+')');
			if(respText.msg != '您购买的：'){
				alert('操作失败！');
				$("#buyall").attr('onclick','sortingData();');
				return;
			}
			if(respText.msg == '您购买的：'){
				var jsds = respText.root;										//sdishes的json
				window.localStorage.setItem("sdishes",JSON.stringify(jsds));
				var newcartnum = 0;
				var totalmoney = 0.00;
				var totalnum = 0;
				$.each(jsds,function(i,item){
					var money = parseFloat(parseFloat(item.pricesprice) * parseFloat(item.orderdetnum)).toFixed(2);
					newcartnum += parseInt(item.orderdetnum);
					totalmoney = parseFloat(money) + totalmoney;
					totalnum++;
				});
				window.localStorage.setItem("cartnum",newcartnum);
				window.localStorage.setItem("totalmoney",totalmoney.toFixed(2));
				window.localStorage.setItem("totalnum",totalnum);
				setscompany();		//设置供应商信息
				buy();
			} else {
				alert(respText.msg);
				var jsds = respText.root;										//sdishes的json
				window.localStorage.setItem("sdishes",JSON.stringify(jsds));
				var newcartnum = 0;
				var totalmoney = 0.00;
				var totalnum = 0;
				$.each(jsds,function(i,item){
					var money = parseFloat(parseFloat(item.pricesprice) * parseFloat(item.orderdetnum)).toFixed(2);
					newcartnum += parseInt(item.orderdetnum);
					totalmoney = parseFloat(money) + totalmoney;
					totalnum++;
				});
				window.localStorage.setItem("cartnum",newcartnum);
				window.localStorage.setItem("totalmoney",totalmoney.toFixed(2));
				window.localStorage.setItem("totalnum",totalnum);
				setscompany();		//设置供应商信息
				if(respText.root.length == 0){
					alert("购物车中没有商品.");
					window.location.href = "goods.jsp?searchclasses="+searchclassesvalue;
					return;
				}
				buy();
			}
		},
		error : function(resp) {
			$("#buyall").attr('onclick','buy();');								//启用按钮
			var respText = eval('('+resp+')');
			alert(respText.msg);
		}
	});
}
//将购物车写入订单表
function buy(){
	//alert("拼接数据");
	//$("#buyall").attr('onclick','');											//禁用按钮
	var scompany = JSON.parse(window.localStorage.getItem("scompany"));
	
	$.each(scompany, function(y, mcompany) {
		var ordermjson = '[{"ordermcustomer":"' + customer.customerid
				+ '","ordermcompany":"' + mcompany.ordermcompany 
				+ '","ordermnum":"' + mcompany.ordermnum
				+ '","ordermmoney":"' + mcompany.ordermmoney
				+ '","ordermemp":"补单'
				+ '","ordermcustype":"' + customer.customertype
				+ '","ordermcuslevel":"' + customer.customerlevel
				+ '","ordermcusshop":"' + customer.customershop
				+ '","ordermconnect":"' + $("#addressconnect").text()
				+ '","ordermphone":"' + $("#addressphone").text()
				+ '","ordermaddress":"' + $("#addressaddress").text()
				+ '","ordermdetail":"' + $(".liuy-info-ta").val()
				+ '","ordermway":"货到付款"}]';
		var orderdetjson = '[';
		var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
		
		$.each(sdishes, function(i, item) {
			
			var orderdnote = '';
			if(item.orderdtype == '秒杀' || item.orderdtype == '年货' || item.orderdtype == '组合商品' ){
				
				if(typeof(item.goodsdetail)!='undefined' && item.goodsdetail){
					orderdnote = '【'+item.orderdtype+'】 '+item.goodsdetail;
				} else {
					orderdnote = '【'+item.orderdtype+'】 ';
				}
				
//alert("秒杀结束");
			} else if(item.orderdtype == '买赠'){
				orderdnote = '【买赠】 '+item.goodsdetail;
				//alert("买增结束");
			}
			//alert(JSON.stringify(item));
			if(mcompany.ordermcompany == item.goodscompany){
				var goodsweight = parseInt(item.goodsweight);
				if(isNaN(goodsweight)){
					goodsweight = 0;
				}
				//alert("正常开始");
				orderdetjson += '{"orderdid":"' + item.goodsid
						+ '","orderdcode":"' + item.goodscode
						+ '","orderdtype":"' + item.orderdtype
						+ '","orderdname":"' + item.goodsname
						+ '","orderddetail":"' + item.goodsdetail
						+ '","orderdunits":"' + item.goodsunits
						+ '","orderdprice":"' + item.pricesprice
						+ '","orderdunit":"' + item.pricesunit
						+ '","orderdclass":"' + item.goodsclassname
						+ '","orderdnum":"' + item.orderdetnum
						+ '","orderdweight":"' + goodsweight
						+ '","orderdnote":"' + orderdnote					//订单备注
						+ '","orderdgoods":"' + item.goodsid				//商品id
						+ '","orderdbrand":"' + changeStr(item.goodsbrand)		//商品品牌
						+ '","orderdmoney":"' + (item.pricesprice * item.orderdetnum).toFixed(2)
						+ '"},';
				//alert("正常结束");
				}
		});
		//alert("结束循环");
		
		orderdetjson = orderdetjson.substr(0, orderdetjson.length - 1) + ']';
		//alert("拼接数据结束");
		saveOrder(ordermjson,orderdetjson);
     });
}
//保存订单和订单详情
function saveOrder(ordermjson,orderdetjson){
	$.ajax({
		url : 'GLOrdermAction.do?method=addOrder',
		type:"post",
		data : {
			json : ordermjson,
			orderdetjson : orderdetjson
		},
		success : function(resp) {
			var respText = eval('('+resp+')'); 
			if(respText.success == false) {
				$("#buyall").attr('onclick','sortingData();');//启用按钮
				alert(respText.msg);
			} else {
				window.localStorage.setItem("sdishes", "[]");
				window.localStorage.setItem("totalnum", 0);
				window.localStorage.setItem("totalmoney", 0);
				window.localStorage.setItem("cartnum", 0);
				alert("下单成功！");
				window.location.href = "order.jsp";
			}
		},
		error : function(resp) {
			$("#buyall").attr('onclick','sortingData();');//启用按钮
			alert('网络出现问题，请稍后再试');
		}
	});
}
</script>
</body>
</html>

















