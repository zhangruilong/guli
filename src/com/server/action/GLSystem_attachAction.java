package com.server.action;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.pojo.Ccustomer;
import com.server.pojo.Customer;
import com.system.action.System_attachAction;
import com.system.poco.System_attachPoco;
import com.system.pojo.System_attach;
import com.system.tools.CommonConst;
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
	
	//首页图片
	@SuppressWarnings("unchecked")
	public void shouyeImg(HttpServletRequest request, HttpServletResponse response){
		String cusid = request.getParameter("customerid");
		String sql = "select * from system_attach where classify='经销商' and code like 'shouye_' and (";
		ArrayList<Ccustomer> ccusLi = (ArrayList<Ccustomer>) selAll(Ccustomer.class,"select * from ccustomer c where c.ccustomercustomer='"+cusid+"'");
		if(ccusLi.size()>0){
			for (Ccustomer cc : ccusLi) {
				sql+= "fid like '%"+cc.getCcustomercompany()+"%' or ";
			}
			sql = sql.substring(0, sql.length()-3)+")";
			Pageinfo pageinfo = new Pageinfo(0, selAll(System_attach.class, sql+" order by code"));
			result = CommonConst.GSON.toJson(pageinfo);
		}
		responsePW(response, result);
	}
	
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
			result = doSingle(delsql);
			
			temp.setId(CommonUtil.getNewId());
	        temp.setName(fileinfo.getFullname());
	        temp.setAttachsize(String.valueOf(fileinfo.getSize()/1024)+"KB");
	        temp.setType(fileinfo.getType());
	        //temp.setCreator(creator);
	        temp.setCreatetime(DateUtils.getDateTime());
			result = insSingle(temp);
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
