package com.server.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.OrdermPoco;
import com.server.poco.TimegoodsPoco;
import com.server.pojo.Orderd;
import com.server.pojo.Orderm;
import com.server.pojo.Timegoods;
import com.system.tools.CommonConst;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.DateUtils;

/**
 * 订单 逻辑层
 *@author ZhangRuiLong
 */
public class GLOrdermAction extends OrdermAction {
	
	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = OrdermPoco.QUERYFIELDNAME;
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
	public void addOrder(HttpServletRequest request, HttpServletResponse response){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		Orderm temp = cuss.get(0);
		
		String mOrdermid = CommonUtil.getNewId();
		temp.setOrdermid(mOrdermid);
		temp.setOrdermcode(mOrdermid);
		temp.setOrdermrightmoney(temp.getOrdermmoney());
//		temp.setOrdermcustomer(getCurrentUserid(request));
		temp.setOrdermstatue("已下单");
		temp.setOrdermtime(DateUtils.getDateTime());
		ArrayList<String> sqls = new ArrayList<String> ();
		String sqlOrderm = getInsSingleSql(temp);
		sqls.add(sqlOrderm);
		//订单详情
		String orderdetjson = request.getParameter("orderdetjson");
		System.out.println("orderdetjson : " + orderdetjson);
		ArrayList<Orderd> sOrderd;
		if(CommonUtil.isNotEmpty(orderdetjson)) {
			java.lang.reflect.Type sOrderdTYPE = new com.google.gson.reflect.TypeToken<ArrayList<Orderd>>() {}.getType();
			sOrderd = CommonConst.GSON.fromJson(orderdetjson, sOrderdTYPE);
			for(Orderd mOrderd:sOrderd){
				if(mOrderd.getOrderdtype().equals("秒杀")){
					@SuppressWarnings("unchecked")
					List<Timegoods> tgList = selAll(Timegoods.class,"select * from timegoods tg where tg.timegoodsid = '"+mOrderd.getOrderdid()+"'");
					if(tgList.size() >0){
						Timegoods editNumTG = tgList.get(0);
						editNumTG.setSurplusnum(editNumTG.getSurplusnum() - mOrderd.getOrderdnum());
						result = updSingle(editNumTG,TimegoodsPoco.KEYCOLUMN);
					}
					/*String timegoodssql = "update ";
					sqls.add(timegoodssql);*/
				}
				mOrderd.setOrderdid(CommonUtil.getNewId());
				mOrderd.setOrderdorderm(mOrdermid);
				mOrderd.setOrderdrightmoney(mOrderd.getOrderdmoney());
				String sqlOrderd = getInsSingleSql(mOrderd);
				sqls.add(sqlOrderd);
			}
			result = doAll(sqls);
		}
		if(result.equals(CommonConst.FAILURE)){
			result = "{success:false,msg:'服务器异常,操作失败'}";
		}/* else {
			result = updSingle(cuss.get(0),TimegoodsPoco.KEYCOLUMN);
			//updSingle(TimegoodsPoco.TABLE, "statue=0", "id!=1 and");			//这是修改
			//doSingle("update a =1");											//这是执行一条sql语句
		}*/
		responsePW(response, result);
	}
}
