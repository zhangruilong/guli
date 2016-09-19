package com.server.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.pojo.Ccustomer;
import com.system.tools.CommonConst;
import com.system.tools.util.CommonUtil;

/**
 * 经销商和客户 逻辑层
 *@author ZhangRuiLong
 */
public class GLCcustomerAction extends CcustomerAction {

	//将json转换成cuss
	public void json2cuss(HttpServletRequest request){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
	}
	//删除客户已经绑定的关系
	public void delCusNexus(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Ccustomer temp:cuss){
			String[] primaryKeys = {"ccustomercompany","ccustomercustomer"};
			result = delSingle(temp, primaryKeys);
		}
		responsePW(response, result);
	}
}
