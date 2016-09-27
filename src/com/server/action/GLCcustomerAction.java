package com.server.action;

import java.util.List;

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
	//新增客户关系
	@SuppressWarnings("unchecked")
	public void addCcus(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		if(cuss.size()>0){
			List<Ccustomer> ccli = selAll(Ccustomer.class,"select * from ccustomer cc where cc.ccustomercompany='"+
					cuss.get(0).getCcustomercompany()+"' and cc.ccustomercustomer='"+cuss.get(0).getCcustomercustomer()+"'");
			if(ccli.size()>0){						//判断是否已经有了这条关系
				result=CommonConst.SUCCESS;
			} else {
				cuss.get(0).setCcustomerid(CommonUtil.getNewId());
				result=insSingle(cuss.get(0));
			}
		}
		responsePW(response, result);
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
