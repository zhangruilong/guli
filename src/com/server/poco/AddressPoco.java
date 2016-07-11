package com.server.poco;

/**
 * 我的地址 实体类的常量
 *@author ZhangRuiLong
 */
public class AddressPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "我的地址";
   /**
    * 实体表名
    */
   public static String TABLE = "Address";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"addressid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"我的地址ID",
	 	"客户ID",
	 	"联系人",
	 	"手机",
	 	"地址",
	 	"是否默认(1默认,0不是默认)",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"addressid",
	 	"addresscustomer",
	 	"addressconnect",
	 	"addressphone",
	 	"addressaddress",
	 	"addressture",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " addressid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"addressid",
	 	"addresscustomer",
	 	"addressconnect",
	 	"addressphone",
	 	"addressaddress",
	 	"addressture",
   };
}

