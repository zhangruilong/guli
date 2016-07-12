package com.system.tools.base;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.formula.functions.T;

import com.system.tools.CommonConst;
import com.system.tools.dba.DBConnectionManager;
import com.system.tools.pojo.BeanToArray;
import com.system.tools.pojo.Queryinfo;
import com.system.tools.util.CommonUtil;
import com.system.tools.util.TypeUtil;

public class BaseDao {
	public static DBConnectionManager connectionMan = DBConnectionManager.getInstance();

	public Queryinfo checkQueryinfo(Queryinfo queryinfo) {
		if(CommonUtil.isEmpty(queryinfo.getStart())){
			queryinfo.setStart("0");
		}
		if(CommonUtil.isEmpty(queryinfo.getEnd())){
			queryinfo.setEnd("20");
		}
		return queryinfo;
	}
	
	@SuppressWarnings("finally")
	public int getTotal(Queryinfo queryinfo) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		int total = 0;
		try {
			sql = "SELECT count(*) AS rowcount FROM " + queryinfo.getType().getSimpleName() + " where 1=1 ";
			if(CommonUtil.isNotEmpty(queryinfo.getWheresql())){
				sql += " and (" + queryinfo.getWheresql() + ") ";
			}
			if(CommonUtil.isNotEmpty(queryinfo.getQuery())){
				sql += " and (" + queryinfo.getQuery() + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			total = rs.getInt(1);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return total;
		}
	}
	public Object rsToObj(Class type, Field[] field, ResultSet rs) {
		try {
			Object obj = type.newInstance();  
			 for (int i = 0; i < field.length; i++) {  
		            //得到属性名  
				 	String fieldname = field[i].getName();  
		            //包装成SetXXX方法  
		            String methodname="set"+fieldname.substring(0,1).toUpperCase()+fieldname.substring(1);  
		            //得到类型  
		            Class  c = field[i].getType();  
		            //得到方法  
		            Method method= type.getMethod(methodname, c);  
		            if(c == String.class){ 
		            	try {
		            		method.invoke(obj, rs.getString(fieldname)); 
		            	} catch (Exception e) {
		        		}
		            }else if(c == int.class){  
		            	try {
		                method.invoke(obj, rs.getInt(fieldname));  
		            	} catch (Exception e) {
		        		}
		            }else if(c == float.class){  
		            	try {
		                method.invoke(obj, rs.getFloat(fieldname));  
		            } catch (Exception e) {
	        		}
		            }else if(c == double.class){  
		            	try {
		                method.invoke(obj, rs.getDouble(fieldname));  
		            } catch (Exception e) {
	        		}
		            }else if(c == java.sql.Date.class){  
		            	try {
		                method.invoke(obj, rs.getDate(fieldname));  
		            } catch (Exception e) {
	        		}
		            }else if(c == boolean.class){  
		            	try {
		                method.invoke(obj, rs.getBoolean(fieldname));  
		            } catch (Exception e) {
	        		}
		            }else if(c == byte.class){ 
		            	try {
		                method.invoke(obj, rs.getBytes(fieldname));  
		            } catch (Exception e) {
	        		}
		            }else if(c == char.class){  
		            	try {
		                method.invoke(obj, rs.getCharacterStream(fieldname));  
		            } catch (Exception e) {
	        		}
		            }else{  
		            	try {
		                method.invoke(obj, rs.getObject(fieldname));
		            } catch (Exception e) {
	        		}
		            }  
		        }
			 return obj;
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
			return null;
		}
	}
	@SuppressWarnings("finally")
	public List selQuery(Queryinfo queryinfo) {
		Connection  conn=connectionMan.getConnection(CommonConst.DSNAME); 
		Statement stmt = null;
		ResultSet rs = null;
		List objs = new ArrayList();
		queryinfo = checkQueryinfo(queryinfo);
		try {
			String sql = "select * from (select A.*, ROWNUM RN from (select * from " + 
						 	queryinfo.getType().getSimpleName() + " where 1=1 ";
			if(CommonUtil.isNotEmpty(queryinfo.getWheresql())){
				sql += " and (" + queryinfo.getWheresql() + ") ";
			}
			if(CommonUtil.isNotEmpty(queryinfo.getQuery())){
				sql += " and (" + queryinfo.getQuery() + ") ";
			}
			if(CommonUtil.isNotEmpty(queryinfo.getOrder())){
				sql += " order by " + queryinfo.getOrder();
			}
			if(queryinfo.getEnd().equals("0"))
				sql = sql+") A where ROWNUM  > "+queryinfo.getEnd()+" ) ";
			else
				sql = sql+") A where ROWNUM  <= "+queryinfo.getEnd()+" ) where RN > "+queryinfo.getStart();
			stmt = conn.createStatement();
			System.out.println(sql);
			rs = stmt.executeQuery(sql);
			//所有的属性  
	        Field[] field = queryinfo.getType().getDeclaredFields(); 
			while (rs.next()) {
				objs.add(this.rsToObj(queryinfo.getType(), field, rs));
			}
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally{
			connectionMan.freeConnection(CommonConst.DSNAME,conn,stmt,rs);
			return objs;
		}
	}
	@SuppressWarnings("finally")
	public List selQuery(Queryinfo queryinfo,String selectsql) {
		Connection  conn=connectionMan.getConnection(CommonConst.DSNAME); 
		Statement stmt = null;
		ResultSet rs = null;
		List objs = new ArrayList();
		queryinfo = checkQueryinfo(queryinfo);
		try {
			String sql = "select * from (select A.*, ROWNUM RN from (" + selectsql;
			if(queryinfo.getEnd().equals("0"))
				sql += ") A where ROWNUM  > "+queryinfo.getEnd()+" ) ";
			else
				sql += ") A where ROWNUM  <= "+queryinfo.getEnd()+" ) where RN > "+queryinfo.getStart();
			stmt = conn.createStatement();
			System.out.println(sql);
			rs = stmt.executeQuery(sql);
			//所有的属性  
	        Field[] field = queryinfo.getType().getDeclaredFields(); 
			while (rs.next()) {
				objs.add(this.rsToObj(queryinfo.getType(), field, rs));
			}
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally{
			connectionMan.freeConnection(CommonConst.DSNAME,conn,stmt,rs);
			return objs;
		}
	}
	@SuppressWarnings("finally")
	public List selAll(Queryinfo queryinfo) {
		Connection  conn=connectionMan.getConnection(CommonConst.DSNAME); 
		Statement stmt = null;
		ResultSet rs = null;
		List objs = new ArrayList();
		try {
			String sql = "select * from " + queryinfo.getType().getSimpleName() + " where 1=1 ";
			if(CommonUtil.isNotEmpty(queryinfo.getWheresql())){
				sql += " and (" + queryinfo.getWheresql() + ") ";
			}
			if(CommonUtil.isNotEmpty(queryinfo.getQuery())){
				sql += " and (" + queryinfo.getQuery() + ") ";
			}
			if(CommonUtil.isNotEmpty(queryinfo.getOrder())){
				sql += " order by " + queryinfo.getOrder();
			}
			stmt = conn.createStatement();
			System.out.println(sql);
			rs = stmt.executeQuery(sql);
			//所有的属性  
	        Field[] field = queryinfo.getType().getDeclaredFields(); 
			while (rs.next()) {
				objs.add(this.rsToObj(queryinfo.getType(), field, rs));
			}
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally{
			connectionMan.freeConnection(CommonConst.DSNAME,conn,stmt,rs);
	        return objs;
		}
	}
	@SuppressWarnings("finally")
	public List selAll(Class type, String selectsql) {
		Connection  conn=connectionMan.getConnection(CommonConst.DSNAME); 
		Statement stmt = null;
		ResultSet rs = null;
		List objs = new ArrayList();
		try {
			stmt = conn.createStatement();
			System.out.println(selectsql);
			rs = stmt.executeQuery(selectsql);
			//所有的属性  
	        Field[] field = type.getDeclaredFields(); 
			while (rs.next()) {
				objs.add(this.rsToObj(type, field, rs));
			}
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally{
			connectionMan.freeConnection(CommonConst.DSNAME,conn,stmt,rs);
	        return objs;
		}
	}
	/**
	 * 获取TABLE的date类型fieldname的最大值
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最大的date
	 */
	@SuppressWarnings("finally")
	public Date getMaxDate(String DSNAME, String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		Date maxcode = null;
		try {
			sql = "SELECT max(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				maxcode = rs.getDate(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(DSNAME, conn, stmt, rs);
			return maxcode;
		}
	}

	/**
	 * 获取TABLE的date类型fieldname的最小值
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最小的date
	 */
	@SuppressWarnings("finally")
	public Date getMinDate(String DSNAME, String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		Date mincode = null;
		try {
			sql = "SELECT min(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				mincode = rs.getDate(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(DSNAME, conn, stmt, rs);
			return mincode;
		}
	}

	/**
	 * 获取TABLE的int类型fieldname的最大值
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最大的int
	 */
	@SuppressWarnings("finally")
	public int getMaxInt(String DSNAME, String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		int maxcode = 0;
		try {
			sql = "SELECT max(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				maxcode = rs.getInt(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(DSNAME, conn, stmt, rs);
			return maxcode;
		}
	}

	/**
	 * 获取TABLE的日期类型fieldname的最小值
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最小的int
	 */
	@SuppressWarnings("finally")
	public int getMinInt(String DSNAME, String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		int mincode = 0;
		try {
			sql = "SELECT min(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				mincode = rs.getInt(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(DSNAME, conn, stmt, rs);
			return mincode;
		}
	}

	/**
	 * 获取TABLE的String类型fieldname的最大值
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最大的String
	 */
	@SuppressWarnings("finally")
	public String getMaxString(String DSNAME, String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		String maxcode = null;
		try {
			sql = "SELECT max(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				maxcode = rs.getString(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(DSNAME, conn, stmt, rs);
			return maxcode;
		}
	}

	/**
	 * 获取TABLE的String类型fieldname的最小值
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最小的String
	 */
	@SuppressWarnings("finally")
	public String getMinString(String DSNAME, String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		String mincode = null;
		try {
			sql = "SELECT min(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				mincode = rs.getString(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(DSNAME, conn, stmt, rs);
			return mincode;
		}
	}

	/**
	 * 获取TABLE的数据总条数
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 条数
	 */
	@SuppressWarnings("finally")
	public int getTotal(String DSNAME, String TABLE, String wheresql, String querysql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		int total = 0;
		try {
			sql = "SELECT count(*) AS rowcount FROM " + TABLE + " where 1=1 ";
			if(CommonUtil.isNotEmpty(wheresql)){
				sql += " and (" + wheresql + ") ";
			}
			if(CommonUtil.isNotEmpty(querysql)){
				sql += " and (" + querysql + ")";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			total = rs.getInt(1);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(DSNAME, conn, stmt, rs);
			return total;
		}
	}

	/**
	 * 将dataobj插入到TABLE表
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param dataobj 要新增的实体对象
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE 
	 */
	public String insSingle(String DSNAME, String TABLE, Object dataobj) {
		BeanToArray beanToArray = TypeUtil.beanToList(dataobj);
		String sql = "insert into " + TABLE + " (";
		String names = "";
		String values = "";
		for (int i = 0; i < beanToArray.getBeanNames().size(); i++) {
			names = names + beanToArray.getBeanNames().get(i) + ",";
			values = values + "?,";
		}
		sql = sql + names.substring(0, names.length() - 1) + ") values ("
				+ values.substring(0, values.length() - 1) + ")";
		return doSingle(DSNAME, sql, beanToArray.getValues());
	}

	/**
	 * 删除TABLE表的数据
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param whereobj where条件后面实体对象
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String delSingle(String DSNAME, String TABLE, Object whereobj) {
		String sql = "delete from " + TABLE;
		BeanToArray wherebeanToArray = TypeUtil.beanToList(whereobj);
		String where = " where 1=1 ";
		for (int i = 0; i < wherebeanToArray.getBeanNames().size(); i++) {
			where = where + " and " + wherebeanToArray.getBeanNames().get(i)
					+ "=? ";
		}
		sql = sql + where;
		return doSingle(DSNAME, sql, wherebeanToArray.getValues());
	}

	/**
	 * 删除TABLE表的数据
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @param param 参数集合
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String delSingle(String DSNAME, String TABLE, String wheresql,
			Object... param) {
		String sql = "delete from " + TABLE + " where " + wheresql;
		return doSingle(DSNAME, sql, param);
	}

	/**
	 * 删除TABLE表的数据
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param whereobj pojo中有联合主键,whereobj有where属性,where条件后面实体对象
	 * @param primaryKeys 主键
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String delSingle(String DSNAME, String TABLE, Object whereobj,
			String[] primaryKeys) {
		String sql = "delete from " + TABLE + " where 1=1 ";
		BeanToArray wherebeanToArray = TypeUtil.beanToList(whereobj);
		List wherevalues = new ArrayList();
		for (int i = 0; i < wherebeanToArray.getBeanNames().size(); i++) {
			String beanName = (String) wherebeanToArray.getBeanNames().get(i);
			for (int j = 0; j < primaryKeys.length; j++) {
				if (primaryKeys[j].equals(beanName)) {
					wherevalues.add(wherebeanToArray.getValues().get(i));
					sql += " and " + primaryKeys[j] + "=? ";
					break;
				}
			}
		}
		return doSingle(DSNAME, sql, wherevalues);
	}
	
	/**
	 * 修改TABLE表的数据
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param whereobj pojo中有id是唯一主键，且id的位置在第一个
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String updSingle(String DSNAME, String TABLE, Object obj) {
		BeanToArray beanToArray = TypeUtil.beanToList(obj);
		String sql = "update " + TABLE + " set ";
		String where = beanToArray.getBeanNames().get(0) + "=? ";
		String set = "";
		for (int i = 1; i < beanToArray.getBeanNames().size(); i++) {// 从i=1开始
			set = set + beanToArray.getBeanNames().get(i) + "=?,";
		}
		sql = sql + set.substring(0, set.length() - 1) + " where " + where;
		List values = beanToArray.getValues();
		Object id = values.get(0);
		values.remove(0);
		values.add(id);
		return doSingle(DSNAME, sql, values);
	}

	/**
	 * 修改TABLE表的数据
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param obj pojo中有联合主键,obj有全部属性
	 * @param primaryKeys 主键
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String updSingle(String DSNAME, String TABLE, Object obj,
			String[] primaryKeys) {
		String sql = "update " + TABLE;
		String set = " set ";
		String where = " where 1=1 ";
		BeanToArray beanToArray = TypeUtil.beanToList(obj);
		List values = new ArrayList();
		List wherevalues = new ArrayList();
		List valuestemps = beanToArray.getValues();
		for (int i = 0; i < beanToArray.getBeanNames().size(); i++) {
			String beanName = (String) beanToArray.getBeanNames().get(i);
			for (int j = 0; j < primaryKeys.length; j++) {
				if (primaryKeys[j].equals(beanName)) {
					wherevalues.add(valuestemps.get(i));
					where = where + " and " + primaryKeys[j] + "=? ";
					break;
				} else if (j == (primaryKeys.length - 1)) {
					values.add(valuestemps.get(i));
					set = set + beanToArray.getBeanNames().get(i) + "=?,";
				}
			}
		}
		// 拼接where到set后面
		for (Object wherevaluestemp : wherevalues) {
			values.add(wherevaluestemp);
		}
		sql = sql + set.substring(0, set.length() - 1) + where;
		return doSingle(DSNAME, sql, values);
	}

	/**
	 * 修改TABLE表的数据
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param dataobj 数据对象,dataobj中主键属性的值为null
	 * @param whereobj pojo中有联合主键,数据Object和主键Object分开，dataobj中主键属性的值为null
	 * @param primaryKeys 主键
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String updSingle(String DSNAME, String TABLE, Object dataobj,
			Object whereobj) {
		String sql = "update " + TABLE;
		// set 数据列表
		BeanToArray beanToArray = TypeUtil.beanToList(dataobj);
		String set = " set ";
		for (int i = 0; i < beanToArray.getBeanNames().size(); i++) {
			set = set + beanToArray.getBeanNames().get(i) + "=?,";
		}
		// where 条件
		BeanToArray wherebeanToArray = TypeUtil.beanToList(whereobj);
		String where = " where 1=1 ";
		for (int i = 0; i < wherebeanToArray.getBeanNames().size(); i++) {
			where = where + " and " + wherebeanToArray.getBeanNames().get(i)
					+ "=? ";
		}

		sql = sql + set.substring(0, set.length() - 1) + where;
		// 拼接where到set后面
		List values = beanToArray.getValues();
		List wherevalues = wherebeanToArray.getValues();
		values.add(wherevalues);
		return doSingle(DSNAME, sql, values);
	}

	/**
	 * 修改TABLE表的数据
	 * @param DSNAME 数据源
	 * @param TABLE 表名
	 * @param datasql 指update table set 后面跟的字符串，例如fieldname='test'
	 * @param wheresql 指where后面跟的字符串，例如fieldname='test'
	 * @param param 参数集合
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String updSingle(String DSNAME, String TABLE, String datasql,
			String wheresql, Object... param) {
		String sql = "update " + TABLE + " set " + datasql + " where "
				+ wheresql;
		return doSingle(DSNAME, sql, param);
	}

	/**
	 * 执行一条sql语句
	 * @param DSNAME 数据源
	 * @param sql sql语句
	 * @param param 参数集合
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	@SuppressWarnings("finally")
	public String doSingle(String DSNAME, String sql, List param) {
		String result = CommonConst.FAILURE;
		Connection conn = connectionMan.getConnection(DSNAME);
		PreparedStatement pstmt = null;
		try {
			System.out.println(sql);
			pstmt = conn.prepareStatement(sql);
			if (param != null) {
				for (int i = 0; i < param.size(); i++) {
					pstmt.setObject(i + 1, param.get(i));
				}
			}
			int num = pstmt.executeUpdate();
			System.out.println("executeUpdate: " + num + " records！");
			if (num > 0) {
				result = CommonConst.SUCCESS;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			connectionMan.freeConnection(DSNAME, conn, pstmt);
			return result;
		}
	}

	/**
	 * 执行一条sql语句
	 * @param DSNAME 数据源
	 * @param sql sql语句
	 * @param param 参数集合
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	@SuppressWarnings("finally")
	public String doSingle(String DSNAME, String sql, Object... param) {
		String result = CommonConst.FAILURE;
		Connection conn = connectionMan.getConnection(DSNAME);
		PreparedStatement pstmt = null;
		try {
			System.out.println(sql);
			pstmt = conn.prepareStatement(sql);
			if (param != null) {
				for (int i = 0; i < param.length; i++) {
					pstmt.setObject(i + 1, param[i]);
				}
			}
			int num = pstmt.executeUpdate();
			System.out.println("executeUpdate: " + num + " records！");
			if (num > 0) {
				result = CommonConst.SUCCESS;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			connectionMan.freeConnection(DSNAME, conn, pstmt);
			return result;
		}
	}
//*****************为单个数据源DSNAME时让开发人员不传DSNAME而写
	/**
	 * 获取TABLE的date类型fieldname的最大值
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最大的date
	 */
	@SuppressWarnings("finally")
	public Date getMaxDate(String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		Date maxcode = null;
		try {
			sql = "SELECT max(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				maxcode = rs.getDate(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return maxcode;
		}
	}

	/**
	 * 获取TABLE的date类型fieldname的最小值
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最小的date
	 */
	@SuppressWarnings("finally")
	public Date getMinDate(String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		Date mincode = null;
		try {
			sql = "SELECT min(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				mincode = rs.getDate(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return mincode;
		}
	}

	/**
	 * 获取TABLE的int类型fieldname的最大值
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最大的int
	 */
	@SuppressWarnings("finally")
	public int getMaxInt(String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		int maxcode = 0;
		try {
			sql = "SELECT max(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				maxcode = rs.getInt(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return maxcode;
		}
	}

	/**
	 * 获取TABLE的int类型fieldname的最小值
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最小的int
	 */
	@SuppressWarnings("finally")
	public int getMinInt(String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		int mincode = 0;
		try {
			sql = "SELECT min(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				mincode = rs.getInt(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return mincode;
		}
	}

	/**
	 * 获取TABLE的String类型fieldname的最大值
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最大的String
	 */
	@SuppressWarnings("finally")
	public String getMaxString(String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		String maxcode = null;
		try {
			sql = "SELECT max(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql = sql + " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				maxcode = rs.getString(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return maxcode;
		}
	}

	/**
	 * 获取TABLE的String类型fieldname的最小值
	 * @param TABLE 表名
	 * @param fieldname 所要查找的自动
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 最小的String
	 */
	@SuppressWarnings("finally")
	public String getMinString(String TABLE, String fieldname,
			String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		String mincode = null;
		try {
			sql = "SELECT min(" + fieldname + ") FROM " + TABLE
					+ " where 1 = 1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql += " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next())
				mincode = rs.getString(fieldname);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return mincode;
		}
	}

	/**
	 * 获取TABLE的数据总条数
	 * @param TABLE 表名
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 条数
	 */
	@SuppressWarnings("finally")
	public int getTotal(String TABLE, String wheresql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		int total = 0;
		try {
			sql = "SELECT count(*) AS rowcount FROM " + TABLE + " where 1=1 ";
			if (CommonUtil.isNotEmpty(wheresql)) {
				sql += " and (" + wheresql + ") ";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			total = rs.getInt(1);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return total;
		}
	}
	/**
	 * 获取TABLE的数据总条数
	 * @param TABLE 表名
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @return 条数
	 */
	@SuppressWarnings("finally")
	public int getTotal(String TABLE, String wheresql, String querysql) {
		String sql = null;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		Statement stmt = null;
		ResultSet rs = null;
		int total = 0;
		try {
			sql = "SELECT count(*) AS rowcount FROM " + TABLE + " where 1=1 ";
			if(CommonUtil.isNotEmpty(wheresql)){
				sql += " and (" + wheresql + ") ";
			}
			if(CommonUtil.isNotEmpty(querysql)){
				sql += " and (" + querysql + ")";
			}
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			total = rs.getInt(1);
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, stmt, rs);
			return total;
		}
	}
	/**
	 * 将dataobj插入TABLE表
	 * @param TABLE 表名
	 * @param dataobj 要新增的实体对象
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String insSingle(Object dataobj) {
		String table = dataobj.getClass().getSimpleName();
		BeanToArray beanToArray = TypeUtil.beanToList(dataobj);
		String sql = "insert into " + table + " (";
		String names = "";
		String values = "";
		for (int i = 0; i < beanToArray.getBeanNames().size(); i++) {
			names = names + beanToArray.getBeanNames().get(i) + ",";
			values = values + "?,";
		}
		sql = sql + names.substring(0, names.length() - 1) + ") values ("
				+ values.substring(0, values.length() - 1) + ")";
		return doSingle(sql, beanToArray.getValues());
	}

	/**
	 * 获取将dataobj插入TABLE表的sql
	 * @param dataobj 要新增的实体对象
	 * @return sql语句
	 */
	public String getInsSingleSql(Object dataobj) {
		String table = dataobj.getClass().getSimpleName();
		BeanToArray beanToArray = TypeUtil.beanToList(dataobj);
		String sql = "insert into " + table + " (";
		String names = "";
		String values = "'";
		for (int i = 0; i < beanToArray.getBeanNames().size(); i++) {
			names += beanToArray.getBeanNames().get(i) + ",";
			values += beanToArray.getValues().get(i) + "','";
		}
		sql += names.substring(0, names.length() - 1) 
			   + ") values ("
			   + values.substring(0, values.length() - 2) 
			   + ")";
		return sql;
	}
	/**
	 * 删除whereobj,TABLE由whereobj.getClass().getSimpleName()获得
	 * @param whereobj where条件后面实体对象
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String delSingle(Object whereobj) {
		String table = whereobj.getClass().getSimpleName();
		String sql = "delete from " + table;
		BeanToArray wherebeanToArray = TypeUtil.beanToList(whereobj);
		String where = " where 1=1 ";
		for (int i = 0; i < wherebeanToArray.getBeanNames().size(); i++) {
			where = where + " and " + wherebeanToArray.getBeanNames().get(i)
					+ "=? ";
		}
		sql = sql + where;
		return doSingle(sql, wherebeanToArray.getValues());
	}

	/**
	 * 删除TABLE表的数据
	 * @param TABLE 表名
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @param param 参数集合
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String delSingle(String TABLE, String wheresql,
			Object... param) {
		String sql = "delete from " + TABLE + " where " + wheresql;
		return doSingle(sql, param);
	}

	/**
	 * 获取删除TABLE表数据的sql
	 * @param TABLE 表名
	 * @param wheresql 指where条件后面字符串fieldname='test1'
	 * @param param 参数集合
	 * @return sql语句
	 */
	public String getDelSingleSql(String TABLE, String wheresql) {
		String sql = "delete from " + TABLE + " where " + wheresql;
		return sql;
	}
	/**
	 * 删除whereobj数据
	 * @param whereobj pojo中有联合主键,whereobj有where属性,where条件后面实体对象
	 * @param primaryKeys 主键
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String delSingle(Object whereobj, String[] primaryKeys) {
		String table = whereobj.getClass().getSimpleName();
		String sql = "delete from " + table + " where 1=1 ";
		BeanToArray wherebeanToArray = TypeUtil.beanToList(whereobj);
		List wherevalues = new ArrayList();
		for (int i = 0; i < wherebeanToArray.getBeanNames().size(); i++) {
			String beanName = (String) wherebeanToArray.getBeanNames().get(i);
			for (int j = 0; j < primaryKeys.length; j++) {
				if (primaryKeys[j].equals(beanName)) {
					wherevalues.add(wherebeanToArray.getValues().get(i));
					sql += " and " + primaryKeys[j] + "=? ";
					break;
				}
			}
		}
		return doSingle(sql, wherevalues);
	}
	/**
	 * 获取删除whereobj数据的sql
	 * @param whereobj pojo中有联合主键,whereobj有where属性,where条件后面实体对象
	 * @param primaryKeys 主键
	 * @return sql语句
	 */
	public String getDelSingleSql(Object whereobj, String[] primaryKeys) {
		String table = whereobj.getClass().getSimpleName();
		String sql = "delete from " + table + " where 1=1 ";
		BeanToArray wherebeanToArray = TypeUtil.beanToList(whereobj);
		for (int i = 0; i < wherebeanToArray.getBeanNames().size(); i++) {
			String beanName = (String) wherebeanToArray.getBeanNames().get(i);
			for (int j = 0; j < primaryKeys.length; j++) {
				if (primaryKeys[j].equals(beanName)) {
					sql += " and " + primaryKeys[j] + "='" + wherebeanToArray.getValues().get(i) + "'";
					break;
				}
			}
		}
		return sql;
	}
	/**
	 * 修改obj数据
	 * @param whereobj pojo中有id是唯一主键，且id的位置在第一个
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String updSingle(Object obj) {
		String table = obj.getClass().getSimpleName();
		BeanToArray beanToArray = TypeUtil.beanToList(obj);
		String sql = "update " + table + " set ";
		String where = beanToArray.getBeanNames().get(0) + "=? ";
		String set = "";
		for (int i = 1; i < beanToArray.getBeanNames().size(); i++) {// 从i=1开始
			set = set + beanToArray.getBeanNames().get(i) + "=?,";
		}
		sql = sql + set.substring(0, set.length() - 1) + " where " + where;
		List values = beanToArray.getValues();
		Object id = values.get(0);
		values.remove(0);
		values.add(id);
		return doSingle(sql, values);
	}

	/**
	 * 修改obj数据
	 * @param obj pojo中有联合主键,obj有全部属性
	 * @param primaryKeys 主键
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String updSingle(Object obj, String[] primaryKeys) {
		String table = obj.getClass().getSimpleName();
		String sql = "update " + table;
		String set = " set ";
		String where = " where 1=1 ";
		BeanToArray beanToArray = TypeUtil.beanToList(obj);
		List values = new ArrayList();
		List wherevalues = new ArrayList();
		List valuestemps = beanToArray.getValues();
		for (int i = 0; i < beanToArray.getBeanNames().size(); i++) {
			String beanName = (String) beanToArray.getBeanNames().get(i);
			for (int j = 0; j < primaryKeys.length; j++) {
				if (primaryKeys[j].equals(beanName)) {
					wherevalues.add(valuestemps.get(i));
					where = where + " and " + primaryKeys[j] + "=? ";
					break;
				} else if (j == (primaryKeys.length - 1)) {
					values.add(valuestemps.get(i));
					set = set + beanToArray.getBeanNames().get(i) + "=?,";
				}
			}
		}
		// 拼接where到set后面
		for (Object wherevaluestemp : wherevalues) {
			values.add(wherevaluestemp);
		}
		sql = sql + set.substring(0, set.length() - 1) + where;
		return doSingle(sql, values);
	}
	/**
	 * 获取修改obj数据的sql
	 * @param obj pojo中有联合主键,obj有全部属性
	 * @param primaryKeys 主键
	 * @return sql语句
	 */
	public String getUpdSingleSql(Object obj, String[] primaryKeys) {
		String table = obj.getClass().getSimpleName();
		String sql = "update " + table;
		String set = " set ";
		String where = " where 1=1 ";
		BeanToArray beanToArray = TypeUtil.beanToList(obj);
		for (int i = 0; i < beanToArray.getBeanNames().size(); i++) {
			String beanName = (String) beanToArray.getBeanNames().get(i);
			for (int j = 0; j < primaryKeys.length; j++) {
				if (primaryKeys[j].equals(beanName)) {
					where += " and " + primaryKeys[j] + "='" + beanToArray.getValues().get(i) + "'";
					break;
				} else if (j == (primaryKeys.length - 1)) {
					set += beanToArray.getBeanNames().get(i) + "='" + beanToArray.getValues().get(i) + "', ";
				}
			}
		}
		sql += set.substring(0, set.length() - 1) + where;
		return sql;
	}
	/**
	 * 修改dataobj数据
	 * @param dataobj 数据对象,dataobj中主键属性的值为null
	 * @param whereobj pojo中有联合主键,数据Object和主键Object分开，dataobj中主键属性的值为null
	 * @param primaryKeys 主键
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String updSingle(Object dataobj, Object whereobj) {
		String table = dataobj.getClass().getSimpleName();
		String sql = "update " + table;
		// set 数据列表
		BeanToArray beanToArray = TypeUtil.beanToList(dataobj);
		String set = " set ";
		for (int i = 0; i < beanToArray.getBeanNames().size(); i++) {
			set = set + beanToArray.getBeanNames().get(i) + "=?,";
		}
		// where 条件
		BeanToArray wherebeanToArray = TypeUtil.beanToList(whereobj);
		String where = " where 1=1 ";
		for (int i = 0; i < wherebeanToArray.getBeanNames().size(); i++) {
			where = where + " and " + wherebeanToArray.getBeanNames().get(i)
					+ "=? ";
		}

		sql = sql + set.substring(0, set.length() - 1) + where;
		// 拼接where到set后面
		List values = beanToArray.getValues();
		List wherevalues = wherebeanToArray.getValues();
		values.add(wherevalues);
		return doSingle(sql, values);
	}

	/**
	 * 修改TABLE数据
	 * @param TABLE 表名
	 * @param datasql 指update table set 后面跟的字符串，例如fieldname='test'
	 * @param wheresql 指where后面跟的字符串，例如fieldname='test'
	 * @param param 参数集合
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	public String updSingle(String TABLE, String datasql,
			String wheresql, Object... param) {
		String sql = "update " + TABLE + " set " + datasql + " where "
				+ wheresql;
		return doSingle(sql, param);
	}
	/**
	 * 获取修改TABLE数据的sql
	 * @param TABLE 表名
	 * @param datasql 指update table set 后面跟的字符串，例如fieldname='test'
	 * @param wheresql 指where后面跟的字符串，例如fieldname='test'
	 * @return sql语句
	 */
	public String getUpdSingleSql(String TABLE, String datasql,
			String wheresql) {
		String sql = "update " + TABLE + " set " + datasql + " where "
				+ wheresql;
		return sql;
	}
	/**
	 * 执行一条sql语句
	 * @param sql sql语句
	 * @param param 参数集合
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	@SuppressWarnings("finally")
	public String doSingle(String sql, List param) {
		String result = CommonConst.FAILURE;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		PreparedStatement pstmt = null;
		try {
			System.out.println(sql);
			pstmt = conn.prepareStatement(sql);
			if (param != null) {
				for (int i = 0; i < param.size(); i++) {
					pstmt.setObject(i + 1, param.get(i));
				}
			}
			int num = pstmt.executeUpdate();
			System.out.println("executeUpdate: " + num + " records！");
			if (num > 0) {
				result = CommonConst.SUCCESS;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, pstmt);
			return result;
		}
	}

	/**
	 * 执行一条sql语句
	 * @param sql sql语句
	 * @param param 参数集合
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	@SuppressWarnings("finally")
	public String doSingle(String sql, Object... param) {
		String result = CommonConst.FAILURE;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		PreparedStatement pstmt = null;
		try {
			System.out.println(sql);
			pstmt = conn.prepareStatement(sql);
			if (param != null) {
				for (int i = 0; i < param.length; i++) {
					pstmt.setObject(i + 1, param[i]);
				}
			}
			int num = pstmt.executeUpdate();
			System.out.println("executeUpdate: " + num + " records！");
			if (num > 0) {
				result = CommonConst.SUCCESS;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, pstmt);
			return result;
		}
	}

	/**
	 * 执行多条语句
	 * @param sql sql语句集合 异常时事物回滚
	 * @return 成功CommonConst.SUCCESS,失败CommonConst.FAILURE
	 */
	@SuppressWarnings("finally")
	public String doAll(String... sql) {
		String result = CommonConst.FAILURE;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		PreparedStatement pstmt = null;
		try {
			conn.setAutoCommit(false);
			if (sql != null) {
				for (int i=0; i<sql.length; i++) {
					System.out.println(sql[i]);
					pstmt = conn.prepareStatement(sql[i]);
					int num = pstmt.executeUpdate();
					System.out.println("executeUpdate: " + num + " records！");
				}
			}
			conn.commit();
			conn.setAutoCommit(true);// 恢复默认
			result = CommonConst.SUCCESS;
		} catch (Exception e) {
			conn.rollback();//回滚   
			conn.setAutoCommit(true);// 恢复默认
			e.printStackTrace();
        } finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, pstmt);
			return result;
		}
	}
	@SuppressWarnings("finally")
	public String doAll(ArrayList<String> sqls) {
		String result = CommonConst.FAILURE;
		Connection conn = connectionMan.getConnection(CommonConst.DSNAME);
		PreparedStatement pstmt = null;
		try {
			conn.setAutoCommit(false);
			if (sqls != null) {
				for (int i=0; i<sqls.size(); i++) {
					System.out.println(sqls.get(i));
					pstmt = conn.prepareStatement(sqls.get(i));
					int num = pstmt.executeUpdate();
					System.out.println("executeUpdate: " + num + " records！");
				}
			}
			conn.commit();
			conn.setAutoCommit(true);// 恢复默认
			result = CommonConst.SUCCESS;
		} catch (Exception e) {
			conn.rollback();//回滚   
			conn.setAutoCommit(true);// 恢复默认
			e.printStackTrace();
        } finally {
			connectionMan.freeConnection(CommonConst.DSNAME, conn, pstmt);
			return result;
		}
	}
}
