package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class result_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"en\">\n");
      out.write("<head>\n");
      out.write("<meta charset=\"UTF-8\">\n");
      out.write("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("<title>AnimMate | Status</title>\n");
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
      out.write("        --success-bg: #dcfce7;\n");
      out.write("        --success-text: #15803d;\n");
      out.write("        --error-bg: #fee2e2;\n");
      out.write("        --error-text: #b91c1c;\n");
      out.write("        \n");
      out.write("        --body-bg: #fffbeb;       \n");
      out.write("        --card-shadow: 0 15px 35px rgba(120, 53, 15, 0.1);\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    body { \n");
      out.write("        background-color: var(--body-bg); \n");
      out.write("        font-family: 'Nunito', sans-serif; \n");
      out.write("        color: var(--secondary);\n");
      out.write("        height: 100vh;\n");
      out.write("        display: flex;\n");
      out.write("        align-items: center;\n");
      out.write("        justify-content: center;\n");
      out.write("        /* Paw Pattern */\n");
      out.write("        background-image: radial-gradient(#fed7aa 2px, transparent 2px), radial-gradient(#fed7aa 2px, transparent 2px);\n");
      out.write("        background-size: 32px 32px;\n");
      out.write("        background-position: 0 0, 16px 16px;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    h2 { font-family: 'Fredoka', sans-serif; font-weight: 600; letter-spacing: 0.5px; }\n");
      out.write("\n");
      out.write("    .result-card {\n");
      out.write("        background: white;\n");
      out.write("        border-radius: 30px;\n");
      out.write("        max-width: 500px;\n");
      out.write("        width: 90%;\n");
      out.write("        padding: 40px 30px;\n");
      out.write("        text-align: center;\n");
      out.write("        box-shadow: var(--card-shadow);\n");
      out.write("        border: 4px solid #fff7ed;\n");
      out.write("        position: relative;\n");
      out.write("        overflow: hidden;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    /* Icon Animation */\n");
      out.write("    .icon-wrapper {\n");
      out.write("        width: 100px;\n");
      out.write("        height: 100px;\n");
      out.write("        border-radius: 50%;\n");
      out.write("        display: flex;\n");
      out.write("        align-items: center;\n");
      out.write("        justify-content: center;\n");
      out.write("        font-size: 3rem;\n");
      out.write("        margin: 0 auto 25px;\n");
      out.write("        animation: popIn 0.6s cubic-bezier(0.68, -0.55, 0.27, 1.55);\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    @keyframes popIn {\n");
      out.write("        0% { transform: scale(0); opacity: 0; }\n");
      out.write("        80% { transform: scale(1.1); opacity: 1; }\n");
      out.write("        100% { transform: scale(1); }\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    .btn-action {\n");
      out.write("        padding: 12px 25px;\n");
      out.write("        border-radius: 50px;\n");
      out.write("        font-weight: 700;\n");
      out.write("        font-family: 'Fredoka', sans-serif;\n");
      out.write("        text-decoration: none;\n");
      out.write("        transition: 0.3s;\n");
      out.write("        display: inline-flex;\n");
      out.write("        align-items: center;\n");
      out.write("        justify-content: center;\n");
      out.write("        gap: 8px;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    .btn-dashboard {\n");
      out.write("        background: white;\n");
      out.write("        color: #9a3412;\n");
      out.write("        border: 2px solid #fed7aa;\n");
      out.write("    }\n");
      out.write("    .btn-dashboard:hover { background: #fff7ed; color: var(--primary); }\n");
      out.write("\n");
      out.write("    .btn-list {\n");
      out.write("        background: var(--primary);\n");
      out.write("        color: white;\n");
      out.write("        border: 2px solid var(--primary);\n");
      out.write("        box-shadow: 0 4px 15px rgba(249, 115, 22, 0.3);\n");
      out.write("    }\n");
      out.write("    .btn-list:hover { background: #ea580c; border-color: #ea580c; color: white; transform: translateY(-2px); }\n");
      out.write("\n");
      out.write("</style>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("\n");

    String type = request.getParameter("type");
    String msg  = request.getParameter("msg");
    
    // Default Styles
    String iconClass = "fas fa-question";
    String iconBg = "#f3f4f6";
    String iconColor = "#6b7280";
    String title = "Notification";
    
    if("add".equals(type)){
        iconClass = "fas fa-paw";
        iconBg = "#dcfce7"; // Soft Green
        iconColor = "#16a34a";
        title = "Welcome Aboard!";
    } 
    else if("update".equals(type)){
        iconClass = "fas fa-pen-fancy";
        iconBg = "#dbeafe"; // Soft Blue
        iconColor = "#2563eb";
        title = "Details Updated";
    } 
    else if("delete".equals(type)){
        iconClass = "fas fa-trash-alt";
        iconBg = "#fee2e2"; // Soft Red
        iconColor = "#dc2626";
        title = "Record Removed";
    } 
    else {
        iconClass = "fas fa-exclamation-circle";
        iconBg = "#ffedd5"; // Soft Orange
        iconColor = "#c2410c";
        title = "Oops! Problem";
    }

      out.write("\n");
      out.write("\n");
      out.write("<div class=\"result-card\">\n");
      out.write("    \n");
      out.write("    <div class=\"icon-wrapper\" style=\"background-color: ");
      out.print( iconBg );
      out.write("; color: ");
      out.print( iconColor );
      out.write(";\">\n");
      out.write("        <i class=\"");
      out.print( iconClass );
      out.write("\"></i>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <h2 style=\"color: ");
      out.print( iconColor );
      out.write(";\">");
      out.print( title );
      out.write("</h2>\n");
      out.write("    <p class=\"text-muted mb-4 fs-5\" style=\"font-weight: 600;\">");
      out.print( (msg != null) ? msg : "Operation completed." );
      out.write("</p>\n");
      out.write("\n");
      out.write("    <div class=\"d-grid gap-2 d-sm-flex justify-content-center\">\n");
      out.write("        <a href=\"index.jsp\" class=\"btn-action btn-dashboard\">\n");
      out.write("            <i class=\"fas fa-home\"></i> Dashboard\n");
      out.write("        </a>\n");
      out.write("        <a href=\"viewAnimals.jsp\" class=\"btn-action btn-list\">\n");
      out.write("            <i class=\"fas fa-list-ul\"></i> View Animals\n");
      out.write("        </a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("</div>\n");
      out.write("\n");
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
