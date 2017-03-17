package com.server.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.AddressPoco;
import com.server.pojo.Address;
import com.server.pojo.Ccustomerview;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;

/**
 * 我的地址 逻辑层
 *@author ZhangRuiLong
 */
public class GLAddressAction extends AddressAction {
	
	//删除
	public void delCusAddress(HttpServletRequest request, HttpServletResponse response){
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(Address temp:cuss){
			result = delSingle(temp,AddressPoco.KEYCOLUMN,dsName);
		}
		responsePW(response, result);
	}
		
	//查询所有
	public void cusAddress(HttpServletRequest request, HttpServletResponse response){
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		Queryinfo queryinfo = getQueryinfo(request, Address.class, AddressPoco.QUERYFIELDNAME, AddressPoco.ORDER, TYPE);
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
    	String queryfieldname[] = AddressPoco.QUERYFIELDNAME;
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
	//修改客户收货地址
	public void updCusAdd(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		if(cuss.size()>0){
			Address editAdd = cuss.get(0);
			String updSQL = getUpdSingleSql(editAdd, AddressPoco.KEYCOLUMN);
			if(editAdd.getAddressture() == 1){
				String sql2 = "update address set addressture=0 where addressid!='"+editAdd.getAddressid()+"' and addresscustomer='"+editAdd.getAddresscustomer()+"'";
				String[] sqls = {updSQL,sql2};
				result = doAll(sqls,dsName);
			} else {
				String[] sqls = {updSQL};
				result = doAll(sqls,dsName);
			}
		}
		responsePW(response, result);
	}
	//新增收货地址
	public void insertCusAdd(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		if(cuss.size()>0){
			Address temp = cuss.get(0);
			temp.setAddressid(CommonUtil.getNewId());
			String insSql = getInsSingleSql(temp);
			if(temp.getAddressture() == 1){
				String sql2 = "update address set addressture=0 where addressid!='"+temp.getAddressid()+"' and addresscustomer='"+temp.getAddresscustomer()+"'";
				String[] sqls = {insSql,sql2};
				result = doAll(sqls,dsName);
			} else {
				String[] sqls = {insSql};
				result = doAll(sqls,dsName);
			}
		}
		responsePW(response, result);
	}
}
