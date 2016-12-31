<%-- 
    Document   : manageParameter
    Created on : Dec 29, 2016, 2:38:51 AM
    Author     : Mike Ho
--%>

<%@page import="dbConn.Conn"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   String action = request.getParameter("action");
   String paraCode = request.getParameter("paraCode");
   
   if (action.equalsIgnoreCase("add") || action.equalsIgnoreCase("update")){
       String paraName = request.getParameter("paraName");
       String value = request.getParameter("value");
       String enable = request.getParameter("enable");
       
       if (paraName.isEmpty() || value.isEmpty()){ 
%>
        <div class="alert alert-warning">
          <strong>Warning!</strong> Please fill in all empty fields.
        </div>
<%
       } else {
            String query = "";
            if (action.equalsIgnoreCase("add")){
                query = 
                    "INSERT INTO far_billing_parameter(param_code,"
                        + " param_name, param_value, enable) "
                        + "VALUES('"+ paraCode +"', '"+ paraName +"',"
                        + " '"+ value +"', '"+ enable +"')";
            } else if (action.equalsIgnoreCase("update")) {        
                query = 
                    "UPDATE far_billing_parameter "
                        + "SET param_code = '"+ paraCode +"', param_name = '"+ paraName +"',"
                        + " param_value = '"+ value +"', enable = '"+ enable +"' "
                        + "WHERE param_code = '"+ paraCode +"'";           
            }
            if (Conn.setData(query)){
%>
                <div class="alert alert-success">
                  <strong>Success!</strong> Item updated successfully.
                </div>          
<%
            } else {
%>
                <div class="alert alert-warning">
                  <strong>Failed!</strong> Item failed to update. Please try again later.
                </div>
<%
            }
       }
   } else if (action.equalsIgnoreCase("delete")){
%>
<%
        String query = "DELETE FROM far_billing_parameter "
                                    + "WHERE param_code = '"+ paraCode +"'";
        if (Conn.setData(query)){
%>
                <div class="alert alert-success">
                  <strong>Success!</strong> Item updated successfully.
                </div>
<%
            
        }
}
%>