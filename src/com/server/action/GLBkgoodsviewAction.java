package com.server.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.BkgoodsviewPoco;
import com.server.pojo.Bkgoodsview;
import com.server.pojo.Ccustomer;
import com.server.pojo.Customer;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;

/**
 * 预定商品 逻辑层
 *@author ZhangRuiLong
 */
public class GLBkgoodsviewAction extends BkgoodsviewAction {
	
	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = BkgoodsviewPoco.QUERYFIELDNAME;
    	for(int i=0;i<queryfieldname.length;i++){
    		querysql += queryfieldname[i] + " like '%" + query + "%' or ";
    	}
		return querysql.substring(0, querysql.length() - 4);
	};
	//预定商品页
	@SuppressWarnings("unchecked")
	public void cusBookingsG(HttpServletRequest request, HttpServletResponse response){
		String cusid = request.getParameter("customerid");
		String comid = request.getParameter("companyid");
		String bkgoodscode = request.getParameter("bkgoodscode");
		String wheresql = null;
		if(CommonUtil.isEmpty(comid)){
			//非业务员补单
			List<Customer> cusli = selAll(Customer.class, "select * from customer where customerid='"+cusid+"'");
			if(cusli.size() == 1){
				Queryinfo Ccustomerqueryinfo = getQueryinfo(Ccustomer.class, null, null, null);
				Ccustomerqueryinfo.setType(Ccustomer.class);
				Ccustomerqueryinfo.setWheresql("Ccustomercustomer='"+cusid+"'");
				ArrayList<Ccustomer> Ccustomercuss = (ArrayList<Ccustomer>) selAll(Ccustomerqueryinfo);
				if(Ccustomercuss.size()!=0){
					wheresql = "bkgoodsstatue='启用' and bkgoodsscope like '%"+cusli.get(0).getCustomertype()+"%' and (";
					for (Ccustomer ccustomer : Ccustomercuss) {
						wheresql += "bkgoodscompany='"+ccustomer.getCcustomercompany()+"' or ";
					}
					wheresql = wheresql.substring(0, wheresql.length()-3) +") ";
					if(CommonUtil.isNotEmpty(bkgoodscode)){
						wheresql += "and bkgoodscode='"+bkgoodscode+"' ";
					}
					Queryinfo queryinfo = getQueryinfo(request);
					queryinfo.setType(Bkgoodsview.class);
					queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
					queryinfo.setWheresql(wheresql);
					queryinfo.setOrder("bkgoodsseq");
					cuss = (ArrayList<Bkgoodsview>) selAll(queryinfo);
					Pageinfo pageinfo = new Pageinfo(0, cuss);
					result = CommonConst.GSON.toJson(pageinfo);
				}
			}
		} else {
			//业务员补单
		}
		responsePW(response, result);
	}
}







