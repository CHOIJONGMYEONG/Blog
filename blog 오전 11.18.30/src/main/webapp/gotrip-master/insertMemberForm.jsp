<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="header.html"/>

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
	<jsp:include page="footer.html" />
