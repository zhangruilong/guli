package com.server.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.CollectPoco;
import com.server.pojo.Collect;
import com.system.tools.CommonConst;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.DateUtils;

/**
 * 收藏 逻辑层
 *@author ZhangRuiLong
 */
public class GLCollectAction extends CollectAction {

	//将json转换成cuss
	public void json2cuss(HttpServletRequest request){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
	}
	//新增
	public void insAllByGoodsid(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Collect temp:cuss){
			if(getTotal(CollectPoco.TABLE, "collectgoods='"+temp.getCollectgoods()+"' and collectcustomer='"+temp.getCollectcustomer()+"'")==0){
				temp.setCreatetime(DateUtils.getDateTime());
				temp.setCollectid(CommonUtil.getNewId());
				result = insSingle(temp);
			};
		}
		responsePW(response, result);
	}
	//删除
	public void delAllByGoodsid(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(Collect temp:cuss){
			result = delSingle(temp);
		}
		responsePW(response, result);
	}
}
