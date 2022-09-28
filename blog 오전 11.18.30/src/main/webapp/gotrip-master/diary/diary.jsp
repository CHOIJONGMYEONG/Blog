<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<%@page import="vo.*"%><!-- ★★★★★★★★★★★★★★ -->

<%
// 달력 출력
// 연도와 월을 파라미터로 받아옴
request.setCharacterEncoding("utf-8");
Calendar c = Calendar.getInstance(); // 일단 오늘 날짜로 만듦
int year = c.get(Calendar.YEAR);
int month = c.get(Calendar.MONTH);

if(request.getParameter("year") != null || request.getParameter("month") != null){
	year = Integer.parseInt(request.getParameter("year"));
	month = Integer.parseInt(request.getParameter("month"));
	
	if(month == -1){ // 1월에서 이전 버튼
		month = 11;
		year--;
	}
	
	if(month == 12){ // 12월에서 다음 버튼
		month = 0;
		year++;
	}
	
	c.set(Calendar.YEAR, year);
	c.set(Calendar.MONTH, month);
}

int lastDay = c.getActualMaximum(Calendar.DATE);
System.out.println("해당 월의 마지막 날짜: " + lastDay);

int startBlank = 0; 
// 1일 전 빈 td의 개수
// 1일의 요일값에서 1을 뺀다
Calendar firstDate = Calendar.getInstance();
firstDate.set(year, month, 1);
startBlank = firstDate.get(Calendar.DAY_OF_WEEK) - 1;
System.out.println(year + "년 " + (month + 1) + "월의 startBlank: " + startBlank);

int endBlank = 7 - ((lastDay + startBlank) % 7);// 마지막 날 이후의 빈 td의 개수
endBlank %= 7; // 7 나오면 0으로 만들기

System.out.println(year + "년 " + (month + 1) + "월의 endBlank: " + endBlank);

// ------------------------------------
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "aa900413");
String sql = "select diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo from diary "
				+ "where YEAR(diary_date) = ? and MONTH(diary_date) = ? order by diary_date";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, c.get(Calendar.YEAR));
stmt.setInt(2, c.get(Calendar.MONTH) + 1);
ResultSet rs = stmt.executeQuery();

// 특수한 환경의 타입인 ResultSet -> ArrayList<Diary>
ArrayList<Diary>list = new ArrayList<>();

while(rs.next()){
	// rs: next()를 꼭 호출해야하고, 커서의 위치에 의존하여 재순환이 힘들다
	Diary d = new Diary();
	d.diaryNo = rs.getInt("diaryNo");
	d.diaryDate = rs.getString("diaryDate");
	d.diaryTodo = rs.getString("diaryTodo");
	
	list.add(d);
}
		
//메뉴 목록
String locationSql = "select location_no locationNo, location_name locationName from location";
PreparedStatement locationStmt = conn.prepareStatement(locationSql);
ResultSet locationRset = locationStmt.executeQuery();

//arraylist로 받았기 때문에 자원해제를 빨리 할 수 있다.
rs.close();
stmt.close();
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
		              <h1><%=year%>년 <%=month+1%>월</h1>
				<div>
					<a href="./diary.jsp?year=<%=year%>&month=<%=month-1%>" class="btn btn-outline-danger">이전 달</a>
					<a href="./diary.jsp?year=<%=year%>&month=<%=month+1%>" class="btn btn-outline-danger">다음 달</a>
				</div>
				<table class="table table-hover table-striped table-bordered">
					<tr>
						<td>일</td>
						<td>월</td>
						<td>화</td>
						<td>수</td>
						<td>목</td>
						<td>금</td>
						<td>토</td>
					</tr>
					<tr>
						<%
						for(int i = 1; i <= lastDay + startBlank + endBlank; i++){
							int date = i - startBlank;
							%>
							<td>
								<%	
								if(date < 1 || date > lastDay){
									// <td>공백</td>
								%>
									&nbsp;
								<%
								} else {
									// <td><a>날짜</a></td>
								%>
										<a href="./insertDiary.jsp?year=<%=year%>&month=<%=month%>&date=<%=date%>" class="float-right text-bold">
											<%=date%>
										</a>
									
								<%
									for(Diary d : list){
										String tmpDate = d.diaryDate.substring(d.diaryDate.length() - 2, d.diaryDate.length());
										int todoDate = Integer.parseInt(tmpDate);
										
										if(todoDate == date){
										%>
											<div><a href="./diaryOne.jsp?diaryNo=<%=d.diaryNo%>"><%= d.diaryTodo%></a></div>
										<%
										}
									}
								} // end for else
								%>
							</td>
							<%
							if(i % 7 == 0){
							%>
								</tr><tr>
							<%	
							}
						} // end for for
						%>
					</tr>
				</table>
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
locationStmt.close();
conn.close();
%>