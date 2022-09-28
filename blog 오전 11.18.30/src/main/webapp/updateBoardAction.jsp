<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// 로그인 안 됐으면 홈으로
if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

// 블로그 주인 아니면 게시글 목록으로
if((Integer)session.getAttribute("loginLevel") < 1){
	response.sendRedirect("./boardList.jsp"); // 가야할 곳이 다름
	return;
}

request.setCharacterEncoding("utf-8");

// 파라미터 받아오기: locationNo, board_title, board_content, board_pw
int boardNo = Integer.parseInt(request.getParameter("boardNo"));
int locationNo = Integer.parseInt(request.getParameter("locationNo"));
String boardTitle = request.getParameter("boardTitle");
String boardContent = request.getParameter("boardContent");
String inputPw = request.getParameter("inputPw");

System.out.println("locationNo: " + locationNo);
System.out.println("boardTitle: " + boardTitle);
System.out.println("boardContent: " + boardContent);
System.out.println("inputPw: " + inputPw);

// db 연동
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
System.out.println("conn: " + conn);

// update
String updateSql = "update board set location_no = ?, board_title = ?, board_content = ? where board_no = ? and board_pw = password(?)";
PreparedStatement stmt = conn.prepareStatement(updateSql);
stmt.setInt(1, locationNo);
stmt.setString(2, boardTitle);
stmt.setString(3, boardContent);
stmt.setInt(4, boardNo);
stmt.setString(5, inputPw);

int row = stmt.executeUpdate();

if(row == 0){
	response.sendRedirect("./updateBoardForm.jsp?boardNo=" + boardNo);
} else {
	response.sendRedirect("./boardOne.jsp?boardNo=" + boardNo);
}

// 자원해제
stmt.close();
conn.close();

%>