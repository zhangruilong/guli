package com.server;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.system.tools.CommonConst;
import com.system.tools.util.CommonUtil;

public class Oauth2 extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException {
		// TODO Auto-generated method stub
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");

		// 获取方法名
		String code = request.getParameter("code");
		System.out.println("code: " + code);

		// 发送 GET 请求
		String s = HttpRequest.sendGet(
				"https://api.weixin.qq.com/sns/oauth2/access_token",
				"appid=wxf5c7a8afa90e6be2&secret=3ad77b3d40d1ab37c052f40b6ce5ba47&code="
						+ code + "&grant_type=authorization_code");
		System.out.println(s);

		if (CommonUtil.isNotEmpty(s)) {
			java.lang.reflect.Type TYPE = new com.google.gson.reflect.TypeToken<WxToken>() {
			}.getType();
			WxToken mWxToken = CommonConst.GSON.fromJson(s, TYPE);
			System.out.println("openid: " + mWxToken.getOpenid());
			try {
				response.sendRedirect("oauth2.jsp?openid="+mWxToken.getOpenid());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
//			RequestDispatcher dispatcher = request
//					.getRequestDispatcher("oauth2.jsp");
//			request.setAttribute("openid", mWxToken.getOpenid());
//			try {
//				dispatcher.forward(request, response);
//			} catch (ServletException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			} catch (IOException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
		}

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}