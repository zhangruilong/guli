package com.server.poco;

/**
 * 城市和县及街道 实体类的常量
 *@author ZhangRuiLong
 */
public class CityPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "城市和县及街道";
   /**
    * 实体表名
    */
   public static String TABLE = "City";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"cityid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"城市ID",
	 	"编码",
	 	"名称",
	 	"父类",
	 	"描述",
	 	"状态",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"cityid",
	 	"citycode",
	 	"cityname",
	 	"cityparent",
	 	"citydetail",
	 	"citystatue",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " cityid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"cityid",
	 	"citycode",
	 	"cityname",
	 	"cityparent",
	 	"citydetail",
	 	"citystatue",
   };
}

