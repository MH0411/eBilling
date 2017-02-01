<%-- 
    Document   : historyBillDetail
    Created on : Jan 22, 2017, 2:26:23 AM
    Author     : Mike Ho
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    DecimalFormat df = new DecimalFormat("0.00");
    String custID = request.getParameter("custID");
    String billNo = request.getParameter("billNo");
    String status = request.getParameter("status");
    
    String query1 = 
            "SELECT patient_name, home_address, new_ic_no, id_no, mobile_phone "
            + "FROM pms_patient_biodata "
            + "WHERE pmi_no = '" + custID + "'";
    ArrayList<ArrayList<String>> dataPatient = dbConn.Conn.getData(query1);
%>
<div style="margin-bottom: 50px">
    <h4><b>Bill Detail</b></h4>
    <div class="form-group">
        <label class="col-lg-2">Bill No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="billNo" id="billNo" value="<%=billNo%>" readonly="true">
        </div>
        <label class="col-lg-2">Transaction Date</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="txnDate" id="txnDate" value="" readonly="true">
        </div>
        <label class="col-lg-2">Customer ID</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="txnDate" id="custID" value="<%=custID%>" readonly="true">
        </div>
        <label class="col-lg-2">Name</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="patientName" id="patientName" value="<%=dataPatient.get(0).get(0)%>" readonly="true">
        </div>
        <label class="col-lg-2">Address</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="address" id="address" value="<%=dataPatient.get(0).get(1)%>" readonly="true">
        </div>
        <label class="col-lg-2">IC No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="ic" id="ic" value="<%=dataPatient.get(0).get(2)%>" readonly="true">
        </div>
        <label class="col-lg-2">Other ID</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="otherID" id="otherID" value="<%=dataPatient.get(0).get(3)%>" readonly="true">
        </div>
        <label class="col-lg-2">Phone No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="phone" id="phone" value="<%=dataPatient.get(0).get(4)%>" readonly="true">
        </div>
    </div>
</div>
        
<div>
    <div id="listOfItems">
        <table id="tableItems" class="table table-filter table-striped" style="background: #fff; border: 1px solid #ccc; border-top: none;">
            <thead>
                <th>Transaction Date</th>
                <th>Item Code</th>
                <th>Item Description</th>
                <th style="text-align: right;">Item Quantity</th>
                <th style="text-align: right;">Unit Price (RM)</th>
                <th style="text-align: right;">Total Amount (RM)</th>
                <th><th>
            </thead>
            <tbody>
<%
        String query2 = 
                "SELECT txn_date, item_cd, item_desc, quantity, item_amt/quantity, item_amt "
                + "FROM far_customer_dtl "
                + "WHERE bill_no = '"+ billNo +"' ";
        ArrayList<ArrayList<String>> dataBill = dbConn.Conn.getData(query2);

        if (!dataBill.isEmpty()){
            System.out.print(dataBill);
            for(int i = 0; i < dataBill.size(); i++){
%>
            <tr>
                <td><%=dataBill.get(i).get(0)%></td>
                <td><%=dataBill.get(i).get(1)%></td>
                <td><%=dataBill.get(i).get(2)%></td>
                <td style="text-align: right;"><%=dataBill.get(i).get(3)%></td>
                <td style="text-align: right;"><%=df.format(Double.parseDouble(dataBill.get(i).get(4)))%></td>
                <td style="text-align: right;"><%=df.format(Double.parseDouble(dataBill.get(i).get(5)))%></td>
<%
            if (status.equalsIgnoreCase("unpaid")){
%>
                <td>
                    <button id="delete<%=i%>" class="btn btn-danger pull-right" type="button">Delete</button>
                </td>
<%} else {%>
                <td></td>
<%}%>
            </tr>
<%}}%>
            </tbody>
        </table>
    </div>
</div>
        
<div>
        <label class="col-lg-8"></label>
        <div class="col-lg-4 pull-right" style="margin-bottom: 10px; ">
<%
    if (status.equalsIgnoreCase("unpaid")){
%>
            <button id="payment" class="btn btn-success" style="float: right;">Payment</button>
            <button id="addItem" class="btn btn-success" style="float: right; margin-right: 10px;">Add Item</button>
<%} else {%>
            <button id="print" class="btn btn-info" style="float: right;">Print Receipt</button>
<%}%>
        </div>
</div>

<script type="text/javascript">
    $(document).ready(function(){
        $('#txnDate').val('<%=dataBill.get(0).get(0)%>');
<%
    if (status.equalsIgnoreCase("unpaid")){
            for (int i = 0; i < dataBill.size(); i++){
%>
        $('#delete<%=i%>').click(function(){
            var billNo = document.getElementById('billNo').value;
            var custID = document.getElementById('custID').value;
            var itemCode = $(this).closest("tr").find("td:nth-child(2)").text();
            var qty = $(this).closest("tr").find("td:nth-child(4)").text();
            var itemAmt = $(this).closest("tr").find("td:nth-child(6)").text();
            var $tr = $(this).closest ('tr');
            
            $.ajax({
                url: "deleteItem.jsp",
                type: "post",
                data: {
                    billNo: billNo,
                    custID: custID,
                    itemCode: itemCode,
                    itemAmt: itemAmt,
                    qty: qty
                },
                timeout: 10000,
                success: function(data) {
                    alert('Success delete data');
                     $tr.remove();
                },
                error: function(err) {
                    alert('Failed to delete the item.');
                }
            });
        });
<%}}%>
    });
</script>