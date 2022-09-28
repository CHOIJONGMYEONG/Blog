<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
//로그인 안 됐으면 홈으로
if(session.getAttribute("loginId") == null){
	response.sendRedirect("../index.jsp");
	return;
}

//블로그 주인 아니면 달력으로
if((Integer)session.getAttribute("loginLevel") < 1){
	response.sendRedirect("./diary.jsp");
	return;
}

// parameter - diaryDate
request.setCharacterEncoding("utf-8");

int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
String diaryTodo = request.getParameter("diaryTodo");
String diaryDate = request.getParameter("diaryDate");

Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
System.out.println("conn: " + conn);

String updateSql = "update diary set diary_todo = ?, diary_date = ? where diary_no = ?";
PreparedStatement stmt = conn.prepareStatement(updateSql);
stmt.setString(1, diaryTodo);
stmt.setString(2, diaryDate);
stmt.setInt(3, diaryNo);

int row = stmt.executeUpdate();

if(row == 0){
	response.sendRedirect("./updateDiaryForm.jsp?diaryNo=" + diaryNo);
} else {
	response.sendRedirect("./diary.jsp");
}

// 자원해제
stmt.close();
conn.close();
%>