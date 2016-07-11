package com.system.action;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
public class System_attachAction extends BaseAction {
	public String result = CommonConst.FAILURE;
	public ArrayList<System_attach> cuss = null;
	public System_attachDao DAO = new System_attachDao();
	public java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<ArrayList<System_attach>>() {}.getType();
	
	//将json转换成cuss
	public void json2cuss(HttpServletRequest request){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
	}
	//新增
	public void insAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(System_attach temp:cuss){
			temp.setId(CommonUtil.getNewId());
			result = DAO.insSingle(temp);
		}
		responsePW(response, result);
	}
	//删除
	public void delAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(System_attach temp:cuss){
			result = DAO.delSingle(temp,System_attachPoco.KEYCOLUMN);
		}
		responsePW(response, result);
	}
	//修改
	public void updAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		result = DAO.updSingle(cuss.get(0),System_attachPoco.KEYCOLUMN);
		responsePW(response, result);
	}
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(System_attach.class);
		queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(System_attachPoco.ORDER);
		cuss = (ArrayList<System_attach>) DAO.selAll(queryinfo);
		FileUtil.expExcel(response,cuss,System_attachPoco.CHINESENAME,System_attachPoco.KEYCOLUMN,System_attachPoco.NAME);
	}
	//导入
	public void impAll(HttpServletRequest request, HttpServletResponse response){
		Fileinfo fileinfo = FileUtil.upload(request,0,null,System_attachPoco.NAME,"impAll");
		String json = FileUtil.impExcel(fileinfo.getPath(),System_attachPoco.FIELDNAME); 
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(System_attach temp:cuss){
			temp.setId(CommonUtil.getNewId());
			result = DAO.insSingle(temp);
		}
		responsePW(response, result);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(System_attach.class);
		queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(System_attachPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, DAO.selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(System_attach.class);
		queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(System_attachPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(DAO.getTotal(queryinfo), DAO.selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//根据fid分页查询
	public void selQueryByFid(HttpServletRequest request, HttpServletResponse response) {
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(System_attach.class);
		queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(System_attachPoco.ORDER);
		String wheresql = queryinfo.getWheresql();
		String fid = request.getParameter("fid");
		if(CommonUtil.isNotEmpty(wheresql)){
			if(CommonUtil.isNotEmpty(fid)){
				queryinfo.setWheresql(wheresql + " and fid='" + fid + "' ");
			}
		}else{
			queryinfo.setWheresql(" fid='" + fid + "' ");
		}
		Pageinfo pageinfo = new Pageinfo(DAO.getTotal(queryinfo), DAO.selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//上传文件
	public void upload(HttpServletRequest request, HttpServletResponse response) {
		System_user user = getCurrentUser(request);
		if(CommonUtil.isNotEmpty(user)){
			String json = request.getParameter("json");
			System.out.println("json : " + json);
			if(CommonUtil.isNotEmpty(json)) {
				cuss = CommonConst.GSON.fromJson(json, TYPE);
			}
			String creator = user.getUsername();
			Fileinfo fileinfo = FileUtil.upload(request,0,null,null,"upload");
			System_attach temp = cuss.get(0);
			temp.setId(CommonUtil.getNewId());
	        temp.setName(fileinfo.getFullname());
	        temp.setAttachsize(String.valueOf(fileinfo.getSize()/1024)+"KB");
	        temp.setType(fileinfo.getType());
	        temp.setCreator(creator);
	        temp.setCreatetime(DateUtils.getDateTime());
			result = DAO.insSingle(temp);
		}
		responsePW(response, result);
	}
}
