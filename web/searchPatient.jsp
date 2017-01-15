<%--
    Document   : search
    Created on : Dec 25, 2016, 3:13:21 AM
    Author     : Mike Ho
--%>

<%@page import="dbConn.Conn"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  String date = request.getParameter("date");
  String ic = request.getParameter("ic");

  String query =
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
   ArrayList<ArrayList<String>> data = Conn.getData(query);
   System.out.print(query);
%>
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
    <tbody>
        <%
            if (!data.isEmpty()){
                for(int i = 0; i < data.size(); i++){
        %>
        <tr>
            <td><%=data.get(i).get(0)%></td>
            <td><%=data.get(i).get(1)%></td>
            <td><%=data.get(i).get(2)%></td>
            <td><%=data.get(i).get(3)%></td>
            <td><%=data.get(i).get(4)%></td>
            <td><%=data.get(i).get(5)%></td>
            <td><%=data.get(i).get(6)%></td>
            <td><%=data.get(i).get(7)%></td>
            <td><a href="#<%=i%>" class="btn btn-success pull-right">Generate Bill</a></td>
        </tr>
        <%}}%>
    </tbody>
</table>
<script type="text/javascript">
    $(document).ready(function(){
      $('#0').click(function(){ 
            alert('hi');
        });
    });
</script>