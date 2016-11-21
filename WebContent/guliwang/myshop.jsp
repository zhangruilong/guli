<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<!-- <link href="../ExtJS/resources/css/ext-all.css" type="text/css" rel="stylesheet"> -->
<style type="text/css">
#result{ width:auto; position: absolute; right:0; top:0}
#result img{ width:30px; height:30px; border-radius:50px}
input:focus{ outline:none}
.close{ position:absolute; display:none}
.reg-wrapper li i:after{ height:34px; line-height:34px;content: "\f3d3"; font-size:1.2em;float:right; margin-right:2%; color:#aaa}
.reg-wrapper li textarea{width:64%;float:right;  border:none; margin-right:6%; font-size:1.1em; padding-bottom:2%;  font-weight:normal}

#uploadImg{ width:69%; height:34px; float:left; position:relative; font-size:12px; overflow:hidden}
#uploadImg a{ display:block; text-align:right;  height:34px; line-height:34px; font-size:1.4em; color:#aaa}
/* #file_input{ width:auto; position:absolute; z-index:100; margin-left:-180px; font-size:60px;opacity:0;filter:alpha(opacity=0); margin-top:-5px;} */
</style>
</head>

<body>
<div class="reg-wrapper">
	<ul>
    	<li><span>店铺名称</span> <input name="customershop" type="text" value="" placeholder="请输入店铺名称"></li>
        <li><span>联系人</span> <input name="customername" type="text" value="" placeholder="请输入联系人"></li>
        <li><span>手机号码</span> <input name="customerphone" type="text" value="" placeholder="请输入联系电话"></li>
        <!-- <li><span>所在城市</span> <select name="customercity" id="city">
			</select><i></i></li>
        <li><span>所在区域</span> <select name="customerxian" id="xian">
			</select><i></i></li> -->
        <li><span>店铺地址</span> <input name="customeraddress" type="text" value=""
         placeholder="请输入店铺地址"></li>
    </ul>
</div>

<div class="confirm-reg">
	<a onclick="doedit()" class="confirm-reg-btn">保存修改</a>
</div>
<!--弹框-->
<div class="cd-popup" role="alert">
	<div class="cd-popup-container">
		<div class="cd-buttons">
        	<h1>谷粒网提示</h1>
			<p class="meg"></p>
            <a class="cd-popup-close">确定</a>
		</div>
	</div>
</div>
<script type="text/javascript" src="../js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
var customer = JSON.parse(window.localStorage.getItem("customer"));
$(function(){
	$.ajax({
		url:"GLCustomerAction.do?method=selAll",
		type:"post",
		data:{
			wheresql:"customerid='"+customer.customerid+"'"
		},
		success:function(resp){
			var data = JSON.parse(resp);
			$("input[name='customershop']").val(data.root[0].customershop);
			$("input[name='customername']").val(data.root[0].customername);
			$("input[name='customerphone']").val(data.root[0].customerphone);
			/* $.ajax({
				url:"CityAction.do?method=selAll",
				type:"post",
				data:{
					wheresql:"cityparent='root'"
				},
				success:function(resp){
					var data2 = JSON.parse(resp).root;
					$("#city option").remove();
					$.each(data2,function(i,item){
						if(item.cityname == data.root[0].customercity){
							$("#city").append('<option value="'+item.cityid+'" selected="selected">'+item.cityname+'</option>');
						} else {
							$("#city").append('<option value="'+item.cityid+'" >'+item.cityname+'</option>');
						}
					});
					cityChaEve();
					initxian();
				},
				error: function(resp){
					var respText = eval('('+resp+')'); 
					alert(respText.msg);
				}
			}); */
			$("input[name='customeraddress']").val(data.root[0].customeraddress);
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
	
	/* $("#xian").change(function(){
		var xian = $("#xian").val();
		$("#xian").val("");
		$("#customerxian").val(xian);
	}); */
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		$(this).removeClass("is-visible");	//移除'is-visible' class
	});
})
//初始化县
/* function initxian(){
	$.ajax({
		   url:"CityAction.do?method=selAll",
		   type:"post",
		   data:{
			   wheresql:"cityparent='"+$("#city").val()+"'"
		   },
		   success:function(resp){
			   var data = JSON.parse(resp).root;
			   $("#xian option").remove();
			   $.each(data,function(i,item){
				   $("#xian").append('<option>'+item.cityname+'</option>');
			   });
		   },
		   error: function(resp){
				var respText = eval('('+resp+')'); 
				alert(respText.msg);
		   }
	   });
} */
//绑定更换城市时的事件
/* function cityChaEve(){
	$("#city").change(function(){
		 $.ajax({
 			   url:"CityAction.do?method=selAll",
 			   type:"post",
 			   data:{
 				   wheresql:"cityparent='"+$(this).val()+"'"
 			   },
 			   success:function(resp){
 				   var data = JSON.parse(resp).root;
				   $("#xian option").remove();
 				   $.each(data,function(i,item){
 					   $("#xian").append('<option>'+item.cityname+'</option>');
 				   });
 			   },
 			   error: function(resp){
 					var respText = eval('('+resp+')'); 
 					alert(respText.msg);
 			   }
 		   });
	});
} */
function doedit(){
	var count = 0;
	var alt;
	var strjson = '[{"customerid":"'+customer.customerid+'",';
	$("input,select").each(function(i,item){
		if($(item).attr("id") != "city"){
			strjson += '"'+$(item).attr("name")+'":"'+$(item).val()+'",';
		} else {
			strjson += '"'+$(item).attr("name")+'":"'+$(item).children("option:selected").text()+'",';
		}
		if($(item).val() == null || $(item).val() == ''){
			//if($(item).attr("id") != "file_input"){
				count++;
				alt=$(item).attr("placeholder");
				return false;
			//}
		}
	});
	strjson = strjson.substr(0, strjson.length - 1);
	strjson += "}]";
	var reg = /^[1][0-9]{10}$/;
	//var reg = new RegExp('[0-9]{11}','g');
	if(!reg.test($("[name='customerphone']").val())){
		$(".meg").text('请填写正确的手机号码。');						//修改弹窗信息
		$(".cd-popup").addClass("is-visible");							//弹出窗口
		return;
	}
	if(count > 0){
		$(".meg").text(alt);															//修改弹窗信息
		$(".cd-popup").addClass("is-visible");							//弹出窗口
		return;
	}
	$.ajax({
		url:"GLCustomerAction.do?method=updAll",
		type:"post",
		data:{
			json:strjson
		},
		success:function(resp){
			var data = eval('('+resp+')');
			alert(data.msg);
			history.go(-1);
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
}
</script>
</body>
</html>