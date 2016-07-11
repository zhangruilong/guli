package com.server.poco;

/**
 * 客户反馈意见 实体类的常量
 *@author ZhangRuiLong
 */
public class FeedbackPoco
{
   /**
    * 实体中文名
    */
   public static String NAME = "客户反馈意见";
   /**
    * 实体表名
    */
   public static String TABLE = "Feedback";
   /**
    * 实体主键
    */
   public static String[] KEYCOLUMN = {"feedbackid"};
   /**
    * 实体中文字段
    */
   public static String[] CHINESENAME = {
   		"客户反馈id",
	 	"内容",
	 	"客户id",
	 	"反馈时间",
	 	"反馈状态",
	};
	/**
	 * 实体英文字段
	 */
   public static final String[] FIELDNAME = {
   		"feedbackid",
	 	"feedbackdetail",
	 	"feedbackcustomer",
	 	"feedbacktime",
	 	"feedbackstate",
   };
   /**
    * 实体排序
    */
   public static final String ORDER = " feedbackid desc ";
   /**
	 * 要模糊查询字段
	 */
   public static final String[] QUERYFIELDNAME = {
   		"feedbackid",
	 	"feedbackdetail",
	 	"feedbackcustomer",
	 	"feedbacktime",
	 	"feedbackstate",
   };
}

