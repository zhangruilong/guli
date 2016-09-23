package com.server.action;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.server.poco.GoodsclassPoco;
import com.server.pojo.Ccustomer;
import com.server.pojo.Company;
import com.server.pojo.Customer;
import com.server.pojo.Goodsclass;
import com.system.tools.CommonConst;
import com.system.tools.pojo.Pageinfo;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.pojo.Treeinfo;
import com.system.tools.util.CommonUtil;

/**
 * 大小类 逻辑层
 *@author ZhangRuiLong
 */
public class GLGoodsclassAction extends GoodsclassAction {

	/**
    * 模糊查询语句
    * @param query
    * @return "filedname like '%query%' or ..."
    */
    public String getQuerysql(String query) {
    	if(CommonUtil.isEmpty(query)) return null;
    	String querysql = "";
    	String queryfieldname[] = GoodsclassPoco.QUERYFIELDNAME;
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
	//获取权限树
	public void selTree(HttpServletRequest request, HttpServletResponse response){
		String node = request.getParameter("node");
		if(node.equals("root")){
			String wheresql = " goodsclassparent='root'";
			result = CommonConst.GSON.toJson(selTree(wheresql),TYPE);
		}else{
			String wheresql = " goodsclassparent='" + node + "'";
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
			sql = "select * from "+GoodsclassPoco.TABLE+" where 1=1 ";
			if(CommonUtil.isNotEmpty(wheresql)){
				sql = sql + " and (" + wheresql + ") ";
			}
			sql += " order by " + GoodsclassPoco.ORDER; 
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				String leaf = "true";
				String selchildwheresql = "Goodsclassparent='" + rs.getString("Goodsclassid") + "'";
				if(selTree(selchildwheresql).size()!=0){
					leaf = null;
				}
				temp = new Treeinfo(rs.getString("Goodsclassid"), rs.getString("Goodsclasscode"), rs.getString("Goodsclassname"), rs.getString("Goodsclassdetail"),
						null, null, null,leaf, rs.getString("Goodsclassparent"));
				temps.add(temp);
			}
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally{
			connectionMan.freeConnection(CommonConst.DSNAME,conn,stmt,rs);
			return temps;
		}
	};
	//查询所有
	@SuppressWarnings("unchecked")
	public void mselAll(HttpServletRequest request, HttpServletResponse response){
		String cusid = request.getParameter("cusid");
		List<Ccustomer> comLi = selAll(Ccustomer.class,"select * from ccustomer cc where cc.ccustomercustomer='"+cusid+"'");
		if(comLi.size()>0){
			String addSql = request.getParameter("wheresql")+" and (";
			for (Ccustomer cc : comLi) {
				addSql += "goodsclasscompany like '%"+cc.getCcustomercompany()+"%' or ";
			}
			addSql = addSql.substring(0,addSql.length()-3)+")";
			
			Queryinfo queryinfo = getQueryinfo(request);
			queryinfo.setWheresql(addSql);
			queryinfo.setType(Goodsclass.class);
			queryinfo.setQuery(getQuerysql(queryinfo.getQuery()));
			queryinfo.setOrder("goodsclassorder,goodsclassid desc");
			Pageinfo pageinfo = new Pageinfo(0, selAll(queryinfo));
			result = CommonConst.GSON.toJson(pageinfo);
		}
		mresponsePW(request, response, result);
	}
}
