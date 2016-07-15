package com.server.action;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.GoodsviewPoco;
import com.server.pojo.Ccustomer;
import com.server.pojo.Collect;
import com.server.pojo.Goodsview;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseActionDao;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.FileUtil;

/**
 * 商品 逻辑层
 *@author ZhangRuiLong
 */
public class GoodsviewAction extends BaseActionDao {
	public String result = CommonConst.FAILURE;
	public ArrayList<Goodsview> cuss = null;
	public java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<ArrayList<Goodsview>>() {}.getType();

	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = GoodsviewPoco.QUERYFIELDNAME;
    	for(int i=0;i<queryfieldname.length;i++){
    		querysql += queryfieldname[i] + " like '%" + query + "%' or ";
    	}
		return querysql.substring(0, querysql.length() - 4);
	};
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Goodsview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(GoodsviewPoco.ORDER);
		cuss = (ArrayList<Goodsview>) selAll(queryinfo);
		FileUtil.expExcel(response,cuss,GoodsviewPoco.CHINESENAME,GoodsviewPoco.KEYCOLUMN,GoodsviewPoco.NAME);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Goodsview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(GoodsviewPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Goodsview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(GoodsviewPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void mselQuery(HttpServletRequest request, HttpServletResponse response){
		String openid = request.getParameter("openid");
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Goodsview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(GoodsviewPoco.ORDER);
		cuss = (ArrayList<Goodsview>) selQuery(queryinfo);
		
		Queryinfo collectqueryinfo = getQueryinfo();
		collectqueryinfo.setType(Collect.class);
		ArrayList<Collect> cussCollect = (ArrayList<Collect>) selQuery(collectqueryinfo);
		for(Goodsview mGoodsview:cuss){
			for(Collect mCollect:cussCollect){
				if(mGoodsview.getGoodsid().equals(mCollect.getCollectgoods())){
					mGoodsview.setGoodsdetail("checked");
				}
			}
		}
	
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), cuss);
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//查询
	public void mselAll(HttpServletRequest request, HttpServletResponse response){
		String companyid = request.getParameter("companyid");
		String customerid = request.getParameter("customerid");
		String customertype = request.getParameter("customertype");
		String customerlevel = request.getParameter("customerlevel");
		String goodsclassname = request.getParameter("goodsclassname");
		//查询该客户的供应商关系表
		Queryinfo Ccustomerqueryinfo = getQueryinfo();
		Ccustomerqueryinfo.setType(Ccustomer.class);
		Ccustomerqueryinfo.setWheresql("Ccustomercustomer='"+customerid+"'");
		ArrayList<Ccustomer> Ccustomercuss = (ArrayList<Ccustomer>) selAll(Ccustomerqueryinfo);
		if(Ccustomercuss.size()!=0){
			String wheresql = "goodsstatue ='上架' and pricesclass='"+customertype+"' and priceslevel='"+customerlevel+"'";
			if(CommonUtil.isNotEmpty(companyid)){
				wheresql += " and goodscompany='"+companyid+"'";
			}else{
				for(Ccustomer mCcustomer:Ccustomercuss){
					wheresql += " and goodscompany ='"+mCcustomer.getCcustomercompany()+"'";
				}
			}
			if(CommonUtil.isNotEmpty(goodsclassname)){
				wheresql += " and (goodsclassname='"+goodsclassname+
						"' or goodsbrand='"+goodsclassname+
						"' or goodstype='"+goodsclassname+
						"')";
			}
			Queryinfo queryinfo = getQueryinfo(request);
			queryinfo.setType(Goodsview.class);
			queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
			queryinfo.setWheresql(wheresql);
			queryinfo.setOrder(GoodsviewPoco.ORDER);
			cuss = (ArrayList<Goodsview>) selAll(queryinfo);
			
			Queryinfo collectqueryinfo = getQueryinfo();
			collectqueryinfo.setType(Collect.class);
			collectqueryinfo.setWheresql("collectcustomer='"+customerid+"'");
			ArrayList<Collect> cussCollect = (ArrayList<Collect>) selAll(collectqueryinfo);
			for(Goodsview mGoodsview:cuss){
				for(Collect mCollect:cussCollect){
					if(mGoodsview.getGoodsid().equals(mCollect.getCollectgoods())){
						mGoodsview.setGoodsdetail("checked");
					}
				}
			}
		
			Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), cuss);
			result = CommonConst.GSON.toJson(pageinfo);
		}
		responsePW(response, result);
	}
}
