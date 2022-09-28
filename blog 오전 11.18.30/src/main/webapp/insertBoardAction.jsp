<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

if((Integer)session.getAttribute("loginLevel") < 1){
	response.sendRedirect("./boardList.jsp"); // 가야할 곳이 다름
	return;
}

request.setCharacterEncoding("utf-8");

int locationNo = Integer.parseInt(request.getParameter("locationNo"));
String boardTitle = request.getParameter("boardTitle");
String boardContent = request.getParameter("boardContent");
String boardPw = request.getParameter("boardPw");

// 디버깅
System.out.println("locationNo: " + locationNo);
System.out.println("boardTitle: " + boardTitle);
System.out.println("boardContent: " + boardContent);
System.out.println("boardPw: " + boardPw);

// DB 연동
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
		
// 메뉴 목록
String sql = "insert into board(location_no, board_title, board_content, board_pw, create_date) values (?, ?, ?, password(?), now())";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, locationNo);
stmt.setString(2, boardTitle);
stmt.setString(3, boardContent);
stmt.setString(4, boardPw);

int effectedRow = stmt.executeUpdate();

if(effectedRow == 1){
	System.out.println("글 입력 성공");
} else {
	System.out.println("글 입력 실패");
}

// 재요청
response.sendRedirect("./boardList.jsp");

// 자원 해제
stmt.close();
conn.close();
%>