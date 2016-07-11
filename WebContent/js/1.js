//窄屏宽度
var screen_width = $(window).width;
var br_width;
var t = 0; 
$(function(){
    $(window).resize(function(){
        var  now = new Date().getTime();  
        if(br_width != $(window).width() && now - t > 200) {
            t = now;  
            br_width = $(window).width();
            check_browser('1');
        }
    });
    $(".js_toggle").Jdropdown({
            delay: 100
        }, function(e) {

    })
    $('#js_search_type li').click(
        function() {
            var $_t = $(this);
            $("#js_search_type").css('overflow', 'visible');
            $_t.siblings("li").show();
        }, 
        function() {
            var $_t = $(this);
            $("#js_search_type").css('overflow', 'hidden');
        }
    )
    hover_mask();
    
});
function changTab(n){
  var len = $("#myTab"+n+" li").length;
  var idx = 0;
  var tabTimer;
  $("#myTab"+n+" li").click(function(){
    idx = $("#myTab"+n+" li").index(this);
    showTab(n,idx);
  }).eq(0).click();

  $('#myTab'+n+'_Content').click(function(){
    clearInterval(tabTimer);
  },function(){
    tabTimer = setInterval(function(){
      showTab(n,idx);
      idx++;
      if(idx==len) idx=0;
    },3000)
  }).trigger('click');
}
//延时切换
(function(a) {
    a.fn.Jdropdown = function(d, e) {
        if (!this.length) {
            return
        }
        if (typeof d == "function") {
            e = d;
            d = {}
        }
        var c = a.extend({
            event: "click",
            current: "hover",
            delay: 0,
            fun: "default"
        }, d || {});
        var b = (c.event == "mouseover") ? "mouseout" : "mouseleave";
        a.each(this, function() {
            var h = null,
                g = null,
                f = false;
            a(this).bind(c.event, function() {
                if (f) {
                    clearTimeout(g)
                } else {
                    var j = a(this);
                    h = setTimeout(function() {
                        if( c.fun == "default" )
                        {
                            var menu_item_wrap =j.find('.menu-item-wrap');
                            var _flag_temp = 0;
                            if(menu_item_wrap.length!=0){
                               var o_menu_in = $(menu_item_wrap.text());
                                j.append(o_menu_in); 
                                menu_item_wrap.remove();
                                _flag_temp =1;
                            }
                            j.addClass(c.current).children(".menu-in").show();
                            j.find('.shadow-bg').show();
                            var _c = j.children(".menu-in");
                            var _c_height = _c.height();
                            var _t_height = j.height();
                            j.find('.shadow-l').css('height',_c_height);
                            j.find('.shadow-r').css('height',_c_height);
                            var _c_to_top = j.offset().top-$(window).scrollTop()+_c_height;
                            var _j_to_top = j.offset().top-$(window).scrollTop()+_t_height;
                            var _c_to_bottom =$(window).height()-_c_to_top;
                             var tg_top = _c_to_bottom-30;
                            if (_c_to_bottom < 30&&tg_top!=(-1)&&tg_top!=1) {
                               
                                if(($(window).height()-30)<_j_to_top){
                                    var border_height = ($.browser.msie && $.browser.version =='7.0')? (-2):2;
                                    _c.css('top','-'+(_c_height-_t_height+border_height)+'px')
                                }else{
                                         _c.css('top',tg_top+'px');
                                }
                                
                            }else{
                                _c.css('top','-2px');
                            }
                            if((_flag_temp==1)&&$.browser.msie && $.browser.version <7.0){
                                j.addClass(c.current).children(".menu-in").hide().show();
                            }
                        }
                        f = true;
                        if (e) {
                            e(j)
                        }
                    }, c.delay)
                }
            }).bind(b, function() {
                if (f) {
                    var j = a(this);
                    g = setTimeout(function() {
                        if( c.fun == "default" )
                        {
                            j.removeClass(c.current).children(".menu-in").hide();
                            j.find('.shadow-bg').hide();
                        }    
                        if( c.fun == 'hover_mask')
                        {
                            j.parents("li").find('.mask').removeClass("op3");
                        }
                        f = false
                    }, c.delay)
                } else {
                    clearTimeout(h)
                }
            })
        })
    }
})(jQuery);






