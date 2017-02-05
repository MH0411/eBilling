<%-- 
    Document   : historyBillDetail
    Created on : Jan 22, 2017, 2:26:23 AM
    Author     : Mike Ho
--%>

<%@page import="dbConn.Conn"%>
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
            <input type="text" class="form-control" id="billNo" value="<%=billNo%>" readonly="true">
        </div>
        <label class="col-lg-2">Transaction Date</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" id="txnDate" value="" readonly="true">
        </div>
        <label class="col-lg-2">Customer ID</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" id="custID" value="<%=custID%>" readonly="true">
        </div>
        <label class="col-lg-2">Name</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" id="patientName" value="<%=dataPatient.get(0).get(0)%>" readonly="true">
        </div>
        <label class="col-lg-2">Address</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" id="address" value="<%=dataPatient.get(0).get(1)%>" readonly="true">
        </div>
        <label class="col-lg-2">IC No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" id="ic" value="<%=dataPatient.get(0).get(2)%>" readonly="true">
        </div>
        <label class="col-lg-2">Other ID</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" id="otherID" value="<%=dataPatient.get(0).get(3)%>" readonly="true">
        </div>
        <label class="col-lg-2">Phone No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" id="phone" value="<%=dataPatient.get(0).get(4)%>" readonly="true">
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
            <button class="btn btn-success" data-toggle="modal" data-target="#makePayment" style="float: right;">Payment</button>
            <button id="addItem" class="btn btn-success" style="float: right; margin-right: 10px;">Add Item</button>
<%} else {%>
            <button id="print" class="btn btn-info" style="float: right;">Print Receipt</button>
<%}%>
        </div>
</div>

<%
    double grandTotal = 0;
    double subtotal = 0;
    double amtPaid = 0;
    
    String query3 = "SELECT item_cd, item_desc, item_amt "
            + "FROM far_customer_dtl "
            + "WHERE bill_no = '"+ billNo +"' ";
    ArrayList<ArrayList<String>> data1 = Conn.getData(query3);

    for(int i = 0 ; i < data1.size() ; i++){
        grandTotal += Double.parseDouble(data1.get(i).get(2));
        if (data1.get(i).get(0).contains("BP") == true){
        } else {
            subtotal += Double.parseDouble(data1.get(i).get(2));
        }
    }

    String query4 = "SELECT item_amt, amt_paid "
            + "FROM far_customer_hdr "
            + "WHERE bill_no = '"+ billNo +"'";
    ArrayList<ArrayList<String>> data2 = Conn.getData(query4);
    grandTotal = Double.parseDouble(data2.get(0).get(0));
    amtPaid = Double.parseDouble(data2.get(0).get(1));

    double outstandingBalance = grandTotal-amtPaid;

    if ((outstandingBalance != 0) && (amtPaid != 0)){
        subtotal = outstandingBalance;
        grandTotal = outstandingBalance;
    }

    grandTotal = Math.round(grandTotal * 20) / 20.0;
%>        
<div class="modal fade" id="makePayment" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Payment Calculator</h4>
            </div>
            
            <div class="modal-body">
                <label class="col-lg-4">Subtotal</label>
                <div class="col-lg-8" style="margin-bottom: 10px">
                    <input type="text" class="form-control" id="subtotal" value="<%=df.format(subtotal)%>" readonly="true" style="text-align: center;">
                </div>
                <label class="col-lg-4">Grand Total</label>
                <div class="col-lg-8" style="margin-bottom: 10px">
                    <input type="text" class="form-control" id="grandTotal" value="<%=df.format(grandTotal)%>" readonly="true" style="text-align: center;">
                </div>
                <label class="col-lg-4">Payment Method</label>
                <div class="dropdown col-lg-8" style="margin-bottom: 10px">
                    <button id="paymentMethod" class="btn btn-primary dropdown-toggle form-control" type="button" data-toggle="dropdown">Cash</button>
                    <ul id="method" class="dropdown-menu">
                        <li><a>Cash</a></li>
                        <li><a>Credit Card</a></li>
                        <li><a>Cheque</a></li>
                    </ul>
                </div>
                <label class="col-lg-4">Amount Received</label>
                <div class="col-lg-8" style="margin-bottom: 10px">
                    <input type="text" class="form-control" id="amtReceived" value="" style="text-align: center;">
                </div>
                <label class="col-lg-4">Change</label>
                <div class="col-lg-8" style="margin-bottom: 10px">
                    <input type="text" class="form-control" id="change" value="" readonly="true" style="text-align: center;">
                </div>
            </div>
            <div class="modal-footer">
                <button id="payment" type="button" class="btn btn-success" data-dismiss="modal">Make Payment</button>
            </div>
        </div>
    </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $('#txnDate').val('<%=dataBill.get(0).get(0)%>');
        
        $('#amtReceived').keypress(function(event) {
            if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57) && event.which != 8) {
                event.preventDefault();
            }
        });
        
        $('#amtReceived').keyup(function() {
            var amtReceived =$(this).val();
            var grandTotal = document.getElementById('grandTotal').value;
            var change = 0;
            
            if (amtReceived == '.'){
                amtReceived = 0;
            }
            
            change = amtReceived - grandTotal;
            $('#change').val(change);
        });
        
        $('#method li a').click(function(){
            $('#paymentMethod').text($(this).text());
        });
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
<%}} else {%>
    
        $('#addItem').click(function (){
            
        });
        
        $('#payment').click(function (){
            var subTotal = document.getElementById('subtotal').value;
            var grandTotal = document.getElementById('grandTotal').value;
            var amtReceived = document.getElementById('amtReceived').value;
            var paymentMethod = document.getElementById('paymentMethod').innerHTML;
            var custID = document.getElementById('custID').value;
            var billNo = document.getElementById('billNo').value;
            
            if (amtReceived == '0' || amtReceived == '.' || amtReceived == ''){
                alert("Please insert an amount first.");
            } else {
                
                $.ajax({
                    url: "makePayment.jsp",
                    type: "post",
                    data: {
                        subTotal: subTotal,
                        grandTotal: grandTotal,
                        amtReceived: amtReceived,
                        paymentMethod: paymentMethod,
                        custID: custID,
                        billNo: billNo
                    },
                    timeout: 10000,
                    success: function(data) {
                       var d = data.split("|");
                       if (d[1] == 1){
                           alert(d[2]);
                           location.reload();
                       } else {
                           alert(d[2]);
                       }
                    },
                    error: function(err) {
                        alert('Failed to make payment.\nPlease try again.');
                    }
                });
            }
        });
<%}%>
    });
</script>