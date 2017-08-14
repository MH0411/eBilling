/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Class;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import dbConn.Conn;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author MH0411
 */
public class SalesReport extends HttpServlet {
    
    private Font recti = new Font(Font.HELVETICA, 16, Font.BOLD);
    private Font rectem = new Font(Font.HELVETICA, 12, Font.BOLD);
    private Font rectemja = new Font(Font.COURIER, 12);
    private Font rectemjaBold = new Font(Font.COURIER, 12, Font.BOLD);
    private Font rectemjaBig = new Font(Font.COURIER, 16, Font.BOLD);
    
    private DecimalFormat df = new DecimalFormat("0.00");
    private String strDay = "";
    private String strMon = "04";
    private String strYear = "2017";
    private String userID = "";
    private String hfc_cd = "";
    
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        strDay = request.getParameter("day");
//        strMon = request.getParameter("month");
//        strDay = request.getParameter("year");
//        userID = request.getSession().getAttribute("USER_ID").toString();
//        hfc_cd = request.getSession().getAttribute("HEALTH_FACILITY_CODE").toString();

        
        String sql = "";
        
        if (!(strDay.isEmpty() && strMon.isEmpty() && strYear.isEmpty())){
            sql = "SELECT cl.item_cd, cl.item_desc, SUM(cl.quantity), SUM(cl.item_amt) "
                    + "FROM far_customer_dtl cl, far_customer_hdr ch "
                    + "WHERE DATE(cl.txn_date) = '" + strYear + "-" + strMon + "-" + strDay + "' "
                    //+ "AND ch.hfc_cd = '" + hfc_cd + "' "
                    + "GROUP BY cl.item_cd "
                    + "ORDER BY SUM(cl.quantity) DESC";
            generateDayOrMonthSalesReport(response, sql);
            
        } else if (!(strMon.isEmpty() && strYear.isEmpty())){
            sql = "SELECT item_cd, item_desc, SUM(quantity), SUM(item_amt) "
                    + "FROM far_customer_dtl " 
                    + "WHERE MONTH(txn_date) = '" + strMon + "' "
                    //+ "AND ch.hfc_cd = '" + hfc_cd + "' "
                    + "GROUP BY item_cd " 
                    + "ORDER BY SUM(quantity) DESC";
            generateDayOrMonthSalesReport(response, sql);
            
        } else if (!(strYear.isEmpty())){
            sql = "SELECT MONTHNAME(txn_date), item_cd, item_desc, SUM(quantity), SUM(item_amt) "
                    + "FROM far_customer_dtl "
                    + "WHERE YEAR(txn_date) = '" + strYear + "' "
                    //+ "AND ch.hfc_cd = '" + hfc_cd + "' "
                    + "AND"
                    + "GROUP BY item_cd "
                    + "ORDER BY txn_date, SUM(quantity) DESC";
            generateYearSalesReport(response, sql);
        }
    }
    
    private void generateDayOrMonthSalesReport(HttpServletResponse response, String sql){
        try {   
            //Create and set PDF format
            Document document = new Document(PageSize.A4, 36, 36, 64, 36); 
            document.setMargins(40, 30, 50, 50); 
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            document.open();
        
            PdfPTable table = new PdfPTable(6);
            table.setWidths(new float[]{0.5f, 1.5f, 4f, 1.5f, 1.5f, 1.5f});
            table.setLockedWidth(true);
            table.setTotalWidth(document.right() - document.left());
            
            PdfPTable header = new PdfPTable(4);
            header.setWidths(new float[]{3f, 4f, 3.5f, 4f});
            header.setLockedWidth(true);
            header.setTotalWidth(document.right() - document.left());
            
//            String sql_getHFAddr = 
//                    "SELECT hfc_name, address1, address2, address3 "
//                    + "FROM adm_health_facility "
//                    + "WHERE hfc_cd = '"+ hfc_cd +"'";
//            ArrayList<ArrayList<String>> hfData = Conn.getData(sql_getHFAddr);
//            String hfName = hfData.get(0).get(0);
//            String hfAddr1 = hfData.get(0).get(1);
//            String hfAddr2 = hfData.get(0).get(2);
//            String hfAddr3 = hfData.get(0).get(3); 
            
            int num = 1;
            ArrayList<ArrayList<String>> saleData = Conn.getData(sql);
            for(int i = 0; i < saleData.size(); i++){
                String no = Integer.toString(num++);

                String itemCode = saleData.get(i).get(0);
                String itemName = saleData.get(i).get(1);
                String totalQty = saleData.get(i).get(2);
                String totalSales = saleData.get(i).get(3);

                PdfPCell cell71 = new PdfPCell(new Phrase(no, rectemja));
                cell71.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell71.setBorder(Rectangle.NO_BORDER);
                PdfPCell cell72 = new PdfPCell(new Phrase(itemCode, rectemja));
                cell72.setHorizontalAlignment(Element.ALIGN_LEFT);
                cell72.setBorder(Rectangle.NO_BORDER);
                PdfPCell cell73 = new PdfPCell(new Phrase(itemName, rectemja));
                cell73.setHorizontalAlignment(Element.ALIGN_LEFT);
                cell73.setBorder(Rectangle.NO_BORDER);
                PdfPCell cell74 = new PdfPCell(new Phrase(totalQty, rectemja));
                cell74.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell74.setBorder(Rectangle.NO_BORDER);
                PdfPCell cell75 = new PdfPCell(new Phrase(totalSales, rectemja));
                cell75.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell75.setBorder(Rectangle.NO_BORDER);

                table.addCell(cell71);
                table.addCell(cell72);
                table.addCell(cell73);
                table.addCell(cell74);
                table.addCell(cell75);
            }
            
            //----------------------------table footer--------------------------------------->
            PdfPTable footer = new PdfPTable(1);
            footer.setWidths(new float[]{10.5f});
            footer.setLockedWidth(true);
            footer.setTotalWidth(document.right() - document.left());
            
            String message1 = "****End of Report****";
            String message2 = "";
            PdfPCell cell160 = new PdfPCell(new Phrase(message1, rectemja));
            cell160.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell160.setBorder(Rectangle.TOP);
            PdfPCell cell170 = new PdfPCell(new Phrase(message2, rectemja));
            cell170.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell170.setBorder(Rectangle.NO_BORDER);
            
            footer.addCell(cell160);
            footer.addCell(cell170);
            
            document.add(header);
            document.add(table);
            document.add(footer);
            
            //Close the PDF for ready to send
            document.close();//close document
            writer.close();
            
            //Send to client browser
            response.setHeader("Expires", "0");
            response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
            response.setHeader("Pragma", "public");
            response.setContentType("application/pdf");
            response.setContentLength(baos.size());
            OutputStream os = response.getOutputStream();
            baos.writeTo(os);
            os.flush();
            os.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void generateYearSalesReport(HttpServletResponse response, String sql){
        try {
            //Create and set PDF format
            Document document = new Document(PageSize.A4, 36, 36, 64, 36); 
            document.setMargins(40, 30, 50, 50); 
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            document.open();
        
            PdfPTable table = new PdfPTable(6);
            table.setWidths(new float[]{0.5f, 1.5f, 4f, 1.5f, 1.5f, 1.5f});
            table.setLockedWidth(true);
            table.setTotalWidth(document.right() - document.left());
            
            
            ArrayList<ArrayList<String>> saleData = Conn.getData(sql);
            
            PdfPTable header = new PdfPTable(4);
            header.setWidths(new float[]{3f, 4f, 3.5f, 4f});
            header.setLockedWidth(true);
            header.setTotalWidth(document.right() - document.left());
    
            
            //Close the PDF for ready to send
            document.close();//close document
            writer.close();
            
            //Send to client browser
            response.setHeader("Expires", "0");
            response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
            response.setHeader("Pragma", "public");
            response.setContentType("application/pdf");
            response.setContentLength(baos.size());
            OutputStream os = response.getOutputStream();
            baos.writeTo(os);
            os.flush();
            os.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
