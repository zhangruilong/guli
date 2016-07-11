package com.server.poco;

/**
 * 收藏 实体类的常量
 *@author ZhangRuiLong
 */
public class CollectPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "收藏";
   /**
    * 实体表名
    */
   public static String TABLE = "Collect";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"collectid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"收藏ID",
	 	"商品ID",
	 	"客户ID",
	 	"描述",
	 	"创建时间",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"collectid",
	 	"collectgoods",
	 	"collectcustomer",
	 	"collectdetail",
	 	"createtime",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " collectid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"collectid",
	 	"collectgoods",
	 	"collectcustomer",
	 	"collectdetail",
	 	"createtime",
   };
}

