package com.server.poco;

/**
 * 标品库 实体类的常量
 *@author ZhangRuiLong
 */
public class ScantviewPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "标品库";
   /**
    * 实体表名
    */
   public static String TABLE = "Scantview";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"scantid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"scantid",
	 	"scantcode",
	 	"scantname",
	 	"scantdetail",
	 	"scantunits",
	 	"scantclass",
	 	"scantimage",
	 	"scantstatue",
	 	"goodsclassid",
	 	"goodsclasscode",
	 	"goodsclassname",
	 	"goodsclassparent",
	 	"goodsclassdetail",
	 	"goodsclassstatue",
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
	 	"goodsclassid",
	 	"goodsclasscode",
	 	"goodsclassname",
	 	"goodsclassparent",
	 	"goodsclassdetail",
	 	"goodsclassstatue",
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
	 	"goodsclassid",
	 	"goodsclasscode",
	 	"goodsclassname",
	 	"goodsclassparent",
	 	"goodsclassdetail",
	 	"goodsclassstatue",
   };
}

