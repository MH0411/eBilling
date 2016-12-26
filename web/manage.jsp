<%-- 
    Document   : manage
    Created on : Dec 24, 2016, 6:17:18 PM
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
                            <li class="active"><a href="manage.jsp"><span>Manage Bill</span></a></li>
                            <li><a href="miscellaneous.jsp"><span>Miscellaneous</span></a></li>
                            <li><a href="parameter.jsp"><span>Bill Parameter</span></a></li>
                            <li><a href="report.jsp"><span>Report</span></a></li>
                            <li><a href="closing.jsp"><span>Closing</span></a></li>
                        </ul>
                    </div>  
                </div>
        
                <!--body-->
                <div class="col-lg-10">
                    <div class="thumbnail">
                        <h4 style="display: inline-block;">Bill History</h4>
                        <div class="form-group" style="display: inline-block; float: right;">
                            <select id="status" class="form-control">
                                <option>Unpaid</option>
                                <option>Paid</option>
                            </select> 
                        </div>            
                        <div id="custom-search-input" style="margin-top: 7px;">
                            <div class="input-group ">
                                <input type="text" id="ic" class=" search-query form-control" placeholder="IC No." />
                                <span class="input-group-btn">
                                    <button id="search" class="btn btn-success pull-right" type="button">Search</button>
                                </span>
                            </div>
                        </div>
                        
                        <div id="billPara">
                            <table class="table table-filter table-striped" style="background: #fff; border: 1px solid #ccc; border-top: none;">
                                <thead>
                                    <th>Transaction Date</th>
                                    <th>Customer ID</th>
                                    <th>Name</th>
                                    <th>IC No.</th>
                                    <th>Other ID</th>
                                    <th>Address</th>
                                    <th>Phone No.</th>
                                    <th>Outstanding (RM)</th>
                                    <th></th>
                                </thead>
                                <tbody>
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
        <script>
            $(document).ready(function(){
                 $("#search").click(function(){
                    var status = $("#status").val();
                    var ic = $("#ic").val();
                    var query = 
                    $.get("searchPatient.jsp",{query:query},function(data){
                     $("#patientInfo").html(data);
                    });
                });
            });
    </body>
</html>