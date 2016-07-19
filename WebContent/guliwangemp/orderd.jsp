<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
	String ordermid = request.getParameter("ordermid");
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
</head>

<body>
<div class="order-detail-info">
</div>
<div class="order-detail-user">
<i class="info-icon"></i>
<div class="pdl-b8">
  <p>收货人:王金宝 16535789623 </p>
  <p>收货地址:嘉兴市海盐海东程璐89号706号</p>
  <p>支付方式:货到付款</p>
</div>
</div>
<div class="order-detail-wrapper">
</div>
<div class="footer">
	<div class="order-detail-foot">
    	<!-- <a href="#">取消订单</a> -->
        <span id="orderd_data" hidden="true"></span>
        <a onclick="regoumai()" href="#">重新购买</a>
    </div>
</div>
<script src="js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var basePath = '<%=basePath%>';
var ordermid = '<%=ordermid%>';
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){ 
	if(ordermid!="null"&&ordermid!=""){
		getJson(basePath+"OrderdAction.do",{method:"selAll",wheresql:"orderdorderm='"+ordermid+"'"},initOrderd,null);
	}
})
function regoumai(){
	var orderds = JSON.parse($("#orderd_data").text());
	var orderdcodes = "";
	var orderdtypes = "";
	$.each(orderds,function(i,item){
		orderdcodes += item.orderdcode + ",";
		orderdtypes += item.orderdtype + ",";
	});
	$.ajax({
		url: "queryREgoumaiGoodsEmp.action",
		async:true,
		data: {"orderdcodes":orderdcodes,"orderdtypes":orderdtypes,"customertype":customer.customertype,"customerlevel":customer.customerlevel},
		dataType:"json",
		success: function(data) {
			$.each(data,function(i,item){
				if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
					//没有购物车
					window.localStorage.setItem("sdishes", "[]");						//创建一个购物车
					var sdishes = JSON.parse(window.localStorage.getItem("sdishes")); 	//将缓存中的sdishes(字符串)转换为json对象
					var money = 0.00;
					if(data[i].type == '商品'){
						//新增订单
						var mdishes = new Object();
						mdishes.goodsid = item.goods.goodsid;
						mdishes.goodsdetail = item.goods.goodsdetail;
						mdishes.goodscompany = item.goods.goodscompany;
						mdishes.companyshop = $(".order-detail-info p").first().text();
						mdishes.companydetail = $(".order-detail-info p").last().text();
						mdishes.goodsclassname = item.goods.goodsclass;
						mdishes.goodscode = item.goods.goodscode;
						mdishes.pricesprice = item.goods.pricesList[0].pricesprice;
						mdishes.pricesunit = item.goods.pricesList[0].pricesunit;
						mdishes.goodsname = item.goods.goodsname;
						mdishes.goodsimage = item.goods.goodsimage;
						mdishes.orderdtype = data[i].type;
						mdishes.goodsunits = item.goods.goodsunits;
						mdishes.orderdetnum = orderds[i].orderdnum;
						money = (parseFloat(item.goods.pricesList[0].pricesprice) * parseFloat(orderds[i].orderdnum)).toFixed(2);
					} else if(data[i].type == '秒杀'){
						var mdishes = new Object();
						mdishes.goodsid = item.timegoods.timegoodsid;
						mdishes.goodsdetail = item.timegoods.timegoodsdetail;
						mdishes.goodscompany = item.timegoods.timegoodscompany;
						mdishes.companyshop = $(".order-detail-info p").first().text();
						mdishes.companydetail = $(".order-detail-info p").last().text();
						mdishes.goodsclassname = item.timegoods.timegoodsclass;
						mdishes.goodscode = item.timegoods.timegoodscode;
						mdishes.pricesprice = item.timegoods.timegoodsorgprice;
						mdishes.pricesunit = item.timegoods.timegoodsunit;
						mdishes.goodsname = item.timegoods.timegoodsname;
						mdishes.goodsimage = item.timegoods.timegoodsimage;
						mdishes.orderdtype = data[i].type;
						mdishes.goodsunits = item.timegoods.timegoodsunits;
						mdishes.orderdetnum = orderds[i].orderdnum;
						mdishes.timegoodsnum = item.timegoods.timegoodsnum;
						money = (parseFloat(item.timegoods.timegoodsorgprice) * parseFloat(orderds[i].orderdnum)).toFixed(2);
					} else if(data[i].type == '买赠'){
						var mdishes = new Object();
						mdishes.goodsid = item.givegoods.givegoodsid;
						mdishes.goodsdetail = item.givegoods.givegoodsdetail;
						mdishes.goodscompany = item.givegoods.givegoodscompany;
						mdishes.companyshop = $(".order-detail-info p").first().text();
						mdishes.companydetail = $(".order-detail-info p").last().text();
						mdishes.goodsclassname = item.givegoods.givegoodsclass;
						mdishes.goodscode = item.givegoods.givegoodscode;
						mdishes.pricesprice = item.givegoods.givegoodsprice;
						mdishes.pricesunit = item.givegoods.givegoodsunit;
						mdishes.goodsname = item.givegoods.givegoodsname;
						mdishes.goodsimage = item.givegoods.givegoodsimage;
						mdishes.orderdtype = data[i].type;
						mdishes.goodsunits = item.givegoods.givegoodsunits;
						mdishes.orderdetnum = orderds[i].orderdnum;
						mdishes.timegoodsnum = item.givegoods.givegoodsnum;
						money = (parseFloat(item.givegoods.givegoodsprice) * parseFloat(orderds[i].orderdnum)).toFixed(2);
					}
					sdishes.push(mdishes); 											//往json对象中添加一个新的元素(订单)
					window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
					
					window.localStorage.setItem("totalnum", 1); 					//设置缓存中的种类数量等于一 
					window.localStorage.setItem("totalmoney", money);				//总金额等于商品价
					var cartnum = parseInt(window.localStorage.getItem("cartnum"));
					window.localStorage.setItem("cartnum",cartnum+parseInt(orderds[i].orderdnum));
				} else {
					//有购物车
					var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));	//将缓存中的sdishes(字符串)转换为json对象
					var tnum = parseInt(window.localStorage.getItem("totalnum"));		//取出商品的总类数
					$.each(sdishes,function(j,item1) {								//遍历购物车中的商品
						if(data[i].type == '商品'){
							if( item1.goodsid == item.goods.goodsid){
								//如果商品id相同
								sdishes[j].orderdetnum = parseInt(sdishes[j].orderdetnum) + parseInt(orderds[i].orderdnum);
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.goods.pricesList[0].pricesprice) * parseFloat(orderds[i].orderdnum) ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+parseInt(orderds[i].orderdnum));
								return false;
							} else if(j == (tnum-1)){
								//如果最后一次进入时goodsid不相同
								//新增订单
								var mdishes = new Object();
								mdishes.goodsid = item.goods.goodsid;
								mdishes.goodsdetail = item.goods.goodsdetail;
								mdishes.goodscompany = item.goods.goodscompany;
								mdishes.companyshop = $(".order-detail-info p").first().text();
								mdishes.companydetail = $(".order-detail-info p").last().text();
								mdishes.goodsclassname = item.goods.goodsclass;
								mdishes.goodscode = item.goods.goodscode;
								mdishes.pricesprice = item.goods.pricesList[0].pricesprice;
								mdishes.pricesunit = item.goods.pricesList[0].pricesunit;
								mdishes.goodsname = item.goods.goodsname;
								mdishes.goodsimage = item.goods.goodsimage;
								mdishes.orderdtype = data[i].type;
								mdishes.goodsunits = item.goods.goodsunits;
								mdishes.orderdetnum = orderds[i].orderdnum;
								sdishes.push(mdishes); 												//往json对象中添加一个新的元素(订单)
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								window.localStorage.setItem("totalnum", tnum + 1);					//商品种类数加一
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.goods.pricesList[0].pricesprice) * parseFloat(orderds[i].orderdnum) ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+parseInt(orderds[i].orderdnum));
							}
						} else if(data[i].type == '秒杀'){
							if( item1.goodsid == item.timegoods.timegoodsid){
								//如果商品id相同
								sdishes[j].orderdetnum = parseInt(sdishes[j].orderdetnum) + parseInt(orderds[i].orderdnum);
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.timegoods.timegoodsorgprice) * parseFloat(orderds[i].orderdnum) ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+parseInt(orderds[i].orderdnum));
								return false;
							} else if(j == (tnum-1)){
								//如果最后一次进入时goodsid不相同
								//新增订单
								var mdishes = new Object();
								mdishes.goodsid = item.timegoods.timegoodsid;
								mdishes.goodsdetail = item.timegoods.timegoodsdetail;
								mdishes.goodscompany = item.timegoods.timegoodscompany;
								mdishes.companyshop = $(".order-detail-info p").first().text();
								mdishes.companydetail = $(".order-detail-info p").last().text();
								mdishes.goodsclassname = item.timegoods.timegoodsclass;
								mdishes.goodscode = item.timegoods.timegoodscode;
								mdishes.pricesprice = item.timegoods.timegoodsorgprice;
								mdishes.pricesunit = item.timegoods.timegoodsunit;
								mdishes.goodsname = item.timegoods.timegoodsname;
								mdishes.goodsimage = item.timegoods.timegoodsimage;
								mdishes.orderdtype = data[i].type;
								mdishes.goodsunits = item.timegoods.timegoodsunits;
								mdishes.orderdetnum = orderds[i].orderdnum;
								mdishes.timegoodsnum = item.timegoods.timegoodsnum;
								sdishes.push(mdishes); 												//往json对象中添加一个新的元素(订单)
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								window.localStorage.setItem("totalnum", tnum + 1);					//商品种类数加一
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.timegoods.timegoodsorgprice) * parseFloat(orderds[i].orderdnum) ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+parseInt(orderds[i].orderdnum));
							}
						} else if(data[i].type == '买赠'){
							if( item1.goodsid == item.givegoods.givegoodsid){
								//如果商品id相同
								sdishes[j].orderdetnum = parseInt(sdishes[j].orderdetnum) + parseInt(orderds[i].orderdnum);
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.givegoods.givegoodsprice) * parseFloat(orderds[i].orderdnum) ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+parseInt(orderds[i].orderdnum));
								return false;
							} else if(j == (tnum-1)){
								//如果最后一次进入时goodsid不相同
								//新增订单
								var mdishes = new Object();
								mdishes.goodsid = item.givegoods.givegoodsid;
								mdishes.goodsdetail = item.givegoods.givegoodsdetail;
								mdishes.goodscompany = item.givegoods.givegoodscompany;
								mdishes.companyshop = $(".order-detail-info p").first().text();
								mdishes.companydetail = $(".order-detail-info p").last().text();
								mdishes.goodsclassname = item.givegoods.givegoodsclass;
								mdishes.goodscode = item.givegoods.givegoodscode;
								mdishes.pricesprice = item.givegoods.givegoodsprice;
								mdishes.pricesunit = item.givegoods.givegoodsunit;
								mdishes.goodsname = item.givegoods.givegoodsname;
								mdishes.goodsimage = item.givegoods.givegoodsimage;
								mdishes.orderdtype = data[i].type;
								mdishes.goodsunits = item.givegoods.givegoodsunits;
								mdishes.orderdetnum = orderds[i].orderdnum;
								mdishes.timegoodsnum = item.givegoods.givegoodsnum;
								sdishes.push(mdishes); 												//往json对象中添加一个新的元素(订单)
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								window.localStorage.setItem("totalnum", tnum + 1);					//商品种类数加一
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.givegoods.givegoodsprice) * parseFloat(orderds[i].orderdnum) ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+parseInt(orderds[i].orderdnum));
							}
						}
					});
				}
			});
			window.location.href = "cart.jsp";
		},
		error:function() {
			alert("网络问题请稍候再试");
		}
	});
}
function initOrderd(data){
	$("#orderd_data").text(JSON.stringify(data.root));
     $(".order-detail-wrapper").html("");
     $(".order-detail-wrapper").append('<ul>');
 	 $.each(data.root, function(i, item) {
 		$(".order-detail-wrapper").append('<li><span class="fl">'+
 				item.orderdname +'</span><span class="fl">¥'+
 				item.orderdprice +'/'+item.orderdunit+'</span><span class="fl">x'+
 				item.orderdnum +'</span><span class="fr"> '+item.orderdmoney+'元</span></li>');
     });
 	$(".order-detail-wrapper").append('</ul>');
 	getJson(basePath+"OrdermviewAction.do",{method:"selAll",wheresql:"ordermid='"+ordermid+"'"},initOrderm,null);
}
function initOrderm(data){
     $(".order-detail-info").html("");
     $(".pdl-b8").html("");
 	 $.each(data.root, function(i, item) {
 		$(".order-detail-info").append('<p name="'+item.companyphone+'">'+item.companyshop+'</p>'+
 				'<p>联系电话：'+item.companyphone+'</p>'+
 				'<p>'+item.companydetail+'</p>');
 		$(".pdl-b8").append('<p>收货人：'+item.ordermconnect+item.ordermphone+'</p>'+
 				'<p>收货地址：'+item.ordermaddress+'</p>'+
 				'<p>支付方式：'+item.ordermway+'</p>');
 		 $(".order-detail-wrapper").append('<p>订单金额: <span>'+item.ordermmoney+'元</span></p>'+
 	 		    '<p>优惠金额: <span>'+(item.ordermmoney-item.ordermrightmoney)+'元</span></p>'+
 	 		    '<p>实付金额: <span>'+item.ordermrightmoney+'元</span></p>');
     });
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
