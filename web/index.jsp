<%-- 
    Document   : Main
    Created on : Dec 24, 2016, 2:19:32 PM
    Author     : Mike Ho
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="dbConn.Conn"%>
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
                            <li class="active"><a href="index.jsp"><span>Billing</span></a></li>
                            <li><a href="manage.jsp"><span>Manage Bill</span></a></li>
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
                        <h4>Patient Information</h4>
                        <div id="custom-search-input">
                            <div class="input-group ">
                                <input type="text" class="  search-query form-control" placeholder="IC no" />
                                <span class="input-group-btn">
                                    <button id="search" class="btn btn-success pull-right" type="button">Search</button>
                                </span>
                            </div>
                        </div>
                        
                        <div id="patientInfo">
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
                    var dateFormat = require('dateformat');
                    var now = new Date();
                    var date = dateFormat(now, "yyyy-mm-dd");
                    var ic = $(this).val();
                    var query = 
                        "SELECT distinct "
                            + "pe.episode_date, pom.order_no, pe.pmi_no, pb.new_ic_no, pb.id_no, "
                            + "pb.patient_name, pb.home_address, "
                            + "pb.mobile_phone "
                            + "FROM pms_episode pe "
                            + "INNER JOIN pis_order_master pom "
                            + "ON pe.pmi_no = pom.pmi_no "
                            + "INNER JOIN ehr_central ec "
                            + "ON pe.pmi_no = ec.pmi_no "
                            + "INNER JOIN pms_patient_biodata pb "
                            + "ON ec.pmi_no = pb.pmi_no "
                            + "WHERE (ec.status = 1 OR ec.status = 3) "
                            + "AND pe.status ='Discharge' "
                            + "AND pom.episode_code like '"+ date +" %' " 
                            + "AND pe.episode_date like '"+ date +" %' "
                            + "AND pb.new_ic_no = '"+ ic +"' "
                            + "AND NOT EXISTS ("
                            + "SELECT ch.order_no FROM far_customer_hdr ch "
                            + "WHERE ch.order_no = pom.order_no) "
                            + "GROUP BY pom.order_no";                        
                    $.get("searchPatient.jsp",{query:query},function(data){
                     $("#patientInfo").html(data);
                    });
                });
            });
        </script>
    </body>
</html>
