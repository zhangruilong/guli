package com.server.pojo;

public class GoodsVo {
	/**
	 * 商品类型
	 */
	private String type;
	/**
	 * 商品数量
	 */
	private int nowGoodsNum;
	/**
	 * 商品
	 */
	private Goodsview goodsview;
	/**
	 * 秒杀商品
	 */
	private Timegoodsview tgview;
	/**
	 * 买赠商品
	 */
	private Givegoodsview ggview;
	/**
	 * 是否已下架
	 */
	private String statue;

	public String getStatue() {
		return statue;
	}

	public void setStatue(String statue) {
		this.statue = statue;
	}

	public int getNowGoodsNum() {
		return nowGoodsNum;
	}

	public void setNowGoodsNum(int nowGoodsNum) {
		this.nowGoodsNum = nowGoodsNum;
	}

	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public Goodsview getGoodsview() {
		return goodsview;
	}
	
	public void setGoodsview(Goodsview goodsview) {
		this.goodsview = goodsview;
	}
	
	public Timegoodsview getTgview() {
		return tgview;
	}
	
	public void setTgview(Timegoodsview tgview) {
		this.tgview = tgview;
	}
	
	public Givegoodsview getGgview() {
		return ggview;
	}
	
	public void setGgview(Givegoodsview ggview) {
		this.ggview = ggview;
	}
	
}
