package com.server.action;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.CityPoco;
import com.server.pojo.City;
import com.system.tools.CommonConst;
import com.system.tools.base.BaseActionDao;
import com.system.tools.pojo.Fileinfo;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.pojo.Treeinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.FileUtil;

/**
 * 城市和县及街道 逻辑层
 *@author ZhangRuiLong
 */
public class CityAction extends BaseActionDao {
	public String result = CommonConst.FAILURE;
	public ArrayList<City> cuss = null;
	public java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<ArrayList<City>>() {}.getType();

	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = CityPoco.QUERYFIELDNAME;
    	for(int i=0;i<queryfieldname.length;i++){
    		querysql += queryfieldname[i] + " like '%" + query + "%' or ";
    	}
		return querysql.substring(0, querysql.length() - 4);
	};
	//将json转换成cuss
	public void json2cuss(HttpServletRequest request){
		String json = request.getParameter("json");
		System.out.println("json : " + json);
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
	}
	//新增
	public void insAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(City temp:cuss){
			temp.setCityid(CommonUtil.getNewId());
			result = insSingle(temp);
		}
		responsePW(response, result);
	}
	//删除
	public void delAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		for(City temp:cuss){
			result = delSingle(temp,CityPoco.KEYCOLUMN);
		}
		responsePW(response, result);
	}
	//修改
	public void updAll(HttpServletRequest request, HttpServletResponse response){
		json2cuss(request);
		result = updSingle(cuss.get(0),CityPoco.KEYCOLUMN);
		responsePW(response, result);
	}
	//导出
	public void expAll(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(City.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(CityPoco.ORDER);
		cuss = (ArrayList<City>) selAll(queryinfo);
		FileUtil.expExcel(response,cuss,CityPoco.CHINESENAME,CityPoco.KEYCOLUMN,CityPoco.NAME);
	}
	//导入
	public void impAll(HttpServletRequest request, HttpServletResponse response){
		Fileinfo fileinfo = FileUtil.upload(request,0,null,CityPoco.NAME,"impAll");
		String json = FileUtil.impExcel(fileinfo.getPath(),CityPoco.FIELDNAME); 
		if(CommonUtil.isNotEmpty(json)) cuss = CommonConst.GSON.fromJson(json, TYPE);
		for(City temp:cuss){
			temp.setCityid(CommonUtil.getNewId());
			result = insSingle(temp);
		}
		responsePW(response, result);
	}
	//查询所有
	public void selAll(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(City.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(CityPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
	}
	//分页查询
	public void selQuery(HttpServletRequest request, HttpServletResponse response){
		Queryinfo queryinfo = getQueryinfo(request);
		queryinfo.setType(City.class);
		queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
		queryinfo.setOrder(CityPoco.ORDER);
		Pageinfo pageinfo = new Pageinfo(getTotal(queryinfo), selQuery(queryinfo));
		result = CommonConst.GSON.toJson(pageinfo);
		responsePW(response, result);
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
