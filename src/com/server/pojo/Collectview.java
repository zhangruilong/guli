package com.server.pojo;

import java.sql.Date;
/**
 * 收藏 实体类
 *@author ZhangRuiLong
 */
public class Collectview
{
   /**
    * collectid,主键
    */
   private String collectid; 
   /**
    * collectcustomer
    */
   private String collectcustomer;   
   /**
    * collectdetail
    */
   private String collectdetail;   
   /**
    * collectcreatetime
    */
   private String collectcreatetime;   
   /**
    * goodsid
    */
   private String goodsid;   
   /**
    * goodscompany
    */
   private String goodscompany;   
   /**
    * goodscode
    */
   private String goodscode;   
   /**
    * goodsname
    */
   private String goodsname;   
   /**
    * goodsdetail
    */
   private String goodsdetail;   
   /**
    * goodsunits
    */
   private String goodsunits;   
   /**
    * goodsclass
    */
   private String goodsclass;   
   /**
    * goodsimage
    */
   private String goodsimage;   
   /**
    * goodsstatue
    */
   private String goodsstatue;   
   /**
    * createtime
    */
   private String createtime;   
   /**
    * updtime
    */
   private String updtime;   
   /**
    * creator
    */
   private String creator;   
   /**
    * updor
    */
   private String updor;   
   /**
    * goodsbrand
    */
   private String goodsbrand;   
   /**
    * goodstype
    */
   private String goodstype;   
   /**
    * goodsorder
    */
   private int goodsorder;   
    //属性方法	    
     /**
	 *设置主键"collectid"属性
	 *@param collectid 实体的Collectid属性
	 */
	public void setCollectid(String collectid)
	{
		this.collectid = collectid;
	}
	
	/**
	 *获取主键"collectid"属性
	 */
	public String getCollectid()
	{
		return this.collectid;
	}

	/**
	 *设置"collectcustomer"属性
	 *@param collectcustomer 实体的Collectcustomer属性
	 */
	public void setCollectcustomer(String collectcustomer)
	{
		this.collectcustomer = collectcustomer;
	}
	
	/**
	 *获取"collectcustomer"属性
	 */
	public String getCollectcustomer()
	{
		return this.collectcustomer;
	}	   

	/**
	 *设置"collectdetail"属性
	 *@param collectdetail 实体的Collectdetail属性
	 */
	public void setCollectdetail(String collectdetail)
	{
		this.collectdetail = collectdetail;
	}
	
	/**
	 *获取"collectdetail"属性
	 */
	public String getCollectdetail()
	{
		return this.collectdetail;
	}	   

	/**
	 *设置"collectcreatetime"属性
	 *@param collectcreatetime 实体的Collectcreatetime属性
	 */
	public void setCollectcreatetime(String collectcreatetime)
	{
		this.collectcreatetime = collectcreatetime;
	}
	
	/**
	 *获取"collectcreatetime"属性
	 */
	public String getCollectcreatetime()
	{
		return this.collectcreatetime;
	}	   

	/**
	 *设置"goodsid"属性
	 *@param goodsid 实体的Goodsid属性
	 */
	public void setGoodsid(String goodsid)
	{
		this.goodsid = goodsid;
	}
	
	/**
	 *获取"goodsid"属性
	 */
	public String getGoodsid()
	{
		return this.goodsid;
	}	   

	/**
	 *设置"goodscompany"属性
	 *@param goodscompany 实体的Goodscompany属性
	 */
	public void setGoodscompany(String goodscompany)
	{
		this.goodscompany = goodscompany;
	}
	
	/**
	 *获取"goodscompany"属性
	 */
	public String getGoodscompany()
	{
		return this.goodscompany;
	}	   

	/**
	 *设置"goodscode"属性
	 *@param goodscode 实体的Goodscode属性
	 */
	public void setGoodscode(String goodscode)
	{
		this.goodscode = goodscode;
	}
	
	/**
	 *获取"goodscode"属性
	 */
	public String getGoodscode()
	{
		return this.goodscode;
	}	   

	/**
	 *设置"goodsname"属性
	 *@param goodsname 实体的Goodsname属性
	 */
	public void setGoodsname(String goodsname)
	{
		this.goodsname = goodsname;
	}
	
	/**
	 *获取"goodsname"属性
	 */
	public String getGoodsname()
	{
		return this.goodsname;
	}	   

	/**
	 *设置"goodsdetail"属性
	 *@param goodsdetail 实体的Goodsdetail属性
	 */
	public void setGoodsdetail(String goodsdetail)
	{
		this.goodsdetail = goodsdetail;
	}
	
	/**
	 *获取"goodsdetail"属性
	 */
	public String getGoodsdetail()
	{
		return this.goodsdetail;
	}	   

	/**
	 *设置"goodsunits"属性
	 *@param goodsunits 实体的Goodsunits属性
	 */
	public void setGoodsunits(String goodsunits)
	{
		this.goodsunits = goodsunits;
	}
	
