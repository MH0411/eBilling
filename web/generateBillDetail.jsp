<%-- 
    Document   : generateBillDetail
    Created on : Feb 1, 2017, 10:45:29 PM
    Author     : Mike Ho
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="dbConn.Conn"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    DecimalFormat df = new DecimalFormat("0.00");
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
    DateFormat dateFormat1 = new SimpleDateFormat("MMyyyy");
    Date date = new Date();
    String txnDate = dateFormat.format(date);
    String date1 = dateFormat1.format(date);
    double grandTotal;
    double subtotal = 0;
    double rounding;
    double gst = 0;
    double serviceCharge = 0;
    double discount = 0;
    double gstAmount = 0;
    double serviceChargeAmount = 0;
    double discountAmount = 0;
    
    String orderNo = request.getParameter("orderNo");
    String pmiNo = request.getParameter("pmiNo");
    
    //module name - > 
    //B = Billing
    //R = Receipt
    //I = Invoice
    String sql1 = "SELECT last_seq_no "
            + "FROM far_last_seq_no "
            + "WHERE module_name = 'B' "
            + "FOR UPDATE";
    ArrayList<ArrayList<String>> dataSeq = Conn.getData(sql1);

    //Get last sequance number
    String seqNo = dataSeq.get(0).get(0);
    int seq = Integer.parseInt(seqNo);
    int currSeq = seq + 1;
    String currentSeq = Integer.toString(currSeq);

    //Update last sequance number
    String sql2 = "UPDATE far_last_seq_no "
            + "SET last_seq_no = '"+ currentSeq +"' "
            + "WHERE module_name = 'B'";
    Conn.setData(sql2);

    //Generate bill no
    int length = (int) Math.log10(currSeq) + 1;
    String zero = "0";
    String num = currentSeq;
    int count;
    for (count = length; count < 10; count++) {
        num = zero + num;
    }
    String billNo = num + date1;
    
    //Display selected patient bill info
    String sql3 = "SELECT DISTINCT "
            + "pb.PATIENT_NAME, "
            + "pb.HOME_ADDRESS, "
            + "pb.NEW_IC_NO, "
            + "pb.ID_NO, "
            + "pb.MOBILE_PHONE, "
            + "NOW(), "
            + "pdd.DRUG_ITEM_CODE, "
            + "mdc.D_TRADE_NAME, "
            + "pdd.DISPENSED_QTY, "
            + "mdc.D_PRICE_PPACK, "
            + "(pdd.DISPENSED_QTY * mdc.D_PRICE_PPACK) AS TOTAL, "
            + "pb.ID_TYPE "
            + "FROM pms_episode pe "
            + "INNER JOIN pms_patient_biodata pb "
            + "ON pe.PMI_NO = pb.PMI_NO "
            + "INNER JOIN pis_order_master pom "
            + "ON pe.PMI_NO = pom.PMI_NO "
            + "INNER JOIN pis_dispense_master pdm "
            + "ON pom.ORDER_NO = pdm.ORDER_NO "
            + "INNER JOIN pis_dispense_detail pdd "
            + "ON pdm.ORDER_NO = pdd.ORDER_NO "  
            + "INNER JOIN pis_mdc2 mdc "
            + "ON pdd.DRUG_ITEM_CODE = mdc.UD_MDC_CODE "
            + "WHERE pe.PMI_NO = '"+ pmiNo +"' "
            + "AND pom.order_no = '"+ orderNo +"' ";
    ArrayList<ArrayList<String>> data = Conn.getData(sql3);
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
            <input type="text" class="form-control" name="txnDate" id="txnDate" value="<%=data.get(0).get(5)%>" readonly="true">
        </div>
        <label class="col-lg-2">Order No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="address" id="orderNo" value="<%=orderNo%>" readonly="true">
        </div>
        <label class="col-lg-2">PMI No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="address" id="pmiNo" value="<%=pmiNo%>" readonly="true">
        </div>        
        <label class="col-lg-2">Name</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="patientName" id="patientName" value="<%=data.get(0).get(0)%>" readonly="true">
        </div>
        <label class="col-lg-2">Address</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="address" id="address" value="<%=data.get(0).get(1)%>" readonly="true">
        </div>
        <label class="col-lg-2">IC No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="ic" id="ic" value="<%=data.get(0).get(2)%>" readonly="true">
        </div>
        <label class="col-lg-2">Other ID</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="otherID" id="otherID" value="<%=data.get(0).get(3)%>" readonly="true">
        </div>
        <label class="col-lg-2">Phone No.</label>
        <div class="col-lg-10" style="margin-bottom: 10px">
            <input type="text" class="form-control" name="phone" id="phone" value="<%=data.get(0).get(4)%>" readonly="true">
        </div>
    </div>
