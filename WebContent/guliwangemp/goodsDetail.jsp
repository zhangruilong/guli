<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
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
<link href="css/dig.css" type="text/css" rel="stylesheet">
<style type="text/css">
.gdw_t_li3_pri{color: #F86B4F;font-size: 24px;float: left;margin-top: 26px;}
#gdw_t_li3{height: 51px;overflow: visible;}
#gdw_t_li2{border:0;}
#goods_ti{width: 80%;}
#goods_det_img2{margin-top: 15px;}
.goods_ti_gn{float: left;width: 95%;}
.goods-detail-wrapper ul li{width: 100%;}
.chk_1 + label{
	width: 13px;
	height: 13px;
	background-position:center;
	margin: 0 auto;
}
.chk_1:checked + label{background-position:center;}
</style>
</head>

<body>
<div class="goods-detail-wrapper">
	<ul>
    	<li><span><img id="goods_det_img1" alt="" src=""></span></li>
        <li id="gdw_t_li2">
        	<!-- <span id="goods_ti"></span>
        	<span class="gdw_tli2span_collect"></span> -->
        </li>
        <!-- <li id="gdw_t_li3"></li> -->
    </ul>
</div>
<div class="goods-detail-wrapper" style="margin: 0;border: 0px;">
	<ul class="gd-lower-liebiao">
    	<li>商品详情</li>
        <li>规格<span></span></li>
        <li>品牌<span></span></li>
        <li>种类<span></span></li>
    </ul>
</div>
<div><img id="goods_det_img2" alt="" src=""></div>
<div class="goodsdetail_float">
	<div class="gdf_gwc_div" onclick="docart()"><img src="images/gwc.png"><em id="totalnum">0</em></div>
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
<script type="text/javascript">
var basePath = '<%=basePath%>';
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
$(function(){
	var type = '${param.type}';
	var data = JSON.parse('${param.goods}');
	if(type == '商品'){
		$("#goods_det_img1").attr("src",'../'+data.goodsimage);
		$("#goods_det_img2").attr("src",basePath+'images/youhuida.jpg');
	    $("#gdw_t_li2").html('<span class="goods_ti_gn">'+data.goodsname+'（'+data.goodsunits+'）</span>');
		$("#gdw_t_li2").append('<span class="gdw_t_li3_pri">￥'+data.pricesprice+'/'+data.pricesunit+'</span>');
		$("#gdw_t_li2").append('<div class="gdw_t_li_stock_num" name="'+data.goodsid+'">'+
	            '<span class="jian min"  onclick="subnum(this,'+data.pricesprice+')"></span>'+
	            '<input readonly="readonly" class="text_box shuliang" name="danpin" type="text" value="'+
	             getcurrennumdanpin(data.goodsid)+'"> '+
	            ' <span class="jia add" onclick="addnum(this,'+data.pricesprice
				   +',\''+data.goodsname+'\',\''+data.pricesunit+'\',\''+data.goodsunits
				   +'\',\''+data.goodscode+'\',\''+data.goodsclass
				   +'\',\''+data.goodscompany+'\',\''+data.companyshop+'\',\''+data.companydetail
				   +'\')"></span>'+
				   '<span hidden="ture">'+JSON.stringify(data)+'</span>'+
	        	'</div>');
		$(".gd-lower-liebiao span:eq(0)").text(data.goodsunits);
		$(".gd-lower-liebiao span:eq(1)").text(data.goodsbrand);
		$(".gd-lower-liebiao span:eq(2)").text(data.goodstype);
		$("#gdw_t_li2").append(' <span class="gdw_t_li3_cc"><input type="checkbox" id="'+data.goodsid+'checkbox" class="chk_1" '+data.goodsdetail+'>'+
	     		'<label for="'+data.goodsid+'checkbox" onclick="checkedgoods(\''+data.goodsid+'\');"></label></span>');
	} else if (type == '秒杀'){
		$("#goods_det_img1").attr("src",'../'+data.timegoodsimage);
		$("#goods_det_img2").attr("src",basePath+'images/youhuida.jpg');
		$("#gdw_t_li2").html('<span class="goods_ti_gn">'+data.timegoodsname+'（'+data.timegoodsunits+'）</span>');
		$("#gdw_t_li2").append('<span class="gdw_t_li3_pri">￥'+data.timegoodsorgprice+'/'+data.timegoodsunit+'</span>');
		$("#gdw_t_li2").append('<div class="gdw_t_li_stock_num" name="'+data.timegoodsid+'">'+
	            '<span class="jian min"  onclick="subnum(this,'+data.timegoodsorgprice+')"></span>'+
	            '<input readonly="readonly" class="text_box shuliang" name="danpin" type="text" value="'+
	             getcurrennumdanpin(data.timegoodsid)+'"> '+
	            ' <span class="jia add" onclick="addtimegoodsnum(this,'+data.timegoodsorgprice
				   +',\''+data.timegoodsname+'\',\''+data.timegoodsunit+'\',\''+data.timegoodsunits
				   +'\',\''+data.timegoodscode+'\',\''+data.timegoodsclass
				   +'\',\''+data.timegoodscompany+'\',\'${param.companyshop}\',\'${param.companydetail}'
				   +'\')"></span>'+
				   '<span hidden="ture">'+JSON.stringify(data)+'</span>'+
	        	'</div>');
		$(".gd-lower-liebiao span:eq(0)").text(data.timegoodsunits);
		$(".gd-lower-liebiao span:eq(2)").text(data.timegoodsclass);
	} else if(type == '买赠'){
		$("#goods_det_img1").attr("src",'../'+data.givegoodsimage);
		$("#goods_det_img2").attr("src",basePath+'images/youhuida.jpg');
		$("#gdw_t_li2").html('<span class="goods_ti_gn">'+data.givegoodsname+'（'+data.givegoodsunits+'）<br><span style="color: #666;">'+data.givegoodsdetail+'</span></span>');
		$("#gdw_t_li2").append('<span class="gdw_t_li3_pri">￥'+data.givegoodsprice+'/'+data.givegoodsunit+'</span>');
		$("#gdw_t_li2").append('<div class="gdw_t_li_stock_num" name="'+data.givegoodsid+'">'+
	            '<span class="jian min"  onclick="subnum(this,'+data.givegoodsprice+')"></span>'+
	            '<input readonly="readonly" class="text_box shuliang" name="'+data.givegoodsdetail+'" type="text" value="'+
	             getcurrennumdanpin(data.givegoodsid)+'"> '+
	            ' <span class="jia add" onclick="addgivegoodsnum(this,'+data.givegoodsprice
				   +',\''+data.givegoodsname+'\',\''+data.givegoodsunit+'\',\''+data.givegoodsunits
				   +'\',\''+data.givegoodscode+'\',\''+data.givegoodsclass
				   +'\',\''+data.givegoodscompany+'\',\''+data.givegoodcompany.companyshop+'\',\''+data.givegoodcompany.companydetail
				   +'\')"></span>'+
				   '<span hidden="ture">'+JSON.stringify(data)+'</span>'+
	        	'</div>');
		$(".gd-lower-liebiao span:eq(0)").text(data.givegoodsunits);
		$(".gd-lower-liebiao span:eq(2)").text(data.givegoodsclass);
	}
	//弹窗
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		if($(event.target).is(".cd-popup-close") || $(event.target).is(".cd-popup-container")){
			//如果点击的是'取消'或者除'确定'外的其他地方
			$(this).removeClass("is-visible");	//移除'is-visible' class
		}
	});
	//购物车图标上的数量
	if(!window.localStorage.getItem("totalnum")){
		window.localStorage.setItem("totalnum",0);
		$("#totalnum").text(0);
	}else{
		$("#totalnum").text(window.localStorage.getItem("cartnum"));
	}
	if(window.localStorage.getItem("totalnum")==0)
		$("#totalnum").hide();
});
//到购物车
function docart(){
	if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
		window.location.href = "cartnothing.html";
	} else {
		window.location.href = "cart.jsp";
	}
}
//加号(秒杀商品)
function addtimegoodsnum(obj,pricesprice,goodsname,pricesunit,goodsunits,goodscode,goodsclassname,goodscompany,companyshop,companydetail){
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
//加号(买赠商品)
function addgivegoodsnum(obj,pricesprice,goodsname,pricesunit,goodsunits,goodscode,goodsclassname,goodscompany,companyshop,companydetail){
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
//加号(商品)
function addnum(obj,pricesprice,goodsname,pricesunit,goodsunits,goodscode,goodsclassname,goodscompany,companyshop,companydetail){
	var item = JSON.parse($(obj).next().text());
	//总价
	var tmoney = parseFloat(window.localStorage.getItem("totalmoney"));
	var newtmoney = (tmoney+pricesprice).toFixed(2);
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
	if(num == 0){
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
		mdishes.goodsimage = item.goodsimage;
		mdishes.orderdtype = '商品';
		sdishes.push(mdishes);
		//种类数
		var tnum = parseInt(window.localStorage.getItem("totalnum"));
		window.localStorage.setItem("totalnum",tnum+1);
	}else{
		//修改订单
		$.each(sdishes, function(i, item) {
			if(item.goodsid==$(obj).parent().attr('name')
					&&item.goodsdetail==$(obj).prev().attr('name')){
				item.orderdetnum = item.orderdetnum + 1;
				return false;
			}
		});
	}
	window.localStorage.setItem("sdishes",JSON.stringify(sdishes));
	
	var cartnum = parseInt(window.localStorage.getItem("cartnum"));
	$("#totalnum").text(cartnum+1);
	window.localStorage.setItem("cartnum",cartnum+1);
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
//收藏商品
function checkedgoods(goodsid){
	if(!customer.customerid || typeof(customer.customerid) == 'undefined'){
		$("#"+goodsid+"checkbox").prop("checked",false);
		$("#"+goodsid+"checkbox").attr("checked","");
		$(".cd-buttons .meg").text("尚无账号，立即注册？");
		$(".cd-buttons .ok").css("display","inline-block");
		$(".cd-popup-close").text("取消");
		$(".cd-popup").addClass("is-visible");
		return;
	}
	var url = 'CollectAction.do?method=';
	if($("#"+goodsid+"checkbox").is(':checked')){
		url +='delAllByGoodsid';
	}else{
		url +='insAll';
	}
	var json = '[{"collectgoods":"' + goodsid + 
		'","collectcustomer":"' + customer.customerid + '"}]';
	$.ajax({
		url : url,
		data : {
			json : json
		},
		success : function(resp) {
			var respText = eval('('+resp+')'); 
			if(respText.success == false) 
				alert(respText.msg);
			else {
				$(".cd-buttons .meg").text("操作成功!");
				$(".cd-buttons .ok").css("display","none");
				$(".cd-popup-close").text("确定");
				$(".cd-popup").addClass("is-visible");	//弹出窗口
				setTimeout(function () {  
					$(".cd-popup").removeClass("is-visible");	//一秒钟后关闭弹窗
			    }, 1000);
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
