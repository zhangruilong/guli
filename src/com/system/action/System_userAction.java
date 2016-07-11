package com.system.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.system.dao.System_menuDao;
import com.system.dao.System_power_quickDao;
import com.system.dao.System_roleuserDao;
import com.system.pojo.System_power_quickview;
import com.system.dao.System_roleuserviewDao;
import com.system.dao.System_userDao;
import com.system.poco.System_power_quickviewPoco;
import com.system.poco.System_userPoco;
import com.system.pojo.System_roleuserview;
import com.system.pojo.System_user;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseAction;
import com.system.tools.pojo.Fileinfo;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.pojo.Treeinfo;
import com.system.tools.util.CipherUtil;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.FileUtil;
import com.system.tools.util.TypeUtil;

/**
 * 用户 逻辑层
 *@author ZhangRuiLong
 */
public class System_userAction extends BaseAction {
	public String result = CommonConst.FAILURE;
	public ArrayList<System_user> cuss = null;
	public System_userDao DAO = new System_userDao();
	public java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<ArrayList<System_user>>() {}.getType();
	
	//将json转换成cuss
	public void json2cuss(HttpServletRequest request){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
	}
	//新增
	public void insAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		String pwd = CipherUtil.generatePassword("1");
		for(System_user temp:cuss){
			temp.setId(CommonUtil.getNewId());
			temp.setPassword(pwd);
			result = DAO.insSingle(temp);
		}
		responsePW(response, result);
	}
	//删除
	public void delAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(System_user temp:cuss){
			result = DAO.delSingle(temp,System_userPoco.KEYCOLUMN);
		}
		responsePW(response, result);
	}
	//修改
	public void updAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		String resetpassword = request.getParameter("resetpassword"); 
		if(CommonUtil.isNotEmpty(resetpassword)){
			cuss.get(0).setPassword(CipherUtil.generatePassword("1"));
			result = DAO.updSingle(cuss.get(0),System_userPoco.KEYCOLUMN);
		}else{
			result = DAO.updSingle(cuss.get(0),System_userPoco.KEYCOLUMN);
		}
		responsePW(response, result);
	}
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(System_user.class);
		queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(System_userPoco.ORDER);
		cuss = (ArrayList<System_user>) DAO.selAll(queryinfo);
		FileUtil.expExcel(response,cuss,System_userPoco.CHINESENAME,System_userPoco.KEYCOLUMN,System_userPoco.NAME);
	}
	//导入
	public void impAll(HttpServletRequest request, HttpServletResponse response){
		Fileinfo fileinfo = FileUtil.upload(request,0,null,System_userPoco.NAME,"impAll");
		String json = FileUtil.impExcel(fileinfo.getPath(),System_userPoco.FIELDNAME); 
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(System_user temp:cuss){
			temp.setId(CommonUtil.getNewId());
			result = DAO.insSingle(temp);
		}
		responsePW(response, result);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(System_user.class);
		queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(System_userPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, DAO.selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(System_user.class);
		queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(System_userPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(DAO.getTotal(queryinfo), DAO.selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//初始化密码
	public void resetpassword(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		String  pwd = CipherUtil.generatePassword("1");
		for(System_user temp : cuss){
			temp.setPassword(pwd);
			result = DAO.updSingle(temp,System_userPoco.KEYCOLUMN);
		}
		responsePW(response, result);
	}
	//用户自己修改密码
	public void setpassword(HttpServletRequest request, HttpServletResponse response){
		System_user user = getCurrentUser(request);
		if(CommonUtil.isNotEmpty(user)){
			String password = request.getParameter("password"); 
			String oldpassword = request.getParameter("oldpassword");
			String userid = user.getId();
			String  oldpwd = CipherUtil.generatePassword(oldpassword);
			if(oldpwd.equals(user.getPassword())){
				System_user temp = new System_user();
		        String  pwd = CipherUtil.generatePassword(password);
		        temp.setPassword(pwd);
		        temp.setId(userid);
		        result = DAO.updSingle(temp);
			}else{
				result = "原密码错误！";
			}
		}
		responsePW(response, result);
	}
	//该角色不包含的用户
	public void selQueryRemoveRoleuser(HttpServletRequest request, HttpServletResponse response){
		//查询所有改角色包含的用户
		String roleid = request.getParameter("roleid");
		Queryinfo roleusercussqueryinfo = new Queryinfo();
		roleusercussqueryinfo.setType(System_roleuserview.class);
		roleusercussqueryinfo.setWheresql(" roleid='" + roleid + "'");
		ArrayList<System_roleuserview> roleusercuss = (ArrayList<System_roleuserview>) new System_roleuserviewDao().selAll(roleusercussqueryinfo);
		//分页查询用户表
		Queryinfo usercussqueryinfo = getQueryinfo(request);
		usercussqueryinfo.setType(System_user.class);
		usercussqueryinfo.setQuery(DAO.getQuerysql(usercussqueryinfo.getQuery()));
		usercussqueryinfo.setOrder(System_userPoco.ORDER);
		ArrayList<System_user> usercuss = (ArrayList<System_user>) DAO.selQuery(usercussqueryinfo);
		//遍历出该角色不包含的用户
		ArrayList<System_user> removeusercuss = new ArrayList<System_user>();
		int removenum = 0;//总条数
		for(System_user temp:usercuss){
			for(System_roleuserview roleusertemp:roleusercuss){
				if(temp.getId().equals(roleusertemp.getUserid())){
					removeusercuss.add(temp);
					removenum++;
				}
			}
		}
		usercuss.removeAll(removeusercuss);//得到该角色不包含的用户
		Pageinfo pageinfo = new Pageinfo(DAO.getTotal(usercussqueryinfo)-removenum, usercuss);
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//登入控制
	public void login(HttpServletRequest request, HttpServletResponse response){
		response.setContentType("text/html;charset=utf-8");
		response.setHeader("Cache-Control", "no-cache");
		String rand = (String)request.getSession().getAttribute("rand");
		String input = request.getParameter("input");
		input = input.toLowerCase();
		if(input.equals(rand)){
			//查询验证用户
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String  pwd = CipherUtil.generatePassword(password);
			String wheresql = "statue = '启用' and loginname = '" + username
					+ "' and password = '" + pwd + "'";
			Queryinfo queryinfo = getQueryinfo(request);
			queryinfo.setType(System_user.class);
			queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
			queryinfo.setOrder(System_userPoco.ORDER);
			queryinfo.setWheresql(wheresql);
			cuss = (ArrayList<System_user>) DAO.selAll(queryinfo);
			if(cuss.size()==0){
				responsePW(response, CommonConst.PASSWORDERRO);
			}else{
				System_user temp = cuss.get(0);
				String userid = temp.getId();
				//if(userid.equals("1")) userid = null;
				ArrayList<Treeinfo> buttonpower = new System_menuDao().selMenu("按钮权限",null,userid);
				ArrayList<Treeinfo> datapower = new System_menuDao().selMenu("数据权限",null,userid);
				Queryinfo quickviewqueryinfo = new Queryinfo();
				quickviewqueryinfo.setType(System_power_quickview.class);
				quickviewqueryinfo.setWheresql("userid='" + temp.getId() + "'");
				quickviewqueryinfo.setOrder(System_power_quickviewPoco.ORDER);
				ArrayList<System_power_quickview> quickmenu = (ArrayList<System_power_quickview>) new System_power_quickDao().selAll(quickviewqueryinfo);
				HttpSession session = request.getSession();
				session.setAttribute("buttonpower", buttonpower); //存
				session.setAttribute("datapower", datapower); //存
				session.setAttribute("user", temp); //存
				session.setAttribute("userid", temp.getId()); //存
				session.setAttribute("username", temp.getUsername()); //存
				session.setAttribute("quickmenu", quickmenu); //存
				responsePW(response, CommonConst.SUCCESS);
			}
		}else {
			responsePW(response, CommonConst.INPUTEERRO);
		}
	}
	//登入控制
	public void mlogin(HttpServletRequest request, HttpServletResponse response){
		response.setContentType("text/html;charset=utf-8");
		response.setHeader("Cache-Control", "no-cache");
		//查询验证用户
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String  pwd = CipherUtil.generatePassword(password);
		String wheresql = "statue = '启用' and loginname = '" + username
				+ "' and password = '" + pwd + "'";
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(System_user.class);
		queryinfo.setQuery(DAO.getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(System_userPoco.ORDER);
		queryinfo.setWheresql(wheresql);
		cuss = (ArrayList<System_user>) DAO.selAll(queryinfo);
		if(cuss.size()==0){
			mresponsePW(request, response, CommonConst.PASSWORDERRO);
		}else{
			Pageinfo pageinfo = new Pageinfo(0,cuss);
			result = CommonConst.GSON.toJson(pageinfo);
			mresponsePW(request, response, result);
		}
	}
}
