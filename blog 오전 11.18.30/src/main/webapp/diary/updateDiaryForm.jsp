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

int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));

//DB 연동
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");

String sql = "select diary_date diaryDate, diary_todo diaryTodo from diary where diary_no = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, diaryNo);
ResultSet rset = stmt.executeQuery();

//메뉴 목록
String locationSql = "select location_no locationNo, location_name locationName from location";
PreparedStatement locationStmt = conn.prepareStatement(locationSql);
ResultSet locationRset = locationStmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateDiaryForm</title>
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
				<form action="./updateDiaryAction.jsp" method="post">
					<table class="table table-hover table-striped">
						
						<%
						if(rset.next()){
						%>
							<tr>
								<td>diaryDate</td>
								<td><input type="text" name="diaryDate" value="<%=rset.getString("diaryDate")%>" class="form-control"/></td>
							</tr>
							<tr>
								<td>diaryTodo</td>
								<td><input type="text" name="diaryTodo" value="<%=rset.getString("diaryTodo")%>" class="form-control"/></td>
							</tr>
						<%
						}
						%>
					</table>
					<input type="hidden" name="diaryNo" value="<%=diaryNo%>"/>
					<button type="submit" class="btn btn-danger">작성</button>
					<button type="reset" class="btn btn-outline-danger">초기화</button>
				</form>
			</div>
		</div>
	</div>
</body>
</html>