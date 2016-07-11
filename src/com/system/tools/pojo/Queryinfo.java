package com.system.tools.pojo;


public class Queryinfo {
	 private Class type;
	 private String start;
	 private String end;
	 private String wheresql;
	 private String query;
	 private String order;
	
	 public Queryinfo() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getStart() {
		return start;
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getEnd() {
		return end;
	}
	public void setEnd(String end) {
		this.end = end;
	}
	public String getWheresql() {
		return wheresql;
	}
	public void setWheresql(String wheresql) {
		this.wheresql = wheresql;
	}
	public String getQuery() {
		return query;
	}
	public void setQuery(String query) {
		this.query = query;
	}
	public Class getType() {
		return type;
	}
	public void setType(Class type) {
		this.type = type;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	public Queryinfo(Class type, String start, String end, String wheresql,
			String query, String order) {
		super();
		this.type = type;
		this.start = start;
		this.end = end;
		this.wheresql = wheresql;
		this.query = query;
		this.order = order;
	}

}
	