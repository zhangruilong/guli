package com.system.tools.util;

import java.util.Random;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;


public class CommonUtil {
	
	public static Boolean isNotEmpty(String str) {
		if(null == str || str.length() <= 0)
			return false;
		return true;
	}
	
	public static Boolean isNotNull(String str) {
		if(null == str || str.length() <= 0 || "null".equals(str.toLowerCase()))
			return false;
		return true;
	}
	
	public static Boolean isNotEmpty(Object obj) {
		if(obj==null)
			return false;
		return true;
	}
	
	public static Boolean isEmpty(String str) {
		if(null == str || str.length() <= 0)
			return true;
		return false;
	}

	public static Boolean isNull(String str) {
		if(null == str || str.length() <= 0 || "null".equals(str.toLowerCase()))
			return true;
		return false;
	}
	public static Boolean isEmpty(Object obj) {
		if(obj==null)
			return true;
		return false;
	}
	
	/**
	 * 为了HTML过滤字符串，转义其中的换行符为&lt;br&gt;，空格为&amp;nbsp;
	 * 
	 * @param str
	 * @return
	 */
	public static String escapeString4Html(String str) {
		String result = "";
		if (str != null && !"".equals(str)) {
			result = StringEscapeUtils.escapeHtml(StringUtils.trimToEmpty(str))
					.replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;");
		}
		return result;
	}
	
	/**
	 * 为了SQL过滤字符串，转义其中的反斜杠\，百分号%，下划线_，单引号'
	 * 
	 * @param str
	 * @return
	 */
	public static String escapeString4Sql(String str) {
		String result = "";
		if (str != null && !"".equals(str)) {
			result = str.replaceAll("\\\\", "\\\\\\\\")
					.replaceAll("%", "\\\\%").replaceAll("_", "\\\\_")
					.replaceAll("'", "''");
		}
		return result;
	}
	
	public static String getNewId() {
		long date = System.currentTimeMillis();
		Random random = new Random();
		int num = random.nextInt(9000) + 1000;
		String newid = "zrl" + Long.toString(date) + num;
		return newid;
	}

	/**
	 * 
	 * @param success 服务器是否交互成功，默认为true
	 * @param msg 提示内容
	 * @return
	 */
	public static String getResponseJson(boolean success, String msg) {
		String result = "{success:" + success + ",msg:'" + msg + "'}";
		return result;
	}
}
