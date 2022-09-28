<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
//로그인 안 됐으면 홈으로
if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

//블로그 주인 아니면 게시글 목록으로
if((Integer)session.getAttribute("loginLevel") < 1){
	response.sendRedirect("./boardList.jsp"); // 가야할 곳이 다름
	return;
}

String locationNo = request.getParameter("locationNo");
System.out.println("locationNo: " + request.getParameter("locationNo"));

// 현재 페이지 확인
int currentPage = 1;
if(request.getParameter("currentPage") != null){
	currentPage = Integer.parseInt(request.getParameter("currentPage"));
}

final int ROW_PER_PAGE = 10;
int beginRow = (currentPage - 1) * ROW_PER_PAGE;

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
<title>Insert Board</title>
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
			<!-- left menu -->
			<!-- location DB를 메뉴 형태로 보여줄 거임 -->
			<div>	
				<ul class="list-group">
					<li class="list-group-item"><a href="./boardList.jsp">전체</a></li>
					<%
						while(locationRset.next()){
					%>
							<li class="list-group-item">
								<a href="./boardList.jsp?locationNo=<%=locationRset.getInt("locationNo")%>">
									<%=locationRset.getString("locationName")%>
								</a>
							</li>
					<%
						}
					%>
				</ul>
			</div>
		</div><!-- end col-sm-2 -->
		
		<div class="col-sm-10">
			<form action="./insertBoardAction.jsp" method="post">
				<table class="table table-hover table-striped">
					<tr>
						<th>locationNo</th>
						<td>
							<select name="locationNo" class="form-control">
								<%
									locationRset.first();
									do {
								%>
										<option value="<%=locationRset.getString("locationNo")%>">
											<%=locationRset.getString("locationName")%>
										</option>
								<%	
									} while(locationRset.next()); // 일단 한 번 실행하고 조건을 검사
								%>
							</select>
						</td>
					</tr>
					<tr>
						<th>boardTitle</th>
						<td><input type="text" name="boardTitle" class="form-control"></td>
					</tr>
					<tr>
						<th>password</th>
						<td><input type="text" name="boardPw" class="form-control"></td>
					</tr>
					<tr>
						<th>boardContent</th>
						<td><textarea rows="5" cols="50" name="boardContent" class="form-control"></textarea></td>
					</tr>
				</table>
				<button type="submit" class="btn btn-danger">제출</button>
				<button type="reset" class="btn btn-outline-danger">초기화</button>
			</form>
		</div><!-- end col-sm-10 -->
	</div><!-- end row -->
</div><!-- end 전체 div -->
</body>
</html>
<%				
	// DB 자원해제
	locationRset.close();
	locationStmt.close();
	conn.close();
%>