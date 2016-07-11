package com.server.poco;

/**
 * 价格体系 实体类的常量
 *@author ZhangRuiLong
 */
public class PricesPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "价格体系";
   /**
    * 实体表名
    */
   public static String TABLE = "Prices";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"pricesid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"价格体系ID",
	 	"商品ID",
	 	"分类",
	 	"等级",
	 	"单品价",
	 	"单品单位",
	 	"套装价",
	 	"套装单位",
	 	"创建时间",
	 	"修改时间",
	 	"创建人",
	 	"修改人",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"pricesid",
	 	"pricesgoods",
	 	"pricesclass",
	 	"priceslevel",
	 	"pricesprice",
	 	"pricesunit",
	 	"pricesprice2",
	 	"pricesunit2",
	 	"createtime",
	 	"updtime",
	 	"creator",
	 	"updor",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " pricesid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"pricesid",
	 	"pricesgoods",
	 	"pricesclass",
	 	"priceslevel",
	 	"pricesprice",
	 	"pricesunit",
	 	"pricesprice2",
	 	"pricesunit2",
	 	"createtime",
	 	"updtime",
	 	"creator",
	 	"updor",
   };
}

