<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
if(session.getAttribute("loginId") != null){
	response.sendRedirect("./index.jsp");
	return;
}

request.setCharacterEncoding("utf-8");
String id = request.getParameter("id");
System.out.println("".equals(id) ? "빈 문자열" : "다시 체크 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
String pw = request.getParameter("pw");

if(id == null || pw == null || id.length() < 4 || pw.length() < 4){
	response.sendRedirect("./index.jsp?errorMsg=invalidAccess");
	return;
}

Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/blog";
Connection conn = DriverManager.getConnection(url, "root", "aa900413");

String sql = "select id, level from member where id = ? and pw = password(?)";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, id);
stmt.setString(2, pw);
ResultSet rs = stmt.executeQuery();
String link = "./index.jsp";

if(rs.next()){ // 로그인 성공
	session.setAttribute("loginId", rs.getString("id")); // 다형성
	// setAttribute의 두 번째 파라미터는 Object 타입 -> String이 들어가고 있음 (다형성)
	session.setAttribute("loginLevel", rs.getInt("level")); // 오토박싱
} else { // 로그인 실패
	link += "?errorMsg=invalidIdPw";
}

response.sendRedirect(link);

// 자원해제
rs.close();
stmt.close();
conn.close();
%>