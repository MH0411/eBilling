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
                    <div id="message"></div>
                    <div id="details" class="thumbnail">
                        <div style="margin-bottom: 250px">
                            <h4>Bill Parameter</h4>
                            <div class="form-group">
                                <%
                                    String query1 = 
                                            "SELECT param_code "
                                            + "FROM far_billing_parameter "
                                            + "WHERE param_code =(SELECT MAX(param_code) FROM far_billing_parameter)";
                                    ArrayList<ArrayList<String>> data = Conn.getData(query1);
                                    String itemCode = data.get(0).get(0);
                                    itemCode = itemCode.replaceAll("[^0-9]", "");

                                    String code = "BP";
                                    for (int i = 0 ; i < 2 ; i++){
                                        code = code + "0";
                                    }
                                    code = code + (Integer.parseInt(itemCode)+1);
                                %>
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
                                    <button id="update" type="submit" class="btn btn-success" >Update</button>
                                    <button id="delete" type="submit" class="btn btn-danger" >Delete</button>
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

        <script>
            function searchItem() {
                // Declare variables 
                var input, filter, table, tr, td, i;
                input = document.getElementById("search");
                filter = input.value.toUpperCase();
                table = document.getElementById("billPara");
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
            $("#billPara tbody tr").click(function(){
                $(this).addClass('selected').siblings().removeClass('selected');    
                document.getElementById('paraCode').value = $(this).find('td:first').html();
                document.getElementById('paraName').value = $(this).find('td:nth-child(2)').html();
                document.getElementById('value').value = $(this).find('td:nth-child(3)').html();
                var status = $(this).find('td:nth-child(4)').html();
                if (status === "yes"){
                    $('#enable').prop('value', 'N');
                    $('a[data-toggle="enable"]').not('[data-title="N"]').removeClass('active').addClass('notActive');
                    $('a[data-toggle="enable"][data-title="N"]').removeClass('notActive').addClass('active');
                } else if (status === "no") {
                    $('#enable').prop('value', 'N');
                    $('a[data-toggle="enable"]').not('[data-title="N"]').removeClass('active').addClass('notActive');
                    $('a[data-toggle="enable"][data-title="N"]').removeClass('notActive').addClass('active');
                }
            });
            $('#rbEnable a').on('click', function(){
                var sel = $(this).data('title');
                var tog = $(this).data('toggle');
                $('#'+tog).prop('value', sel);
                
                $('a[data-toggle="'+tog+'"]').not('[data-title="'+sel+'"]').removeClass('active').addClass('notActive');
                $('a[data-toggle="'+tog+'"][data-title="'+sel+'"]').removeClass('notActive').addClass('active');
            });
            $(document).ready(function(){
                $('#add').click(function(){
                    var paraCode = document.getElementById('paraCode').value;
                    var paraName = document.getElementById('paraName').value;
                    var value = document.getElementById('value').value;
                    var enable = $('#rbEnable a.active').html();
                    enable = String(enable).toLowerCase();
                    
                    $.get('manageParameter.jsp',{action:'add', paraCode:paraCode, paraName:paraName, value:value, enable:enable},function(data){
                        $('#message').html(data);
                        $("#details").load(location.href + " #details");
                    });
                });              
            });
            </script>
    </body>
</html>