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
<style type="text/css">
.reg-wrapper li span{
	width: 30%;
}
.float_select_quyu{
	position: fixed ;
	left:0%;
	top:50%;
	z-index: 999;
	height: 30px;
	line-height: 30px;
	width: 100px;
	border: solid 1px ;
	display: block;
	background-color: #ccc;
}
#cusCityDiv ul{
	padding: 0px;
	margin: 0px;
	
}
#cusCityDiv ul li{
	list-style: none;
}
.reg-wrapper ul li input{
}
</style>
</head>

<body>
<form action="">
	<div class="reg-wrapper reg-dianpu-info">
		<ul>
			<li>
			<span>所在城市</span>
			<input onclick="input_sele_city()" placeholder="所在城市" id="customercity" name="" type="text" readonly="readonly" style="background-color:#fff;"/>
         <div id="divList" style="display: none; position: absolute ;width: 50%;height:30%;right:0px; left:50%; top:10%; border: 1px solid black; overflow: auto; position: absolute; background-color:#FFFFFF; "> 
                <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
                    <tr> 
                        <td> 
                               <div id="cusCityDiv"  style="overflow: auto; padding-left:0; width: 100%; background-color: #F2F2F2;height: 100%; ">
                               	<ul>
                               			<li>嘉兴市</li>
                               	</ul>
                               </div> 
                        </td> 
                    </tr> 
                </table>   
          </div> 
			</li>
        <li>
			<span>所在地区</span>
			<input onclick="" placeholder="所在地区" id="customerxian" name="customerxian" type="text" readonly="readonly" style="background-color:#fff;"/>
         <div id="xianList" style="display: none; position: absolute ;width: 50%;height:30%;right:0px; left:50%; top:20%; border: 1px solid black; overflow: auto; position: absolute; background-color:#FFFFFF; "> 
                <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
                    <tr> 
                        <td> 
                               <div id="cusXianDiv"  style="overflow: auto; padding-left:0; width: 100%; background-color: #F2F2F2;height: 100%; ">
                               	<ul>
                               		<li>请选择</li>
                               	</ul>
                               </div> 
                        </td> 
                    </tr> 
                </table>   
          </div> 
		</li>
			<li><span>店铺名称</span> <input name="customershop" type="text" id="customershop"
				placeholder="请输入店铺名称"></li>
			<li><span>店铺地址</span> <input name="customeraddress" type="text" id="customeraddress"
				placeholder="请输入店铺地址"></li>
			<li><span>联系人</span><input name="customername" type="text" id="customername"
				placeholder="请输入名字"></li>
			<li><span>手机号</span><input name="customerphone" type="text" id="customerphone"
				placeholder="请输入手机号码"></li>
		</ul>
	</div>
	<div class="confirm-reg">
		<a onclick="reg()" class="confirm-reg-btn">确认注册</a> <a href="agreement.jsp">确认注册即同意《谷粒网客户注册服务协议》</a>
	</div>
	<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="meg">恭喜您注册成功,绑定供货商后即可购买商品!</p>
            <a class="cd-popup-close">确定</a>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
