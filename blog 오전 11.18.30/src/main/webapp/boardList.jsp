<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
		String locationNo = request.getParameter("locationNo");
		System.out.println("locationNo: " + request.getParameter("locationNo"));
		
		request.setCharacterEncoding("utf-8");
		String word = request.getParameter("word"); // 검색어
		System.out.println("word: " + word);
		
		// 현재 페이지 확인
		int currentPage = 1;
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		final int ROW_PER_PAGE = 10;
		int beginRow = (currentPage - 1) * ROW_PER_PAGE;
		
		// DB 연동
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog", "root", "1234");
				
		// 메뉴 목록
		String locationSql = "select location_no locationNo, location_name locationName from location";
		PreparedStatement locationStmt = conn.prepareStatement(locationSql);
		ResultSet locationRset = locationStmt.executeQuery();
		
		// 게시글 목록
		//				O			X 		word
		// locationNo O 지역에서 검색	지역별 보기
		// locationNo x 전체 검색		전체 보기
		
		// 조인까지의 쿼리
		String countSql = "SELECT COUNT(*) as 'totalRow' FROM location l JOIN board b using(location_no)";
		String boardSql = "SELECT location_name locationName, location_no locationNo, board_no boardNo, board_title boardTitle FROM location l JOIN board b using(location_no)";
  		// 모든 쿼리는 정렬, limit으로 끝남
  		String sqlEnd = " ORDER BY board_no DESC LIMIT ?, ?"; // 마지막 setter는 limit 2개
		PreparedStatement boardStmt = null;
		PreparedStatement cntStmt = null; // 전체 컬럼 수 받아올 stmt
		String condition = "";
		
		if(locationNo == null && word == null){
			// 전체 보기
			// 리밋 안 붙인 count(*) 쿼리 돌려서 전체 컬럼 수 계산
			cntStmt = conn.prepareStatement(countSql);
			
			// 정렬, limit 붙여서 다시 수행 -> 10개씩 데이터 받아오는 용도
			boardSql += sqlEnd;
			boardStmt = conn.prepareStatement(boardSql);
			boardStmt.setInt(1, beginRow);
			boardStmt.setInt(2, ROW_PER_PAGE);
		} else if (locationNo == null && word != null){
			// 전체리스트에서 검색
			// cntStmt
			condition = " WHERE board_title like ?";
			countSql += condition;
			cntStmt = conn.prepareStatement(countSql);
			cntStmt.setString(1, "%" + word + "%");

			boardSql += condition + sqlEnd;
			boardStmt = conn.prepareStatement(boardSql);
			boardStmt.setString(1, "%" + word + "%");
			boardStmt.setInt(2, beginRow);
			boardStmt.setInt(3, ROW_PER_PAGE);
		} else if(locationNo != null && word == null){
			// 지역별 보기
			condition = " WHERE location_no = ?";
			countSql += condition;
			cntStmt = conn.prepareStatement(countSql);
			cntStmt.setInt(1, Integer.parseInt(locationNo));
			
			boardSql += condition + sqlEnd;
			boardStmt = conn.prepareStatement(boardSql);
			boardStmt.setInt(1, Integer.parseInt(locationNo));
			boardStmt.setInt(2, beginRow);
			boardStmt.setInt(3, ROW_PER_PAGE);
		} else {
			// 지역에서 검색
			condition = " WHERE location_no = ? and board_title like ?";
			countSql += condition;
			cntStmt = conn.prepareStatement(countSql);
			cntStmt.setInt(1, Integer.parseInt(locationNo));
			cntStmt.setString(2, "%" + word + "%");

			boardSql += condition + sqlEnd;
			boardStmt = conn.prepareStatement(boardSql);
			boardStmt.setInt(1, Integer.parseInt(locationNo));
			boardStmt.setString(2, "%" + word + "%");
			boardStmt.setInt(3, beginRow);
			boardStmt.setInt(4, ROW_PER_PAGE);
		}
		
		ResultSet countRset = cntStmt.executeQuery();
		ResultSet boardRset = boardStmt.executeQuery();
		
		// 반환된 컬럼 수 조회 (페이징에 사용)
		int totalRow = -1; // 검색 쿼리이기 때문에 cnt == 0 반환 가능 -> -1로 초기화
		if(countRset.next()){
			totalRow = countRset.getInt("totalRow");
		}
		System.out.println("totalRow: " + totalRow + "<<<<<<<<<<<<<<<<<<<<<<<<");
		
		// 마지막 row 계산
		// double로 나눴으므로 나눠떨어지지 않으면 무조건 소수점 생김 -> ceil로 올려서 페이지 수 맞추기
		int lastPage = (int)Math.ceil(totalRow / (double)ROW_PER_PAGE);
		
		// 각 페이지의 시작과 끝 구하기
		// currentPage - 1 해야 rowPerPage의 배수들이 +1 되지 않음	 
		int pageBegin = ((currentPage - 1) / ROW_PER_PAGE) * ROW_PER_PAGE + 1; // 페이지 시작 넘버
		int pageEnd = pageBegin + ROW_PER_PAGE - 1; // 페이지 끝 글 구하는 공식
		pageEnd = Math.min(pageEnd, lastPage); // 둘 중에 작은 값이 pageEnd
		
		// 페이징 a 태그 href 속성에 들어갈 쿼리스트링만 분기로 처리	
		String link = "./boardList.jsp?";

		// 파라미터 값이 존재할 때만 쿼리스트링 추가
		if(locationNo != null){
			link += "locationNo=" + locationNo;
		}
		
		if(word != null){
			link += "&word=" + word;
		}
		
		link += "&currentPage="; // 페이징 작업을 위해 currentPage를 맨 끝으로
	%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BLOG</title>
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
									<a href="./boardList.jsp?locationNo=<%=locationRset.getString("locationNo")%>">
										<%=locationRset.getString("locationName")%>
									</a>
								</li>
						<%
							}
						%>
					</ul>
				</div>
  			</div>
  			<div class="col-sm-8">
		  		<%	
				if(session.getAttribute("loginLevel") != null && (Integer)session.getAttribute("loginLevel") > 0){
					// loginlevel == null이면 null > 0을 검사하게 되니까 null 체크부터,
					// level 값(Object 타입)을 Integer로 형변환한 뒤 0보다 클 때만 글 입력이 나오게
					%>
					<div>
						<a href="./insertBoard.jsp" class="btn btn-danger float-right">글 입력</a>
					</div>
					<%
				}
				%>
				
				<table class="table table-hover table-striped">
					<thead>
						<tr>
							<th>locationName</th>
							<th>boardNo</th>
							<th>boardTitle</th>
						</tr>
					<thead>
					<tbody>
						<%
						while(boardRset.next()){
						%>
							<tr>
								<td><%=boardRset.getString("locationName")%></td>
								<td><%=boardRset.getInt("boardNo")%></td>
								<td>
									<a href="./boardOne.jsp?boardNo=<%=boardRset.getInt("boardNo")%>">
										<%=boardRset.getString("boardTitle")%>
									</a>
								</td>
							</tr>
						<%
						}
						%>
					</tbody>
				</table>
				
				<div>
					<form class="form-inline" action="./boardList.jsp">
						<%
							if(locationNo != null){
								%>
								<input type="hidden" name="locationNo" value="<%=locationNo%>"/>
								<%	
							}
						%>
	              		<label>제목 검색:</label>
	               		<input type="text" class="form-control" id="word" name="word">
	               		<!-- value=로 검색어 저장 가능 -> 하려면 null 처리 -->
	               		<button type="submit" class="btn btn-primary">Submit</button>
           			</form>
           			<br/>
				</div>
								
				<!-- 페이징 -->
				<div>
					<ul class="pagination">
						<li class="page-item">
						<%
						// 이전 버튼
						if(pageBegin > ROW_PER_PAGE){
						%>
							<a class="page-link" href="<%=link + pageBegin%>">이전</a>
						<%
						}
						%>
					
						</li><!-- 이전 태그의 끝 -->
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
						  <li class="page-item">
					
						<%
						// 다음 페이지
						if(pageEnd < lastPage){
						%>
							<a class="page-link" href="<%=link + (pageEnd + 1)%>">다음</a>
						<%
						}
						%>
						</li>
					</ul>
				</div><!-- 페이징 끝-->
  			</div>
		</div>
	</div>
</body>
</html>

<%
locationRset.close();
countRset.close();
boardRset.close();
locationStmt.close();
cntStmt.close();
boardStmt.close();
conn.close();
%>