	/**
	 *获取"goodsunits"属性
	 */
	public String getGoodsunits()
	{
		return this.goodsunits;
	}	   

	/**
	 *设置"goodsclass"属性
	 *@param goodsclass 实体的Goodsclass属性
	 */
	public void setGoodsclass(String goodsclass)
	{
		this.goodsclass = goodsclass;
	}
	
	/**
	 *获取"goodsclass"属性
	 */
	public String getGoodsclass()
	{
		return this.goodsclass;
	}	   

	/**
	 *设置"goodsimage"属性
	 *@param goodsimage 实体的Goodsimage属性
	 */
	public void setGoodsimage(String goodsimage)
	{
		this.goodsimage = goodsimage;
	}
	
	/**
	 *获取"goodsimage"属性
	 */
	public String getGoodsimage()
	{
		return this.goodsimage;
	}	   

	/**
	 *设置"goodsstatue"属性
	 *@param goodsstatue 实体的Goodsstatue属性
	 */
	public void setGoodsstatue(String goodsstatue)
	{
		this.goodsstatue = goodsstatue;
	}
	
	/**
	 *获取"goodsstatue"属性
	 */
	public String getGoodsstatue()
	{
		return this.goodsstatue;
	}	   

	/**
	 *设置"createtime"属性
	 *@param createtime 实体的Createtime属性
	 */
	public void setCreatetime(String createtime)
	{
		this.createtime = createtime;
	}
	
	/**
	 *获取"createtime"属性
	 */
	public String getCreatetime()
	{
		return this.createtime;
	}	   

	/**
	 *设置"updtime"属性
	 *@param updtime 实体的Updtime属性
	 */
	public void setUpdtime(String updtime)
	{
		this.updtime = updtime;
	}
	
	/**
	 *获取"updtime"属性
	 */
	public String getUpdtime()
	{
		return this.updtime;
	}	   

	/**
	 *设置"creator"属性
	 *@param creator 实体的Creator属性
	 */
	public void setCreator(String creator)
	{
		this.creator = creator;
	}
	
	/**
	 *获取"creator"属性
	 */
	public String getCreator()
	{
		return this.creator;
	}	   

	/**
	 *设置"updor"属性
	 *@param updor 实体的Updor属性
	 */
	public void setUpdor(String updor)
	{
		this.updor = updor;
	}
	
	/**
	 *获取"updor"属性
	 */
	public String getUpdor()
	{
		return this.updor;
	}	   

	/**
	 *设置"goodsbrand"属性
	 *@param goodsbrand 实体的Goodsbrand属性
	 */
	public void setGoodsbrand(String goodsbrand)
	{
		this.goodsbrand = goodsbrand;
	}
	
	/**
	 *获取"goodsbrand"属性
	 */
	public String getGoodsbrand()
	{
		return this.goodsbrand;
	}	   

	/**
	 *设置"goodstype"属性
	 *@param goodstype 实体的Goodstype属性
	 */
	public void setGoodstype(String goodstype)
	{
		this.goodstype = goodstype;
	}
	
	/**
	 *获取"goodstype"属性
	 */
	public String getGoodstype()
	{
		return this.goodstype;
	}	   

	/**
	 *设置"goodsorder"属性
	 *@param goodsorder 实体的Goodsorder属性
	 */
	public void setGoodsorder(int goodsorder)
	{
		this.goodsorder = goodsorder;
	}
	
	/**
	 *获取"goodsorder"属性
	 */
	public int getGoodsorder()
	{
		return this.goodsorder;
	}	   
	public Collectview() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Collectview(
		String collectid
	 	,String collectcustomer
	 	,String collectdetail
	 	,String collectcreatetime
	 	,String goodsid
	 	,String goodscompany
	 	,String goodscode
	 	,String goodsname
	 	,String goodsdetail
	 	,String goodsunits
	 	,String goodsclass
	 	,String goodsimage
	 	,String goodsstatue
	 	,String createtime
	 	,String updtime
	 	,String creator
	 	,String updor
	 	,String goodsbrand
	 	,String goodstype
	 	,int goodsorder
		 ){
		super();
		this.collectid = collectid;
	 	this.collectcustomer = collectcustomer;
	 	this.collectdetail = collectdetail;
	 	this.collectcreatetime = collectcreatetime;
	 	this.goodsid = goodsid;
	 	this.goodscompany = goodscompany;
	 	this.goodscode = goodscode;
	 	this.goodsname = goodsname;
	 	this.goodsdetail = goodsdetail;
	 	this.goodsunits = goodsunits;
	 	this.goodsclass = goodsclass;
	 	this.goodsimage = goodsimage;
	 	this.goodsstatue = goodsstatue;
	 	this.createtime = createtime;
	 	this.updtime = updtime;
	 	this.creator = creator;
	 	this.updor = updor;
	 	this.goodsbrand = goodsbrand;
	 	this.goodstype = goodstype;
	 	this.goodsorder = goodsorder;
	}
}

