package com.server.action;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.GoodsviewPoco;
import com.server.poco.OrderdPoco;
import com.server.pojo.Givegoodsview;
import com.server.pojo.GoodsVo;
import com.server.pojo.Goodsview;
import com.server.pojo.HotOrderdSumVO;
import com.server.pojo.Orderd;
import com.server.pojo.SdishesVO;
import com.server.pojo.Timegoods;
import com.server.pojo.Timegoodsview;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseActionDao;
import com.system.tools.pojo.Fileinfo;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.DateUtils;
import com.system.tools.util.FileUtil;

/**
 * 订单详细 逻辑层
 *@author ZhangRuiLong
 */
public class OrderdAction extends BaseActionDao {
	public String result = CommonConst.FAILURE;
	public ArrayList<Orderd> cuss = null;
	public java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<ArrayList<Orderd>>() {}.getType();

	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = OrderdPoco.QUERYFIELDNAME;
    	for(int i=0;i<queryfieldname.length;i++){
    		querysql += queryfieldname[i] + " like '%" + query + "%' or ";
    	}
		return querysql.substring(0, querysql.length() - 4);
	};
	//将json转换成cuss
	public void json2cuss(HttpServletRequest request){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
	}
	//新增
	public void insAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Orderd temp:cuss){
			temp.setOrderdid(CommonUtil.getNewId());
			result = insSingle(temp);
		}
		responsePW(response, result);
	}
	//删除
	public void delAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Orderd temp:cuss){
			result = delSingle(temp,OrderdPoco.KEYCOLUMN);
		}
		responsePW(response, result);
	}
	//修改
	public void updAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		result = updSingle(cuss.get(0),OrderdPoco.KEYCOLUMN);
		responsePW(response, result);
	}
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Orderd.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrderdPoco.ORDER);
		cuss = (ArrayList<Orderd>) selAll(queryinfo);
		FileUtil.expExcel(response,cuss,OrderdPoco.CHINESENAME,OrderdPoco.KEYCOLUMN,OrderdPoco.NAME);
	}
	//导入
	public void impAll(HttpServletRequest request, HttpServletResponse response){
		Fileinfo fileinfo = FileUtil.upload(request,0,null,OrderdPoco.NAME,"impAll");
		String json = FileUtil.impExcel(fileinfo.getPath(),OrderdPoco.FIELDNAME); 
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(Orderd temp:cuss){
			temp.setOrderdid(CommonUtil.getNewId());
			result = insSingle(temp);
		}
		responsePW(response, result);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Orderd.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrderdPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Orderd.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrderdPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//查询客户今天购买的秒杀商品数量
	@SuppressWarnings("unchecked")
	public void selCusXGOrderd(HttpServletRequest request, HttpServletResponse response){
		Pageinfo pageinfo = new Pageinfo(0,selAll(Orderd.class, "select od.orderdcode,od.orderdtype,od.orderdunits,sum(od.orderdnum) as orderdclass from orderm om "+
				"left join orderd od on od.orderdorderm = om.ordermid where om.ordermcustomer = '"+request.getParameter("customerid")+
				"' and (od.orderdtype = '买赠' or od.orderdtype = '秒杀' ) and om.ordermtime >= '"+DateUtils.getDate()+
				" 00:00:00' and om.ordermtime <= '"+DateUtils.getDate()+" 23:59:59'  group by od.orderdcode,od.orderdtype,od.orderdunits"));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//重新购买
	@SuppressWarnings("unchecked")
	public void queryREgoumaiGoods(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		ArrayList<GoodsVo> gvoList = new ArrayList<GoodsVo>();
		for (Orderd item : cuss) {
			GoodsVo gvo = new GoodsVo();
			if(item.getOrderdtype().equals("商品")){
				List<Goodsview> tgviewList = selAll(Goodsview.class,"select * from goodsview gv where gv.goodscode = '"+item.getOrderdcode()+
							   "' and gv.goodsunits = '"+item.getOrderdunits()+
							   "' and gv.pricesclass = '"+request.getParameter("customertype")+
							   "' and gv.priceslevel = "+request.getParameter("customerlevel")+
							   " and gv.goodsstatue = '上架'");
				if(tgviewList.size() > 0){
					gvo.setType(item.getOrderdtype());
					gvo.setGoodsview(tgviewList.get(0));
					gvo.setNowGoodsNum(item.getOrderdnum());
				} else {
					Goodsview xjg = new Goodsview();
					xjg.setGoodsname(item.getOrderdname());
					xjg.setGoodsunits(item.getOrderdunits());
					gvo.setType(item.getOrderdtype());
					gvo.setGoodsview(xjg);
					gvo.setStatue("下架");
				}
				gvoList.add(gvo);
			} else if(item.getOrderdtype().equals("秒杀")){
				List<Timegoodsview> tgviewList = selAll(Timegoodsview.class,"select * from timegoodsview tv where tv.timegoodscode = '"+
								item.getOrderdcode()+"' and tv.timegoodsunits = '"+item.getOrderdunits()+
								"' and tv.timegoodsstatue = '启用'");
				if(tgviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setTgview(tgviewList.get(0));
					gvo.setNowGoodsNum(item.getOrderdnum());
				} else {
					Timegoodsview xjg = new Timegoodsview();
					xjg.setTimegoodsname(item.getOrderdname());
					xjg.setTimegoodsunits(item.getOrderdunits());
					gvo.setType(item.getOrderdtype());
					gvo.setTgview(xjg);
					gvo.setStatue("下架");
				}
				gvoList.add(gvo);
			} else if(item.getOrderdtype().equals("买赠")){
				List<Givegoodsview> ggviewList = selAll(Givegoodsview.class,"select * from givegoodsview gv where gv.givegoodscode = '"+
								item.getOrderdcode()+"' and gv.givegoodsunits = '"+item.getOrderdunits()+
								"' and gv.givegoodsstatue = '启用'");
				if(ggviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setGgview(ggviewList.get(0));
					gvo.setNowGoodsNum(item.getOrderdnum());
				} else {
					Givegoodsview xjg = new Givegoodsview();
					xjg.setGivegoodsname(item.getOrderdname());
					xjg.setGivegoodsunits(item.getOrderdunits());
					gvo.setType(item.getOrderdtype());
					gvo.setGgview(xjg);
					gvo.setStatue("下架");
				}
				gvoList.add(gvo);
			}
		}
		Pageinfo pageinfo = new Pageinfo(gvoList);
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//热销商品
	@SuppressWarnings("unchecked")
	public void hotgoodssel(HttpServletRequest request, HttpServletResponse response){
		String staTime = request.getParameter("staTime");
		String endTime = request.getParameter("endTime");
		String customerxian = request.getParameter("customerxian");
		String sql = "select * from (select A.*, ROWNUM RN from ( "+
			"select sum(od.orderdnum) odgoodsnum,od.orderdcode,od.orderdtype,od.orderdunits "+
			"from orderd od left join orderm om on om.ordermid = od.orderdorderm  "+
			"left join company cp on om.ordermcompany = cp.companyid left join city ct on ct.cityid = cp.companycity "+
			"where om.ordermtime >= '"+staTime+"' and om.ordermtime <= '"+endTime+"' and ct.cityname = '"+customerxian+
			"' group by od.orderdcode,od.orderdtype,od.orderdunits order by odgoodsnum desc "+
			") A where ROWNUM  <= (1*10) ) where RN > ((1-1)*10)";
		List<HotOrderdSumVO> hos = (ArrayList<HotOrderdSumVO>) selAll(HotOrderdSumVO.class, sql);
		ArrayList<GoodsVo> gvoList = new ArrayList<GoodsVo>();
		for (HotOrderdSumVO item : hos) {
			GoodsVo gvo = new GoodsVo();
			if(item.getOrderdtype().equals("商品")){
				List<Goodsview> tgviewList = selAll(Goodsview.class,"select * from goodsview gv where gv.goodscode = '"+item.getOrderdcode()+
							   "' and gv.goodsunits = '"+item.getOrderdunits()+
							   "' and gv.pricesclass = '"+request.getParameter("customertype")+
							   "' and gv.priceslevel = "+request.getParameter("customerlevel")+
							   " and gv.goodsstatue = '上架'");
				if(tgviewList.size() > 0){
					gvo.setType(item.getOrderdtype());
					gvo.setGoodsview(tgviewList.get(0));
					gvoList.add(gvo);
				}
			} else if(item.getOrderdtype().equals("秒杀")){
				List<Timegoodsview> tgviewList = selAll(Timegoodsview.class,"select * from timegoodsview tv where tv.timegoodscode = '"+
								item.getOrderdcode()+"' and tv.timegoodsunits = '"+item.getOrderdunits()+
								"' and tv.timegoodsstatue = '启用'");
				if(tgviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setTgview(tgviewList.get(0));
					gvoList.add(gvo);
				}
			} else if(item.getOrderdtype().equals("买赠")){
				List<Givegoodsview> ggviewList = selAll(Givegoodsview.class,"select * from givegoodsview gv where gv.givegoodscode = '"+
								item.getOrderdcode()+"' and gv.givegoodsunits = '"+item.getOrderdunits()+
								"' and gv.givegoodsstatue = '启用'");
				if(ggviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setGgview(ggviewList.get(0));
					gvoList.add(gvo);
				}
			}
		}
		Pageinfo pageinfo = new Pageinfo(gvoList);
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//整理前端传来的购物车数据
	public void sortingSdiData(HttpServletRequest request, HttpServletResponse response){
		String json = request.getParameter("json");
		String customerid = request.getParameter("customerid");
		String customertype = request.getParameter("customertype");
		String customerlevel = request.getParameter("customerlevel");
		
		System.out.println("json : " + json);
		List<SdishesVO> svoList = null;
		if(CommonUtil.isNotEmpty(json)) svoList = CommonConst.GSON.fromJson(json, new com.google.gson.reflect.TypeToken<ArrayList<Orderd>>() {}.getType());
		Pageinfo pageinfo = new Pageinfo(svoList);
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//验证商品是否已经下架
	/*@SuppressWarnings("unchecked")
	public void checkGoodsXJ(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		ArrayList<GoodsVo> gvoList = new ArrayList<GoodsVo>();
		GoodsVo gvo = new GoodsVo();
		for (Orderd item : cuss) {
			
			if(item.getOrderdtype().equals("商品")){
				gvoList.add(checkOdGoods(request,item.getOrderdcode(),item.getOrderdunits(),item.getOrderdnum(),item.getOrderdname()));
			} else if(item.getOrderdtype().equals("秒杀")){
				List<Timegoodsview> tgviewList = selAll(Timegoodsview.class,"select * from timegoodsview tv where tv.timegoodscode = '"+
								item.getOrderdcode()+"' and tv.timegoodsunits = '"+item.getOrderdunits()+
								"' and tv.timegoodsstatue = '启用'");
				if(tgviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setTgview(tgviewList.get(0));
					gvo.setNowGoodsNum(item.getOrderdnum());
				} else {
					Timegoodsview xjg = new Timegoodsview();
					xjg.setTimegoodsname(item.getOrderdname());
					xjg.setTimegoodsunits(item.getOrderdunits());
					gvo.setType(item.getOrderdtype());
					gvo.setTgview(xjg);
					gvo.setStatue("下架");
				}
				gvoList.add(gvo);
			} else if(item.getOrderdtype().equals("买赠")){
				List<Givegoodsview> ggviewList = selAll(Givegoodsview.class,"select * from givegoodsview gv where gv.givegoodscode = '"+
								item.getOrderdcode()+"' and gv.givegoodsunits = '"+item.getOrderdunits()+
								"' and gv.givegoodsstatue = '启用'");
				if(ggviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setGgview(ggviewList.get(0));
					gvo.setNowGoodsNum(item.getOrderdnum());
				} else {
					Givegoodsview xjg = new Givegoodsview();
					xjg.setGivegoodsname(item.getOrderdname());
					xjg.setGivegoodsunits(item.getOrderdunits());
					gvo.setType(item.getOrderdtype());
					gvo.setGgview(xjg);
					gvo.setStatue("下架");
				}
				gvoList.add(gvo);
			}
		}
		Pageinfo pageinfo = new Pageinfo(gvoList);
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//验证普通商品是否下架,价格是否变化,客户等级是否变化
	@SuppressWarnings("unchecked")
	public GoodsVo checkOdGoods(HttpServletRequest request,String goodscode,String goodsunits,Integer goodsnum,String goodsname){
		GoodsVo gvo = new GoodsVo();
		List<Goodsview> tgviewList = selAll(Goodsview.class,"select * from goodsview gv where gv.goodscode = '"+goodscode+
				   "' and gv.goodsunits = '"+goodsunits+
				   "' and gv.pricesclass = '"+request.getParameter("customertype")+
				   "' and gv.priceslevel = "+request.getParameter("customerlevel")+
				   " and gv.goodsstatue = '上架'");
		if(tgviewList.size() > 0){
			gvo.setGoodsview(tgviewList.get(0));
			gvo.setNowGoodsNum(goodsnum);
		} else {
			Goodsview xjg = new Goodsview();
			xjg.setGoodsname(goodsname);
			xjg.setGoodsunits(goodsunits);
			gvo.setGoodsview(xjg);
			gvo.setStatue("下架");
		}
		gvo.setType("商品");
		return gvo;
	}*/
	
}










