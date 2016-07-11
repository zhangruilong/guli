package com.server.poco;

/**
 * 在线支付记录 实体类的常量
 *@author ZhangRuiLong
 */
public class PayPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "在线支付记录";
   /**
    * 实体表名
    */
   public static String TABLE = "Pay";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"payid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"在线支付ID",
	 	"订单ID",
	 	"备注",
	 	"状态",
	 	"修改时间",
	 	"修改人",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"payid",
	 	"payorderm",
	 	"paydetail",
	 	"paystatue",
	 	"updtime",
	 	"updor",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " payid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"payid",
	 	"payorderm",
	 	"paydetail",
	 	"paystatue",
	 	"updtime",
	 	"updor",
   };
}

