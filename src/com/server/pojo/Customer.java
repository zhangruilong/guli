package com.server.pojo;

import java.sql.Date;
/**
 * 客户 实体类
 *@author ZhangRuiLong
 */
public class Customer
{
   /**
    * 客户ID,主键
    */
   private String customerid; 
   /**
    * 编码
    */
   private String customercode;   
   /**
    * 姓名
    */
   private String customername;   
   /**
    * 手机
    */
   private String customerphone;   
   /**
    * 密码
    */
   private String customerpsw;   
   /**
    * 店铺
    */
   private String customershop;   
   /**
    * 城市
    */
   private String customercity;   
   /**
    * 县
    */
   private String customerxian;   
   /**
    * 街道地址
    */
   private String customeraddress;   
   /**
    * 类型
    */
   private String customertype;   
   /**
    * 等级
    */
   private Integer customerlevel;   
   /**
    * openid
    */
   private String openid;   
   /**
    * 描述
    */
   private String customerdetail;   
   /**
    * 状态
    */
   private String customerstatue;   
   /**
    * 创建时间
    */
   private String createtime;   
   /**
    * 修改时间
    */
   private String updtime;   
    //属性方法	    
     /**
	 *设置主键"客户ID"属性
	 *@param customerid 实体的Customerid属性
	 */
	public void setCustomerid(String customerid)
	{
		this.customerid = customerid;
	}
	
	/**
	 *获取主键"客户ID"属性
	 */
	public String getCustomerid()
	{
		return this.customerid;
	}

	/**
	 *设置"编码"属性
	 *@param customercode 实体的Customercode属性
	 */
	public void setCustomercode(String customercode)
	{
		this.customercode = customercode;
	}
	
	/**
	 *获取"编码"属性
	 */
	public String getCustomercode()
	{
		return this.customercode;
	}	   

	/**
	 *设置"姓名"属性
	 *@param customername 实体的Customername属性
	 */
	public void setCustomername(String customername)
	{
		this.customername = customername;
	}
	
	/**
	 *获取"姓名"属性
	 */
	public String getCustomername()
	{
		return this.customername;
	}	   

	/**
	 *设置"手机"属性
	 *@param customerphone 实体的Customerphone属性
	 */
	public void setCustomerphone(String customerphone)
	{
		this.customerphone = customerphone;
	}
	
	/**
	 *获取"手机"属性
	 */
	public String getCustomerphone()
	{
		return this.customerphone;
	}	   

	/**
	 *设置"密码"属性
	 *@param customerpsw 实体的Customerpsw属性
	 */
	public void setCustomerpsw(String customerpsw)
	{
		this.customerpsw = customerpsw;
	}
	
	/**
	 *获取"密码"属性
	 */
	public String getCustomerpsw()
	{
		return this.customerpsw;
	}	   

	/**
	 *设置"店铺"属性
	 *@param customershop 实体的Customershop属性
	 */
	public void setCustomershop(String customershop)
	{
		this.customershop = customershop;
	}
	
	/**
	 *获取"店铺"属性
	 */
	public String getCustomershop()
	{
		return this.customershop;
	}	   

	/**
	 *设置"城市"属性
	 *@param customercity 实体的Customercity属性
	 */
	public void setCustomercity(String customercity)
	{
		this.customercity = customercity;
	}
	
	/**
	 *获取"城市"属性
	 */
	public String getCustomercity()
	{
		return this.customercity;
	}	   

	/**
	 *设置"县"属性
	 *@param customerxian 实体的Customerxian属性
	 */
	public void setCustomerxian(String customerxian)
	{
		this.customerxian = customerxian;
	}
	
	/**
	 *获取"县"属性
	 */
	public String getCustomerxian()
	{
		return this.customerxian;
	}	   

	/**
	 *设置"街道地址"属性
	 *@param customeraddress 实体的Customeraddress属性
	 */
	public void setCustomeraddress(String customeraddress)
	{
		this.customeraddress = customeraddress;
	}
	
	/**
	 *获取"街道地址"属性
	 */
	public String getCustomeraddress()
	{
		return this.customeraddress;
	}	   

	/**
	 *设置"类型"属性
	 *@param customertype 实体的Customertype属性
	 */
	public void setCustomertype(String customertype)
	{
		this.customertype = customertype;
	}
	
	/**
	 *获取"类型"属性
	 */
	public String getCustomertype()
	{
		return this.customertype;
	}	   

	/**
	 *设置"等级"属性
	 *@param customerlevel 实体的Customerlevel属性
	 */
	public void setCustomerlevel(Integer customerlevel)
	{
		this.customerlevel = customerlevel;
	}
	
	/**
	 *获取"等级"属性
	 */
	public Integer getCustomerlevel()
	{
		return this.customerlevel;
	}	   

	/**
	 *设置"openid"属性
	 *@param openid 实体的Openid属性
	 */
	public void setOpenid(String openid)
	{
		this.openid = openid;
	}
	
	/**
	 *获取"openid"属性
	 */
	public String getOpenid()
	{
		return this.openid;
	}	   

	/**
	 *设置"描述"属性
	 *@param customerdetail 实体的Customerdetail属性
	 */
	public void setCustomerdetail(String customerdetail)
	{
		this.customerdetail = customerdetail;
	}
	
	/**
	 *获取"描述"属性
	 */
	public String getCustomerdetail()
	{
		return this.customerdetail;
	}	   

	/**
	 *设置"状态"属性
	 *@param customerstatue 实体的Customerstatue属性
	 */
	public void setCustomerstatue(String customerstatue)
	{
		this.customerstatue = customerstatue;
	}
	
	/**
	 *获取"状态"属性
	 */
	public String getCustomerstatue()
	{
		return this.customerstatue;
	}	   

	/**
	 *设置"创建时间"属性
	 *@param createtime 实体的Createtime属性
	 */
	public void setCreatetime(String createtime)
	{
		this.createtime = createtime;
	}
	
	/**
	 *获取"创建时间"属性
	 */
	public String getCreatetime()
	{
		return this.createtime;
	}	   

	/**
	 *设置"修改时间"属性
	 *@param updtime 实体的Updtime属性
	 */
	public void setUpdtime(String updtime)
	{
		this.updtime = updtime;
	}
	
	/**
	 *获取"修改时间"属性
	 */
	public String getUpdtime()
	{
		return this.updtime;
	}	   
	public Customer() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Customer(
		String customerid
	 	,String customercode
	 	,String customername
	 	,String customerphone
	 	,String customerpsw
	 	,String customershop
	 	,String customercity
	 	,String customerxian
	 	,String customeraddress
	 	,String customertype
	 	,int customerlevel
	 	,String openid
	 	,String customerdetail
	 	,String customerstatue
	 	,String createtime
	 	,String updtime
		 ){
		super();
		this.customerid = customerid;
	 	this.customercode = customercode;
	 	this.customername = customername;
	 	this.customerphone = customerphone;
	 	this.customerpsw = customerpsw;
	 	this.customershop = customershop;
	 	this.customercity = customercity;
	 	this.customerxian = customerxian;
	 	this.customeraddress = customeraddress;
	 	this.customertype = customertype;
	 	this.customerlevel = customerlevel;
	 	this.openid = openid;
	 	this.customerdetail = customerdetail;
	 	this.customerstatue = customerstatue;
	 	this.createtime = createtime;
	 	this.updtime = updtime;
	}
}

