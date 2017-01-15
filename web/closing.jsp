<%-- 
    Document   : closing
    Created on : Dec 24, 2016, 6:17:59 PM
    Author     : Mike Ho
--%>

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
                            <li><a href="parameter.jsp"><span>Bill Parameter</span></a></li>
                            <li><a href="report.jsp"><span>Report</span></a></li>
                            <li class="active"><a href="closing.jsp"><span>Closing</span></a></li>
                        </ul>
                    </div>   
                </div>
        
                <!--body-->
                <div class="col-lg-10">
                    <div id="message"></div>
                    <div id="reportDetails" class="thumbnail">
                        <div style="margin-bottom: 250px">
                            <h4>Year End Processing</h4>
                            <div id="patient" class="col-lg-10" style="margin-bottom: 10px">
                                <select id="year">
                                </select>
                            </div>
                            <div class="col-lg-10" style="margin-bottom: 10px">
                                <button id="yearlyStatement" type="submit" class="btn btn-info" >Customer Yearly Account Statement</button><br>
                            </div>
                            <div class="col-lg-10" style="margin-bottom: 10px">
                                <button id="detailsStatement" type="submit" class="btn btn-info" >Customer Details Account Statement</button><br>
                            </div>
                            <div class="col-lg-10" style="margin-bottom: 10px">
                                <form action="report.jsp" method="POST">
                                    <button id="yearEndReport" type="submit" class="btn btn-info" >Year End Processing Report</button>
                                </form>
                            </div>
                    </div>
                </div>
            </div>
        </div>
            
        <!--js-->
        <script src="assets/js/jquery.min.js" type="text/javascript"></script>
        <script src="assets/js/custom.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                var $year = $("#year");
                $year.empty();
                $.each(vals, function(index, value) {
                    $year.append("<option>" + value + "</option>");
                });
            });
        </script>
    </body>
</html>