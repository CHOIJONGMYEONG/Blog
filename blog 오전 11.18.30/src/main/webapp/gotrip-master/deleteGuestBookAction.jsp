<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// 돌려보내기
request.setCharacterEncoding("utf-8");
if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

if(request.getParameter("guestbookNo") == null){
	response.sendRedirect("./guestbook.jsp");
	return;
}

int guestbookNo = Integer.parseInt(request.getParameter("guestbookNo"));

// 디버깅
System.out.println("guestbookNo: " + guestbookNo);

Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
System.out.println("conn: " + conn);

String sql = "delete from guestbook where guestbook_no = ? and id = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, guestbookNo);
stmt.setString(2, (String)session.getAttribute("loginId"));
System.out.println("stmt: " + stmt);

int row = stmt.executeUpdate();

if(row == 0){
	System.out.println("삭제 실패");
} else {
	System.out.println("삭제 성공");
}

// guestbook으로 돌아가게함
response.sendRedirect("./guestbook.jsp");

//자원해제
stmt.close();
conn.close();
%>