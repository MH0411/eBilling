<%-- 
    Document   : manageMiscellaneous
    Created on : Jan 1, 2017, 1:36:08 AM
    Author     : Mike Ho
--%><%@page import="dbConn.Conn"%>


<%@page import="dbConn.Conn"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
   String action = request.getParameter("action");
   String itemCode = request.getParameter("itemCode");
   
   if (action.equalsIgnoreCase("add") || action.equalsIgnoreCase("update")){
       String itemName = request.getParameter("itemName");
       String sellPrice = request.getParameter("sellPrice");
       String buyPrice = request.getParameter("buyPrice");
       
       if (itemName.isEmpty() || sellPrice.isEmpty() || buyPrice.isEmpty()){ 
%>
        <div class="alert alert-warning">
          <strong>Warning!</strong> Please fill in all empty fields.
        </div>
<%
       } else {
            String query = "";
            if (action.equalsIgnoreCase("add")){
                query = 
                    "INSERT into far_miscellaneous_item (item_code, item_desc, buying_price, selling_price)"
                        + "VALUES ('"+ itemCode +"','"+ itemName +"','"+ buyPrice +"','"+ sellPrice +"')";
            } else if (action.equalsIgnoreCase("update")) {        
                query = 
                    "UPDATE far_miscellaneous_item "
                        + "SET item_desc = '"+ itemName +"', buying_price = '"+ buyPrice +"', selling_price = '"+ sellPrice +"' "
                        + "WHERE item_code = '" + itemCode + "'";         
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
        if (itemCode.equals("RG00001") || itemCode.equals("RG00002") || itemCode.equals("RG00003")){
%>
                <div class="alert alert-warning">
                  <strong>Failed!</strong> Unable to delete default item.
                </div>     
<%
        } else {
            String query = "DELETE FROM far_miscellaneous_item "
                                    + "WHERE item_code='" + itemCode + "'";
            if (Conn.setData(query)){
%>
                <div class="alert alert-success">
                  <strong>Success!</strong> Item deleted successfully.
                </div>
<%

            } else {
%>
                <div class="alert alert-warning">
                  <strong>Failed!</strong> Item failed to delete. Please try again later.
                </div>
<%
            }
        }
    }
%>