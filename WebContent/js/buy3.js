//设置供应商信息
function setscompany(){
	var data = JSON.parse(window.localStorage.getItem("sdishes"));
	var scompany = new Array();
	$.each(data, function(i, item) {
		if(scompany.length==0){
			var mcompany = new Object();
			mcompany.ordermcompany = item.goodscompany;
			mcompany.companyshop = item.companyshop;
			mcompany.companydetail = item.companydetail;
			mcompany.ordermnum = 1;
			mcompany.ordermmoney = (item.pricesprice * item.orderdetnum).toFixed(2);
			scompany.push(mcompany);
		}else{
			$.each(scompany, function(y, item2) {
				if(item2.ordermcompany == item.goodscompany){
					item2.ordermnum += 1;
					item2.ordermmoney = (parseFloat(item2.ordermmoney) + item.pricesprice * item.orderdetnum).toFixed(2);
					return false;
				}else if(y==scompany.length-1){
					var mcompany = new Object();
					mcompany.ordermcompany = item.goodscompany;
					mcompany.companyshop = item.companyshop;
					mcompany.companydetail = item.companydetail;
					mcompany.ordermnum = 1;
					mcompany.ordermmoney = (item.pricesprice * item.orderdetnum).toFixed(2);
					scompany.push(mcompany);
				}
			});
		}
	});
	window.localStorage.setItem("scompany",JSON.stringify(scompany));
	return scompany;
}