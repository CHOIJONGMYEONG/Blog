<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
//로그인 안 됐으면 홈으로
request.setCharacterEncoding("utf-8");
if(session.getAttribute("loginId") == null){
	response.sendRedirect("./index.jsp");
	return;
}

//블로그 주인 아니면 게시글 목록으로
if((Integer)session.getAttribute("loginLevel") < 1){
	response.sendRedirect("./boardList.jsp"); // 가야할 곳이 다름
	return;
}

String locationNo = request.getParameter("locationNo");
System.out.println("locationNo: " + request.getParameter("locationNo"));

// 현재 페이지 확인
int currentPage = 1;
if(request.getParameter("currentPage") != null){
	currentPage = Integer.parseInt(request.getParameter("currentPage"));
}

final int ROW_PER_PAGE = 10;
int beginRow = (currentPage - 1) * ROW_PER_PAGE;

// DB 연동
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "aa900413");
		
// 메뉴 목록
String locationSql = "select location_no locationNo, location_name locationName from location";
PreparedStatement locationStmt = conn.prepareStatement(locationSql);
ResultSet locationRset = locationStmt.executeQuery();
%>

<jsp:include page="header.html"/>
</head>
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
                    <form action="./insertBoardAction.jsp" method="post">
				<table class="table table-hover table-striped">
					<tr>
						<th>locationNo</th>
						<td>
							<select name="locationNo" class="form-control">
								<%
								locationRset.first();
									do {
								%>
										<option value="<%=locationRset.getString("locationNo")%>">
											<%=locationRset.getString("locationName")%>
										</option>
								<%	
									} while(locationRset.next()); // 일단 한 번 실행하고 조건을 검사
								%>
							</select>
						</td>
					</tr>
					<tr>
						<th>boardTitle</th>
						<td><input type="text" name="boardTitle" class="form-control"></td>
					</tr>
					<tr>
						<th>password</th>
						<td><input type="text" name="boardPw" class="form-control"></td>
					</tr>
					<tr>
						<th>boardContent</th>
						<td><textarea rows="5" cols="50" name="boardContent" class="form-control"></textarea></td>
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
						<li class="d-flex"><a href="./boardList.jsp">전체</a></li>
						
						<%
							locationRset.first();
							while(locationRset.next()){
						%>
								<li class="d-flex">
									<a href="./boardList.jsp?locationNo=<%=locationRset.getString("locationNo")%>">
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
	// DB 자원해제
	locationRset.close();
	locationStmt.close();
	conn.close();
%>