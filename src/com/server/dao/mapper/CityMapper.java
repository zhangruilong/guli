package com.server.dao.mapper;

import java.util.List;

import com.server.pojo.City;
/**
 * 城市
 * @author taolichao
 *
 */
public interface CityMapper {
	/**
     * 查询全部地区
     */
	List<City> selectAllCity();
	/**
	 * 根据主键删除
	 */
    int deleteByPrimaryKey(String cityid);
    /**
     * 选择性添加
     */
    int insertSelective(City record);
    /**
     * 根据主键查询
     */
    City selectByPrimaryKey(String cityid);
    /**
     * 根据主键选择性修改
     */
    int updateByPrimaryKeySelective(City record);
}