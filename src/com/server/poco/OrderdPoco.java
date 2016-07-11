package com.server.poco;

/**
 * 订单详细 实体类的常量
 *@author ZhangRuiLong
 */
public class OrderdPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "订单详细";
   /**
    * 实体表名
    */
   public static String TABLE = "Orderd";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"orderdid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"订单详细ID",
	 	"订单ID",
	 	"商品编码",
	 	"商品类型",
	 	"名称",
	 	"描述",
	 	"规格",
	 	"价格",
	 	"单位",
	 	"小类",
	 	"数量",
	 	"下单金额",
	 	"实际金额",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"orderdid",
	 	"orderdorderm",
	 	"orderdcode",
	 	"orderdtype",
	 	"orderdname",
	 	"orderddetail",
	 	"orderdunits",
	 	"orderdprice",
	 	"orderdunit",
	 	"orderdclass",
	 	"orderdnum",
	 	"orderdmoney",
	 	"orderdrightmoney",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " orderdid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"orderdid",
	 	"orderdorderm",
	 	"orderdcode",
	 	"orderdtype",
	 	"orderdname",
	 	"orderddetail",
	 	"orderdunits",
	 	"orderdprice",
	 	"orderdunit",
	 	"orderdclass",
	 	"orderdnum",
	 	"orderdmoney",
	 	"orderdrightmoney",
   };
}

