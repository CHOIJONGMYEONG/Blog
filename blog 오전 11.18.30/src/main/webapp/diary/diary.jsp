<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<%@page import="vo.*"%><!-- ★★★★★★★★★★★★★★ -->

<%
// 달력 출력
// 연도와 월을 파라미터로 받아옴
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
Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
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

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>diary.jsp</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">

<!-- jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>

<!-- Popper JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1 class="container p-3 my-3 border">BLOG</h1>
		<div class="row">
			<div class="col-sm-2">
				<div>	
					<ul class="list-group">
						<li class="list-group-item"><a href="./boardList.jsp">전체</a></li>
						<%
							while(locationRset.next()){
						%>
								<li class="list-group-item">
									<a href="../boardList.jsp?locationNo=<%=locationRset.getInt("locationNo")%>">
										<%=locationRset.getString("locationName")%>
									</a>
								</li>
						<%
							}

						%>
					</ul>
				</div>
			</div><!-- end col-sm-2 -->
			<div class="col-sm-10">
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
	</div>
</body>
</html>

<%
//자원해제
locationRset.close();
locationStmt.close();
conn.close();
%>