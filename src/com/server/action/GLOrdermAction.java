package com.server.action;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.BkgoodsPoco;
import com.server.poco.OrdermPoco;
import com.server.pojo.Bkgoods;
import com.server.pojo.Orderd;
import com.server.pojo.Orderm;
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
		
		String odCode = DateUtils.formatDate(new Date(), "yyyyMMddhhmmss");
		String todayOd = (getTotal("orderm", "ordermtime like '"+DateUtils.getDate()+"%' and ordermcompany='"+temp.getOrdermcompany()+"'")+1)+"";
		odCode = "G"+odCode+"0000".substring(0, 4-todayOd.length())+todayOd ;
		temp.setOrdermcode(odCode);
		temp.setOrdermrightmoney(temp.getOrdermmoney());
		temp.setOrdermstatue("已下单");
		temp.setOrdermprinttimes("0");
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
				if(mOrderd.getOrderdtype().equals("秒杀") || mOrderd.getOrderdtype().equals("买赠") || 
						mOrderd.getOrderdtype().equals("年货") || mOrderd.getOrderdtype().equals("组合") ){
					@SuppressWarnings("unchecked")
					List<Bkgoods> tgList = selAll(Bkgoods.class,"select * from bkgoods bg where bg.bkgoodsid = '"+mOrderd.getOrderdid()+"'");
					if(tgList.size() >0){
						Bkgoods editNumTG = tgList.get(0);			//修改剩余数量
						editNumTG.setBkgoodssurplus(editNumTG.getBkgoodssurplus() - mOrderd.getOrderdnum());
						result = updSingle(editNumTG,BkgoodsPoco.KEYCOLUMN);
					}
				}
				mOrderd.setOrderdid(CommonUtil.getNewId());
				mOrderd.setOrderdorderm(mOrdermid);
				mOrderd.setOrderdrightmoney(mOrderd.getOrderdmoney());
				String sqlOrderd = getInsSingleSql(mOrderd);
				sqls.add(sqlOrderd);
			}
			String[] ss = sqls.toArray(new String[0]);
			result = doAll(ss);
		}
		if(result.equals(CommonConst.FAILURE)){
			result = "{success:false,msg:'操作失败'}";
		}
		responsePW(response, result);
	}
}
