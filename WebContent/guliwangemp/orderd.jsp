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
<link href="../css/base.css" type="text/css" rel="stylesheet">
<link href="../css/layout.css" type="text/css" rel="stylesheet">
</head>

<body>
<div class="order-detail-info">
</div>
<div class="order-detail-user">
<i class="info-icon"></i>
<div class="pdl-b8">
  <p>收货人: </p>
  <p>收货地址:</p>
  <p>支付方式:</p>
</div>
</div>
<div class="order-detail-wrapper">
</div>
<div class="footer">
	<div class="order-detail-foot">
    	<!-- <a href="#">取消订单</a> -->
        <span id="orderd_data" hidden="true"></span>
        <a onclick="regoumai()" >重新购买</a>
    </div>
</div>
<script src="../js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var basePath = '<%=basePath%>';
var ordermid = '<%=ordermid%>';
var comid = '';
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){ 
	if(ordermid!="null"&&ordermid!=""){
		getJson(basePath+"GLOrderdAction.do",{
			method:"selAll",
			wheresql:"orderdorderm='"+ordermid+"'",
			customerxian: customer.customerxian
		},initOrderd,null);
	}
})
//重新购买
function regoumai(){
	var orderds = $("#orderd_data").text();
	$.ajax({
		url:"GLOrderdAction.do?method=queryREgoumaiGoods",
		type:"post",
		data:{
			json:orderds,
			customertype: customer.customertype,
			customerlevel: customer.customerlevel,
			comid : comid
		},
		success: function(resp){
			var jsonResp = JSON.parse(resp);
			var data = jsonResp.root;
			if(jsonResp.msg.length > 10){
				if(confirm(jsonResp.msg) == false){
					return ;
				}
			}
			$.each(data,function(i,item){
				//alert(JSON.parse(item));
				var now_GNum = parseInt(item.nowGoodsNum);
				if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
					//没有购物车
					window.localStorage.setItem("sdishes", "[]");						//创建一个购物车
					var sdishes = JSON.parse(window.localStorage.getItem("sdishes")); 	//将缓存中的sdishes(字符串)转换为json对象
					var money = 0.00;
					if(item.type == '商品' && item.statue != '下架'){
						//新增订单
						var mdishes = new Object();
						mdishes.goodsid = item.goodsview.goodsid;
						mdishes.goodsdetail = 'danpin';
						mdishes.goodscompany = item.goodsview.goodscompany;
						mdishes.companyshop = item.goodsview.companyshop;
						mdishes.companydetail = item.goodsview.companydetail;
						mdishes.goodsclassname = item.goodsview.goodsclass;
						mdishes.goodscode = item.goodsview.goodscode;
						mdishes.pricesprice = item.goodsview.pricesprice;
						mdishes.pricesunit = item.goodsview.pricesunit;
						mdishes.goodsname = item.goodsview.goodsname;
						var goodsimages = [];
				 		if(typeof(item.goodsview.goodsimage)!='undefined'){
				 			goodsimages = item.goodsview.goodsimage.split(',');
				 		} else {
				 			goodsimages[0] = 'images/default.jpg';
				 		}
						mdishes.goodsimage = goodsimages[0];
						mdishes.orderdtype = '商品';
						mdishes.goodsunits = item.goodsview.goodsunits;
						mdishes.orderdetnum = item.nowGoodsNum;
						mdishes.goodsweight = item.goodsview.goodsweight;
						mdishes.goodsbrand = item.goodsview.goodsbrand;
						money = (parseFloat(item.goodsview.pricesprice) * now_GNum).toFixed(2);
					} else if((item.type=='年货' || item.type=='组合' || item.type=='秒杀' || item.type=='买赠') && item.statue != '下架'){
						var mdishes = new Object();
						mdishes.goodsid = item.bgview.bkgoodsid;
						mdishes.goodsdetail = item.bgview.bkgoodsdetail;
						mdishes.goodscompany = item.bgview.bkgoodscompany;
						mdishes.companyshop = item.bgview.companyshop;
						mdishes.companydetail = item.bgview.companydetail;
						mdishes.goodsclassname = item.bgview.bkgoodsclass;
						mdishes.goodscode = item.bgview.bkgoodscode;
						mdishes.pricesprice = item.bgview.bkgoodsorgprice;
						mdishes.pricesunit = item.bgview.bkgoodsunit;
						mdishes.goodsname = item.bgview.bkgoodsname;
						mdishes.goodsimage = item.bgview.bkgoodsimage;
						mdishes.orderdtype = item.type;
						mdishes.goodsunits = item.bgview.bkgoodsunits;
						mdishes.goodsweight = item.bgview.bkgoodsweight;
						mdishes.surplusnum = item.bgview.bkgoodssurplus;	//剩余数量
						mdishes.timegoodsnum = item.bgview.bkgoodsnum;	//限购数量
						mdishes.orderdetnum = item.nowGoodsNum;
						money = (parseFloat(item.bgview.bkgoodsorgprice) * now_GNum).toFixed(2);
					}
					if(typeof(mdishes)!='undefined' && mdishes){
						sdishes.push(mdishes); 											//往json对象中添加一个新的元素(订单)
						window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
						
						window.localStorage.setItem("totalnum", 1); 					//设置缓存中的种类数量等于一 
						window.localStorage.setItem("totalmoney", money);				//总金额等于商品价
						var cartnum = parseInt(window.localStorage.getItem("cartnum"));
						window.localStorage.setItem("cartnum",cartnum+now_GNum);
					}
				} else {
					//有购物车
					var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));	//将缓存中的sdishes(字符串)转换为json对象
					var tnum = parseInt(window.localStorage.getItem("totalnum"));		//取出商品的总类数
					$.each(sdishes,function(j,item1) {								//遍历购物车中的商品
						if(item.type == '商品' && item.statue != '下架'){
							if( item1.goodsid == item.goodsview.goodsid){
								//如果商品id相同
								sdishes[j].orderdetnum = parseInt(sdishes[j].orderdetnum) + now_GNum;
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.goodsview.pricesprice) * now_GNum ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+now_GNum);
								return false;
							} else if(j == (tnum-1)){
								//如果最后一次进入时goodsid不相同
								//新增订单
								var mdishes = new Object();
								mdishes.goodsid = item.goodsview.goodsid;
								mdishes.goodsdetail = 'danpin';
								mdishes.goodscompany = item.goodsview.goodscompany;
								mdishes.companyshop = item.goodsview.companyshop;
								mdishes.companydetail = item.goodsview.companydetail;
								mdishes.goodsclassname = item.goodsview.goodsclass;
								mdishes.goodscode = item.goodsview.goodscode;
								mdishes.pricesprice = item.goodsview.pricesprice;
								mdishes.pricesunit = item.goodsview.pricesunit;
								mdishes.goodsname = item.goodsview.goodsname;
								var goodsimages = [];
						 		if(typeof(item.goodsview.goodsimage)!='undefined'){
						 			goodsimages = item.goodsview.goodsimage.split(',');
						 		} else {
						 			goodsimages[0] = 'images/default.jpg';
						 		}
								mdishes.goodsimage = goodsimages[0];
								mdishes.orderdtype = '商品';
								mdishes.goodsunits = item.goodsview.goodsunits;
								mdishes.orderdetnum = item.nowGoodsNum;
								mdishes.goodsweight = item.goodsview.goodsweight;
								mdishes.goodsbrand = item.goodsview.goodsbrand;
								sdishes.push(mdishes); 												//往json对象中添加一个新的元素(订单)
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								window.localStorage.setItem("totalnum", tnum + 1);					//商品种类数加一
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.goodsview.pricesprice) * now_GNum ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+now_GNum);
							}
						} else if((item.type=='年货' || item.type=='组合' || item.type=='秒杀' || item.type=='买赠') && item.statue != '下架'){
							if( item1.goodsid == item.bgview.bkgoodsid){
								//如果商品id相同
								sdishes[j].orderdetnum = parseInt(sdishes[j].orderdetnum) + now_GNum;
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.bgview.givegoodsprice) * now_GNum ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+now_GNum);
								return false;
							} else if(j == (tnum-1)){
								//如果最后一次进入时goodsid不相同
								//新增订单
								var mdishes = new Object();
								mdishes.goodsid = item.bgview.bkgoodsid;
								mdishes.goodsdetail = item.bgview.bkgoodsdetail;
								mdishes.goodscompany = item.bgview.bkgoodscompany;
								mdishes.companyshop = item.bgview.companyshop;
								mdishes.companydetail = item.bgview.companydetail;
								mdishes.goodsclassname = item.bgview.bkgoodsclass;
								mdishes.goodscode = item.bgview.bkgoodscode;
								mdishes.pricesprice = item.bgview.bkgoodsorgprice;
								mdishes.pricesunit = item.bgview.bkgoodsunit;
								mdishes.goodsname = item.bgview.bkgoodsname;
								mdishes.goodsimage = item.bgview.bkgoodsimage;
								mdishes.orderdtype = item.type;
								mdishes.surplusnum = item.bgview.bkgoodssurplus;	//剩余数量
								mdishes.timegoodsnum = item.bgview.bkgoodsnum;	//限购数量
								mdishes.goodsunits = item.bgview.bkgoodsunits;
								mdishes.goodsweight = item.bgview.bkgoodsweight;
								mdishes.goodsbrand = item.bgview.bkgoodsbrand;
								mdishes.orderdetnum = item.nowGoodsNum;
								sdishes.push(mdishes); 												//往json对象中添加一个新的元素(订单)
								window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
								window.localStorage.setItem("totalnum", tnum + 1);					//商品种类数加一
								var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
								var newtmoney = ( tmoney + parseFloat(item.bgview.bkgoodsorgprice) * now_GNum ).toFixed(2);
								window.localStorage.setItem("totalmoney",newtmoney);	
								var cartnum = parseInt(window.localStorage.getItem("cartnum"));
								window.localStorage.setItem("cartnum",cartnum+now_GNum);
							}
						}
					});
				}
			});
			window.location.href = "cart.jsp";
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
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
 	getJson(basePath+"GLOrdermviewAction.do",{method:"selAll",wheresql:"ordermid='"+ordermid+"'",
		customerxian: customer.customerxian},initOrderm,null);
}
function initOrderm(data){
	comid = data.root[0].ordermcompany;
     $(".order-detail-info").html("");
     $(".pdl-b8").html("");
 	 $.each(data.root, function(i, item) {
 		$(".order-detail-info").append('<p name="'+item.companyphone+'">'+item.companyshop+'</p>'+
 				'<p>联系电话：<a href="tel:'+item.companyphone+'">'+item.companyphone+'</a></p>'+
 				'<p>'+item.companydetail+'</p>');
 		var odmmsg = '<p>收货人：'+item.ordermconnect+item.ordermphone+'</p>'+
			'<p>收货地址：'+item.ordermaddress+'</p>'+
				'<p>支付方式：'+item.ordermway+'</p>';
		if(item.ordermdetail){
			odmmsg += '<p>订单留言：'+item.ordermdetail+'</p>';
		}
 		$(".pdl-b8").append(odmmsg);
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
