package com.server.poco;

/**
 * 业务员 实体类的常量
 *@author ZhangRuiLong
 */
public class EmpPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "业务员";
   /**
    * 实体表名
    */
   public static String TABLE = "Emp";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"empid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"业务员ID",
	 	"经销商ID",
	 	"编码",
	 	"账号",
	 	"密码",
	 	"描述",
	 	"状态",
	 	"创建时间",
	 	"修改时间",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"empid",
	 	"empcompany",
	 	"empcode",
	 	"loginname",
	 	"password",
	 	"empdetail",
	 	"empstatue",
	 	"createtime",
	 	"updtime",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " empid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"empid",
	 	"empcompany",
	 	"empcode",
	 	"loginname",
	 	"password",
	 	"empdetail",
	 	"empstatue",
	 	"createtime",
	 	"updtime",
   };
}

