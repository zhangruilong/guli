package com.server.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.OrderdPoco;
import com.server.pojo.Givegoodsview;
import com.server.pojo.GoodsVo;
import com.server.pojo.Goodsview;
import com.server.pojo.Orderd;
import com.server.pojo.Timegoods;
import com.server.pojo.Timegoodsview;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseActionDao;
import com.system.tools.pojo.Fileinfo;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
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
	//查询客户购买的秒杀商品数量
	@SuppressWarnings("unchecked")
	public void selCusXGOrderd(HttpServletRequest request, HttpServletResponse response){
		Pageinfo pageinfo = new Pageinfo(0,selAll(Orderd.class, "select od.orderdcode,od.orderdtype,od.orderdunits,sum(od.orderdnum) as orderdclass from orderm om "+
				"left join orderd od on od.orderdorderm = om.ordermid where om.ordermcustomer = '"+request.getParameter("customerid")+
				"' and (od.orderdtype = '买赠' or od.orderdtype = '秒杀' ) group by od.orderdcode,od.orderdtype,od.orderdunits"));
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
	//查询客户购买的秒杀商品数量
	/*
	public void selCusXGOrderd(HttpServletRequest request, HttpServletResponse response){
		Pageinfo pageinfo = new Pageinfo(0, selCusXGOrderd(request.getParameter("customerid")));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}*/
	/*public ArrayList<Orderd> selCusXGOrderd(String customerid) {
		String sql = null;
		Orderd temp = null;
		ArrayList<Orderd> temps = new ArrayList<Orderd>();
		Connection  conn=connectionMan.getConnection(CommonConst.DSNAME); 
		Statement stmt = null;
		ResultSet rs = null;
		try {
			sql = "select '' as orderdid,od.orderdcode as orderdcode,od.orderdtype as orderdtype,od.orderdunits as orderdunits,sum(od.orderdnum) as orderdclass from orderm om "+
					"left join orderd od on od.orderdorderm = om.ordermid where om.ordermcustomer = '"+customerid+
					"' and (od.orderdtype = '买赠' or od.orderdtype = '秒杀' ) group by od.orderdcode,od.orderdtype,od.orderdunits";
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				temp = new Orderd();
				temp.setOrderdcode( rs.getString("orderdcode"));
				temp.setOrderdclass(rs.getString("orderdclass"));
				temp.setOrderdunits(rs.getString("orderdunits"));
				temp.setOrderdtype(rs.getString("orderdtype"));
				temps.add(temp);
			}
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally{
			connectionMan.freeConnection(CommonConst.DSNAME,conn,stmt,rs);
			return temps;
		}
	};*/
}
