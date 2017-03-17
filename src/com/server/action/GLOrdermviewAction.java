package com.server.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.OrdermviewPoco;
import com.server.pojo.Ordermview;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;

/**
 * 订单 逻辑层
 *@author ZhangRuiLong
 */
public class GLOrdermviewAction extends OrdermviewAction {

	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		Queryinfo queryinfo = getQueryinfo(request, Ordermview.class, OrdermviewPoco.QUERYFIELDNAME, OrdermviewPoco.ORDER, TYPE);
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
    	String queryfieldname[] = OrdermviewPoco.QUERYFIELDNAME;
    	for(int i=0;i<queryfieldname.length;i++){
    		querysql += queryfieldname[i] + " like '%" + query + "%' or ";
    	}
		return querysql.substring(0, querysql.length() - 4);
	};
	//分页查询
	public void mselQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Ordermview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder("ordermtime desc");
		String openid = request.getParameter("openid");
		String begindate = request.getParameter("begindate");
		String enddate = request.getParameter("enddate");
		String beginmoney = request.getParameter("beginmoney");
		String endmoney = request.getParameter("endmoney");
		String companyname = request.getParameter("companyname");
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		String wheresql = "openid='"+openid+"' and ordermstatue!='已删除'";
		if(CommonUtil.isNotNull(begindate)){
			wheresql += " and ordermtime>='"+begindate+"'";
		}
		if(CommonUtil.isNotNull(enddate)){
			wheresql += " and ordermtime<='"+enddate+" 24'";
		}
		if(CommonUtil.isNotNull(beginmoney)){
			wheresql += " and ordermmoney>='"+beginmoney+"'";
		}
		if(CommonUtil.isNotNull(endmoney)){
			wheresql += " and ordermmoney<='"+endmoney+"'";
		}
		if(CommonUtil.isNotNull(companyname)){
			wheresql += " and companyshop like '%"+companyname+"%'";
		}
//		if(CommonUtil.isNotNull(wheresql)){
//			wheresql = wheresql.substring(5,wheresql.length());
//		}
		queryinfo.setDsname(dsName);
		queryinfo.setWheresql(wheresql);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
}
