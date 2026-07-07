package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;

public final class addAnimal_jsp extends org.apache.jasper.runtime.HttpJspBase
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

    // --- BACKEND LOGIC (Your original code) ---
    String successMsg = null;
    String errorMsg = null;

    if("POST".equalsIgnoreCase(request.getMethod())){

        String name = request.getParameter("name");
        String species = request.getParameter("species");
        String breed = request.getParameter("breed");
        String gender = request.getParameter("gender");
        String ageStr = request.getParameter("age");
        String date = request.getParameter("date");

        int age = 0;
        if(ageStr!=null && !ageStr.trim().equals("")) age = Integer.parseInt(ageStr);

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                "root","1234"
            );

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO animal(name,species,breed,gender,age,arrival_date) VALUES(?,?,?,?,?,?)"
            );

            ps.setString(1,name);
            ps.setString(2,species);
            ps.setString(3,breed);
            ps.setString(4,gender);
            ps.setInt(5,age);
            ps.setString(6,date);

            int rows = ps.executeUpdate();

            if(rows>0){
                successMsg = "Animal added successfully! Welcome to the family.";
            } else {
                errorMsg = "Failed to add animal. Please try again.";
            }

            con.close();
        }catch(Exception e){
            errorMsg = "Database Error: " + e.getMessage();
        }
    }

      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"en\">\n");
      out.write("<head>\n");
      out.write("<meta charset=\"UTF-8\">\n");
      out.write("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("<title>AnimMate | New Registration</title>\n");
      out.write("\n");
      out.write("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css\">\n");
      out.write("<link href=\"https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&family=Nunito:wght@400;600;700&display=swap\" rel=\"stylesheet\">\n");
      out.write("\n");
      out.write("<style>\n");
      out.write("    :root {\n");
      out.write("        /* PET THEME PALETTE */\n");
      out.write("        --primary: #f97316;       /* Warm Paw Orange */\n");
      out.write("        --primary-soft: #ffedd5;  \n");
      out.write("        --secondary: #78350f;     /* Earthy Brown */\n");
      out.write("        \n");
      out.write("        --sidebar-bg: #fff7ed;    \n");
      out.write("        --body-bg: #fffbeb;       \n");
      out.write("        \n");
      out.write("        --card-shadow: 0 10px 25px rgba(120, 53, 15, 0.08);\n");
      out.write("        --border-radius-lg: 24px;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    body { \n");
      out.write("        background-color: var(--body-bg); \n");
      out.write("        font-family: 'Nunito', sans-serif; \n");
      out.write("        color: var(--secondary);\n");
      out.write("        margin: 0; \n");
      out.write("        background-image: radial-gradient(#fed7aa 2px, transparent 2px), radial-gradient(#fed7aa 2px, transparent 2px);\n");
      out.write("        background-size: 32px 32px;\n");
      out.write("        background-position: 0 0, 16px 16px;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    h1, h2, h3, h4, h5 { font-family: 'Fredoka', sans-serif; }\n");
      out.write("\n");
      out.write("    /* SIDEBAR */\n");
      out.write("    .sidebar { width: 260px; background: var(--sidebar-bg); border-right: 2px solid #fed7aa; color: #9a3412; position: fixed; height: 100vh; padding: 30px 24px; z-index: 1000; }\n");
      out.write("    .brand { font-size: 24px; font-weight: 600; color: var(--primary); margin-bottom: 40px; display: flex; align-items: center; gap: 12px; }\n");
      out.write("    .nav-link { color: #9a3412; padding: 12px 18px; border-radius: 50px; margin-bottom: 6px; display: flex; align-items: center; gap: 12px; text-decoration: none; transition: 0.3s; font-weight: 600; font-size: 1rem; }\n");
      out.write("    .nav-link:hover { background: var(--primary-soft); color: var(--primary); transform: translateX(4px); }\n");
      out.write("    .nav-link.active { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3); }\n");
      out.write("\n");
      out.write("    /* MAIN CONTENT */\n");
      out.write("    .main-content { margin-left: 260px; padding: 0; }\n");
      out.write("    .top-navbar { background: rgba(255, 251, 235, 0.85); backdrop-filter: blur(8px); padding: 16px 40px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 900; }\n");
      out.write("    \n");
      out.write("    .search-wrapper { position: relative; width: 350px; }\n");
      out.write("    .search-wrapper input { width: 100%; padding: 12px 15px 12px 50px; border-radius: 50px; border: 2px solid #fed7aa; background: white; font-size: 0.95rem; outline: none; color: var(--secondary); }\n");
      out.write("    .search-wrapper i { position: absolute; left: 20px; top: 50%; transform: translateY(-50%); color: var(--primary); }\n");
      out.write("    .user-profile { display: flex; align-items: center; gap: 12px; cursor: pointer; padding: 6px 12px; border-radius: 50px; background: white; border: 2px solid #fed7aa; }\n");
      out.write("    .avatar { width: 40px; height: 40px; background: #fde68a; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #b45309; }\n");
      out.write("\n");
      out.write("    /* FORM CARD DESIGN */\n");
      out.write("    .page-body { padding: 40px; display: flex; justify-content: center; }\n");
      out.write("    \n");
      out.write("    .form-card {\n");
      out.write("        background: white;\n");
      out.write("        border-radius: var(--border-radius-lg);\n");
      out.write("        width: 100%;\n");
      out.write("        max-width: 700px;\n");
      out.write("        box-shadow: var(--card-shadow);\n");
      out.write("        border: 2px solid #fff7ed;\n");
      out.write("        overflow: hidden;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    .card-header-custom {\n");
      out.write("        background: var(--primary-soft);\n");
      out.write("        padding: 30px;\n");
      out.write("        text-align: center;\n");
      out.write("        border-bottom: 2px dashed #fed7aa;\n");
      out.write("    }\n");
      out.write("    \n");
      out.write("    .header-icon {\n");
      out.write("        width: 70px; height: 70px;\n");
      out.write("        background: white;\n");
      out.write("        border-radius: 50%;\n");
      out.write("        display: flex; align-items: center; justify-content: center;\n");
      out.write("        margin: 0 auto 15px;\n");
      out.write("        color: var(--primary);\n");
      out.write("        font-size: 1.8rem;\n");
      out.write("        box-shadow: 0 4px 10px rgba(249, 115, 22, 0.2);\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    .card-body-custom { padding: 40px; }\n");
      out.write("\n");
      out.write("    .form-label { font-weight: 700; color: #9a3412; font-size: 0.9rem; margin-bottom: 8px; margin-left: 5px; }\n");
      out.write("    \n");
      out.write("    .form-control, .form-select {\n");
      out.write("        border-radius: 15px;\n");
      out.write("        border: 2px solid #fed7aa;\n");
      out.write("        padding: 12px 15px;\n");
      out.write("        font-weight: 600;\n");
      out.write("        color: var(--secondary);\n");
      out.write("        background: #fff;\n");
      out.write("    }\n");
      out.write("    .form-control:focus, .form-select:focus {\n");
      out.write("        border-color: var(--primary);\n");
      out.write("        box-shadow: 0 0 0 4px var(--primary-soft);\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    .btn-save {\n");
      out.write("        background: var(--primary);\n");
      out.write("        color: white;\n");
      out.write("        border: none;\n");
      out.write("        padding: 12px 30px;\n");
      out.write("        border-radius: 50px;\n");
      out.write("        font-size: 1rem;\n");
      out.write("        font-weight: 700;\n");
      out.write("        font-family: 'Fredoka', sans-serif;\n");
      out.write("        box-shadow: 0 4px 15px rgba(249, 115, 22, 0.4);\n");
      out.write("        transition: 0.3s;\n");
      out.write("    }\n");
      out.write("    .btn-save:hover { background: #ea580c; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(249, 115, 22, 0.5); color: white; }\n");
      out.write("\n");
      out.write("    /* ALERTS */\n");
      out.write("    .custom-alert { border-radius: 15px; padding: 20px; text-align: center; margin-bottom: 25px; border: 2px solid transparent; }\n");
      out.write("    .success-msg { background: #dcfce7; color: #166534; border-color: #86efac; }\n");
      out.write("    .error-msg { background: #fee2e2; color: #991b1b; border-color: #fca5a5; }\n");
      out.write("\n");
      out.write("</style>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("\n");
      out.write("<div class=\"sidebar\">\n");
      out.write("    <div class=\"brand\"><i class=\"fas fa-paw fa-lg\"></i> AnimMate</div>\n");
      out.write("    <div class=\"d-flex flex-column gap-2 mt-4\">\n");
      out.write("        <small class=\"text-uppercase fw-bold ps-3 mb-2\" style=\"font-size:11px; color:#c2410c;\">Shelter</small>\n");
      out.write("        <a href=\"index.jsp\" class=\"nav-link\"><i class=\"fas fa-chart-pie\"></i> Dashboard</a>\n");
      out.write("        <a href=\"viewAnimals.jsp\" class=\"nav-link\"><i class=\"fas fa-dog\"></i> Our Animals</a>\n");
      out.write("        <a href=\"addAnimal.jsp\" class=\"nav-link active\"><i class=\"fas fa-plus-circle\"></i> New Arrival</a>\n");
      out.write("        <small class=\"text-uppercase fw-bold ps-3 mt-4 mb-2\" style=\"font-size:11px; color:#c2410c;\">Care</small>\n");
      out.write("        <a href=\"HealthRecordPanel.jsp\" class=\"nav-link\"><i class=\"fas fa-heartbeat\"></i> Health</a>\n");
      out.write("        <a href=\"CaretakerCRUD.jsp\" class=\"nav-link\"><i class=\"fas fa-users\"></i> Staff</a>\n");
      out.write("    </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<div class=\"main-content\">\n");
      out.write("\n");
      out.write("    <div class=\"top-navbar\">\n");
      out.write("        <div class=\"search-wrapper\">\n");
      out.write("            <i class=\"fas fa-search\"></i>\n");
      out.write("            <input type=\"text\" placeholder=\"Search...\">\n");
      out.write("        </div>\n");
      out.write("        <div class=\"d-flex align-items-center gap-3\">\n");
      out.write("            <div class=\"text-end d-none d-md-block\">\n");
      out.write("                <div style=\"font-weight:700; font-size:1rem; color:var(--secondary); font-family:'Fredoka';\">Dr. Sarah</div>\n");
      out.write("                <div style=\"font-size:0.85rem; color:#ca8a04;\">Head Vet</div>\n");
      out.write("            </div>\n");
      out.write("            <div class=\"avatar\">DS</div>\n");
      out.write("        </div>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"page-body\">\n");
      out.write("        \n");
      out.write("        <div class=\"form-card\">\n");
      out.write("            \n");
      out.write("            <div class=\"card-header-custom\">\n");
      out.write("                <div class=\"header-icon\">\n");
      out.write("                    <i class=\"fas fa-paw\"></i>\n");
      out.write("                </div>\n");
      out.write("                <h3 class=\"m-0\" style=\"color:#78350f; font-weight:700;\">New Registration</h3>\n");
      out.write("                <p class=\"text-muted m-0 small\">Add a new friend to the shelter</p>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"card-body-custom\">\n");
      out.write("\n");
      out.write("                ");
 if(successMsg != null){ 
      out.write("\n");
      out.write("                <div class=\"custom-alert success-msg\">\n");
      out.write("                    <i class=\"fas fa-check-circle fa-2x mb-2\"></i><br>\n");
      out.write("                    <span style=\"font-size:1.1rem; font-weight:700;\">");
      out.print(successMsg);
      out.write("</span>\n");
      out.write("                    <div class=\"mt-3 d-flex justify-content-center gap-2\">\n");
      out.write("                        <a href=\"viewAnimals.jsp\" class=\"btn btn-sm btn-success rounded-pill fw-bold px-3\">View List</a>\n");
      out.write("                        <a href=\"addAnimal.jsp\" class=\"btn btn-sm btn-outline-success rounded-pill fw-bold px-3\">Add Another</a>\n");
      out.write("                    </div>\n");
      out.write("                </div>\n");
      out.write("                ");
 } 
      out.write("\n");
      out.write("\n");
      out.write("                ");
 if(errorMsg != null){ 
      out.write("\n");
      out.write("                <div class=\"custom-alert error-msg\">\n");
      out.write("                    <i class=\"fas fa-exclamation-triangle fa-2x mb-2\"></i><br>\n");
      out.write("                    ");
      out.print(errorMsg);
      out.write("\n");
      out.write("                </div>\n");
      out.write("                ");
 } 
      out.write("\n");
      out.write("\n");
      out.write("                <form method=\"post\">\n");
      out.write("                    \n");
      out.write("                    <div class=\"row g-3\">\n");
      out.write("                        <div class=\"col-md-6\">\n");
      out.write("                            <label class=\"form-label\">Name</label>\n");
      out.write("                            <input type=\"text\" name=\"name\" class=\"form-control\" placeholder=\"e.g. Charlie\" required>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"col-md-6\">\n");
      out.write("                            <label class=\"form-label\">Species</label>\n");
      out.write("                            <input type=\"text\" name=\"species\" class=\"form-control\" placeholder=\"e.g. Dog, Cat\" required>\n");
      out.write("                        </div>\n");
      out.write("\n");
      out.write("                        <div class=\"col-md-6\">\n");
      out.write("                            <label class=\"form-label\">Breed</label>\n");
      out.write("                            <input type=\"text\" name=\"breed\" class=\"form-control\" placeholder=\"e.g. Labrador\">\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"col-md-6\">\n");
      out.write("                            <label class=\"form-label\">Gender</label>\n");
      out.write("                            <select name=\"gender\" class=\"form-select\">\n");
      out.write("                                <option value=\"Male\">Male</option>\n");
      out.write("                                <option value=\"Female\">Female</option>\n");
      out.write("                                <option value=\"Unknown\">Unknown</option>\n");
      out.write("                            </select>\n");
      out.write("                        </div>\n");
      out.write("\n");
      out.write("                        <div class=\"col-md-6\">\n");
      out.write("                            <label class=\"form-label\">Age (Years)</label>\n");
      out.write("                            <input type=\"number\" name=\"age\" class=\"form-control\" min=\"0\" placeholder=\"e.g. 5\">\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"col-md-6\">\n");
      out.write("                            <label class=\"form-label\">Admission Date</label>\n");
      out.write("                            <input type=\"date\" name=\"date\" class=\"form-control\" required>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("\n");
      out.write("                    <div class=\"d-flex justify-content-between align-items-center mt-4 pt-2\">\n");
      out.write("                        <a href=\"index.jsp\" class=\"text-decoration-none fw-bold\" style=\"color:#9a3412;\">\n");
      out.write("                            <i class=\"fas fa-arrow-left me-1\"></i> Cancel\n");
      out.write("                        </a>\n");
      out.write("                        <button type=\"submit\" class=\"btn btn-save\">\n");
      out.write("                            <i class=\"fas fa-save me-2\"></i> Save Record\n");
      out.write("                        </button>\n");
      out.write("                    </div>\n");
      out.write("\n");
      out.write("                </form>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("    </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js\"></script>\n");
      out.write("</body>\n");
      out.write("</html>");
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
