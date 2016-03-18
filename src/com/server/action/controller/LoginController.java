package com.server.action.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
/**
 * 登录
 * @author taolichao
 *
 */
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.server.dao.mapper.AddressMapper;
import com.server.dao.mapper.CityMapper;
import com.server.dao.mapper.CustomerMapper;
import com.server.pojo.entity.Address;
import com.server.pojo.entity.City;
import com.server.pojo.entity.Customer;
import com.system.tools.base.ModelAndView;
import com.system.tools.util.CommonUtil;
@Controller
public class LoginController {
	@Autowired
	private CustomerMapper customerMapper;
	@Autowired
	private CityMapper cityMapper;
	@Autowired
	private AddressMapper addressMapper;
	//登录
	@RequestMapping("/guliwang/login")
	public String login(HttpSession session,Customer customer){
		customer.setCustomerphone("15645566879");
		customer.setCustomerpsw("1");				//这是默认的账号和密码
		customer = customerMapper.selectByPhone(customer);
		session.setAttribute("customer", customer);
		return "redirect:login.jsp";
	}
	//注册页面
	@RequestMapping("/guliwang/doReg")
	public String doReg(Model model){
		List<City> cityList = cityMapper.selectAllCity();
		model.addAttribute("cityList", cityList);
		return "forward:reg.jsp";
	}
	//注册用户
	@RequestMapping("/guliwang/reg")
	public String reg(Customer customer,String addressphone){
		String newCusId = CommonUtil.getNewId();
		customer.setCustomerid(newCusId);		//设置新id
		customer.setCustomerstatue("启用");
		customer.setCustomerlevel(1);
		customerMapper.insertSelective(customer);		//添加新客户
		//添加新地址
		Address address = new Address();
		address.setAddressture(1);							//自动设为默认地址
		address.setAddressid(CommonUtil.getNewId());		//设置新id
		address.setAddressaddress(customer.getCustomercity()+customer.getCustomerxian()+customer.getCustomeraddress());
		address.setAddresscustomer(newCusId);				//客户id
		address.setAddressphone(addressphone);
		address.setAddressconnect(customer.getCustomername());
		addressMapper.insertSelective(address);				//添加默认地址
		return "redirect:login.jsp";
	}
	//注销登录
	@RequestMapping("/guliwang/loginOut")
	public String loginOut(HttpSession session){
		session.invalidate();
		return "redirect:login.jsp";
	}
	//检查用户名
	@RequestMapping(value="/guliwang/checkCustomerphone", produces = {"text/javascript;charset=UTF-8"})
	public @ResponseBody String checkCustomerphone(String customerphone){
		Customer cus = customerMapper.selectPhoneToCus(customerphone);
		if(cus == null){
			return "ok";
		} else {
			return "no";
		}
	}
	//检查用户名
		@RequestMapping(value="/guliwang/querycity", produces="application/json")
		@ResponseBody 
		public List<City> querycity(City city){
			City parentCity = cityMapper.selectByCityparent(city).get(0);
			city = new City();
			city.setCityparent(parentCity.getCityid());
			List<City> cityList = cityMapper.selectByCityparent(city);
			return cityList;
		}
}


















