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
<style type="text/css">
input {
	float: left;
	
  -webkit-appearance: none; /* remove default */
  display: block;
  margin: 38px 10px 10px 10px;
  width: 26px;
  height: 26px;
  border-radius: 13px;
  cursor: pointer;
  vertical-align: middle;
  box-shadow: inset hsla(0,0%,0%,1) 0 0 0 1px;
  background-color: white;
  background-repeat: no-repeat;
}



/* The up/down direction logic */

input:checked {
	box-shadow: none;
  background: url(../images/price-rd.png) no-repeat;
  background-size: 24px 24px;
}
#cwn_a_xiadan{
	right: 16%;
}
</style>
</head>

<body>
	<form action="delCollect.action" method="post">
	<div class="gl-box">
		<div class="wapper-nav"><a onclick="javascript:window.history.go(-1)" class='goback'></a>
	我的收藏<a id="cwn_a_xiadan" onclick="xiadan()">下单</a><a id="cwn_a_bianji" onclick="editToDel()">编辑</a></div>
		</div>
		<div class="shoucang-wrap">
			<ul>
			</ul>
		</div>
	</form>
<script src="../js/jquery-1.8.3.min.js"></script>
<script src="../js/jquery-dropdown.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customeremp"));
var comid = '';
$(function(){
	$.ajax({
		url:"GLCollectviewAction.do?method=cusColl",
		type:"post",
		data:{
			wheresql:"collectcustomer='"+customer.customerid+"' and pricesclass='"+
					customer.customertype+"' and priceslevel='"+customer.customerlevel+
					"' ",
			customerxian: customer.customerxian
		},
		success:function(resp){
			var jsonResp = eval('('+resp+')');
			var data = jsonResp.root;
			if(typeof(data) != 'undefined' && data.length > 0){
				comid = data[0].goodscompany;
				$.each(data,function(i,item){
					var jsonitem = JSON.stringify(item);
					var goodsimages = [];
			 		if(typeof(item.goodsimage)!='undefined'){
			 			goodsimages = item.goodsimage.split(',');
			 		} else {
			 			goodsimages[0] = 'images/default.jpg';
			 		}
					$(".shoucang-wrap ul").append(
						'<li name="'+item.goodsid+'"><span hidden="true">'+jsonitem+'</span>'+
						'<a name="'+item.goodsid+'" ><span class="fl">'+
						'<img src="../'+goodsimages[0]+'" alt="" onerror="javascript:this.src=\'../images/default.jpg\'"/></span>'+
							'<h1>'+item.goodsname+'<span>（'+item.goodsunits+'）</span>'+
								'</h1>'+
								'<p class="clct-GP-img">'+
											'售价：<font>￥'+item.pricesprice+'</font>/'+item.pricesunit+
										'</p>'+
										/* '<p>'+
											'<font>&nbsp;</font>'+
										'</p>'+ */
							'</a>'+
						'</li>');
				})
			} else {
				window.location.href = 'collectnothing.html';
			}
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
})
	//下单
	function xiadan(){
		$("#cwn_a_xiadan").text("确定");
		$("#cwn_a_bianji").text("取消");
		$("#cwn_a_xiadan").attr("onclick","collectDoCart()");
		$("#cwn_a_bianji").attr("onclick","cancel()");
		$.each($("li"),function(i,item){
			$(item).prepend("<input type='checkbox' value='"+$(item).attr("name")+"' >");
		})
	}
	//取消
	function cancel(){
		$("li input").remove();
		$(".wapper-nav").html('<a onclick="javascript:window.history.go(-1)" class="goback"></a>'+
				'我的收藏<a id="cwn_a_xiadan" onclick="xiadan()">下单</a><a id="cwn_a_bianji" onclick="editToDel()">编辑</a>');
	}
	//加入购物车
	function collectDoCart(){
		
		var goods = JSON.parse('[]');
		$.each($("[type='checkbox']"),function(i,item){
			if(item.checked){
				goods.push(JSON.parse($(item).next().text()));
			}
		})
		if(parseInt(goods.length) >0){
			$.each(goods,function(i,item){
				if (window.localStorage.getItem("sdishes") == null || window.localStorage.getItem("sdishes") == "[]") {				//判断有没有购物车
					//没有购物车
					window.localStorage.setItem("sdishes", "[]");						//创建一个购物车
					var sdishes = JSON.parse(window.localStorage.getItem("sdishes")); 	//将缓存中的sdishes(字符串)转换为json对象
					//新增订单
					var mdishes = new Object();
					mdishes.goodsid = item.goodsid;
					mdishes.goodsdetail = 'danpin';
					mdishes.goodscompany = item.goodscompany;
					mdishes.companyshop = item.companyshop;
					mdishes.companydetail = item.companydetail;
					mdishes.goodsclassname = item.goodsclass;
					mdishes.goodscode = item.goodscode;
					mdishes.pricesprice = item.pricesprice;
					mdishes.pricesunit = item.pricesunit;
					mdishes.goodsname = item.goodsname;
					var goodsimages = [];
			 		if(typeof(item.goodsimage)!='undefined'){
			 			goodsimages = item.goodsimage.split(',');
			 		} else {
			 			goodsimages[0] = 'images/default.jpg';
			 		}
					mdishes.goodsimage = goodsimages[0];
					mdishes.orderdtype = '商品';
					mdishes.timegoodsnum = item.goodsnum;
					mdishes.goodsunits = item.goodsunits;
					mdishes.orderdetnum = 1;
					mdishes.goodsweight = item.goodsweight;
					mdishes.goodsbrand = item.goodsbrand;
					sdishes.push(mdishes); 											//往json对象中添加一个新的元素(订单)
					window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
					
					window.localStorage.setItem("totalnum", 1); 					//设置缓存中的种类数量等于一 
					window.localStorage.setItem("totalmoney", item.pricesprice);	//总金额等于商品价
					var cartnum = parseInt(window.localStorage.getItem("cartnum"));
					window.localStorage.setItem("cartnum",cartnum+1);
				} else {
					
					//有购物车
					var sdishes = JSON.parse(window.localStorage.getItem("sdishes"));	//将缓存中的sdishes(字符串)转换为json对象
					var tnum = parseInt(window.localStorage.getItem("totalnum"));		//取出商品的总类数
					$.each(sdishes,function(j,item1) {								//遍历购物车中的商品
						//i是增量,item是迭代出来的元素.i从0开始
						if( item1.goodsid == item.goodsid){
							//如果商品id相同
							return false;
						} else if(j == (tnum-1)){
							//如果最后一次进入时goodsid不相同
							//新增订单
							var mdishes = new Object();
							mdishes.goodsid = item.goodsid;
							mdishes.goodsdetail = 'danpin';
							mdishes.goodscompany = item.goodscompany;
							mdishes.companyshop = item.companyshop;
							mdishes.companydetail = item.companydetail;
							mdishes.goodsclassname = item.goodsclass;
							mdishes.goodscode = item.goodscode;
							mdishes.pricesprice = item.pricesprice;
							mdishes.pricesunit = item.pricesunit;
							mdishes.goodsname = item.goodsname;
							var goodsimages = [];
					 		if(typeof(item.goodsimage)!='undefined'){
					 			goodsimages = item.goodsimage.split(',');
					 		} else {
					 			goodsimages[0] = 'images/default.jpg';
					 		}
							mdishes.goodsimage = goodsimages[0];
							mdishes.orderdtype = '商品';
							mdishes.timegoodsnum = item.goodsnum;
							mdishes.goodsunits = item.goodsunits;
							mdishes.orderdetnum = 1;
							mdishes.goodsweight = item.goodsweight;
							mdishes.goodsbrand = item.goodsbrand;
							sdishes.push(mdishes); 												//往json对象中添加一个新的元素(订单)
							window.localStorage.setItem("sdishes", JSON.stringify(sdishes));
							window.localStorage.setItem("totalnum", tnum + 1);					//商品种类数加一
							var tmoney = parseFloat(window.localStorage.getItem("totalmoney")); //从缓存中取出总金额
							var newtmoney = (tmoney+parseFloat(item.pricesprice)).toFixed(2);
							window.localStorage.setItem("totalmoney",newtmoney);	
							var cartnum = parseInt(window.localStorage.getItem("cartnum"));
							window.localStorage.setItem("cartnum",cartnum+1);
						}	
					})
				}
			})
			window.location.href = "cart.jsp";
		} else {
			cancel();
		}
	}
	//修改
	function editToDel(){
		$("#cwn_a_xiadan").text("删除");
		$("#cwn_a_bianji").text("取消");
		$("#cwn_a_xiadan").attr("onclick","delCollects()");
		$("#cwn_a_bianji").attr("onclick","cancel()");
		$.each($("li"),function(i,item){
			$(item).prepend("<input style='background-color:whit;' type='checkbox' value='"+$(item).attr("name")+"' name='collectids'>");
		})
	}
	//删除收藏
	function delCollects(){
		var collectids = '[';
		$.each($("[type='checkbox']"),function(i,item){
			if(item.checked){
				collectids += '{"collectcustomer":"'+customer.customerid+'","collectgoods":"'+$(item).val()+'"},';
			}
		});
		collectids = collectids.substr(0,collectids.length -1) + "]";
		if(collectids.length > 2){
			$.ajax({
				url:"GLCollectAction.do?method=delAllByGoodsid",
				type:"post",
				data:{
					json:collectids,
					comid: comid
				},
				success:function(resp){
					var respText = eval('('+resp+')');
					alert(respText.msg);
					window.location.reload();
				},
				error : function(resp2){
					var respText2 = eval('('+resp2+')');
					alert(respText2.msg);
				}
			});
		} else {
			cancel();
		}
	}
</script>
</body>

</html>
