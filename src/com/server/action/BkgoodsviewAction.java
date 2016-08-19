package com.server.action;

import java.lang.reflect.Type;
import com.google.gson.reflect.TypeToken;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.pojo.Bkgoodsview;
import com.server.pojo.Ccustomer;
import com.server.pojo.Customer;
import com.server.pojo.Givegoodsview;
import com.server.poco.BkgoodsviewPoco;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseActionDao;
import com.system.tools.pojo.Fileinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.FileUtil;
import com.system.tools.pojo.Pageinfo;

/**
 * 预定商品 逻辑层
 *@author ZhangRuiLong
 */
public class BkgoodsviewAction extends BaseActionDao {
	public String result = CommonConst.FAILURE;
	public ArrayList<Bkgoodsview> cuss = null;
	public Type TYPE = new TypeToken<ArrayList<Bkgoodsview>>() {}.getType();
	
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
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Bkgoodsview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		if(CommonUtil.isNull(queryinfo.getOrder())) queryinfo.setOrder(BkgoodsviewPoco.ORDER);
		cuss = (ArrayList<Bkgoodsview>) selAll(queryinfo);
		FileUtil.expExcel(response,cuss,BkgoodsviewPoco.CHINESENAME,BkgoodsviewPoco.NAME);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Bkgoodsview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		if(CommonUtil.isNull(queryinfo.getOrder())) queryinfo.setOrder(BkgoodsviewPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Bkgoodsview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		if(CommonUtil.isNull(queryinfo.getOrder())) queryinfo.setOrder(BkgoodsviewPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
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
				Queryinfo Ccustomerqueryinfo = getQueryinfo();
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







