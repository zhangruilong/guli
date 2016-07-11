package com.server.poco;

/**
 * 商品 实体类的常量
 *@author ZhangRuiLong
 */
public class GoodsPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "商品";
   /**
    * 实体表名
    */
   public static String TABLE = "Goods";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"goodsid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"商品ID",
	 	"经销商ID",
	 	"编码",
	 	"名称",
	 	"描述",
	 	"规格",
	 	"小类ID",
	 	"图片",
	 	"状态",
	 	"创建时间",
	 	"修改时间",
	 	"创建人",
	 	"修改人",
	 	"品牌",
	 	"种类",
	 	"顺序",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"goodsid",
	 	"goodscompany",
	 	"goodscode",
	 	"goodsname",
	 	"goodsdetail",
	 	"goodsunits",
	 	"goodsclass",
	 	"goodsimage",
	 	"goodsstatue",
	 	"createtime",
	 	"updtime",
	 	"creator",
	 	"updor",
	 	"goodsbrand",
	 	"goodstype",
	 	"goodsorder",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " goodsid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"goodsid",
	 	"goodscompany",
	 	"goodscode",
	 	"goodsname",
	 	"goodsdetail",
	 	"goodsunits",
	 	"goodsclass",
	 	"goodsimage",
	 	"goodsstatue",
	 	"createtime",
	 	"updtime",
	 	"creator",
	 	"updor",
	 	"goodsbrand",
	 	"goodstype",
	 	"goodsorder",
   };
}

