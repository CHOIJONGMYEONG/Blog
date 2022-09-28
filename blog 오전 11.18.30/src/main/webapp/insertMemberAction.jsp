<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
if(session.getAttribute("loginId") != null){ // 로그인 한 사람 회원가입 금지~
	response.sendRedirect("./index.jsp");
	return;
}

request.setCharacterEncoding("utf-8");
String id = request.getParameter("id");
String pw = request.getParameter("pw");

//직접 접근하면 db에 null값 다 들어가니까 검사해야함 -> if-return
// length() 메소드 -> 공백도 센다..?
if(id == null || pw == null || id.length() < 4 || pw.length() < 4){
	response.sendRedirect("./insertMember.jsp?errorMsg=error");
	// 왜 쫓겨났는지 에러 메시지로 알려주기~
	return; // return문을 적지 않으면 else 블록을 사용해도 된다
}

//DB 연동
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
		
//메뉴 목록
String memberSql = "insert into member(id, pw, level) values (?, password(?), 0)";
PreparedStatement memberStmt = conn.prepareStatement(memberSql);
memberStmt.setString(1, id);
memberStmt.setString(2, pw);

int result = memberStmt.executeUpdate();
System.out.println("result: " + result);

response.sendRedirect("./index.jsp");

// 자원 해제
memberStmt.close();
conn.close();
%>