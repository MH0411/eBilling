<%-- 
    Document   : miscellaneous
    Created on : Dec 24, 2016, 6:17:34 PM
    Author     : Mike Ho
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="dbConn.Conn"%>
<%@page import="java.util.ArrayList"%>
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
                            <li class="active"><a href="miscellaneous.jsp"><span>Miscellaneous</span></a></li>
                            <li><a href="parameter.jsp"><span>Bill Parameter</span></a></li>
                            <li><a href="report.jsp"><span>Report</span></a></li>
                            <li><a href="closing.jsp"><span>Closing</span></a></li>
                        </ul>
                    </div>        
                </div>
        
                <!--body-->
                <div class="col-lg-10">
                    <div id="message"></div>
                    <div id="miscDetails" class="thumbnail">
                        <div style="margin-bottom: 250px">
                            <h4>Miscellaneous Item</h4>
                            <div style="margin-bottom: 250px">
                                <div class="form-group">
                                    <%
                                        String query1 = 
                                                "SELECT item_code "
                                                + "FROM far_miscellaneous_item "
                                                + "WHERE item_code =(SELECT MAX(item_code) FROM far_miscellaneous_item)";
                                        ArrayList<ArrayList<String>> data1 = Conn.getData(query1);
                                        String itemCode = data1.get(0).get(0);
                                        itemCode = itemCode.replaceAll("[^0-9]", "");
                                        
                                        String code = "RG";
                                        for (int i = 0 ; i < 4 ; i++){
                                            code = code + "0";
                                        }
                                        code = code + (Integer.parseInt(itemCode)+1);
                                    %>
                                    <label class="col-lg-2">Item Code</label>
                                    <div class="col-lg-10" style="margin-bottom: 10px">
                                        <input type="text" class="form-control" name="itemCode" id="itemCode" value="<%=code%>" readonly="true">
                                    </div>
                                    <label class="col-lg-2">Item Name</label>
                                    <div class="col-lg-10" style="margin-bottom: 10px">
                                      <input type="text" class="form-control" name="itemName" id="itemName">
                                    </div>
                                    <label class="col-lg-2">Buying Price (RM)</label>
                                    <div class="col-lg-10" style="margin-bottom: 10px">
                                      <input type="text" class="form-control" name="buyPrice" id="buyPrice">
                                    </div>
                                    <label class="col-lg-2">Selling Price (RM)</label>
                                    <div class="col-lg-10" style="margin-bottom: 10px">
                                      <input type="text" class="form-control" name="sellPrice" id="sellPrice">
                                    </div>
                                    <label class="col-lg-2"></label>
                                    <div class="col-lg-10 pull-right" style="margin-bottom: 10px">
                                        <button type="submit" class="btn btn-success" >Add</button>
                                        <button type="submit" class="btn btn-success" disabled="true">Update</button>
                                        <button type="submit" class="btn btn-danger" disabled="true">Delete</button>
                                    </div>
                                </div>
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
                        <div id="confirm" class="modal hide fade">
                            <div class="modal-body">
                                 Are you confirm to delete this item?
                            </div>
                            <div class="modal-footer">
                                <button type="button" data-dismiss="modal" class="btn btn-primary" id="confirmDelete">Delete</button>
                                <button type="button" data-dismiss="modal" class="btn">Cancel</button>
                            </div>
                        </div>       
                        <div  id="miscItem" >
                            <table class="table table-filter table-striped" style="background: #fff; border: 1px solid #ccc; border-top: none;">
                                <thead>
                                    <th>Item Code</th>
                                    <th>Name</th>
                                    <th>Buying Price (RM)</th>
                                    <th>Selling Price (RM)</th>
                                </thead>
                                <tbody>
                                    <%
                                        DecimalFormat df = new DecimalFormat("0.00");
                                        String query2 = "SELECT * FROM far_miscellaneous_item";
                                        ArrayList<ArrayList<String>> data2 = Conn.getData(query2);
                                        if (!data2.isEmpty()){
                                            for (int i = 0; i< data2.size(); i++){
                                    %>
                                    <tr>
                                        <td><%=data2.get(i).get(1)%></td>
                                        <td><%=data2.get(i).get(2)%></td>
                                        <td><%=df.format(Double.parseDouble(data2.get(i).get(3)))%></td>
                                        <td><%=df.format(Double.parseDouble(data2.get(i).get(4)))%></td>
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
        
        <script>
            function searchItem() {
                // Declare variables 
                var input, filter, table, tr, td, i;
                input = document.getElementById("search");
                filter = input.value.toUpperCase();
                table = document.getElementById("miscItem");
                tr = table.getElementsByTagName("tr");

                // Loop through all table rows, and hide those who don't match the search query
                for (i = 0; i < tr.length; i++) {
                    td = tr[i].getElementsByTagName("td")[1];
                    if (td) {
                        if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    } 
                }
            }
            $("#miscItem tbody tr").click(function(){
                $(this).addClass('selected').siblings().removeClass('selected');    
                document.getElementById("itemCode").value=$(this).find('td:first').html();
                document.getElementById("itemName").value=$(this).find('td:nth-child(2)').html();
                document.getElementById("buyPrice").value=$(this).find('td:nth-child(3)').html();
                document.getElementById("sellPrice").value=$(this).find('td:nth-child(4)').html();
                
                $('#add').prop('.disabled', true);
                $('#update').prop('.disabled', false);
                $('#delete').prop('.disabled', false);        
            });
            $(document).ready(function(){
                var itemCode = document.getElementById('itemCode').value;
                var itemName = document.getElementById('itemName').value;
                var buyPrice = document.getElementById('buyPrice').value;
                var sellPrice = document.getElementById('sellPrice').value;
                
                $('#add').click(function(){
                    $.get('manageMiscellaneous.jsp',{action:'add', itemCode:itemCode, itemName:itemName, buyPrice:buyPrice, sellPrice:sellPrice},function(data){
                        $('#message').html(data);
                        $("#miscDetails").load(location.href + " #miscDetails");
                    });
                });       
                $('#update').click(function(){
                    $.get('manageMiscellaneous.jsp',{action:'update', itemCode:itemCode, itemName:itemName, buyPrice:buyPrice, sellPrice:sellPrice},function(data){
                        $('#message').html(data);
                        $("#miscDetails").load(location.href + " #miscDetails");
                    });
                });   
                $('#delete').click(function(){
                    $('#confirm').modal({ backdrop: 'static', keyboard: false })
                    .one('click', '#confirmDelete', function() {
                        $.get('manageMiscellaneous.jsp',{action:'delete', itemCode:itemCode},function(data){
                            $('#message').html(data);
                            $("#miscDetails").load(location.href + " #miscDetails");
                        });
                    });
                });            
            });
            </script>
    </body>
</html>