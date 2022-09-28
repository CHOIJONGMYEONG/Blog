<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("utf-8");
//로그인 안 한 사람 읽기 권한X
if(session.getAttribute("loginId") == null){
	response.sendRedirect("../index.jsp?errorMsg=noLogin");
	return;
}

// getParameter
int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));

Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "aa900413");

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
		               <table class="table table-hover table-striped">
					<%
					if(rset.next()){
					%>
					<tr>
						<th>축제일자</th>
						<td><%=rset.getString("diaryDate")%></td>
					</tr>
					<tr>
						<th>축제내용</th>
						<td><%=rset.getString("diaryTodo")%></td>
					</tr>
					<%
					}
					%>
				</table>
					<%
					if((Integer)session.getAttribute("loginLevel") > 0){
					%>
						<a href="./updateDiaryForm.jsp?diaryNo=<%=diaryNo%>" class="btn btn-outline-danger float-right">수정</a>
						<a href="./deleteDiaryAction.jsp?diaryNo=<%=diaryNo%>" class="btn btn-outline-danger float-right">삭제</a>
					<%
					}
					%>

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
<%
//자원해제
locationRset.close();
rset.close();
locationStmt.close();
stmt.close();
conn.close();
%>
		