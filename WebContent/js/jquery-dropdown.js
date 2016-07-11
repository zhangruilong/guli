$(function(){
	$(".home-search-wrapper span.citydrop").on("click",function(){
        var val = $(this).attr('class');
        if(val.indexOf('on') == -1){
            $(this).addClass('on');
			$(".more").fadeIn(200);
			$(".home-hot-wrap,.goods-wrapper").fadeOut();
            $(".menu").show().stop().animate({
                height:'92%'
            },0);
        }else{
            $(this).removeClass('on');
			$(".more").hide();
			$(".home-hot-wrap,.goods-wrapper").fadeIn(400);
            $(".menu").hide(200).stop().animate({
                height:'0'
            },0);
        }
    })
});