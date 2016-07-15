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
#file_input{ width:auto; position:absolute; z-index:100; margin-left:-180px; font-size:60px;opacity:0;filter:alpha(opacity=0); margin-top:-5px;}
</style>
</head>

<body>
<div class="reg-wrapper">
	<ul>
    	<li><span>店铺名称</span> <input name="customershop" type="text" value="" placeholder="请输入店铺名称"></li>
        <li><span>联系人</span> <input name="customername" type="text" value="" placeholder="请输入联系人"></li>
        <li><span>联系电话</span> <input name="customerphone" type="text" value="" placeholder="请输入联系电话"></li>
        <li><span>所在城市</span> 
			<span style="position:absolute;overflow:hidden;margin-left: 170px;"> 
			<select id="city" style="width:160%;">
				<option></option>
					<option>嘉兴市</option>
			</select>
			</span><i></i> 
			<span style="position:absolute;display:block;">
				<input id="customercity" name="customercity" type="text" value="" 
				placeholder="请输入城市" style="width:118px;margin-left: 228%;">
			</span>
			</li>
			<li><span>所在地区</span> 
			<span style="position:absolute;overflow:hidden;margin-left: 170px;"> 
			<select id="xian" style="width:160%;">
				<option>海盐县</option>
				<option>嘉善县</option>
				<option>秀洲区</option>
				<option>南湖区</option>
			</select>
			</span><i></i> 
			<span style="position:absolute;display: block;">
				<input id="customerxian" name="customerxian" type="text" value="" 
				placeholder="请输入地区" style="width:118px;margin-left: 228%;">
			</span>
			</li>
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
		url:"CustomerAction.do?method=selAll",
		type:"post",
		data:{
			wheresql:"customerid='"+customer.customerid+"'"
		},
		success:function(resp){
			var data = JSON.parse(resp);
			$("input[name='customershop']").val(data.root[0].customershop);
			$("input[name='customername']").val(data.root[0].customername);
			$("input[name='customerphone']").val(data.root[0].customerphone);
			$("#customercity").val(data.root[0].customercity);
			$("#customerxian").val(data.root[0].customerxian);
			$("input[name='customeraddress']").val(data.root[0].customeraddress);
		},
		error : function(resp2){
			var respText2 = eval('('+resp2+')');
			alert(respText2.msg);
		}
	});
	$("#city").change(function(){
		var city = $("#city").val();		//得到城市复选框的值
		$("#city").val("");					//将城市复选框清空
		$("#customercity").val(city);		//将城市输入框的值变为城市复选框的值
		/* Ext.Ajax.request({
			//通过ajax查询到地区复选框的值
			url:"querycity.action",
			method:"POST",
			params:{
				"cityname":city
			},
			success:function(response,option){
				var result = response.responseText;			//得到返回的文本信息
				var $result = Ext.util.JSON.decode(result);	//转化为json对象
				$("#xian").empty();							//清空
				var $option = $("<option></option>");		//添加第一个option
				$("#xian").append($option);
				for (var i=0; i<$result.length;i++ ){
					var city = $result[i];
					$option = $("<option>"+city.cityname+"</option>");
					$("#xian").append($option);
				}
			},
			failure:function(response,option){
				Ext.Msg.alert("提示","网络出现问题,请稍后再试");
			}
		}); */
	}); 
	$("#xian").change(function(){
		var xian = $("#xian").val();
		$("#xian").val("");
		$("#customerxian").val(xian);
	});
	$(".cd-popup").on("click",function(event){		//绑定点击事件
		$(this).removeClass("is-visible");	//移除'is-visible' class
	});
})
function doedit(){
	var count = 0;
	var alt;
	var strjson = '[{"customerid":"'+customer.customerid+'",';
	$("input").each(function(i,item){
		strjson += '"'+$(item).attr("name")+'":"'+$(item).val()+'",';
		if($(item).val() == null || $(item).val() == ''){
			if($(item).attr("id") != "file_input"){
				count++;
				alt=$(item).attr("placeholder");
				return false;
			}
		}
	});
	strjson = strjson.substr(0, strjson.length - 1);
	strjson += "}]";
	if(count > 0){
		$(".meg").text(alt);		//修改弹窗信息
		$(".cd-popup").addClass("is-visible");	//弹出窗口
		return;
	}
	$.ajax({
		url:"CustomerAction.do?method=updAll",
		type:"post",
		data:{
			json:strjson
		},
		success:function(resp){
			var data = eval('('+resp+')');
			alert(data.msg);
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