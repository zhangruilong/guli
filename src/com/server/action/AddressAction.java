package com.server.action;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.pojo.Address;
import com.server.poco.AddressPoco;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseActionDao;
import com.system.tools.pojo.Fileinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.FileUtil;
import com.system.tools.pojo.Pageinfo;

/**
 * 我的地址 逻辑层
 *@author ZhangRuiLong
 */
public class AddressAction extends BaseActionDao {
	public String result = CommonConst.FAILURE;
	public ArrayList<Address> cuss = null;
	public java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<ArrayList<Address>>() {}.getType();
	
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
	//新增
	public void insAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Address temp:cuss){
			temp.setAddressid(CommonUtil.getNewId());
			result = insSingle(temp);
		}
		responsePW(response, result);
	}
	//删除
	public void delAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Address temp:cuss){
			result = delSingle(temp,AddressPoco.KEYCOLUMN);
		}
		responsePW(response, result);
	}
	//修改
	public void updAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		result = updSingle(cuss.get(0),AddressPoco.KEYCOLUMN);
		responsePW(response, result);
	}
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Address.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(AddressPoco.ORDER);
		cuss = (ArrayList<Address>) selAll(queryinfo);
		FileUtil.expExcel(response,cuss,AddressPoco.CHINESENAME,AddressPoco.KEYCOLUMN,AddressPoco.NAME);
	}
	//导入
	public void impAll(HttpServletRequest request, HttpServletResponse response){
		Fileinfo fileinfo = FileUtil.upload(request,0,null,AddressPoco.NAME,"impAll");
		String json = FileUtil.impExcel(fileinfo.getPath(),AddressPoco.FIELDNAME); 
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(Address temp:cuss){
			temp.setAddressid(CommonUtil.getNewId());
			result = insSingle(temp);
		}
		responsePW(response, result);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Address.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		if(CommonUtil.isNull(queryinfo.getOrder())) queryinfo.setOrder(AddressPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Address.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(AddressPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//修改客户收货地址
	public void updCusAdd(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		Address editAdd = cuss.get(0);
		result = updSingle(editAdd,AddressPoco.KEYCOLUMN);
		if(CommonConst.SUCCESS.equals(result) && editAdd.getAddressture() == 1){
			updSingle(AddressPoco.TABLE, "addressture=0", "addressid!='"+editAdd.getAddressid()+"' and addresscustomer='"+editAdd.getAddresscustomer()+"'");
		}
		responsePW(response, result);
	}
	//新增收货地址
	public void insertCusAdd(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		Address temp = cuss.get(0);
		temp.setAddressid(CommonUtil.getNewId());
		result = insSingle(temp);
		if(CommonConst.SUCCESS.equals(result) && temp.getAddressture() == 1){
			updSingle(AddressPoco.TABLE, "addressture=0", "addressid!='"+temp.getAddressid()+"' and addresscustomer='"+temp.getAddresscustomer()+"'");
		}
		responsePW(response, result);
	}
}
