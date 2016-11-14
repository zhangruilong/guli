//获取url中的参数
function getQueryString(name){
var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
var urlparastr = decodeURI(window.location.search);			//防止中文乱码
//alert(urlparastr);
var r = urlparastr.substr(1).match(reg);  //匹配目标参数
if (r!=null) return decodeURI(r[2]); return null; //返回参数值
} 
//转换为空的字符串
function changeStr(obj){
	if(typeof(obj) == "undefined" || !obj || obj=='undefined' || obj=='null'){
		return '';
	} else {
		return obj;
	}
}



