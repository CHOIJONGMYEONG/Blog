<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
		
		String boardNo = request.getParameter("boardNo");
		System.out.println("deleteBoardForm -- boardNo: " + boardNo);
		
		// DB 연동
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
				
		// 메뉴 목록
		String locationSql = "select location_no locationNo, location_name locationName from location";
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		ResultSet locationRset = locationStmt.executeQuery();
	%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BLOG</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">

<!-- jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>

<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1 class="container p-3 my-3 border">BLOG</h1>
		<div class="row">
			<div class="col-sm-2">
				<div>	
					<ul class="list-group">
						<li class="list-group-item"><a href="./boardList.jsp">전체</a></li>
						
						<%
							while(locationRset.next()){
						%>
								<li class="list-group-item">
									<a href="./boardList.jsp?locationNo=<%=locationRset.getString("locationNo")%>">
										<%=locationRset.getString("locationName")%>
									</a>
								</li>
						<%
							}
						%>
					</ul>
				</div>
  			</div>
  			<div class="col-sm-8">
  				<form action="./deleteBoardAction.jsp" method="post">
					<input type="hidden" name="boardNo" value="<%=boardNo%>">
					비밀번호: 
					<input type="password" name="inputPw">
					<button type="submit">삭제하기</button>
				</form>
  			</div>
  		</div>
  	</div>
  </body>
 </html>
 
 <%
 locationRset.close();
 locationStmt.close();
 conn.close();
 %>