</div>
        
<div>
    <div id="listOfItems">
        <table id="tableItems" class="table table-filter table-striped" style="background: #fff; border: 1px solid #ccc; border-top: none;">
            <thead>
                <th>Item Code</th>
                <th>Item Description</th>
                <th style="text-align: right;">Item Quantity</th>
                <th style="text-align: right;">Unit Price (RM)</th>
                <th style="text-align: right;">Total Amount (RM)</th>
            </thead>
            <tbody>
<%
    if (!data.isEmpty()){
        for(int i = 0; i < data.size(); i++){
%>
            <tr>
                <td><%=data.get(i).get(6)%></td>
                <td><%=data.get(i).get(7)%></td>
                <td style="text-align: right;"><%=data.get(i).get(8)%></td>
                <td style="text-align: right;"><%=df.format(Double.parseDouble(data.get(i).get(9)))%></td>
                <td style="text-align: right;"><%=df.format(Double.parseDouble(data.get(i).get(10)))%></td>
            </tr>
<%          
            subtotal += Double.parseDouble(data.get(i).get(10));
        }
    }

    //Search and add miscellaneous item to table.
    String type = data.get(0).get(11);
    if (type.equals("Matric No.")) {
        type = "RG00001";
    } else if (type.equals("Staff No.")) {
        type = "RG00002";
    } else if (type.equals("Foreigner")) {
        type = "RG00003";
    }

    String sql4 = "SELECT * FROM far_miscellaneous_item WHERE item_code = '"+ type +"'";
    ArrayList<ArrayList<String>> dataItem = Conn.getData(sql4);
    subtotal = subtotal + Double.parseDouble(dataItem.get(0).get(4));
%>
        <tr>
            <td><%=dataItem.get(0).get(1)%></td>
            <td><%=dataItem.get(0).get(2)%></td>
            <td style="text-align: right;">1.00</td>
            <td style="text-align: right;"><%=df.format(Double.parseDouble(dataItem.get(0).get(4)))%></td>
            <td style="text-align: right;"><%=df.format(Double.parseDouble(dataItem.get(0).get(4)))%></td>
        </tr>
<%
    //Search and add billing parameters
    String sql5 = "SELECT param_code, param_name, param_value FROM far_billing_parameter WHERE enable = 'yes'";
    ArrayList<ArrayList<String>>billingParameters = Conn.getData(sql5);

    for (int i = 0 ; i < billingParameters.size() ; i++){
        if (billingParameters.get(i).get(1).equalsIgnoreCase("gst")){
            gst = Double.parseDouble(billingParameters.get(i).get(2));
        } else if (billingParameters.get(i).get(1).equalsIgnoreCase("service charge")){
            serviceCharge = Double.parseDouble(billingParameters.get(i).get(2));
        } else if (billingParameters.get(i).get(1).equalsIgnoreCase("discount")){
            discount = Double.parseDouble(billingParameters.get(i).get(2));
        }
    }

    //Calculate grand total
    discountAmount = subtotal * discount;
    discountAmount = Double.parseDouble(df.format(discountAmount));
    subtotal =  subtotal - discountAmount;

    serviceChargeAmount = subtotal * serviceCharge;
    serviceChargeAmount = Double.parseDouble(df.format(serviceChargeAmount));
    subtotal = subtotal + serviceChargeAmount;

    gstAmount = subtotal * gst;
    gstAmount = Double.parseDouble(df.format(gstAmount));
    subtotal = subtotal + gstAmount;

    //Round the grand total
    grandTotal = subtotal;
    grandTotal = Math.round(grandTotal * 20) / 20.0;

    rounding = grandTotal - subtotal;
    rounding = Double.parseDouble(df.format(rounding));
    
    //display to bill details table
    for (int i = 0 ; i < billingParameters.size() ; i++){
%>
        <tr>
            <td><%=billingParameters.get(i).get(0)%></td>
            <td><%=billingParameters.get(i).get(1)%></td>
            <td style="text-align: right;">1</td>
<%
        if (billingParameters.get(i).get(1).equalsIgnoreCase("gst")){
%>
            <td style="text-align: right;"><%=df.format(gstAmount)%></td>
            <td style="text-align: right;"><%=df.format(gstAmount)%></td>
<%
        } else if (billingParameters.get(i).get(1).equalsIgnoreCase("service charge")){
%>
            <td style="text-align: right;"><%=df.format(serviceChargeAmount)%></td>
            <td style="text-align: right;"><%=df.format(serviceChargeAmount)%></td>
<%
        } else if (billingParameters.get(i).get(1).equalsIgnoreCase("discount")){
%>
            <td style="text-align: right;"><%=df.format(discountAmount)%></td>
            <td style="text-align: right;"><%=df.format(discountAmount)%></td>
<%
        }
    }
