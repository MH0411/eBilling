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
                    <div id="message"></div>
                    <div id="paraDetails" class="thumbnail">
                        <div style="margin-bottom: 250px">
                            <h4>Bill Parameter</h4>
                            <div class="form-group">
                                <label class="col-lg-2">Item Code</label>
                                <div class="col-lg-10" style="margin-bottom: 10px">
                                    <input type="text" class="form-control" name="paraCode" id="paraCode" value="<%=code%>" readonly="true">
                                </div>
                                <label class="col-lg-2">Item Name</label>
                                <div class="col-lg-10" style="margin-bottom: 10px">
                                  <input type="text" class="form-control" name="paraName" id="paraName">
                                </div>
                                <label class="col-lg-2">Value</label>
                                <div class="col-lg-10" style="margin-bottom: 10px">
                                  <input type="text" class="form-control" name="value" id="value">
                                </div>
                                <label class="col-lg-2">Enabled</label>
                                <div class="col-sm-7 col-md-7" style="margin-bottom: 10px">
                                        <div class="input-group">
                                                <div id="rbEnable" class="btn-group">
                                                        <a class="btn btn-primary btn-sm active" data-toggle="enable" data-title="Y">YES</a>
                                                        <a class="btn btn-primary btn-sm" data-toggle="enable" data-title="N">NO</a>
                                                </div>
                                                <input type="hidden" name="happy" id="enable">
                                        </div>
                                </div>
                                <label class="col-lg-2"></label>
                                <div class="col-lg-10 pull-right" style="margin-bottom: 10px">
                                    <button id="add" type="submit" class="btn btn-success" >Add</button>
                                    <button id="update" type="submit" class="btn btn-success" disabled="true">Update</button>
                                    <button id="delete" type="submit" class="btn btn-danger" disabled="true">Delete</button>
                                </div>
                            </div>
                        </div>
                        <div id="confirm" class="modal hide fade">
                            <div class="modal-body">
                                 Are you confirm to delete this item?
                            </div>
                            <div class="modal-footer">
                                <button type="button" data-dismiss="modal" class="btn btn-primary" id="confirmDelete">Delete</button>
                                <button type="button" data-dismiss="modal" class="btn">Cancel</button>
                            </div>
                        </div>                                
                        <div id="custom-search-input">
                            <div class="input-group ">
                                <input id="search" type="text" class=" search-query form-control" placeholder="Item Name" onkeyup="searchItem()"/>
                                <span class="input-group-btn">
                                    <button class="btn btn-success pull-right">Search</button>
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
                                </thead>
                                <tbody>
                                    <%
                                        DecimalFormat df = new DecimalFormat("0.00");
                                        String query2 = "SELECT * FROM far_billing_parameter";
                                        ArrayList<ArrayList<String>> data2 = Conn.getData(query2);
                                        if (!data2.isEmpty()){
                                            for (int i = 0; i< data2.size(); i++){
                                    %>
                                    <tr>
                                        <td><%=data2.get(i).get(0)%></td>
                                        <td><%=data2.get(i).get(1)%></td>
                                        <td><%=df.format(Double.parseDouble(data2.get(i).get(2)))%></td>
                                        <td><%=data2.get(i).get(5)%></td>
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