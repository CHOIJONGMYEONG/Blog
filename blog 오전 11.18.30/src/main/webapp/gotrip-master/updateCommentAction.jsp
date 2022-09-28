<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
// 로그인 한 사람만 가능
if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

// getParameter
request.setCharacterEncoding("utf-8");
int boardNo = Integer.parseInt(request.getParameter("boardNo"));
int commentNo = Integer.parseInt(request.getParameter("commentNo"));
String commentContent = request.getParameter("commentContent");

System.out.println("boardNo: " + boardNo);
System.out.println("commentNo: " + commentNo);
System.out.println("commentContent: " + commentContent);

//DB 연동
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "aa900413");

// update
String updateSql = "update comment set comment_content = ? where comment_no = ? and id = ?";
PreparedStatement stmt = conn.prepareStatement(updateSql);
stmt.setString(1, commentContent);
stmt.setInt(2, commentNo);
stmt.setString(3, (String)session.getAttribute("loginId"));

int row = stmt.executeUpdate();

if(row == 0){
	System.out.println("댓글 수정 실패!");
	response.sendRedirect("./updateCommentForm.jsp?boardNo=" + boardNo + "&commentNo=" + commentNo);
} else {
	System.out.println("댓글 수정 성공!");
	response.sendRedirect("./boardOne.jsp?boardNo=" + boardNo);	
}

// 자원해제
stmt.close();
conn.close();

%>