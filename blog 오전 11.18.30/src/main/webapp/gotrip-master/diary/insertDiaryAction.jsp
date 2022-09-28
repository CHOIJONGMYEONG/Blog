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

// getParameter
request.setCharacterEncoding("utf-8");
String diaryDate = request.getParameter("diaryDate");
String todo = request.getParameter("todo");

System.out.println("diaryDate: " + diaryDate);
System.out.println("todo: " + todo);

//DB 연동
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
		
//메뉴 목록
String sql = "insert into diary(diary_date, diary_todo, create_date) values (?, ?, now())";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, diaryDate);
stmt.setString(2, todo);

int effectedRow = stmt.executeUpdate();

if(effectedRow == 1){
	System.out.println("글 입력 성공");
} else {
	System.out.println("글 입력 실패");
}

//재요청
response.sendRedirect("./diary.jsp");

//자원 해제
stmt.close();
conn.close();
%>