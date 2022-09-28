<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.html"/>
	
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
    </div>
<jsp:include page="footer.html" />