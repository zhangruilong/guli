package com.server.action;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.OrdermviewPoco;
import com.server.pojo.Ordermview;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseActionDao;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.FileUtil;

/**
 * 订单 逻辑层
 *@author ZhangRuiLong
 */
public class OrdermviewAction extends BaseActionDao {
	public String result = CommonConst.FAILURE;
	public ArrayList<Ordermview> cuss = null;
	public java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<ArrayList<Ordermview>>() {}.getType();

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
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Ordermview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrdermviewPoco.ORDER);
		cuss = (ArrayList<Ordermview>) selAll(queryinfo);
		FileUtil.expExcel(response,cuss,OrdermviewPoco.CHINESENAME,OrdermviewPoco.KEYCOLUMN,OrdermviewPoco.NAME);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Ordermview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrdermviewPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Ordermview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrdermviewPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void mselQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Ordermview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrdermviewPoco.ORDER);
		String openid = request.getParameter("openid");
		String begindate = request.getParameter("begindate");
		String enddate = request.getParameter("enddate");
		String beginmoney = request.getParameter("beginmoney");
		String endmoney = request.getParameter("endmoney");
		String companyname = request.getParameter("companyname");
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
		queryinfo.setWheresql(wheresql);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
}
