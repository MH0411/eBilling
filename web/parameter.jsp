<%-- 
    Document   : parameter
    Created on : Dec 24, 2016, 6:18:20 PM
    Author     : Mike Ho
--%>

<%@page import="dbConn.Conn"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.DecimalFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%@include file = "includes/header.html" %>
    <body>
        <div class="container-fluid">
            <%@include file = "includes/topMenu.html" %>
            <div class="row">
                <div class="col-lg-2">                
                    <div id="cssmenu">
                        <ul>
                            <li><a href="index.jsp"><span>Billing</span></a></li>
                            <li><a href="manage.jsp"><span>Manage Bill</span></a></li>
                            <li><a href="miscellaneous.jsp"><span>Miscellaneous</span></a></li>
                            <li class="active"><a href="parameter.jsp"><span>Bill Parameter</span></a></li>
                            <li><a href="report.jsp"><span>Report</span></a></li>
                            <li><a href="closing.jsp"><span>Closing</span></a></li>
                        </ul>
                    </div>   
                </div>
        
                <!--body-->
                <div class="col-lg-10">
                    <div class="thumbnail">
                        <h4>Bill Parameter</h4>
                        <div id="custom-search-input">
                            <div class="input-group ">
                                <input type="text" class="  search-query form-control" placeholder="Item Name" />
                                <span class="input-group-btn">
                                    <button id="search" class="btn btn-success pull-right" type="button">Search</button>
                                </span>
                            </div>
                        </div>
                        
                        <div id="billPara">
                            <table class="table table-filter table-striped" style="background: #fff; border: 1px solid #ccc; border-top: none;">
                                <thead>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Value</th>
                                    <th>Enable</th>
                                    <th></th>
                                </thead>
                                <tbody>
                                    <%
                                        DecimalFormat df = new DecimalFormat("0.00");
                                        String query = "SELECT * FROM far_billing_parameter";
                                        ArrayList<ArrayList<String>> data = Conn.getData(query);
                                        if (!data.isEmpty()){
                                            for (int i = 0; i< data.size(); i++){
                                    %>
                                    <tr>
                                        <td><%=data.get(i).get(0)%></td>
                                        <td><%=data.get(i).get(1)%></td>
                                        <td><%=df.format(Double.parseDouble(data.get(i).get(2)))%></td>
                                        <td><%=data.get(i).get(5)%></td>
                                        <td>
                                            <button id="delete" class="btn btn-success pull-right" type="button">Delete</button>
                                            <button id="edit" class="btn btn-success pull-right" type="button">Edit</button>
                                        </td>
                                    </tr>
                                    <%}}%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
            
        <!--js-->
        <script src="assets/js/dateformat.js" type="text/javascript"></script>
        <script src="assets/js/jquery.min.js" type="text/javascript"></script>
        <script src="assets/js/custom.js" type="text/javascript"></script>

    </body>
</html>