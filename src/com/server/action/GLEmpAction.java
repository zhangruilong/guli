package com.server.action;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.EmpPoco;
import com.server.pojo.Emp;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;

/**
 * 业务员 逻辑层
 *@author ZhangRuiLong
 */
public class GLEmpAction extends EmpAction {

	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = EmpPoco.QUERYFIELDNAME;
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
	//业务员登入控制
	public void memplogin(HttpServletRequest request, HttpServletResponse response){
		response.setContentType("text/html;charset=utf-8");
		response.setHeader("Cache-Control", "no-cache");
		//查询验证用户
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String wheresql = "empstatue = '启用' and loginname = '" + username
				+ "' and password = '" + password + "'";
		Queryinfo queryinfo = getQueryinfo(Emp.class, null, null, null);
		queryinfo.setWheresql(wheresql);
		cuss = (ArrayList<Emp>) selAll(queryinfo);
		if(cuss.size()==0){
			responsePW(response, "{success:true,code:403,msg:'账号密码错误'}");
		}else{
			Pageinfo pageinfo = new Pageinfo(0,cuss);
			result = CommonConst.GSON.toJson(pageinfo);
			responsePW(response, result);
		}
	}
}
