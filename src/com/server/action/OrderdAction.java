package com.server.action;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.GoodsviewPoco;
import com.server.poco.OrderdPoco;
import com.server.pojo.Customer;
import com.server.pojo.Givegoodsview;
import com.server.pojo.Goods;
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
import com.system.tools.util.TypeUtil;

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
		String msg = "";
		ArrayList<GoodsVo> gvoList = new ArrayList<GoodsVo>();
		for (Orderd item : cuss) {
			GoodsVo gvo = new GoodsVo();
			if(item.getOrderdtype().equals("商品")){
				List<Goodsview> gList = selAll(Goodsview.class,"select * from goodsview gv where gv.goodscode = '"+item.getOrderdcode()+
							   "' and gv.goodsunits = '"+item.getOrderdunits()+
							   "' and gv.pricesclass = '"+request.getParameter("customertype")+
							   "' and gv.priceslevel = "+request.getParameter("customerlevel")+
							   " and gv.goodsstatue = '上架'");
				if(gList.size() > 0){
					gvo.setType(item.getOrderdtype());
					gvo.setGoodsview(gList.get(0));
					gvo.setNowGoodsNum(item.getOrderdnum());
				} else {
					/*Goodsview xjg = new Goodsview();
					xjg.setGoodsname(item.getOrderdname());
					xjg.setGoodsunits(item.getOrderdunits());
					gvo.setType(item.getOrderdtype());
					gvo.setGoodsview(xjg);
					gvo.setStatue("下架");*/
					msg += item.getOrderdname()+"("+item.getOrderdunits()+")";
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
					/*Timegoodsview xjg = new Timegoodsview();
					xjg.setTimegoodsname(item.getOrderdname());
					xjg.setTimegoodsunits(item.getOrderdunits());
					gvo.setType(item.getOrderdtype());
					gvo.setTgview(xjg);
					gvo.setStatue("下架");*/
					msg += item.getOrderdname()+"("+item.getOrderdunits()+")";
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
					/*Givegoodsview xjg = new Givegoodsview();
					xjg.setGivegoodsname(item.getOrderdname());
					xjg.setGivegoodsunits(item.getOrderdunits());
					gvo.setType(item.getOrderdtype());
					gvo.setGgview(xjg);
					gvo.setStatue("下架");*/
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
								"' and tv.timegoodsstatue = '启用' and tv.timegoodsscope like '%"+request.getParameter("customertype")+"%'");
				if(tgviewList.size() >0){
					gvo.setType(item.getOrderdtype());
					gvo.setTgview(tgviewList.get(0));
					gvoList.add(gvo);
				}
			} else if(item.getOrderdtype().equals("买赠")){
				List<Givegoodsview> ggviewList = selAll(Givegoodsview.class,"select * from givegoodsview gv where gv.givegoodscode = '"+
								item.getOrderdcode()+"' and gv.givegoodsunits = '"+item.getOrderdunits()+
								"' and gv.givegoodsstatue = '启用' and gv.givegoodsscope like '%"+request.getParameter("customertype")+"%'");
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
		String customertype = "";
		String customerlevel = "";
		@SuppressWarnings("unchecked")
		List<Customer> cusLi = selAll(Customer.class, "select * from customer where customerid='"+customerid+"'");
		if(cusLi.size() ==1){
			customertype = cusLi.get(0).getCustomertype();
			customerlevel = cusLi.get(0).getCustomerlevel().toString();
			System.out.println("json : " + json);
			List<SdishesVO> svoList = null;
			if(CommonUtil.isNotEmpty(json)) svoList = CommonConst.GSON.fromJson(json, new com.google.gson.reflect.TypeToken<ArrayList<SdishesVO>>() {}.getType());
			infoMap.put("svoList", svoList);
			infoMap = checkXJ(infoMap, customertype, customerlevel);				//检查商品是否下架
			infoMap = checkSurplus(customerid,infoMap);							//检查剩余限量是否足够 并修改
			@SuppressWarnings("unchecked")
			Pageinfo pageinfo = new Pageinfo((List<SdishesVO>)infoMap.get("svoList"));
			pageinfo.setMsg("您购买的："+TypeUtil.objToString(infoMap.get("xjGoodsMsg"))+TypeUtil.objToString(infoMap.get("editNumMsg"))+TypeUtil.objToString(infoMap.get("deleGoodsMsg")));
			result = CommonConst.GSON.toJson(pageinfo);
		}
		responsePW(response, result);
	}
	//检查商品是否下架了
	@SuppressWarnings("unchecked")
	public Map<String, Object> checkXJ(Map<String, Object> infoMap,String customertype,String customerlevel){
		List<SdishesVO> svoList = (List<SdishesVO>) infoMap.get("svoList");
		List<SdishesVO> svoListremove = new ArrayList<SdishesVO>();
		String xjGoodsMsg = "";
		for (int i = 0; i < svoList.size(); i++) {
			SdishesVO svo = svoList.get(i);
			if(svo.getOrderdtype().equals("商品")){
				List<Goodsview> gList = selAll(Goodsview.class,"select * from goodsview gv where gv.goodscode = '"+svo.getGoodscode()+
						   "' and gv.goodsunits = '"+svo.getGoodsunits()+
						   "' and gv.pricesclass = '"+customertype+
						   "' and gv.priceslevel = "+customerlevel+
						   " and gv.goodsstatue = '上架'");
				if(gList.size() == 0){
					svoListremove.add(svo);
					xjGoodsMsg += svo.getGoodsname()+",";									//提示信息
				} else {
					Float gp = gList.get(0).getPricesprice();
					if(!gp.equals(svo.getPricesprice())){
						svoList.get(i).setPricesprice(gp);							//修改价格
					}
				}
			} else if(svo.getOrderdtype().equals("秒杀")){
				List<Timegoodsview> tgviewList = selAll(Timegoodsview.class,"select * from timegoodsview tv where tv.timegoodscode = '"+
						svo.getGoodscode()+"' and tv.timegoodsunits = '"+svo.getGoodsunits()+
						"' and tv.timegoodsstatue = '启用' and timegoodsscope like '%"+customertype+"%'");
				if(tgviewList.size() == 0){
					svoListremove.add(svo);
					xjGoodsMsg += svo.getGoodsname()+",";									//提示信息
				} else {
					String tp = tgviewList.get(0).getTimegoodsorgprice();
					if(!tp.equals(svo.getPricesprice())){
						svoList.get(i).setPricesprice(Float.parseFloat(tp));							//修改价格
					}
				}
			} else if(svo.getOrderdtype().equals("买赠")){
				List<Givegoodsview> ggviewList = selAll(Givegoodsview.class,"select * from givegoodsview gv where gv.givegoodscode = '"+
						svo.getGoodscode()+"' and gv.givegoodsunits = '"+svo.getGoodsunits()+
						"' and gv.givegoodsstatue = '启用' and givegoodsscope like '%"+customertype+"%'");
				if(ggviewList.size() == 0){
					svoListremove.add(svo);
					xjGoodsMsg += svo.getGoodsname()+",";									//提示信息
				} else {
					String gp = ggviewList.get(0).getGivegoodsprice();
					if(!gp.equals(svo.getPricesprice())){
						svoList.get(i).setPricesprice(Float.parseFloat(gp));							//修改价格
					}
				}
			}
		}
		if(CommonUtil.isNotEmpty(xjGoodsMsg)){
			infoMap.put("xjGoodsMsg", xjGoodsMsg+" 商品已下架。");
		}
		svoList.removeAll(svoListremove);
		infoMap.put("svoList", svoList);
		return infoMap;
	}
	//检查剩余限量是否足够 并修改
	@SuppressWarnings("unchecked")
	public Map<String, Object> checkSurplus(String customerid,Map<String, Object> infoMap){
		List<SdishesVO> svoList = (List<SdishesVO>) infoMap.get("svoList");
		List<SdishesVO> svoListremove = new ArrayList<SdishesVO>();
		cuss = (ArrayList<Orderd>) selAll(Orderd.class, "select od.orderdcode,od.orderdtype,od.orderdunits,sum(od.orderdnum) as orderdclass from orderm om "+
				"left join orderd od on od.orderdorderm = om.ordermid where om.ordermcustomer = '"+customerid+
				"' and (od.orderdtype = '买赠' or od.orderdtype = '秒杀' ) and om.ordermtime >= '"+DateUtils.getDate()+
				" 00:00:00' and om.ordermtime <= '"+DateUtils.getDate()+" 23:59:59'  group by od.orderdcode,od.orderdtype,od.orderdunits");
		String editNumMsg = "";
		String deleGoodsMsg = "";
		for (int i=0; i < svoList.size(); i++) {
			SdishesVO svo = svoList.get(i);
			Integer odNum = svo.getOrderdetnum();				//订单中购买的数量
			//检查秒杀和买赠商品的每日限购
			if(svo.getOrderdtype().equals("秒杀") || svo.getOrderdtype().equals("买赠")){
				Integer daySur = svo.getTimegoodsnum() - odNum;
				for (Orderd od : cuss) {
					if(od.getOrderdtype().equals(svo.getOrderdtype()) && od.getOrderdcode().equals(svo.getGoodscode()) && od.getOrderdunits().equals(svo.getGoodsunits())){
						daySur -= Integer.parseInt(od.getOrderdclass());
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
			
			//检查秒杀商品的剩余数量
			if(svo.getOrderdtype().equals("秒杀")){
				List<Timegoods> tgList = selAll(Timegoods.class, "select * from timegoods tg where tg.timegoodscode = '"+
						svo.getGoodscode()+"' and tg.timegoodsunits = '"+svo.getGoodsunits()+"'");
				if(CommonUtil.isNotEmpty(tgList)){
					Integer surnum = tgList.get(0).getSurplusnum();			//剩余数量
					if(odNum != -1 && tgList.get(0).getAllnum() > 0){						//如果有设置总限购，并且订单商品没有被删除。
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
		if(CommonUtil.isNotEmpty(editNumMsg)){
			infoMap.put("editNumMsg", editNumMsg+" 超过限购数量已调整。");
		}
		if(CommonUtil.isNotEmpty(deleGoodsMsg)){
			infoMap.put("deleGoodsMsg", deleGoodsMsg+ " 超过限购数量已去除。");
		}
		infoMap.put("svoList", svoList);
		return infoMap;
	}
}










