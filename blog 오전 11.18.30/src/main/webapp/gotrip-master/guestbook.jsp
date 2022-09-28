<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
		request.setCharacterEncoding("utf-8");

		// DB 연동
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "aa900413");
				
		// 메뉴 목록
		String locationSql = "select location_no locationNo, location_name locationName from location";
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		ResultSet locationRset = locationStmt.executeQuery(); 
		
		// 페이징
		// 현재 페이지 확인
		int currentPage = 1;
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		final int ROW_PER_PAGE = 10;
		int beginRow = (currentPage - 1) * ROW_PER_PAGE;
		int totalRow = -1;
				
		// 방명록 불러오기
		String guestBookSql = "select guestbook_no guestbookNo, guestbook_content guestbookContent, id, create_date createDate from guestbook order by guestbook_no desc limit ?, ?";
		PreparedStatement guestBookStmt = conn.prepareStatement(guestBookSql);
		guestBookStmt.setInt(1, beginRow); 
		guestBookStmt.setInt(2, ROW_PER_PAGE);
		ResultSet guestBookRset = guestBookStmt.executeQuery();
		
		// count(*)
		String cntSql = "select count(*) from guestbook";
		PreparedStatement cntStmt = conn.prepareStatement(cntSql);
		ResultSet cntRset = cntStmt.executeQuery();
		
		if(cntRset.next()){
			totalRow = cntRset.getInt("count(*)");
		}
		
		// 마지막 페이지 계산
		int lastPage = (int)Math.ceil(totalRow / (double)ROW_PER_PAGE);
		
		// 각 페이지의 시작과 끝
		int pageBegin = ((currentPage - 1) / ROW_PER_PAGE) * ROW_PER_PAGE + 1; // 페이지 시작 넘버
		int pageEnd = pageBegin + ROW_PER_PAGE - 1;
		pageEnd = Math.min(pageEnd, lastPage);
		
		// 쿼리스트링 만들기
		String link = "./guestbook.jsp?currentpage=";
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
		               	<% 
	  			if(session.getAttribute("loginId") != null){
	  			%>
		  			<form method="post" action="./insertGuestbookAction.jsp">
		  				<!-- hidden 값 필요 없음. getAttribute("loginId")로 해결 -->
		  				<div>
		  					<textarea rows="3" cols="" name="guestbookContent" class="form-control"></textarea>
		  				</div>
		  				<div>
		  					<button type="submit" class="btn btn-danger float-right">글 입력</button>
		  				</div>
		  			</form>
	  			<%
	  			}
	  			// 댓글 뿌리기
	  			while(guestBookRset.next()){
	  			%>
	  			<table class="table table-striped">
	  				<tr>
	  					<td colspan="2"><%=guestBookRset.getString("guestbookContent")%></td>
	  				</tr>
	  				<tr>
	  					<td><%=guestBookRset.getString("id")%></td>
	  					<td><%=guestBookRset.getString("createDate")%></td>
	  				</tr>
	  			</table>
	  					<% 
	  						String loginId = (String)session.getAttribute("loginId");
	  						if(loginId != null && loginId.equals(guestBookRset.getString("id"))){
	  					%>
	  							<a href="./deleteGuestBookAction.jsp?guestbookNo=<%=guestBookRset.getString("guestbookNo")%>" class="btn btn-outline-danger float-right">삭제</a>
	  					<%
	  						}
	  			}
	  			%>
  			
  		
			<ul class="pagination">
				<%			
				// 이전 버튼
				if(pageBegin > ROW_PER_PAGE){
				%>
					<li class="page-item"><a class="page-link" href="<%=link + pageBegin%>">이전</a></li>
				<%
				}
				%>
			
				<!-- 숫자 페이징 -->
				<%	
				for(int i = pageBegin; i <= pageEnd; i++){							
				%>
					<li class="page-item">
						<a class="page-link" href="<%=link + i%>"><%=i%></a>
					</li>
				<%
				}
				%>
				  
				<%
				// 다음 페이지
				if(pageEnd < lastPage){
				%>
					<li class="page-item"><a class="page-link" href="<%=link + (pageEnd + 1)%>">다음</a></li>
				<%
				}
				%>
				</ul>
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
 
 
 	
 // 자원 해제
 guestBookRset.close();
 locationRset.close();
 guestBookStmt.close();
 locationStmt.close();
 conn.close();
 %>