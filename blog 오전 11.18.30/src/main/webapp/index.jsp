<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>INDEX</title>
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
	<h1>INDEX</h1>
	<h3>로그인</h3>
	
	<%
	// 에러 메시지가 있으면 출력!
		if(request.getParameter("errorMsg") != null){
			%>
			<div>
				<%=request.getParameter("errorMsg")%>
			</div>
			<%
		}
	%>
	
	<%
	// 로그인 전이면 로그인 폼 보여줌
	if(session.getAttribute("loginId") == null){
	%>
	
	<!-- LogIn Form-->
	<form method="post" action="./loginAction.jsp">
		<table class="table table-hover table-striped">
			<tr>
				<td>ID</td>
				<td><input type="text" name="id" class="form-control"></td>
			</tr>
			<tr>
				<td>PW</td>
				<td><input type="password" name="pw" class="form-control"></td>
			</tr>
		</table>
		<button type="submit" class="btn btn-primary">로그인</button>
		<a href="./insertMemberForm.jsp" class="btn btn-outline-primary">회원가입</a>
	</form>
	
	<% 
	} else {
		// 로그인이 되어 있으면 환영메시지
		%>
		<h2><%=session.getAttribute("loginId")%>님(Level: <%=session.getAttribute("loginLevel") %>), 반갑습니다</h2>
		<a href="./logout.jsp" class="btn btn-danger">로그아웃</a>
		<br/>
		<%
	}
	%>
	
	<br/>
		<div>
	       <a href="./boardList.jsp" class="btn btn-outline-danger">게시판</a>
	       <a href="./guestbook.jsp" class="btn btn-outline-danger">방명록</a>
	       <a href="./diary/diary.jsp" class="btn btn-outline-danger">다이어리</a>
	    </div>     
    </div>
</body>
</html>