package com.server.poco;

/**
 * 订单 实体类的常量
 *@author ZhangRuiLong
 */
public class OrdermPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "订单";
   /**
    * 实体表名
    */
   public static String TABLE = "Orderm";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"ordermid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"订单ID",
	 	"客户ID",
	 	"经销商ID",
	 	"编码",
	 	"种类数",
	 	"下单金额",
	 	"实际金额",
	 	"支付方式",
	 	"状态",
	 	"备注",
	 	"下单时间",
	 	"联系人",
	 	"手机",
	 	"地址",
	 	"修改时间",
	 	"修改人",
	 	"业务员ID",
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
   };
}

