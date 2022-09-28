<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
request.setCharacterEncoding("utf-8");

// 돌아가
if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

if(request.getParameter("boardNo") == null){
	response.sendRedirect("./boardList.jsp");
	return;
}

int boardNo = Integer.parseInt(request.getParameter("boardNo"));

if(request.getParameter("commentContent") == null 
	|| "".equals(request.getParameter("commentContent"))){
	response.sendRedirect("./boardOne.jsp?boardNo=" + boardNo);
	return;
}

String commentContent = request.getParameter("commentContent");
String id = (String)session.getAttribute("loginId");

System.out.println("boardNo: " + boardNo);
System.out.println("commentContent: " + commentContent);

// 서비스
//// db 연결 ~ 처리
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
System.out.println("conn: " + conn);

String sql = "insert into comment(board_no, comment_content, id, create_date) values (?, ?, ?, now())";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, boardNo);
stmt.setString(2, commentContent);
stmt.setString(3, id);

System.out.println(stmt);

int row = stmt.executeUpdate();

if(row == 1){
	System.out.println("댓글 작성 성공!!" );
} else {
	System.out.println("댓글 작성 실패!!" );
}

response.sendRedirect("./boardOne.jsp?boardNo=" + boardNo);

// 자원해제
stmt.close();
conn.close();
%>