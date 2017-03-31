package com.server.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.CcustomerviewPoco;
import com.server.pojo.Ccustomerview;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;

/**
 * CCUSTOMERVIEW 逻辑层
 *@author ZhangRuiLong
 */
public class GLCcustomerviewAction extends CcustomerviewAction {
	
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request, Ccustomerview.class, CcustomerviewPoco.QUERYFIELDNAME, CcustomerviewPoco.ORDER, TYPE);
		String comid = request.getParameter("comid");
		if(comid.equals("1")){
			queryinfo.setDsname("mysql");
		}
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
}
