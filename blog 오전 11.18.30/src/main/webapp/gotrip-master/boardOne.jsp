<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
// 로그인 안 한 사람 돌려보내기
/* if(session.getAttribute("loginId") == null){
	response.sendRedirect("./boardList.jsp");
	return;
} */

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

int boardNo = Integer.parseInt(request.getParameter("boardNo"));
				
// 글 띄우기
String sql = "select l.location_name locationName, b.board_title boardTitle, b.board_content boardContent, b.board_pw boardPw, b.create_date create_date from board b join location l on b.location_no = l.location_no where b.board_no = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, boardNo);
ResultSet rset = stmt.executeQuery();

// 댓글 띄우기
String commentSql = "select id, comment_no commentNo, comment_content commentContent, create_date createDate from comment where board_no = ?";
PreparedStatement commentStmt = conn.prepareStatement(commentSql);
commentStmt.setInt(1, boardNo);
ResultSet commentRset = commentStmt.executeQuery();
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
							<th>location_name</th>
							<td><%=rset.getString("location_name")%></td>
						</tr>
						<tr>
							<th>board_title</th>
							<td><%=rset.getString("board_title")%></td>
						</tr>
						<tr>
							<th>board_content</th>
							<td><%=rset.getString("board_content")%></td>
						</tr>
						<tr>
							<th>create_date</th>
							<td><%=rset.getString("create_date")%></td>
						</tr>
				</table>
				<%
						}
					
					if((Integer)session.getAttribute("loginLevel") > 0){
					%>
						<a href="./updateBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-outline-danger float-right">수정</a>
						<a href="./deleteBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-outline-danger float-right">삭제</a>
					<%
					}
					%>
				
				
				
				<div>
					<!------- 댓글 확인 ------->
					<br/>
					<table class="table table-hover table-striped">
						<%
						while(commentRset.next()){
						%>
							<tr>
								<td>댓글</td>
								<td><%=commentRset.getString("commentContent")%></td>
							</tr>
							<tr>
								<td>날짜</td>
								<td><%=commentRset.getString("createDate")%></td>
							</tr>
							<tr>
								
								<% 
								if(commentRset.getString("id").equals((String)session.getAttribute("loginId"))){ // 로그인이 됐고, dbId.equals(sessionId){
								%>
								<td colspan="2">
									<a href="./updateCommentForm.jsp?boardNo=<%=boardNo%>&commentNo=<%=commentRset.getString("commentNo")%>" class="btn btn-outline-danger float-right">수정</a>
									<a href="./deleteCommentAction.jsp?boardNo=<%=boardNo%>&commentNo=<%=commentRset.getString("commentNo")%>" class="btn btn-outline-danger float-right">삭제</a>
								</td>
								<%
								}
								%>
							</tr>
						<%
						}
						%>
					</table>
					<br/>
				</div>
			
				<!------- 댓글 입력 폼 ------->
				<div>
					<form action="./insertCommentAction.jsp" method="post">
						<input type="hidden" name="boardNo" value="<%=boardNo%>" />
						<div>
							댓글
							<textarea class="form-control" name="commentContent" rows="2" cols="50"></textarea>
						</div>
						<button type="submit" class="btn btn-danger float-right">작성</button>
					</form>
				</div>

					</div>
				</div>
		
			 <div class="col-lg-4">
                    <div class="blog_right_sidebar">
                        <aside class="single_sidebar_widget search_widget">
                            <form  action="./boardList.jsp">
                            <%
							if(locationNo != null){
								%>
								<input type="hidden" name="locationNo" value="<%=locationNo%>"/>
								<%	
								}
							%>
                            
                                <div class="form-group">
                                    <div class="input-group mb-3">
                                        <input type="text" class="form-control" placeholder='Search Keyword'
                                           id="word" name="word">
                                        <div class="input-group-append">
                                            <button class="btns" type="button"><i class="ti-search"></i></button>
                                        </div>
                                    </div>
                                </div>
                                <button class="button rounded-0 primary-bg text-white w-100 btn_1 boxed-btn"
                                    type="submit">Search</button>
                            </form>
                        </aside>

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
</html>
<jsp:include page="footer.html" />
<%
//자원해제
locationRset.close();
rset.close();
commentRset.close();
locationStmt.close();
commentStmt.close();
stmt.close();
conn.close();
%>
						