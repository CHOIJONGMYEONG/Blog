<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
//로그인 안 됐으면 홈으로
request.setCharacterEncoding("utf-8");
if(session.getAttribute("loginId") == null){
	response.sendRedirect("../index.jsp");
	return;
}

//블로그 주인 아니면 달력으로
if((Integer)session.getAttribute("loginLevel") < 1){
	response.sendRedirect("./diary.jsp");
	return;
}

int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));

// 디버깅
System.out.println(diaryNo);

Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
System.out.println("conn: " + conn);

String sql = "delete from diary where diary_no = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, diaryNo);
System.out.println("stmt: " + stmt);

int row = stmt.executeUpdate();

if(row == 0){
	System.out.println("삭제 실패");
	response.sendRedirect("./diaryOne.jsp?diaryNo=" + diaryNo);
} else {
	System.out.println("삭제 성공");
	response.sendRedirect("./diary.jsp");
}

// 자원해제
stmt.close();
conn.close();
%>