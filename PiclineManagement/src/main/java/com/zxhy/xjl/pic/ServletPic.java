package com.zxhy.xjl.pic;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.zxhy.*;
import com.zxhy.xjl.picture.lines.Impl.QRPicServiceImpl;
import com.zxhy.xjl.picture.lines.service.QRPicService;
/**
 * Servlet implementation class ServletPic
 */
public class ServletPic extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletPic() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
          

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		//doGet(request, response);
		String sucflag;
		String trflag;
		HttpSession session = request.getSession();
		String flag = request.getParameter("hid");
		//0是生成图片二维码，1是验证
		if(flag.equals("0")){	
			System.out.println( request.getParameter("file1"));
			String logoAddress =request.getParameter("file2");
			String picAddress =request.getParameter("file1");
			int n = Integer.parseInt(request.getParameter("sec1")) ;
			QRPicServiceImpl qrps=new QRPicServiceImpl();
			try {
				sucflag="二维码加密成功！";
				qrps.getQRPic("ZTEsoft", logoAddress, "/Users/Arthur/Desktop/newlogo.jpg", false, picAddress, 10, 10, 1.0f,n);
				session.setAttribute("sucflag", sucflag);
				response.sendRedirect("examples/picmanager.jsp");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				sucflag="加密失败，请检查输入文件！";
				e.printStackTrace();
				session.setAttribute("sucflag", sucflag);
				response.sendRedirect("examples/picmanager.jsp");
			}
		}else if(flag.equals("1")){
			String srcFile =request.getParameter("file3");
			String destFile =request.getParameter("file4");
			int n = Integer.parseInt(request.getParameter("sec2")) ;
			QRPicServiceImpl qrps=new QRPicServiceImpl();
			boolean enflag = qrps.offlineCheck(srcFile, destFile, n);
			if(enflag){   trflag="是真实图片，没有篡改!";
				session.setAttribute("sucflag", trflag);
				response.sendRedirect("examples/picmanager.jsp#tabs1-js");
				
			}else{
				trflag="图片被篡改，请注意信息安全！";
				session.setAttribute("sucflag", trflag);
				response.sendRedirect("examples/picmanager.jsp#tabs1-js");
			}
		}else{   trflag="输入了非法信息，请检查！";
			session.setAttribute("sucflag", trflag);
			response.sendRedirect("examples/picmanager.jsp");
		}
	}
}
