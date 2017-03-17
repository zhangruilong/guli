package com.server.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.CollectviewPoco;
import com.server.pojo.Collectview;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;

/**
 * 收藏 逻辑层
 *@author ZhangRuiLong
 */
public class GLCollectviewAction extends CollectviewAction {

	//查询所有
	public void cusColl(HttpServletRequest request, HttpServletResponse response){
		String customerxian = request.getParameter("customerxian");
		String dsName = null;
		if("海盐县/平湖区/海宁市".indexOf(customerxian) != -1){
			dsName = "mysql";
		}
		Queryinfo queryinfo = getQueryinfo(request, Collectview.class, CollectviewPoco.QUERYFIELDNAME, CollectviewPoco.ORDER, TYPE);
		queryinfo.setDsname(dsName);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
}





