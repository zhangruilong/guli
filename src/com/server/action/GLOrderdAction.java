package com.server.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.OrderdPoco;
import com.server.pojo.Bkgoods;
import com.server.pojo.Bkgoodsview;
import com.server.pojo.Customer;
import com.server.pojo.Givegoodsview;
import com.server.pojo.GoodsVo;
import com.server.pojo.Goodsview;
import com.server.pojo.HotOrderdSumVO;
import com.server.pojo.Orderd;
import com.server.pojo.SdishesVO;
import com.server.pojo.Timegoodsview;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.DateUtils;
import com.system.tools.util.TypeUtil;

/**
 * 订单详细 逻辑层
 *@author ZhangRuiLong
 */
public class GLOrderdAction extends OrderdAction {

	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		Queryinfo queryinfo = getQueryinfo(request, Orderd.class, OrderdPoco.QUERYFIELDNAME, OrderdPoco.ORDER, TYPE);
		queryinfo.setDsname(dsName);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	
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
		if(!CommonUtil.isNull(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
	}
	//查询客户今天购买的秒杀商品数量
	public void selCusXGOrderd(HttpServletRequest request, HttpServletResponse response){
		String dsName = null;
		String companyid = request.getParameter("companyid");
		if(companyid.equals("1")){
			dsName = "mysql";
		}
		String customerid = request.getParameter("customerid");
		Pageinfo pageinfo = new Pageinfo(0,selAll(Orderd.class, "select od.orderdcode,od.orderdtype,od.orderdunits,sum(od.orderdnum) as orderdclass from orderm om "+
				"left join orderd od on od.orderdorderm = om.ordermid where om.ordermcustomer = '"+customerid+
				"' and (od.orderdtype = '买赠' or od.orderdtype = '秒杀' or od.orderdtype = '组合商品' ) and om.ordermtime >= '"+DateUtils.getDate()+
				" 00:00:00' and om.ordermtime <= '"+DateUtils.getDate()+" 23:59:59' group by od.orderdcode,od.orderdtype,od.orderdunits",dsName));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//重新购买
	@SuppressWarnings("unchecked")
	public void queryREgoumaiGoods(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		String msg = "";
		String customertype = request.getParameter("customertype");
		String customerlevel = request.getParameter("customerlevel");
		String comid = request.getParameter("comid");
		ArrayList<GoodsVo> gvoList = new ArrayList<GoodsVo>();
		String dsName = null;
		if(comid.equals("1")){
			dsName = "mysql";
		}
		for (Orderd item : cuss) {
			GoodsVo gvo = new GoodsVo();
			if(item.getOrderdtype().equals("商品")){
				
				List<Goodsview> gList = selAll(Goodsview.class,"select * from goodsview gv where gv.goodsid = '"+item.getOrderdgoods()+
							   "' and gv.pricesclass = '"+customertype+
							   "' and gv.priceslevel = "+customerlevel+
							   " and gv.goodsstatue = '上架'", dsName);
				if(gList.size() > 0){
					gvo.setType(item.getOrderdtype());
					gvo.setGoodsview(gList.get(0));
					gvo.setNowGoodsNum(item.getOrderdnum());
				} else {
					msg += item.getOrderdname()+"("+item.getOrderdunits()+")";
				}
				gvoList.add(gvo);
			} else if(item.getOrderdtype().equals("年货") || item.getOrderdtype().equals("组合商品") || 
					item.getOrderdtype().equals("秒杀") || item.getOrderdtype().equals("买赠")){
				List<Bkgoodsview> bgviewList = selAll(Bkgoodsview.class,"select * from bkgoodsview bv where bv.bkgoodsid = '"+
						item.getOrderdgoods()+"' and bv.bkgoodsstatue = '启用'", dsName);
				if(bgviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setBgview(bgviewList.get(0));
					gvo.setNowGoodsNum(item.getOrderdnum());
				} else {
					msg += item.getOrderdname()+"("+item.getOrderdunits()+")";
				}
				gvoList.add(gvo);
			}
		}
		if(!msg.equals("")){
			msg = "您购买的:" + msg +"已下架,是否加入购物车?";
		}
		Pageinfo pageinfo = new Pageinfo(gvoList);
		pageinfo.setMsg(msg);
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//热销商品
	@SuppressWarnings("unchecked")
	public void hotgoodssel(HttpServletRequest request, HttpServletResponse response){
		String staTime = request.getParameter("staTime");
		String endTime = request.getParameter("endTime");
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		String sql = null;
		if(null == dsName){
			sql = "select * from (select A.*, ROWNUM RN from ( "+
					"select sum(od.orderdnum) odgoodsnum,od.orderdcode,od.orderdtype,od.orderdunits "+
					"from orderd od left join orderm om on om.ordermid = od.orderdorderm  "+
					"left join company cp on om.ordermcompany = cp.companyid left join city ct on ct.cityid = cp.companycity "+
					"where om.ordermtime >= '"+staTime+"' and om.ordermtime <= '"+endTime+"' and ct.cityname = '"+customerxian+
					"' group by od.orderdcode,od.orderdtype,od.orderdunits order by odgoodsnum desc "+
					") A where ROWNUM  <= (1*10) ) where RN > ((1-1)*10)";
		} else {
			sql = 
					"select sum(od.orderdnum) odgoodsnum,od.orderdcode,od.orderdtype,od.orderdunits "+
					"from orderd od left join orderm om on om.ordermid = od.orderdorderm  "+
					"left join company cp on om.ordermcompany = cp.companyid left join city ct on ct.cityid = cp.companycity "+
					"where om.ordermtime >= '"+staTime+"' and om.ordermtime <= '"+endTime+"' and ct.cityname = '"+customerxian+
					"' group by od.orderdcode,od.orderdtype,od.orderdunits order by odgoodsnum desc "+
					"limit 0,10";
		}
		List<HotOrderdSumVO> hos = selAll(HotOrderdSumVO.class, sql, dsName);
		ArrayList<GoodsVo> gvoList = new ArrayList<GoodsVo>();
		for (HotOrderdSumVO item : hos) {
			GoodsVo gvo = new GoodsVo();
			if(item.getOrderdtype().equals("商品")){
				List<Goodsview> tgviewList = selAll(Goodsview.class,"select * from goodsview gv where gv.goodscode = '"+item.getOrderdcode()+
							   "' and gv.goodsunits = '"+item.getOrderdunits()+
							   "' and gv.pricesclass = '"+request.getParameter("customertype")+
							   "' and gv.priceslevel = "+request.getParameter("customerlevel")+
							   " and gv.goodsstatue = '上架'", dsName);
				if(tgviewList.size() > 0){
					gvo.setType(item.getOrderdtype());
					gvo.setGoodsview(tgviewList.get(0));
					gvoList.add(gvo);
				}
			} else if(item.getOrderdtype().equals("秒杀")){
				List<Timegoodsview> tgviewList = selAll(Timegoodsview.class,"select * from timegoodsview tv where tv.timegoodscode = '"+
								item.getOrderdcode()+"' and tv.timegoodsunits = '"+item.getOrderdunits()+
								"' and tv.timegoodsstatue = '启用' and tv.timegoodsscope like '%"+request.getParameter("customertype")+"%'", dsName);
				if(tgviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setTgview(tgviewList.get(0));
					gvoList.add(gvo);
				}
			} else if(item.getOrderdtype().equals("买赠")){
				List<Givegoodsview> ggviewList = selAll(Givegoodsview.class,"select * from givegoodsview gv where gv.givegoodscode = '"+
								item.getOrderdcode()+"' and gv.givegoodsunits = '"+item.getOrderdunits()+
								"' and gv.givegoodsstatue = '启用' and gv.givegoodsscope like '%"+request.getParameter("customertype")+"%'", dsName);
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
		Map<String, Object> infoMap = new HashMap<String, Object>();
		String json = request.getParameter("json");
		String customerid = request.getParameter("customerid");
		String companyid = request.getParameter("companyid");
		String dsName = null;
		if(companyid.equals("1")){
			dsName = "mysql";
		}
		String customertype = "";
		String customerlevel = "";
		@SuppressWarnings("unchecked")
		List<Customer> cusLi = selAll(Customer.class, "select * from customer where customerid='"+customerid+"'",dsName);
		if(cusLi.size() ==1){
			customertype = cusLi.get(0).getCustomertype();
			customerlevel = cusLi.get(0).getCustomerlevel().toString();
			System.out.println("json : " + json);
			List<SdishesVO> svoList = null;
			if(!CommonUtil.isNull(json)) svoList = CommonConst.GSON.fromJson(json, new com.google.gson.reflect.TypeToken<ArrayList<SdishesVO>>() {}.getType());
			infoMap.put("svoList", svoList);
			infoMap = checkXJ(infoMap, customertype, customerlevel, dsName);				//检查商品是否下架
			infoMap = checkSurplus(customerid,infoMap, dsName);								//检查剩余限量是否足够 并修改
			@SuppressWarnings("unchecked")
			Pageinfo pageinfo = new Pageinfo((List<SdishesVO>)infoMap.get("svoList"));
			pageinfo.setMsg("您购买的："+TypeUtil.objToString(infoMap.get("xjGoodsMsg"))+
					TypeUtil.objToString(infoMap.get("editNumMsg"))+TypeUtil.objToString(infoMap.get("deleGoodsMsg")));
			result = CommonConst.GSON.toJson(pageinfo);
		}
		responsePW(response, result);
	}
	//检查商品是否下架了
	@SuppressWarnings("unchecked")
	public Map<String, Object> checkXJ(Map<String, Object> infoMap,String customertype,String customerlevel, String dsName){
		List<SdishesVO> svoList = (List<SdishesVO>) infoMap.get("svoList");
		List<SdishesVO> svoListremove = new ArrayList<SdishesVO>();
		String xjGoodsMsg = "";
		for (int i = 0; i < svoList.size(); i++) {
			SdishesVO svo = svoList.get(i);
			if(svo.getOrderdtype().equals("商品")){
				List<Goodsview> gList = selAll(Goodsview.class,"select * from goodsview gv where gv.goodsid = '"+svo.getGoodsid()+
						   "' and gv.pricesclass = '"+customertype+
						   "' and gv.priceslevel = "+customerlevel+
						   " and gv.goodsstatue = '上架'", dsName);
				if(gList.size() == 0){
					svoListremove.add(svo);
					xjGoodsMsg += svo.getGoodsname()+",";									//提示信息
				} else {
					Float gp = gList.get(0).getPricesprice();
					if(!gp.equals(svo.getPricesprice())){
						svoList.get(i).setPricesprice(gp);							//修改价格
					}
				}
			} else if(svo.getOrderdtype().equals("年货") || svo.getOrderdtype().equals("组合商品") || 
					svo.getOrderdtype().equals("买赠") || svo.getOrderdtype().equals("秒杀") ){
				List<Bkgoodsview> bgviewList = selAll(Bkgoodsview.class,"select * from bkgoodsview bv where bv.bkgoodsid = '"+
						svo.getGoodsid()+"' and bv.bkgoodsstatue = '启用' and bv.bkgoodsscope like '%"+customertype+"%'", dsName);
				if(bgviewList.size() == 0){
					svoListremove.add(svo);
					xjGoodsMsg += svo.getGoodsname()+",";							//提示信息
				} else {
					Float gp = bgviewList.get(0).getBkgoodsorgprice();
					if(!gp.equals(svo.getPricesprice())){
						svoList.get(i).setPricesprice(gp);							//修改价格
					}
				}
			}
		}
		if(!CommonUtil.isNull(xjGoodsMsg)){
			infoMap.put("xjGoodsMsg", xjGoodsMsg+" 商品已下架。");
		}
		svoList.removeAll(svoListremove);
		infoMap.put("svoList", svoList);
		return infoMap;
	}
	//检查剩余限量是否足够 并修改
	@SuppressWarnings("unchecked")
	public Map<String, Object> checkSurplus(String customerid,Map<String, Object> infoMap, String dsName){
		List<SdishesVO> svoList = (List<SdishesVO>) infoMap.get("svoList");
		List<SdishesVO> svoListremove = new ArrayList<SdishesVO>();
		cuss = (ArrayList<Orderd>) selAll(Orderd.class, "select od.orderdgoods,od.orderdtype,sum(od.orderdnum) as orderdclass from orderm om "+
				"left join orderd od on od.orderdorderm = om.ordermid where om.ordermcustomer = '"+customerid+
				"' and (od.orderdtype = '买赠' or od.orderdtype = '秒杀' or od.orderdtype = '组合商品') and om.ordermstatue!='已删除' and om.ordermtime >= '"+DateUtils.getDate()+
				" 00:00:00' and om.ordermtime <= '"+DateUtils.getDate()+" 23:59:59'  group by od.orderdtype,od.orderdgoods", dsName);
		String editNumMsg = "";
		String deleGoodsMsg = "";
		for (int i=0; i < svoList.size(); i++) {
			SdishesVO svo = svoList.get(i);
			Integer odNum = svo.getOrderdetnum();				//订单中购买的数量
			//检查秒杀和买赠商品的每日限购
			if((svo.getOrderdtype().equals("秒杀") || svo.getOrderdtype().equals("买赠") || svo.getOrderdtype().equals("组合商品")) && 
					svo.getTimegoodsnum() != -1){
				Integer daySur = svo.getTimegoodsnum() - odNum;	//限购数量 减 购买的数量
				for (Orderd od : cuss) {
					if(od.getOrderdtype().equals(svo.getOrderdtype()) && od.getOrderdgoods().equals(svo.getGoodsid())){
						daySur -= Integer.parseInt(od.getOrderdclass());	//这里的 "orderdclass" 里面放的是订单数量
					}
				}
				if(daySur >= 0){
					
				} else if(daySur < 0 && odNum + daySur > 0){
					odNum += daySur;
					svoList.get(i).setOrderdetnum(odNum);									//修改
					editNumMsg += svo.getGoodsname()+",";									//提示信息
				} else {
					odNum = -1;
					svoListremove.add(svo);
					deleGoodsMsg += svo.getGoodsname()+",";									//提示信息
				}
			}
			
			//检查组合商品的剩余数量
			if(svo.getOrderdtype().equals("组合商品") || svo.getOrderdtype().equals("秒杀")){
				List<Bkgoods> tgList = selAll(Bkgoods.class, "select * from bkgoods bkg where bkg.bkgoodsid = '"+svo.getGoodsid()+"'", dsName);
				if(!CommonUtil.isNull(tgList)){
					Integer surnum = tgList.get(0).getBkgoodssurplus();			//剩余数量
					if(odNum != -1 && tgList.get(0).getBkgoodsallnum() > 0){						//如果有设置总限购，并且订单商品没有被删除。
						if(surnum <= 0){									//判断剩余数量
							svoListremove.add(svoList.get(i));
							deleGoodsMsg += svo.getGoodsname()+",";									//提示信息
						} else if(odNum > surnum && odNum.equals(svo.getOrderdetnum())){				//如果没有被修改过,并且下单数量大于剩余数量
							editNumMsg += svo.getGoodsname()+",";									//提示信息
							odNum = surnum;
							svoList.get(i).setOrderdetnum(odNum);
						} else {											//如果有被修改过
							odNum = surnum;
						}
					}
				}
			}
		}
		svoList.removeAll(svoListremove);
		if(!CommonUtil.isNull(editNumMsg)){
			infoMap.put("editNumMsg", editNumMsg+" 超过限购数量已调整。");
		}
		if(!CommonUtil.isNull(deleGoodsMsg)){
			infoMap.put("deleGoodsMsg", deleGoodsMsg+ " 超过限购数量已去除。");
		}
		infoMap.put("svoList", svoList);
		return infoMap;
	}
}










