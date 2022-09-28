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

// getParameter
// ./insertDiary.jsp?year=&month=&date=
String year = request.getParameter("year");
int month = Integer.parseInt(request.getParameter("month")) + 1;
String date = request.getParameter("date");

//메뉴 목록
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
String locationSql = "select location_no locationNo, location_name locationName from location";
PreparedStatement locationStmt = conn.prepareStatement(locationSql);
ResultSet locationRset = locationStmt.executeQuery();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>InsertDiary</title>
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
				<form action="./insertDiaryAction.jsp" method="post">
					<input type="hidden" name="diaryDate" value="<%=year+"-"+month+"-"+date%>" class="form-control"/>
					<table class="table table-hover table-striped">
						<tr>
							<th>축제입력</th>
							<td><input type="text" name="todo" class="form-control"></td>
						</tr>
					</table>
					<button type="submit" class="btn btn-danger">제출</button>
					<button type="reset" class="btn btn-outline-danger">초기화</button>
				</form>
			</div>
		</div>
	</div>
</body>
</html>

<%
//자원해제
locationRset.close();
locationStmt.close();
conn.close();
%>