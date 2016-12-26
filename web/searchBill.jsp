<%-- 
    Document   : searchBill
    Created on : Dec 25, 2016, 8:27:18 PM
    Author     : Mike Ho
--%>

<%@page import="dbConn.Conn"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ic = request.getParameter("ic");
    String status = request.getParameter("status");
    String query =
        "SELECT ch.bill_no, ch.customer_id, pb.patient_name, pb.new_ic_no, pb.id_no, "
        + "pb.home_address, pb.mobile_phone, ch.quantity, (ch.item_amt-ch.amt_paid) "
        + "FROM far_customer_hdr ch, pms_patient_biodata pb "
        + "WHERE ch.payment = '"+ status +"' "
        + "AND pb.pmi_no = ch.customer_id "
        + "AND pb.new_ic_no = '"+ ic +"'";
    ArrayList<ArrayList<String>> data = Conn.getData(query);
%>
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
        <%
            if (!data.isEmpty()){
                for(int i = 0; i < data.size(); i++){
        %>
        <tr>
            <td><%=data.get(i).get(0)%></td>
            <td><%=data.get(i).get(1)%></td>
            <td><%=df.format(Double.parseDouble(data.get(i).get(2)))%></td>
            <td><%=data.get(i).get(5)%></td>
            <td>
                <button id="delete" class="btn btn-success pull-right" type="button">Delete</button>
                <button id="edit" class="btn btn-success pull-right" type="button">Edit</button>
            </td>
        </tr>
        <%}}%>
    </tbody>
</table>

