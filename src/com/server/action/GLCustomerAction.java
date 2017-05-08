package com.server.action;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.CustomerPoco;
import com.server.pojo.Address;
import com.server.pojo.Customer;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.DateUtils;

/**
 * 客户 逻辑层
 *@author ZhangRuiLong
 */
public class GLCustomerAction extends CustomerAction {
	
	//修改
	public void updAll(HttpServletRequest request, HttpServletResponse response){
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(Customer temp:cuss){
			result = updSingle(temp,CustomerPoco.KEYCOLUMN,dsName);
		}
		responsePW(response, result);
	}
	
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		Queryinfo queryinfo = getQueryinfo(request, Customer.class, CustomerPoco.QUERYFIELDNAME, CustomerPoco.ORDER, TYPE);
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
    	String queryfieldname[] = CustomerPoco.QUERYFIELDNAME;
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
	//查询客户信息
	@SuppressWarnings("unchecked")
	public void selCustomer(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setWheresql(queryinfo.getWheresql());
		queryinfo.setType(Customer.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(CustomerPoco.ORDER);
		cuss = (ArrayList<Customer>) selAll(queryinfo);
		if(cuss.size()==0 || "海盐县/平湖区/海宁市".indexOf(cuss.get(0).getCustomerxian()) != -1){
			queryinfo.setDsname("mysql");
			cuss = (ArrayList<Customer>) selAll(queryinfo);
			if(cuss.size()==0){
				Customer mCustomer = new Customer();
				mCustomer.setCustomercity("嘉兴市");
				mCustomer.setCustomerxian("海盐县");
				mCustomer.setCustomershop("我的店铺");
				mCustomer.setCustomerlevel(3);
				mCustomer.setCustomertype("3");
				mCustomer.setCustomerstatue("启用");
				cuss.add(mCustomer);
			}
		}
		Pageinfo pageinfo = new Pageinfo(0, cuss);
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//注册
	@SuppressWarnings("unchecked")
	public void regCustomer(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Customer temp:cuss){
			ArrayList<String> sqlList = new ArrayList<String>();				//sql语句的list集合
			ArrayList<Customer> cusList = (ArrayList<Customer>) selAll(Customer.class, "select * from customer c where c.customerphone='"+
					temp.getCustomerphone()+"' or c.openid='"+temp.getOpenid()+"'");
			if(cusList != null && cusList.size() > 0){
				result = "{success:false,code:400,msg:'手机已经注册过了。'}";
			}else{
				String newId = CommonUtil.getNewId();
				temp.setCustomerid(newId);		//设置新id
				temp.setCustomerstatue("启用");
				temp.setCustomerlevel(3);							//默认等级
				temp.setCustomertype("3");							//默认类型
				temp.setCreatetime(DateUtils.getDateTime());
				String sqlCustomer = getInsSingleSql(temp);
				sqlList.add(sqlCustomer);
				//添加新地址
				Address address = new Address();
				address.setAddressture(1);							//自动设为默认地址
				address.setAddressid(newId);		//设置新id
				address.setAddressaddress(temp.getCustomercity()+temp.getCustomerxian()+temp.getCustomeraddress());
				address.setAddresscustomer(newId);				//客户id
				address.setAddressphone(temp.getCustomerphone());
				address.setAddressconnect(temp.getCustomername());
				String sqlAddress = getInsSingleSql(address);
				sqlList.add(sqlAddress);
				if("海盐县/平湖区/海宁市".indexOf(temp.getCustomerxian()) != -1 ){
					//注册信息到MySQL
					result = doAll(sqlList, "mysql");
				} else {
					//注册信息到Oracle
					result = doAll(sqlList, "oracle");
				}
				if(CommonConst.SUCCESS.equals(result)){
					ArrayList<Customer> retCust = new ArrayList<Customer>();
					retCust.add(temp);
					Pageinfo pageinfo = new Pageinfo(0, retCust);
					result = CommonConst.GSON.toJson(pageinfo);
				}
			}
			
		}
		responsePW(response, result);
	}
}














