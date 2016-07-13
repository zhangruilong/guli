package com.server.action;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.OrdermPoco;
import com.server.poco.TimegoodsPoco;
import com.server.pojo.Orderd;
import com.server.pojo.Orderm;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseActionDao;
import com.system.tools.pojo.Fileinfo;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.DateUtils;
import com.system.tools.util.FileUtil;

/**
 * 订单 逻辑层
 *@author ZhangRuiLong
 */
public class OrdermAction extends BaseActionDao {
	public String result = CommonConst.FAILURE;
	public ArrayList<Orderm> cuss = null;
	public java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<ArrayList<Orderm>>() {}.getType();
	

	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = OrdermPoco.QUERYFIELDNAME;
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
		for(Orderm temp:cuss){
			temp.setOrdermid(CommonUtil.getNewId());
			result = insSingle(temp);
		}
		responsePW(response, result);
	}
	//删除
	public void delAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Orderm temp:cuss){
			result = delSingle(temp,OrdermPoco.KEYCOLUMN);
		}
		responsePW(response, result);
	}
	//修改
	public void updAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		cuss.get(0).setUpdor(getCurrentUsername(request));
		cuss.get(0).setUpdtime(DateUtils.getDateTime());
		result = updSingle(cuss.get(0),OrdermPoco.KEYCOLUMN);
		responsePW(response, result);
	}
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Orderm.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrdermPoco.ORDER);
		cuss = (ArrayList<Orderm>) selAll(queryinfo);
		FileUtil.expExcel(response,cuss,OrdermPoco.CHINESENAME,OrdermPoco.KEYCOLUMN,OrdermPoco.NAME);
	}
	//导入
	public void impAll(HttpServletRequest request, HttpServletResponse response){
		Fileinfo fileinfo = FileUtil.upload(request,0,null,OrdermPoco.NAME,"impAll");
		String json = FileUtil.impExcel(fileinfo.getPath(),OrdermPoco.FIELDNAME); 
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(Orderm temp:cuss){
			temp.setOrdermid(CommonUtil.getNewId());
			result = insSingle(temp);
		}
		responsePW(response, result);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Orderm.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrdermPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(Orderm.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(OrdermPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//新增
	public void addOrder(HttpServletRequest request, HttpServletResponse response){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		Orderm temp = cuss.get(0);
		
		String mOrdermid = CommonUtil.getNewId();
		temp.setOrdermid(mOrdermid);
		temp.setOrdermcode(mOrdermid);
		temp.setOrdermrightmoney(temp.getOrdermmoney());
//		temp.setOrdermcustomer(getCurrentUserid(request));
		temp.setOrdermstatue("已下单");
		temp.setOrdermtime(DateUtils.getDateTime());
		ArrayList<String> sqls = new ArrayList<String> ();
		String sqlOrderm = getInsSingleSql(temp);
		sqls.add(sqlOrderm);
		//订单详情
		String orderdetjson = request.getParameter("orderdetjson");
		System.out.println("orderdetjson : " + orderdetjson);
		ArrayList<Orderd> sOrderd;
		if(CommonUtil.isNotEmpty(orderdetjson)) {
			java.lang.reflect.Type sOrderdTYPE = new com.google.gson.reflect.TypeToken<ArrayList<Orderd>>() {}.getType();
			sOrderd = CommonConst.GSON.fromJson(orderdetjson, sOrderdTYPE);
			for(Orderd mOrderd:sOrderd){
				mOrderd.setOrderdid(CommonUtil.getNewId());
				mOrderd.setOrderdorderm(mOrdermid);
				mOrderd.setOrderdrightmoney(mOrderd.getOrderdmoney());
				String sqlOrderd = getInsSingleSql(mOrderd);
				sqls.add(sqlOrderd);
			}
			result = doAll(sqls);
		}
		if(result.equals(CommonConst.FAILURE)){
			result = "{success:false,msg:'服务器异常,操作失败'}";
		} else {
			updSingle(TimegoodsPoco.TABLE, "statue=0", "id!=1 and");
			doSingle("update a =1");
		}
		responsePW(response, result);
	}
	//导出
	/*public void expOrderm(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String staTime = request.getParameter("staTime");
		String endTime = request.getParameter("staTime");
		String companyid = request.getParameter("companyid");
		ArrayList<com.server.pojo.entity.Orderd> list = orderdMapper.selectByTime(staTime, endTime, companyid);
		String[] heads = {"商品编码","商品名称","规格","单位","数量","商品单价","商品总价","实际金额"};				//表头
		String[] discard = {"orderdid","orderdorderm","orderddetail","orderdclass","orderdtype"};			//要忽略的字段名
		String name = "订单商品统计报表";	
		FileUtil.expExcel(response,list,heads,discard,name);
	}*/
}
