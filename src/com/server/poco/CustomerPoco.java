package com.server.poco;

/**
 * 客户 实体类的常量
 *@author ZhangRuiLong
 */
public class CustomerPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "客户";
   /**
    * 实体表名
    */
   public static String TABLE = "Customer";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"customerid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"客户ID",
	 	"编码",
	 	"姓名(联系人名)",
	 	"手机",
	 	"密码",
	 	"店铺(客户名)",
	 	"城市",
	 	"县",
	 	"街道地址",
	 	"类型",
	 	"等级",
	 	"openid",
	 	"描述",
	 	"状态",
	 	"创建时间",
	 	"修改时间",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
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
	 	"createtime",
	 	"updtime",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " customerid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
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
	 	"createtime",
	 	"updtime",
   };
}