var customercity = '';
var divListTop = $(".reg-wrapper ul li").innerHeight(); //divList的top值
var xianListTop = divListTop*2;	//xianList的top值
$("#divList").css("top",divListTop + "px");
$("#xianList").css("top",xianListTop + "px");
	$(function(){
		//防止openid 为 字符串"null"
		if(!window.localStorage.getItem("openid") || window.localStorage.getItem("openid")== 'null' || window.localStorage.getItem("openid") == ''){
			window.location.href = "index.jsp";
			return;
		}
		$(".cd-popup").on("click",function(event){		//绑定点击事件
			$(this).removeClass("is-visible");			//移除'is-visible' class
		});
		$.ajax({
			url:"GLCityAction.do?method=selAll",
			type:"post",
			data:{
				wheresql:"cityparent='root'"
			},
			success:function(resp){
				var data = JSON.parse(resp).root;
				$("#cusCityDiv ul li").remove();
				$.each(data,function(i,item){
					$("#cusCityDiv ul").append('<li name="'+item.cityid+'">'+item.cityname+'</li>');
				});
				cityBinDing();
			},
			error: function(resp){
				var respText = eval('('+resp+')'); 
				alert(respText.msg);
			}
		});
	})
	function input_sele_city(){
		$("#city").trigger("change");
	}
	//注册
	function reg(){
		alert("您在谷粒网的唯一标识码为："+window.localStorage.getItem("openid")+" 您不必记住它。");
		$('.confirm-reg-btn').attr('onclick','');						//禁用按钮
		var count = 0;
		var alt;
		$("input").each(function(i,item){
			if($(item).val() == null || $(item).val() == ''){
				count++;
				alt=$(item).attr("placeholder");
				return false;
			}
		});
		if(count > 0){
			$(".meg").text(alt);			//修改弹窗信息
			$(".cd-popup").addClass("is-visible");	//弹出窗口
			$('.confirm-reg-btn').attr('onclick','reg()');				//启用按钮
			return;
		}
		var reg = /^[1][0-9]{10}$/;
		//var reg = new RegExp('[0-9]{11}','g');
		if(!reg.test($("#customerphone").val())){
			$(".meg").text('请填写正确的手机号码。');			//修改弹窗信息
			$(".cd-popup").addClass("is-visible");	//弹出窗口
			$('.confirm-reg-btn').attr('onclick','reg()');				//启用按钮
			return;
		}
		if($("#customercity").val() == null || $("#customercity").val() == ''){
			$(".meg").text("请选择城市");		//修改弹窗信息
			$(".cd-popup").addClass("is-visible");	//弹出窗口
			$('.confirm-reg-btn').attr('onclick','reg()');				//启用按钮
			return;
		}
		if($("#customerxian").val() == null || $("#customerxian").val() == ''){
			$(".meg").text("请选择地区");		//修改弹窗信息
			$(".cd-popup").addClass("is-visible");	//弹出窗口
			$('.confirm-reg-btn').attr('onclick','reg()');				//启用按钮
			return;
		}
		$.ajax({
			url: "GLCustomerAction.do?method=regCustomer",
			type:"post",
			data: {
				json:'[{'+
				'"openid":"'+window.localStorage.getItem("openid")+'",'+
				'"customercity":"'+$("#customercity").val()+'",'+
				'"customerphone":"'+$("#customerphone").val()+'",'+
				'"customerxian":"'+$("#customerxian").val()+'",'+
				'"customershop":"'+$.trim($("#customershop").val())+'",'+
				'"customername":"'+$("#customername").val()+'",'+
				'"customeraddress":"'+$("#customeraddress").val()+'"'+
				'}]'
			},
			success: function(resp) {
				var respText = eval('('+resp+')');
				if(respText.msg == '操作成功'){
					window.localStorage.setItem("customer",JSON.stringify(respText.root[0]));
					$(".meg").text("恭喜您注册成功,绑定经销商后即可购买商品!");
					$(".cd-buttons a").attr("href","cusbinding.jsp");
					$(document).click(function(){
						window.location.href = "cusbinding.jsp";
					});
					$(".cd-popup").addClass("is-visible");	//弹出窗口
				} else {
					alert(respText.msg);
					$('.confirm-reg-btn').attr('onclick','reg()');				//启用按钮
				}
			},
			error:function(data) {
				var dataJson = JSON.parse(data);
				if(dataJson.code == '400'){
					$(".meg").text(dataJson.msg);
					$(".cd-buttons a").attr("href","index.jsp");
					$(document).click(function(){
						window.location.reload();
					});
					$(".cd-popup").addClass("is-visible");	//弹出窗口
				} else {
					alert("操作失败。");
					window.location.reload();
				}
			}
		});
	}
	
////////////////////////////////////////////这是下拉列表菜单的js///////////////////////////////////////////////////////
	   var oRegion = document.getElementById("customercity");     //需要弹出下拉列表的文本框 
       var oDivList = document.getElementById("divList");         //要弹出的下拉列表
       var contentD = document.getElementById("contentDiv") ;
       var customerxianObj = $("#customerxian");
       var xianListObj = $("#xianList");
       var bNoAdjusted = true;  //控制div是否已经显示的变量
       var html = "" ; 
       var all_html ="" ;
       var colOptions = "" ;
       
     //绑定城市选择的事件
   	function cityBinDing(){
   		$("#cusCityDiv ul li").click(function(){
    		   $(oRegion).val($(this).text());
    		   $.ajax({
    			   url:"GLCityAction.do?method=selAll",
    			   type:"post",
    			   data:{
    				   wheresql:"cityparent='"+$(this).attr("name")+"'"
    			   },
    			   success:function(resp){
    				   var data = JSON.parse(resp).root;
   					   $("#cusXianDiv ul li").remove();
    				   $.each(data,function(i,item){
    					   $("#cusXianDiv ul").append('<li>'+item.cityname+'</li>');
    				   });
    				  $("#cusXianDiv ul li").click(function(){
    			    	 customerxianObj.val($(this).text());
    			     });
    			   },
    			   error: function(resp){
    					var respText = eval('('+resp+')'); 
    					alert(respText.msg);
    			   }
    		   });
    	   });
   	     
   	}
     //关闭下拉框
       $(document).click(function (e) {          
          var target_id = $(e.target).attr('id');             // 获取点击dom元素id ;
          if(target_id!=oRegion.id){
                  oDivList.style.display = "none";//隐藏div，实现关闭下拉框的效果 ;
          }
          if(target_id!= customerxianObj.attr("id")){
        	  xianListObj.css("display","none");
          }
       });
       $(function(){
	     
    	   cityBinDing();
	     
	   /* function cityclick(obj){
		   customerxianObj.val($(obj).text());
	   } */
       });

       //文本获得焦点时的事件 (弹出下拉框)
       oRegion.onfocus = function() { 
           oRegion.style.backgroundColor="white" ;
           oDivList.style.display = "block";
           if (bNoAdjusted) //控制div是否已经显示的变量 
           { 
               bNoAdjusted = false; 
               //设置下拉列表的宽度和位置 
               oDivList.style.width = this.offsetWidth - 4; 
               oDivList.style.posTop = oRegion.offsetTop + oRegion.offsetHeight + 1;          // 设定高度
               oDivList.style.posLeft = oRegion.offsetLeft +1 ;               // 设定与左边的位置;
           } 
       }; 
       //县的文本获得焦点的事件
       customerxianObj.focus(function(){
    	   $("#xianList").css("display","block");
       });
</script>
</body>
</html>
