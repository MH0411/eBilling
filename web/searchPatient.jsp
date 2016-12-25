<%-- 
    Document   : search
    Created on : Dec 25, 2016, 3:13:21 AM
    Author     : Mike Ho
--%>

<%@page import="dbConn.Conn"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   String ic = request.getParameter("ic");
   String query = request.getParameter("query");
   ArrayList<ArrayList<String>> data = Conn.getData(query);
%>
<table class="table table-filter table-striped" style="background: #fff; border: 1px solid #ccc; border-top: none;">
    <thead>
        <th>Episode Date</th>
        <th>Order No</th>
        <th>PMI No.</th>
        <th>IC No.</th>
        <th>Other ID</th>
        <th>Name</th>
        <th>Address</th>
        <th>Phone No.</th>
        <th></th>
    </thead>
    <tbody>
        <%
            if (!data.isEmpty()){
                for(int i = 0; i < data.size(); i++){
        %>
        <tr>   
            <td><%=data.get(i).get(0)%></td>
            <td><%=data.get(i).get(1)%></td>
            <td><%=data.get(i).get(2)%></td>
            <td><%=data.get(i).get(3)%></td>
            <td><%=data.get(i).get(4)%></td>
            <td><%=data.get(i).get(5)%></td>
            <td><%=data.get(i).get(6)%></td>
            <td><%=data.get(i).get(7)%></td>
            <td><%=data.get(i).get(8)%></td>
            <td><%=data.get(i).get(9)%></td>
            <td><a href="#" class="btn btn-success pull-right">Generate Bill</a></td>
        </tr>   
        <%}}%>
    </tbody>
</table>
    