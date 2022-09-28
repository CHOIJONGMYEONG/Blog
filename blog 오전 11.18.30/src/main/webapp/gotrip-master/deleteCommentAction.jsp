<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
// 로그인, 파라미터 null 체크
request.setCharacterEncoding("utf-8");
if (session.getAttribute("loginId") == null 
		|| request.getParameter("boardNo") == null
		|| request.getParameter("commentNo") == null) {
	response.sendRedirect("./boardList.jsp");
	return;
}

// 파라미터 받아오기
int commentNo = Integer.parseInt(request.getParameter("commentNo"));
String boardNo = request.getParameter("boardNo");

// db
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "aa900413");
System.out.println("conn: " + conn);

// delete
String sql = "delete from id, comment where comment_no = ? and id = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, commentNo);
stmt.setString(2, (String) session.getAttribute("loginId"));
System.out.println("stmt: " + stmt);

int row = stmt.executeUpdate();

if (row == 0) {
	System.out.println("삭제 실패");
} else {
	System.out.println("삭제 성공");
}

// guestbook으로 돌아가게함
response.sendRedirect("./boardOne.jsp?boardNo=" + boardNo);

//자원해제
stmt.close();
conn.close();
%>