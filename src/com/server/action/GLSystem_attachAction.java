package com.server.action;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.system.action.System_attachAction;
import com.system.dao.System_attachDao;
import com.system.poco.System_attachPoco;
import com.system.pojo.System_attach;
import com.system.pojo.System_user;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseAction;
import com.system.tools.pojo.Fileinfo;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.DateUtils;
import com.system.tools.util.FileUtil;

/**
 * 附件 逻辑层
 *@author ZhangRuiLong
 */
public class GLSystem_attachAction extends System_attachAction {
	
	//上传文件
	public void uploadImg(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("===============upload==============================================================================================");
		//System_user user = getCurrentUser(request);
		//if(CommonUtil.isNotEmpty(user)){
			String json = request.getParameter("json");
			System.out.println("json : " + json);
			if(CommonUtil.isNotEmpty(json)) {
				cuss = CommonConst.GSON.fromJson(json, TYPE);
			}
			//String creator = user.getUsername();
			Fileinfo fileinfo = FileUtil.upload(request,0,null,null,"upload");
			System_attach temp = cuss.get(0);
			String delsql = "delete from system_attach where classify='"+temp.getClassify()
			+"' and fid='"+ temp.getFid()+"'";
			result = DAO.doSingle(delsql);
			
			temp.setId(CommonUtil.getNewId());
	        temp.setName(fileinfo.getFullname());
	        temp.setAttachsize(String.valueOf(fileinfo.getSize()/1024)+"KB");
	        temp.setType(fileinfo.getType());
	        //temp.setCreator(creator);
	        temp.setCreatetime(DateUtils.getDateTime());
			result = DAO.insSingle(temp);
		//}
			if(CommonConst.SUCCESS.equals(result)){
				try {
					response.sendRedirect("mine.jsp");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
	}
}
