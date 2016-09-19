package com.server.action;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.CityPoco;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Treeinfo;
import com.system.tools.util.CommonUtil;

/**
 * 城市和县及街道 逻辑层
 *@author ZhangRuiLong
 */
public class GLCityAction extends CityAction {

	//将json转换成cuss
	public void json2cuss(HttpServletRequest request){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
	}
	//获取权限树
	public void selTree(HttpServletRequest request, HttpServletResponse response){
		String node = request.getParameter("node");
		if(node.equals("root")){
			String wheresql = " cityparent='root'";
			result = CommonConst.GSON.toJson(selTree(wheresql),TYPE);
		}else{
			String wheresql = " cityparent='" + node + "'";
			result = CommonConst.GSON.toJson(selTree(wheresql),TYPE);		
		}
		responsePW(response, result);
	}
	public ArrayList<Treeinfo> selTree(String wheresql) {
		String sql = null;
		Treeinfo temp = null;
		ArrayList<Treeinfo> temps = new ArrayList<Treeinfo>();
		Connection  conn=connectionMan.getConnection(CommonConst.DSNAME); 
		Statement stmt = null;
		ResultSet rs = null;
		try {
			sql = "select * from "+CityPoco.TABLE+" where 1=1 ";
			if(CommonUtil.isNotEmpty(wheresql)){
				sql = sql + " and (" + wheresql + ") ";
			}
			sql += " order by " + CityPoco.ORDER; 
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				String leaf = "true";
				String selchildwheresql = "cityparent='" + rs.getString("cityid") + "'";
				if(selTree(selchildwheresql).size()!=0){
					leaf = null;
				}
				temp = new Treeinfo(rs.getString("cityid"), rs.getString("citycode"), rs.getString("cityname"), rs.getString("citydetail"),
						null, null, null,leaf, rs.getString("cityparent"));
				temps.add(temp);
			}
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally{
			connectionMan.freeConnection(CommonConst.DSNAME,conn,stmt,rs);
			return temps;
		}
	};
	//手机端index页面的 县 
	/*public void indexXianQu(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(City.class);
		Pageinfo pageinfo = new Pageinfo(0, selAll("select ct.* from city ct left outer join city ct2 on ct.cityparent = ct2.cityid",queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}*/
}
