package com.server.pojo;

public class HotOrderdSumVO {
	
	private Integer odgoodsnum;					//订单商品数量
	
	private String orderdcode;					//商品编号
	
	private String orderdtype;					//商品类型
	
	private String orderdunits;					//规格
	
	public String getOrderdunits() {
		return orderdunits;
	}

	public void setOrderdunits(String orderdunits) {
		this.orderdunits = orderdunits;
	}

	public Integer getOdgoodsnum() {
		return odgoodsnum;
	}

	public void setOdgoodsnum(Integer odgoodsnum) {
		this.odgoodsnum = odgoodsnum;
	}

	public String getOrderdcode() {
		return orderdcode;
	}

	public void setOrderdcode(String orderdcode) {
		this.orderdcode = orderdcode;
	}

	public String getOrderdtype() {
		return orderdtype;
	}

	public void setOrderdtype(String orderdtype) {
		this.orderdtype = orderdtype;
	}
	
}
