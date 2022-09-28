<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("utf-8");
		// 로그인 안 됐으면 홈으로
		if(session.getAttribute("loginId") == null){
			response.sendRedirect("./index.jsp");
			return;
		}
	
		// 블로그 주인 아니면 게시글 목록으로
		if((Integer)session.getAttribute("loginLevel") < 1){
			response.sendRedirect("./boardList.jsp"); // 가야할 곳이 다름
			return;
		}
		
		String boardNo = request.getParameter("boardNo");
		System.out.println("deleteBoardForm -- boardNo: " + boardNo);
		
		// DB 연동
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "aa900413");
				
		// 메뉴 목록
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
		               <form action="./deleteBoardAction.jsp" method="post">
							<input type="hidden" name="boardNo" value="<%=boardNo%>">
							비밀번호: 
							<input type="password" name="inputPw">
							<button type="submit">삭제하기</button>
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
 </html>
 
 <%
 locationRset.close();
 locationStmt.close();
 conn.close();
 %>