package com.server.poco;

/**
 * 预定商品 实体类的常量
 *@author ZhangRuiLong
 */
public class BkgoodsviewPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "预定商品";
   /**
    * 实体表名
    */
   public static String TABLE = "Bkgoodsview";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"bkgoodsid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"bkgoodsid",
	 	"bkgoodscompany",
	 	"bkgoodscode",
	 	"bkgoodsname",
	 	"bkgoodsdetail",
	 	"bkgoodsunits",
	 	"bkgoodsunit",
	 	"bkgoodsprice",
	 	"bkgoodsorgprice",
	 	"bkgoodsnum",
	 	"bkgoodsclass",
	 	"bkgoodsimage",
	 	"bkgoodsstatue",
	 	"bkcreatetime",
	 	"bkcreator",
	 	"bkgoodsseq",
	 	"bkgoodsscope",
	 	"companycode",
	 	"username",
	 	"companyphone",
	 	"companyshop",
	 	"companyaddress",
	 	"companycity",
	 	"companydetail",
	 	"loginname",
	 	"companystatue",
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
   		"bkgoodsid",
	 	"bkgoodscompany",
	 	"bkgoodscode",
	 	"bkgoodsname",
	 	"bkgoodsdetail",
	 	"bkgoodsunits",
	 	"bkgoodsunit",
	 	"bkgoodsprice",
	 	"bkgoodsorgprice",
	 	"bkgoodsnum",
	 	"bkgoodsclass",
	 	"bkgoodsimage",
	 	"bkgoodsstatue",
	 	"bkcreatetime",
	 	"bkcreator",
	 	"bkgoodsseq",
	 	"bkgoodsscope",
	 	"companycode",
	 	"username",
	 	"companyphone",
	 	"companyshop",
	 	"companyaddress",
	 	"companycity",
	 	"companydetail",
	 	"loginname",
	 	"companystatue",
	 	"citycode",
	 	"cityname",
	 	"cityparent",
	 	"citydetail",
	 	"citystatue",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " bkgoodsid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"bkgoodsid",
	 	"bkgoodscompany",
	 	"bkgoodscode",
	 	"bkgoodsname",
	 	"bkgoodsdetail",
	 	"bkgoodsunits",
	 	"bkgoodsunit",
	 	"bkgoodsprice",
	 	"bkgoodsorgprice",
	 	"bkgoodsnum",
	 	"bkgoodsclass",
	 	"bkgoodsimage",
	 	"bkgoodsstatue",
	 	"bkcreatetime",
	 	"bkcreator",
	 	"bkgoodsseq",
	 	"bkgoodsscope",
	 	"companycode",
	 	"username",
	 	"companyphone",
	 	"companyshop",
	 	"companyaddress",
	 	"companycity",
	 	"companydetail",
	 	"loginname",
	 	"companystatue",
	 	"citycode",
	 	"cityname",
	 	"cityparent",
	 	"citydetail",
	 	"citystatue",
   };
}

