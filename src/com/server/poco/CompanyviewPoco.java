package com.server.poco;

/**
 * 经销商 实体类的常量
 *@author ZhangRuiLong
 */
public class CompanyviewPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "经销商";
   /**
    * 实体表名
    */
   public static String TABLE = "Companyview";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"companyid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"companyid",
	 	"companycode",
	 	"username",
	 	"companyphone",
	 	"companyshop",
	 	"companycity",
	 	"companyaddress",
	 	"companydetail",
	 	"companystatue",
	 	"loginname",
	 	"password",
	 	"createtime",
	 	"updtime",
	 	"cityid",
	 	"citycode",
	 	"cityname",
	 	"cityparent",
	 	"citydetail",
	 	"citystatue",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"companyid",
	 	"companycode",
	 	"username",
	 	"companyphone",
	 	"companyshop",
	 	"companycity",
	 	"companyaddress",
	 	"companydetail",
	 	"companystatue",
	 	"loginname",
	 	"password",
	 	"createtime",
	 	"updtime",
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
   public static final String ORDER = " companyid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"companyid",
	 	"companycode",
	 	"username",
	 	"companyphone",
	 	"companyshop",
	 	"companycity",
	 	"companyaddress",
	 	"companydetail",
	 	"companystatue",
	 	"loginname",
	 	"password",
	 	"createtime",
	 	"updtime",
	 	"cityid",
	 	"citycode",
	 	"cityname",
	 	"cityparent",
	 	"citydetail",
	 	"citystatue",
   };
}

