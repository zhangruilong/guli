/**
 * Created by an.han on 13-12-17.
 */
window.onload = function () {

    var table = document.getElementById('cartTable'); // 购物车表格
    var selectInputs = document.getElementsByClassName('check'); // 所有勾选框
    var checkAllInputs = document.getElementsByClassName('check-all') // 全选框
    var tr = table.children[0].rows; //行
    var selectedTotal = document.getElementById('selectedTotal'); //已选商品数目容器
    var priceTotal = document.getElementById('priceTotal'); //总计*/
    var deleteAll = document.getElementById('deleteAll'); // 删除全部按钮
    var selectedViewList = document.getElementById('selectedViewList'); //浮层已选商品列表容器
    var selected = document.getElementById('selected'); //已选商品
	
	/*var zongjia=document.getElementById("zongjia").innerHTML;
	priceTotal.innerHTML = zongjia ;*/
// 更新总数和总价格，已选浮层
function jisuan(){
var sum   = 0;
var ptotal= document.getElementById('priceTotal');
var table = document.getElementById("cartTable");
for(var i=0;i<table.rows.length;i++){
sum += parseFloat(table.rows[i].cells[3].innerText);
}
ptotal.innerHTML=sum.toFixed(2)
selectedTotal.innerHTML = document.getElementsByTagName("tr").length;
}
jisuan();
    function getTotal() {
		
		var seleted = 0;
		var price = 0;
		var HTMLstr = '';
		
		for (var i = 0, len = tr.length; i < len; i++) {
			if (tr[i].getElementsByTagName('input').value="1") {
				tr[i].className = 'on';
				seleted += parseInt(tr[i].getElementsByTagName('input')[0].value);
				price += parseFloat(tr[i].cells[3].innerHTML);
			}
			else {
				tr[i].className = '';
			}
		}
	
		selectedTotal.innerHTML = seleted;
		priceTotal.innerHTML = price.toFixed(2);
	}

    // 计算单行价格
    function getSubtotal(tr) {
        var cells = tr.cells;
        var price = cells[2]; //单价
        var subtotal = cells[3]; //小计td
        var countInput = tr.getElementsByTagName('input')[0]; //数目input
        var span = tr.getElementsByTagName('span')[1]; //-号
        //写入HTML
        subtotal.innerHTML = (parseInt(countInput.value) * parseFloat(price.innerHTML)).toFixed(2);
    }
    //为每行元素添加事件
    for (var i = 0; i < tr.length; i++) {
        //将点击事件绑定到tr元素
        tr[i].onclick = function (e) {
            var e = e || window.event;
            var el = e.target || e.srcElement; //通过事件对象的target属性获取触发元素
            var cls = el.className; //触发元素的class
            var countInout = this.getElementsByTagName('input')[0]; // 数目input
            var value = parseInt(countInout.value); //数目
            //通过判断触发元素的class确定用户点击了哪个元素
            switch (cls) {
                case 'add': //点击了加号
                    countInout.value = value + 1;
                    getSubtotal(this);
                    break;
                case 'reduce': //点击了减号
                    if (value > 1) {
                        countInout.value = value - 1;
                        getSubtotal(this);
                    }
                    break;
                case 'delete': //点击了删除
                    var conf = confirm('确定删除此商品吗？');
                    if (conf) {
                        this.parentNode.removeChild(this);
                    }
                    break;
            }
            getTotal();
        }
        // 给数目输入框绑定keyup事件
        tr[i].getElementsByTagName('input')[0].onkeyup = function () {
            var val = parseInt(this.value);
            if (isNaN(val) || val <= 0) {
                val = 1;
            }
            if (this.value != val) {
                this.value = val;
            }
            getSubtotal(this.parentNode.parentNode); //更新小计
            getTotal(); //更新总数
        }
    }

    	

   
}
