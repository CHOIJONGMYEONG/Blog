<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
// 유저 확인
// 로그인 안 됐으면 홈으로
if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

//DB 연동
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
		
// 메뉴 목록
String locationSql = "select location_no locationNo, location_name locationName from location";
PreparedStatement locationStmt = conn.prepareStatement(locationSql);
ResultSet locationRset = locationStmt.executeQuery();

//파라미터
String boardNo = request.getParameter("boardNo");
int commentNo = Integer.parseInt(request.getParameter("commentNo"));
System.out.println("boardNo: " + boardNo);
System.out.println("commentNo: " + commentNo);

// 댓글 내용
String commentSql = "select comment_content commentContent from comment where comment_no = ?";
PreparedStatement commentStmt = conn.prepareStatement(commentSql);
commentStmt.setInt(1, commentNo);
ResultSet commentRset = commentStmt.executeQuery();
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
				<div>
					<form action="./updateCommentAction.jsp" method="post">
						<input type="hidden" name="boardNo" value="<%=boardNo%>" />
						<input type="hidden" name="commentNo" value="<%=commentNo%>" />
						댓글
						<%
						if(commentRset.next()){
						%>
							<textarea class="form-control" name="commentContent" rows="2" cols="50" class="form-control"><%=commentRset.getString("commentContent")%></textarea>
						<%
						}
						%>
						<button type="submit" class="btn btn-danger float-right">작성</button>
					</form>
				</div>
  			</div>
  		</div>
  	</div>
  </body>
 </html>
 
 <%
 locationRset.close();
 commentRset.close();
 locationStmt.close();
 commentStmt.close();
 conn.close();
 %>