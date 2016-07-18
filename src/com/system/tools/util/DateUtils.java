package com.system.tools.util;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.lang.time.DateFormatUtils;

/**
 * 日期工具类, 继承org.apache.commons.lang.time.DateUtils类
 */
public class DateUtils extends org.apache.commons.lang.time.DateUtils {
	
	private static String[] parsePatterns = { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", 
		"yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss", "yyyy/MM/dd HH:mm", 
		"yyyy/M/d", "yyyy-M-d" };

	/**
	 * 获取当前时间String
	 * 
	 * @return
	 */
	public static String getStringDate() {
		java.util.Date currentTime = new java.util.Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd"); 
		String dateString = formatter.format(currentTime);  
		return dateString;
	}
	
	//获取当前日期
	public static java.sql.Date getSqlDate() {
	    java.util.Date utilDate=new java.util.Date();      
	    java.sql.Date sqlDate=new java.sql.Date(utilDate.getTime()); 
		return sqlDate;
	}
	
	//比较日期
	public static int compareSqlDate(java.sql.Date firstdate,java.sql.Date lastdate) {  
        try {
            if (firstdate.getTime() > lastdate.getTime()) {
                System.out.println("dt1 在dt2前");
                return 1;
            } else if (firstdate.getTime() < lastdate.getTime()) {
                System.out.println("dt1在dt2后");
                return 2;
            } else {
                return 0;
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return -1;
    }
	
	/**
	 * 得到当前日期字符串 格式（yyyy-MM-dd）
	 */
	public static String getDate() {
		return getDate("yyyy-MM-dd");
	}
	
	/**
	 * 得到当前日期字符串 格式（yyyy-MM-dd） pattern可以为："yyyy-MM-dd" "HH:mm:ss" "E"
	 */
	public static String getDate(String pattern) {
		return DateFormatUtils.format(new Date(), pattern);
	}
	
	/**
	 * 得到日期字符串 默认格式（yyyy-MM-dd） pattern可以为："yyyy-MM-dd" "HH:mm:ss" "E"
	 */
	public static String formatDate(Date date, Object... pattern) {
		String formatDate = null;
		if (pattern != null && pattern.length > 0) {
			formatDate = DateFormatUtils.format(date, pattern[0].toString());
		} else {
			formatDate = DateFormatUtils.format(date, "yyyy-MM-dd");
		}
		return formatDate;
	}
	
	/**
	 * 得到日期时间字符串，转换格式（yyyy-MM-dd HH:mm:ss）
	 */
	public static String formatDateTime(Date date) {
		return formatDate(date, "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 得到当前时间字符串 格式（HH:mm:ss）
	 */
	public static String getTime() {
		return formatDate(new Date(), "HH:mm:ss");
	}

	/**
	 * 得到当前日期和时间字符串 格式（yyyy-MM-dd HH:mm:ss）
	 */
	public static String getDateTime() {
		return formatDate(new Date(), "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 得到当前年份字符串 格式（yyyy）
	 */
	public static String getYear() {
		return formatDate(new Date(), "yyyy");
	}

	/**
	 * 得到当前月份字符串 格式（MM）
	 */
	public static String getMonth() {
		return formatDate(new Date(), "MM");
	}

	/**
	 * 得到当天字符串 格式（dd）
	 */
	public static String getDay() {
		return formatDate(new Date(), "dd");
	}

	/**
	 * 得到当前星期字符串 格式（E）星期几
	 */
	public static String getWeek() {
		return formatDate(new Date(), "E");
	}
	
	/**
	 * 日期型字符串转化为日期 格式
	 * { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", 
	 *   "yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss", "yyyy/MM/dd HH:mm" }
	 */
	public static Date parseDate(Object str) {
		if (str == null){
			return null;
		}
		try {
			return parseDate(str.toString(), parsePatterns);
		} catch (ParseException e) {
			return null;
		}
	}

	/**
	 * 获取过去的天数
	 * @param date
	 * @return
	 */
	public static long pastDays(Date date) {
		long t = new Date().getTime()-date.getTime();
		return t/(24*60*60*1000);
	}
	
    /**
     * 得到今天的开始时间
     */
	public static Date getDateStart(Date date) {
		if(date==null) {
			return null;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			date= sdf.parse(formatDate(date, "yyyy-MM-dd")+" 00:00:00");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}
	/**
	 * 得到今天的结束时间
	 * @param date
	 * @return
	 */
	public static Date getDateEnd(Date date) {
		if(date==null) {
			return null;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			date= sdf.parse(formatDate(date, "yyyy-MM-dd") +" 23:59:59");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}
	/**
	 * 把日期转换成字符串
	 * @param date
	 * @return
	 */
	public static String getDateFromObject(Object date){
		if(date==null){
			return "";
		}
		if (date instanceof Date) {
			return formatDate((Date)date,"yyyy-MM-dd HH:mm");
		}else{
			return date.toString();
		}
	}
	
	/**
	 * 取一周的第一天
	 * @param date		一周中的某一天
	 */
	public static String getFirstDayOfWeek(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int day_of_week = cal.get(Calendar.DAY_OF_WEEK) - 2;
		cal.add(Calendar.DATE, -day_of_week);
		return formatDate(cal.getTime(), "yyyy-MM-dd");
	}
	/**
	 * 取一周的最后一天
	 * @param date
	 */
	public static String getLastDayOfWeek(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int day_of_week = cal.get(Calendar.DAY_OF_WEEK) - 2;
		cal.add(Calendar.DATE, 6 - day_of_week);
		return formatDate(cal.getTime(), "yyyy-MM-dd");
	}
	/**
	 * 计算某天是1年中的第几周
	 * @param date
	 * @return
	 */
	public static int getWeekOfYear(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		return cal.get(Calendar.WEEK_OF_YEAR);
	}
	
	/**
	 * 格式化周信息，格式：2014年第13周(03.24-03.30)
	 * @param date
	 * @return
	 */
	public static String formatYearWeek(Date date){
		String ret = (date.getYear() + 1900) + "年第" + getWeekOfYear(date) + "周";
		
		String startWeekDay = getFirstDayOfWeek(date);
		startWeekDay = startWeekDay.substring(5).replace("-", ".");
		String endWeekDay = getLastDayOfWeek(date);
		endWeekDay = endWeekDay.substring(5).replace("-", ".");
		
		ret += "(" + startWeekDay + "-" + endWeekDay + ")";
		
		return ret;
	}
	
	/**
	 * 格式化月信息，格式：2014年1月
	 * @param date
	 * @return
	 */
	public static String formatYearMonth(Date date){
		String ret = (date.getYear() + 1900) + "年" + (date.getMonth() + 1) + "月";
		return ret;
	}
	/**
	 * @param args
	 * @throws ParseException
	 */
	public static void main(String[] args) throws ParseException {
		Date date = new Date();
		date = parseDate("2014-03-05");
//		System.out.println(getFirstDayOfWeek(date));
//		System.out.println(getLastDayOfWeek(date));
//		System.out.println(getWeekOfYear(date));
		String startWeekDay = "2014-03-05";
		startWeekDay = startWeekDay.substring(5).replace("-", ".");
		System.out.println(startWeekDay);
				
//		System.out.println(formatDate(parseDate("2010/3/6")));
//		System.out.println(getDate("yyyy年MM月dd日 E"));
//		long time = new Date().getTime()-parseDate("2012-11-19").getTime();
//		System.out.println(time/(24*60*60*1000));
	}
}
