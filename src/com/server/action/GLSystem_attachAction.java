package com.server.action;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.pojo.Ccustomer;
import com.server.pojo.Customer;
import com.server.pojo.Indexarea;
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
	
	//首页图片和首页专区
	@SuppressWarnings("unchecked")
	public void shouyeImg(HttpServletRequest request, HttpServletResponse response){
		String cusid = request.getParameter("customerid");
		String quImgSQL = "select * from system_attach where classify='经销商' and code like 'shouye_' and (";		//查询经销商图片
		String quAreaSQL = "select * from indexarea ia where ia.indexareastatue='启用' and (";		//查询经销商首页区
		ArrayList<Ccustomer> ccusLi = (ArrayList<Ccustomer>) selAll(Ccustomer.class,
				"select * from ccustomer c where c.ccustomercustomer='"+cusid+"'");
		if(ccusLi.size()>0){
			for (Ccustomer cc : ccusLi) {
				quImgSQL+= "fid like '%"+cc.getCcustomercompany()+"%' or ";
				quAreaSQL+= "ia.indexareacompany='"+cc.getCcustomercompany()+"' or ";
			}
			quImgSQL = quImgSQL.substring(0, quImgSQL.length()-3)+")";
			quAreaSQL = quAreaSQL.substring(0, quAreaSQL.length()-3)+")";
			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap.put("msg", "操作成功");
			resultMap.put("images",selAll(System_attach.class, quImgSQL+" order by code"));		//图片
			resultMap.put("area",selAll(Indexarea.class, quAreaSQL+" order by ia.indexareaorder"));	//首页区
			result = CommonConst.GSON.toJson(resultMap);
		}
		responsePW(response, result);
	}
	
	//上传文件
	public void uploadImg(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("==============================================upload===============================================================");
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
