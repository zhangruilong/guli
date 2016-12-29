package com.server.action;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.TimegoodsviewPoco;
import com.server.pojo.Ccustomer;
import com.server.pojo.Timegoodsview;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;

/**
 * 秒杀商品 逻辑层
 *@author ZhangRuiLong
 */
public class GLTimegoodsviewAction extends TimegoodsviewAction {
	
	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = TimegoodsviewPoco.QUERYFIELDNAME;
    	for(int i=0;i<queryfieldname.length;i++){
    		querysql += queryfieldname[i] + " like '%" + query + "%' or ";
    	}
		return querysql.substring(0, querysql.length() - 4);
	};
	
	//秒杀页
	@SuppressWarnings("unchecked")
	public void cusTimeG(HttpServletRequest request, HttpServletResponse response){
		String companyid = request.getParameter("companyid");
		String customerid = request.getParameter("customerid");
		String customertype = request.getParameter("customertype");
		String timegoodscode = request.getParameter("timegoodscode");
		String wheresql = null;
		if(CommonUtil.isEmpty(companyid)){
			//如果不是业务员补单
			Queryinfo Ccustomerqueryinfo = getQueryinfo(Ccustomer.class, null, null, null);
			Ccustomerqueryinfo.setWheresql("Ccustomercustomer='"+customerid+"' ");
			ArrayList<Ccustomer> Ccustomercuss = (ArrayList<Ccustomer>) selAll(Ccustomerqueryinfo);
			if(Ccustomercuss.size()!=0){
				wheresql = "timegoodsstatue='启用' and timegoodsscope like '%"+customertype+"%'  and (";
				for (Ccustomer ccustomer : Ccustomercuss) {
					wheresql += "timegoodscompany='"+ccustomer.getCcustomercompany()+"' or ";
				}
				wheresql = wheresql.substring(0, wheresql.length()-3) +") ";
				if(CommonUtil.isNotEmpty(timegoodscode)){
					wheresql += "and timegoodscode='"+timegoodscode+"'";
				}
				Queryinfo queryinfo = getQueryinfo(request);
				queryinfo.setType(Timegoodsview.class);
				queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
				queryinfo.setWheresql(wheresql);
				queryinfo.setOrder("timegoodsseq");
				cuss = (ArrayList<Timegoodsview>) selAll(queryinfo);
				Pageinfo pageinfo = new Pageinfo(0, cuss);
				result = CommonConst.GSON.toJson(pageinfo);
			}
		} else {
			//如果是业务员补单
			wheresql = "timegoodsstatue='启用' and timegoodsscope like '%"+customertype+"%' and timegoodscompany='"+companyid+"' ";
			if(CommonUtil.isNotEmpty(timegoodscode)){
				wheresql += "and timegoodscode='"+timegoodscode+"'";
			}
			Queryinfo queryinfo = getQueryinfo(request);
			queryinfo.setType(Timegoodsview.class);
			queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
			queryinfo.setWheresql(wheresql);
			queryinfo.setOrder("timegoodsseq");
			cuss = (ArrayList<Timegoodsview>) selAll(queryinfo);
			Pageinfo pageinfo = new Pageinfo(0, cuss);
			result = CommonConst.GSON.toJson(pageinfo);
		}
		
		responsePW(response, result);
	}
}











