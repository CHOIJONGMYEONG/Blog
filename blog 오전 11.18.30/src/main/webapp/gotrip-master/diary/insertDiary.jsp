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
<jsp:include page="header.html"/>

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
	


<jsp:include page="footer.html" />
<%
//자원해제
locationRset.close();
locationStmt.close();
conn.close();
%>