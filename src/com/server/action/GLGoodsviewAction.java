package com.server.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.GoodsviewPoco;
import com.server.pojo.Ccustomer;
import com.server.pojo.Collect;
import com.server.pojo.Goodsview;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;

/**
 * 商品 逻辑层
 *@author ZhangRuiLong
 */
public class GLGoodsviewAction extends GoodsviewAction {

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
	//分页查询
	@SuppressWarnings("unchecked")
	public void mselQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Goodsview.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(GoodsviewPoco.ORDER);
		cuss = (ArrayList<Goodsview>) selQuery(queryinfo);
		
		Queryinfo collectqueryinfo = getQueryinfo(Collect.class, null, null, null);
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
	@SuppressWarnings("unchecked")
	public void mselAll(HttpServletRequest request, HttpServletResponse response){
		String companyid = request.getParameter("companyid");
		String customerid = request.getParameter("customerid");
		String customertype = request.getParameter("customertype");
		String customerlevel = request.getParameter("customerlevel");
		String goodsclassname = request.getParameter("goodsclassname");
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		//查询该客户的供应商关系表
		Queryinfo Ccustomerqueryinfo = getQueryinfo(Ccustomer.class, null, null, null);
		Ccustomerqueryinfo.setWheresql("Ccustomercustomer='"+customerid+"'");
		Ccustomerqueryinfo.setDsname(dsName);
		List<Ccustomer> Ccustomercuss = selAll(Ccustomerqueryinfo);
		if(Ccustomercuss.size()!=0){
			String wheresql = "goodsstatue ='上架' and pricesclass='"+customertype+"' and priceslevel='"+customerlevel+"'";
			if(CommonUtil.isNotEmpty(companyid)){
				wheresql += " and goodscompany='"+companyid+"'";
			}else{
				wheresql += " and (";
				for(Ccustomer mCcustomer:Ccustomercuss){
					if(mCcustomer.getCcustomercompany().equals("1")){
						dsName = "mysql";
					}
					wheresql += "goodscompany ='"+mCcustomer.getCcustomercompany()+"' or ";
				}
				wheresql = wheresql.substring(0, wheresql.length()-3) +")";
			}
			if(CommonUtil.isNotEmpty(goodsclassname)){
				wheresql += " and (goodsclassname='"+goodsclassname+
						"' or goodsbrand='"+goodsclassname+
						"' or goodstype like '%"+goodsclassname+
						"%')";
			}
			Queryinfo queryinfo = getQueryinfo(request);
			queryinfo.setType(Goodsview.class);
			queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
			queryinfo.setWheresql(wheresql);
			queryinfo.setOrder(" goodsorder desc,goodsname,goodsclass,goodsunits ");
			queryinfo.setDsname(dsName);
			cuss = (ArrayList<Goodsview>) selAll(queryinfo);
			
			Queryinfo collectqueryinfo = getQueryinfo(Collect.class, null, null, null);
			collectqueryinfo.setWheresql("collectcustomer='"+customerid+"'");
			collectqueryinfo.setDsname(dsName);
			List<Collect> cussCollect = selAll(collectqueryinfo);
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
