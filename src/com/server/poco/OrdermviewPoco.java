package com.server.poco;

/**
 * 订单 实体类的常量
 *@author ZhangRuiLong
 */
public class OrdermviewPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "订单";
   /**
    * 实体表名
    */
   public static String TABLE = "Ordermview";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"ordermid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"ordermid",
	 	"ordermcustomer",
	 	"ordermcompany",
	 	"ordermcode",
	 	"ordermnum",
	 	"ordermmoney",
	 	"ordermrightmoney",
	 	"ordermway",
	 	"ordermstatue",
	 	"ordermdetail",
	 	"ordermtime",
	 	"ordermconnect",
	 	"ordermphone",
	 	"ordermaddress",
	 	"updtime",
	 	"updor",
	 	"ordermemp",
	 	"companyshop",
	 	"companyphone",
	 	"companydetail",
	 	"openid",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"ordermid",
	 	"ordermcustomer",
	 	"ordermcompany",
	 	"ordermcode",
	 	"ordermnum",
	 	"ordermmoney",
	 	"ordermrightmoney",
	 	"ordermway",
	 	"ordermstatue",
	 	"ordermdetail",
	 	"ordermtime",
	 	"ordermconnect",
	 	"ordermphone",
	 	"ordermaddress",
	 	"updtime",
	 	"updor",
	 	"ordermemp",
	 	"companyshop",
	 	"companyphone",
	 	"companydetail",
	 	"openid",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " ordermid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"ordermid",
	 	"ordermcustomer",
	 	"ordermcompany",
	 	"ordermcode",
	 	"ordermnum",
	 	"ordermmoney",
	 	"ordermrightmoney",
	 	"ordermway",
	 	"ordermstatue",
	 	"ordermdetail",
	 	"ordermtime",
	 	"ordermconnect",
	 	"ordermphone",
	 	"ordermaddress",
	 	"updtime",
	 	"updor",
	 	"ordermemp",
	 	"companyshop",
	 	"companyphone",
	 	"companydetail",
	 	"openid",
   };
}

