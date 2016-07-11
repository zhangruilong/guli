package com.server.poco;

/**
 * 客户 实体类的常量
 *@author ZhangRuiLong
 */
public class CcustomerviewPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "客户";
   /**
    * 实体表名
    */
   public static String TABLE = "Ccustomerview";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"ccustomerid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"ccustomerid",
	 	"ccustomerdetail",
	 	"createtime",
	 	"customerid",
	 	"customercode",
	 	"customername",
	 	"customerphone",
	 	"customerpsw",
	 	"customershop",
	 	"customercity",
	 	"customerxian",
	 	"customeraddress",
	 	"customertype",
	 	"customerlevel",
	 	"openid",
	 	"customerdetail",
	 	"customerstatue",
	 	"cuscreatetime",
	 	"updtime",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"ccustomerid",
	 	"ccustomerdetail",
	 	"createtime",
	 	"customerid",
	 	"customercode",
	 	"customername",
	 	"customerphone",
	 	"customerpsw",
	 	"customershop",
	 	"customercity",
	 	"customerxian",
	 	"customeraddress",
	 	"customertype",
	 	"customerlevel",
	 	"openid",
	 	"customerdetail",
	 	"customerstatue",
	 	"cuscreatetime",
	 	"updtime",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " ccustomerid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"ccustomerid",
	 	"ccustomerdetail",
	 	"createtime",
	 	"customerid",
	 	"customercode",
	 	"customername",
	 	"customerphone",
	 	"customerpsw",
	 	"customershop",
	 	"customercity",
	 	"customerxian",
	 	"customeraddress",
	 	"customertype",
	 	"customerlevel",
	 	"openid",
	 	"customerdetail",
	 	"customerstatue",
	 	"cuscreatetime",
	 	"updtime",
   };
}

