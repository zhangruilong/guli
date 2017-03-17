package com.server.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.pojo.Feedback;
import com.system.tools.CommonConst;
import com.system.tools.util.CommonUtil;

/**
 * 客户反馈意见 逻辑层
 *@author ZhangRuiLong
 */
public class GLFeedbackAction extends FeedbackAction {

	//新增
	public void insAll(HttpServletRequest request, HttpServletResponse response){
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		json = json.replace("\"\"", "null");
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(Feedback temp:cuss){
			if(CommonUtil.isNull(temp.getFeedbackid()))
				temp.setFeedbackid(CommonUtil.getNewId());
			result = insSingle(temp,dsName);
		}
		responsePW(response, result);
	}
}
