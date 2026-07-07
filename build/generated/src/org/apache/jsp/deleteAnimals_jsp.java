package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;

public final class deleteAnimals_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");

String dbUrl="jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
String dbUser="root";
String dbPass="1234";

String idStr=request.getParameter("id");
Integer animalId=null;

if(idStr!=null && !idStr.trim().isEmpty()){
    animalId=Integer.parseInt(idStr);
}

boolean deleted=false;
String errorMsg=null;

Connection con=null;
ResultSet rsHealth=null;

try{
    if(animalId==null){
        errorMsg="Animal ID not provided.";
    }else{
        Class.forName("com.mysql.cj.jdbc.Driver");
        con=DriverManager.getConnection(dbUrl,dbUser,dbPass);

        try{
            PreparedStatement ps=con.prepareStatement(
                "DELETE FROM animal WHERE animal_id=?");
            ps.setInt(1,animalId);
            int rows=ps.executeUpdate();

            if(rows>0){
                deleted=true;
            }else{
                errorMsg="Animal not found.";
            }
        }catch(SQLException fk){
            errorMsg="Cannot delete. This animal has health records linked.";

            PreparedStatement ps2=con.prepareStatement(
                "SELECT record_id,disease,treatment,record_date FROM health_record WHERE animal_id=?");
            ps2.setInt(1,animalId);
            rsHealth=ps2.executeQuery();
        }
    }
}catch(Exception e){
    errorMsg=e.getMessage();
}

      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<title>Delete Result</title>\n");
      out.write("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("</head>\n");
      out.write("<body class=\"bg-light\">\n");
      out.write("\n");
      out.write("<div class=\"container mt-5\">\n");
      out.write("\n");
 if(deleted){ 
      out.write("\n");
      out.write("\n");
      out.write("<div class=\"card p-5 text-center shadow\">\n");
      out.write("    <h2 class=\"text-success\">Deleted Successfully</h2>\n");
      out.write("    <p>Animal ID <b>");
      out.print(animalId);
      out.write("</b> removed.</p>\n");
      out.write("    <a href=\"viewAnimals.jsp\" class=\"btn btn-success mt-3\">Back to List</a>\n");
      out.write("</div>\n");
      out.write("\n");
 } else { 
      out.write("\n");
      out.write("\n");
      out.write("<div class=\"card p-5 shadow\">\n");
      out.write("    <h2 class=\"text-danger\">Delete Failed</h2>\n");
      out.write("    <p>");
      out.print(errorMsg);
      out.write("</p>\n");
      out.write("\n");
      out.write("    ");
 if(rsHealth!=null && rsHealth.isBeforeFirst()){ 
      out.write("\n");
      out.write("    <h5 class=\"mt-4\">Health Records Linked</h5>\n");
      out.write("    <table class=\"table table-bordered\">\n");
      out.write("        <tr>\n");
      out.write("            <th>ID</th><th>Disease</th><th>Treatment</th><th>Date</th>\n");
      out.write("        </tr>\n");
      out.write("        ");
 while(rsHealth.next()){ 
      out.write("\n");
      out.write("        <tr>\n");
      out.write("            <td>");
      out.print(rsHealth.getInt(1));
      out.write("</td>\n");
      out.write("            <td>");
      out.print(rsHealth.getString(2));
      out.write("</td>\n");
      out.write("            <td>");
      out.print(rsHealth.getString(3));
      out.write("</td>\n");
      out.write("            <td>");
      out.print(rsHealth.getDate(4));
      out.write("</td>\n");
      out.write("        </tr>\n");
      out.write("        ");
 } 
      out.write("\n");
      out.write("    </table>\n");
      out.write("    ");
 } else if(rsHealth!=null){ 
      out.write("\n");
      out.write("        <p class=\"text-muted\">No health records found.</p>\n");
      out.write("    ");
 } 
      out.write("\n");
      out.write("\n");
      out.write("    <a href=\"viewAnimals.jsp\" class=\"btn btn-secondary mt-3\">Back</a>\n");
      out.write("</div>\n");
      out.write("\n");
 } 
      out.write("\n");
      out.write("\n");
      out.write("</div>\n");
      out.write("</body>\n");
      out.write("</html>\n");
      out.write("\n");
 if(con!=null) con.close(); 
      out.write('\n');
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
