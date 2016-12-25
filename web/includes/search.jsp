<%-- 
    Document   : search.jsp
    Created on : Dec 24, 2016, 9:35:01 PM
    Author     : Mike Ho
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="dbConn.Conn"%>
<%
   String ic = request.getParameter("ic");
   String query = request.getParameter("query");
   try {
       ArrayList<ArrayList<String>> data = Conn.getData(query);
       out.print(data);
   } catch (Exception e) {
        e.printStackTrace();
   }
%>