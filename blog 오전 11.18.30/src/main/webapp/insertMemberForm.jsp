<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertMemberForm</title>
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
		<h1>INSERT MEMBER</h1>
		<%
			if(request.getParameter("errorMsg") != null){
		%>
				<span style="color:red"><%=request.getParameter("errorMsg")%></span>
		<%		
			}
		%>
		<form method="post" action="./insertMemberAction.jsp">
			<table class="table table-hover table-striped">
				<tr>
					<td>id</td>
					<td><input type="text" name="id" class="form-control"></td>
				</tr>
				<tr>
					<td>pw</td>
					<td><input type="password" name="pw" class="form-control"></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-danger float-right">회원가입</button>
		</form>
	</div>
</body>
</html>