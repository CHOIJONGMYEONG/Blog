<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

request.setCharacterEncoding("utf-8");
String guestbookContent = request.getParameter("guestbookContent");

Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");

// insert
String sql = "insert into guestbook(guestbook_content, id, create_date) values(?, ?, now())";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, guestbookContent);
stmt.setString(2, (String)session.getAttribute("loginId"));
stmt.executeUpdate();

response.sendRedirect("./guestbook.jsp");

// 자원해제
stmt.close();
conn.close();
%>