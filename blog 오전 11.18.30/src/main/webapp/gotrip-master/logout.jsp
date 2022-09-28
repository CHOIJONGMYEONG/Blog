<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 

session.invalidate();
// 세션 리셋
// 세션을 리셋하면 자동으로 새로운 세션이 할당된다

response.sendRedirect("./index.jsp");
%>