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
	<div class="jiesuan-foot-info"><img src="../images/jiesuanbg.png" > 种类数：<span id="totalnum">0</span>总价：<span id="totalmoney">0</span> </div><a onclick="nextpage();" class="jiesuan-button">结算</a>
</div>
<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="popup_msg">尚无账号，立即注册？</p>
            <a href="#" class="cd-popup-close">取消</a><a class="popup_queding" href="reg.jsp">确定</a>
		</div>
	</div>
</div>
<script type="text/javascript" src="../js/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="../js/buy3.js"></script>
<script> 
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){
	$.ajax({
		url:"AddressAction.do?method=selAll",
		type:"post",
		data:{wheresql:"address.addresscustomer='"+customer.customerid+"'"},
		success : function(resp){
			var respText = eval('('+resp+')'); 
			if(typeof(respText.root) == 'undefined' || !respText.root){
				$(".popup_msg").text("还没有收货地址,请先添加收货地址。");				//修改弹窗文字信息
				$(".popup_queding").attr("href","mine.jsp");
				$(".cd-popup").addClass("is-visible");
			}
		},
		error : function(data){
			alert("网络出现问题!");
			history.go(-1);
		}
	});
	if('${requestScope.nullInfo}' == 'y'){
		$(".popup_msg").text("网络问题请重试。");
		$(".popup_queding").attr("href","index.jsp");
		$(".cd-popup").addClass("is-visible");
		setTimeout(function () {  
	        window.location.href = "index.jsp";
	    }, 500);
		return;
	}
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
	var flag = 0;
	var goodsname = '';
	$(".jia.add").each(function(i,item){
		var goodsNum = parseInt($(item).prev().val());
		var dailySur = parseInt($(item).attr("name"));
		if(goodsNum > dailySur){
			flag++;
			goodsname = $(item).parent().children("h2").text();
			return false;
		}
	});
	if(flag == 0){
		//整理购物车数据
			$("#buyall").attr('onclick','');											//禁用按钮
			$.ajax({
				url:"OrderdAction.do?method=sortingSdiData",
				type:"post",
				data:{
					json:window.localStorage.getItem("sdishes"),
					customerid:customer.customerid,
					customertype:customer.customertype,
					customerlevel:customer.customerlevel
				},
				success:function(resp){
					var respText = eval('('+resp+')');
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
						window.location.href = "buy.jsp";
					} else {
						alert(respText.msg);
					}
				},
				error : function(resp) {
					$("#buyall").attr('onclick','buy();');								//启用按钮
					var respText = eval('('+resp+')');
					alert(respText.msg);
				}
			});
		
	} else {
		alert("您购买的："+goodsname+" 超过了限购数量");
	}
}
//初始化的页面信息
function initDishes(data){
	var scompany = setscompany();
	$.ajax({
		url:"OrderdAction.do?method=selCusXGOrderd",
		type:"post",
		data:{customerid:customer.customerid},
		success : function(data2){
    		var cusOrder = JSON.parse(data2);
			$(".cart-wrapper").html("");
		    $.each(scompany, function(y, mcompany) {
		    	$(".cart-wrapper").append('<h1 name="'+mcompany.companyid +'">'+mcompany.companyshop+'</h1><ul>');
		    	$.each(data, function(i, item) {
		    		var dailySur = parseInt(item.timegoodsnum);
		    		if(cusOrder.root && cusOrder.root.length > 0){
		    			var itemGoodsCount = 0;
						$.each(cusOrder.root,function(k,item3){
							//alert(item.orderdtype +" == "+ item3.orderdtype +" && "+ item3.orderdcode +" == "+ item.goodscode);
							if(item.orderdtype == item3.orderdtype && item3.orderdcode == item.goodscode){
								itemGoodsCount += parseInt(item3.orderdclass);
							}
						});
						dailySur = parseInt(item.timegoodsnum) - itemGoodsCount;																//每日限购剩余数量
		    		}
		    		if(mcompany.ordermcompany==item.goodscompany)
		            $(".cart-wrapper").append('<li name="'+item.goodsid+'">'+
		                      	'<em><img src="../'+item.goodsimage+
		         	         	'" alt="" onerror="javascript:this.src=\'images/default.jpg\'"/></em> '+
		                      	'<h2>'+item.goodsname+' <span class="price">'+item.pricesprice+'元/'+item.pricesunit+'</span></h2>'+
		          				'<span onclick="subnum(this,'+item.pricesprice+')" class="jian min"></span>'+
		                          '<input class="text_box shuliang" readonly="readonly" name="'+item.goodsdetail+'" type="text" value="'+
		       	                getcurrennum(item.goodsid,item.goodsdetail)+'"> '+
		                          '<span name="'+dailySur+'" onclick="addnum(this,'+item.pricesprice+',\''+item.goodscode+'\',\''+item.goodsclassname+'\')" class="jia add"></span>'+
		                      '</li>');
		       });
		       $(".cart-wrapper").append('</ul><div class="songda">'+mcompany.companydetail+'</div>');		//添加供应商信息
			});
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
}
//得到商品数量
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
//加号
function addnum(obj,dishesprice,goodscode,goodsclassname){
	var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));
	var cusMSOrderNum = parseInt($(obj).attr("name"));
	var numt = $(obj).prev(); 
	var num = parseInt(numt.val());
	if((parseInt(cusMSOrderNum) - num) <= 0){
		alert('您购买的商品超过了限购数量。');
	} else {
		//总价
		var tmoney = parseFloat(window.localStorage.getItem("totalmoney"));
		var newtmoney = (tmoney+dishesprice).toFixed(2);
		$("#totalmoney").text(newtmoney);
		window.localStorage.setItem("totalmoney",newtmoney);
		//数量
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
}
//减号
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
