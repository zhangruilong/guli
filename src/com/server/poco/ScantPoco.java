package com.server.poco;

/**
 * 标品库 实体类的常量
 *@author ZhangRuiLong
 */
public class ScantPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "标品库";
   /**
    * 实体表名
    */
   public static String TABLE = "Scant";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"scantid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"标品ID",
	 	"编码",
	 	"名称",
	 	"描述",
	 	"规格",
	 	"小类ID",
	 	"图片",
	 	"状态",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"scantid",
	 	"scantcode",
	 	"scantname",
	 	"scantdetail",
	 	"scantunits",
	 	"scantclass",
	 	"scantimage",
	 	"scantstatue",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " scantid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"scantid",
	 	"scantcode",
	 	"scantname",
	 	"scantdetail",
	 	"scantunits",
	 	"scantclass",
	 	"scantimage",
	 	"scantstatue",
   };
}

