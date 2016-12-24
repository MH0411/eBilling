<%-- 
    Document   : parameter
    Created on : Dec 24, 2016, 6:18:20 PM
    Author     : Mike Ho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%@include file = "includes/header.html" %>
    <body>
        <%@include file = "includes/topMenu.html" %>
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
        
        <!--body-->
        <script src="assets/js/custom.js" type="text/javascript"></script>
    </body>
</html>