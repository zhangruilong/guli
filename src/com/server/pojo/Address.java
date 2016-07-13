package com.server.pojo;

import java.sql.Date;
/**
 * 我的地址 实体类
 *@author ZhangRuiLong
 */
public class Address
{
   /**
    * 我的地址ID,主键
    */
   private String addressid; 
   /**
    * 客户ID
    */
   private String addresscustomer;   
   /**
    * 联系人
    */
   private String addressconnect;   
   /**
    * 手机
    */
   private String addressphone;   
   /**
    * 地址
    */
   private String addressaddress;   
   /**
    * 是否默认(1默认,0不是默认)
    */
   private int addressture;   
    //属性方法	    
     /**
	 *设置主键"我的地址ID"属性
	 *@param addressid 实体的Addressid属性
	 */
	public void setAddressid(String addressid)
	{
		this.addressid = addressid;
	}
	
	/**
	 *获取主键"我的地址ID"属性
	 */
	public String getAddressid()
	{
		return this.addressid;
	}

	/**
	 *设置"客户ID"属性
	 *@param addresscustomer 实体的Addresscustomer属性
	 */
	public void setAddresscustomer(String addresscustomer)
	{
		this.addresscustomer = addresscustomer;
	}
	
	/**
	 *获取"客户ID"属性
	 */
	public String getAddresscustomer()
	{
		return this.addresscustomer;
	}	   

	/**
	 *设置"联系人"属性
	 *@param addressconnect 实体的Addressconnect属性
	 */
	public void setAddressconnect(String addressconnect)
	{
		this.addressconnect = addressconnect;
	}
	
	/**
	 *获取"联系人"属性
	 */
	public String getAddressconnect()
	{
		return this.addressconnect;
	}	   

	/**
	 *设置"手机"属性
	 *@param addressphone 实体的Addressphone属性
	 */
	public void setAddressphone(String addressphone)
	{
		this.addressphone = addressphone;
	}
	
	/**
	 *获取"手机"属性
	 */
	public String getAddressphone()
	{
		return this.addressphone;
	}	   

	/**
	 *设置"地址"属性
	 *@param addressaddress 实体的Addressaddress属性
	 */
	public void setAddressaddress(String addressaddress)
	{
		this.addressaddress = addressaddress;
	}
	
	/**
	 *获取"地址"属性
	 */
	public String getAddressaddress()
	{
		return this.addressaddress;
	}	   

	/**
	 *设置"是否默认"属性
	 *@param addressture 实体的Addressture属性
	 */
	public void setAddressture(int addressture)
	{
		this.addressture = addressture;
	}
	
	/**
	 *获取"是否默认"属性
	 */
	public int getAddressture()
	{
		return this.addressture;
	}	   
	public Address() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Address(
		String addressid
	 	,String addresscustomer
	 	,String addressconnect
	 	,String addressphone
	 	,String addressaddress
	 	,int addressture
		 ){
		super();
		this.addressid = addressid;
	 	this.addresscustomer = addresscustomer;
	 	this.addressconnect = addressconnect;
	 	this.addressphone = addressphone;
	 	this.addressaddress = addressaddress;
	 	this.addressture = addressture;
	}
}

