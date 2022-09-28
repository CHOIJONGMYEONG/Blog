<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
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
<jsp:include page="header.html"/>
<body>
	
     <!-- slider Area Start-->
     <div class="slider-area ">
        <!-- Mobile Menu -->
        <div class="single-slider slider-height2 d-flex align-items-center" data-background="assets/img/hero/about.jpg">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12">
                    </div>
                </div>
            </div>
        </div>
     </div>
     <!-- slider Area End-->
    <!--================Blog Area =================-->
    <section class="blog_area section-padding">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mb-5 mb-lg-0">
                    <div class="blog_left_sidebar">
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
                
                
                <div class="col-lg-4">
                    <div class="blog_right_sidebar">

                        <aside class="single_sidebar_widget post_category_widget">
                            <h4 class="widget_title">Category</h4>
                            <ul class="list cat-list">
						<li class="d-flex"><a href="../boardList.jsp">전체</a></li>
						
						<%
							while(locationRset.next()){
						%>
								<li class="d-flex">
									<a href="../boardList.jsp?locationNo=<%=locationRset.getString("locationNo")%>">
										<%=locationRset.getString("locationName")%>
									</a>
								</li>
						<%
							}
						%>
                            </ul>
                        </aside>
                      


                    </div>
                </div>
            </div>
        </div>
    </section>
	
	
	
	
</body>
<jsp:include page="footer.html" />