%>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td style="text-align: right;"><b>Grand Total</b></td>
            <td id="grandTotal" style="text-align: right;"><%=df.format(grandTotal)%></td>
        </tr>
            </tbody>
        </table>
    </div>
</div>
        
<div>
        <div class="col-lg-4 pull-left" style="margin-bottom: 10px; ">
            <button id="cancel" class="btn btn-warning" style="float: left;">Cancel</button>
        </div>
        <div class="col-lg-8 pull-right" style="margin-bottom: 10px; ">
            <button id="back" class="btn btn-success" style="float: right;" disabled="true">Back</button>
            <button id="confirm" class="btn btn-success" style="float: right; margin-right: 10px;" >Confirm</button>
            <button id="addItem" class="btn btn-success" style="float: right; margin-right: 10px;" disabled="true">Add Item</button>
            <button id="payment" class="btn btn-info" style="float: right; margin-right: 10px;" disabled="true">Payment</button>
        </div>
</div>

<script type="text/javascript">
    $(document).ready(function(){
        $('#cancel').click(function(){
            location.reload();
        });
        
        $('#back').click(function(){
            location.reload();
        });
        
        $('#confirm').click(function(){
            var orderNo = document.getElementById('orderNo').value;
            var pmiNo = document.getElementById('pmiNo').value;
            var billNo = document.getElementById('billNo').value;
            var txnDate = document.getElementById('txnDate').value;
            var patientName = document.getElementById('patientName').value;
            var grandTotal = document.getElementById('grandTotal').innerHTML;
            var tableItem;
            tableItem = new Array();

            $('#tableItems tr').each(function(row, tr){
                tableItem[row]={
                    "itemCode" : $(tr).find('td:eq(0)').text()
                    , "itemDesc" : $(tr).find('td:eq(1)').text()
                    , "itemQty" : $(tr).find('td:eq(2)').text()
                    , "unitPrice" : $(tr).find('td:eq(3)').text()
                    , "totalPrice" : $(tr).find('td:eq(4)').text()
                };    
            }); 
            tableItem.shift();  // first row will be empty - so remove
            tableItem = JSON.stringify(tableItem);
            
            $.ajax({
                url: "saveGenerateBill.jsp",
                type: "post",
                data: {
                    pmiNo: pmiNo,
                    billNo: billNo,
                    orderNo: orderNo,
                    txnDate: txnDate,
                    patientName: patientName,
                    tableItem: tableItem,
                    grandTotal: grandTotal
                },
                timeout: 10000,
                success: function(data) {
                    var d = data.split("|");
                    if (d[1] == 1){
                        $('#confirm').prop('disabled', true);
                        $('#cancel').prop('disabled', true);
                        $('#addItem').prop('disabled', false);
                        $('#payment').prop('disabled', false);
                        $('#back').prop('disabled', false);
                        alert(d[2]);
                    } else {
                        alert(d[2]);
                    }
                },
                error: function(err) {
                }
            });
        });
        
        $('#addItem').click(function(){
            
        });
        
        $('#payment').click(function(){
            
        });
    });
</script>