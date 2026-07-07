package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.util.*;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("\n");

    // --- BACKEND LOGIC ---
    String dbUrl = "jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = "1234";

    // 1. Get Parameters
    String searchQuery = request.getParameter("q");
    String filterType = request.getParameter("type"); // "BIRD" or "NON_BIRD"

    boolean isSearchMode = (searchQuery != null && !searchQuery.trim().isEmpty());
    boolean isFilterMode = (filterType != null && !filterType.trim().isEmpty());

    // 2. Define Regex for Birds
    String birdRegex = "Bird|Parrot|Macaw|Sparrow|Pigeon|Crow|Peacock|Eagle|Owl";

    int totalAnimals = 0, birdCount = 0, mammalCount = 0, medicalCases = 0;
    StringBuilder chartLabels = new StringBuilder();
    StringBuilder chartData = new StringBuilder();

    Connection con = null;
    ResultSet rsAnimals = null;
    ResultSet rsCaretakers = null; 

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        Statement st = con.createStatement();

        // 3. KPI Stats
        ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM animal");
        if(rs.next()) totalAnimals = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM animal WHERE species REGEXP '" + birdRegex + "'");
        if(rs.next()) birdCount = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM animal WHERE species NOT REGEXP '" + birdRegex + "'");
        if(rs.next()) mammalCount = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM health_record");
        if(rs.next()) medicalCases = rs.getInt(1);

        // 4. Chart Data
        rs = st.executeQuery("SELECT species, COUNT(*) FROM animal GROUP BY species");
        while(rs.next()){
            chartLabels.append("'").append(rs.getString(1)).append("',");
            chartData.append(rs.getInt(2)).append(",");
        }
        if(chartLabels.length() > 0) chartLabels.setLength(chartLabels.length()-1);
        if(chartData.length() > 0) chartData.setLength(chartData.length()-1);

        // 5. Data Retrieval
        if(isSearchMode){
            String pattern = "%" + searchQuery + "%";
            // Animals
            PreparedStatement ps1 = con.prepareStatement("SELECT * FROM animal WHERE name LIKE ? OR species LIKE ? OR animal_id = ?");
            ps1.setString(1, pattern);
            ps1.setString(2, pattern);
            try { ps1.setInt(3, Integer.parseInt(searchQuery)); } catch(Exception e) { ps1.setInt(3, 0); }
            rsAnimals = ps1.executeQuery();

            // Caretakers
            PreparedStatement ps2 = con.prepareStatement("SELECT * FROM caretaker WHERE name LIKE ? OR phone LIKE ? OR shift LIKE ?");
            ps2.setString(1, pattern);
            ps2.setString(2, pattern);
            ps2.setString(3, pattern);
            rsCaretakers = ps2.executeQuery();
        } 
        else if(isFilterMode) {
            if(filterType.equals("BIRD")) {
                PreparedStatement ps = con.prepareStatement("SELECT * FROM animal WHERE species REGEXP ?");
                ps.setString(1, birdRegex);
                rsAnimals = ps.executeQuery();
            } else {
                PreparedStatement ps = con.prepareStatement("SELECT * FROM animal WHERE species NOT REGEXP ?");
                ps.setString(1, birdRegex);
                rsAnimals = ps.executeQuery();
            }
        }
        else {
            rsAnimals = st.executeQuery("SELECT * FROM animal ORDER BY arrival_date DESC LIMIT 5");
        }

    } catch(Exception e) {
        // e.printStackTrace();
    }

      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"en\">\n");
      out.write("<head>\n");
      out.write("<meta charset=\"UTF-8\">\n");
      out.write("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("<title>AnimMate | Dashboard</title>\n");
      out.write("\n");
      out.write("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css\">\n");
      out.write("<link href=\"https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&family=Nunito:wght@400;600;700&display=swap\" rel=\"stylesheet\">\n");
      out.write("<script src=\"https://cdn.jsdelivr.net/npm/chart.js\"></script>\n");
      out.write("\n");
      out.write("<style>\n");
      out.write("    :root {\n");
      out.write("        /* PET THEME PALETTE */\n");
      out.write("        --primary: #f97316;       /* Warm Paw Orange */\n");
      out.write("        --primary-soft: #ffedd5;  /* Soft Orange Tint */\n");
      out.write("        --secondary: #78350f;     /* Earthy Brown */\n");
      out.write("        \n");
      out.write("        --sidebar-bg: #fff7ed;    /* Creamy sidebar */\n");
      out.write("        --body-bg: #fffbeb;       /* Warmer Cream background */\n");
      out.write("        \n");
      out.write("        --card-shadow: 0 8px 20px rgba(120, 53, 15, 0.08);\n");
      out.write("        --border-radius-lg: 24px;\n");
      out.write("        --sidebar-width: 260px;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    body { \n");
      out.write("        background-color: var(--body-bg); \n");
      out.write("        font-family: 'Nunito', sans-serif; \n");
      out.write("        color: var(--secondary);\n");
      out.write("        margin: 0; \n");
      out.write("        /* Paw print pattern */\n");
      out.write("        background-image: radial-gradient(#fed7aa 2px, transparent 2px), radial-gradient(#fed7aa 2px, transparent 2px);\n");
      out.write("        background-size: 32px 32px;\n");
      out.write("        background-position: 0 0, 16px 16px;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    h1, h2, h3, h4, h5 { font-family: 'Fredoka', sans-serif; }\n");
      out.write("\n");
      out.write("    /* SIDEBAR */\n");
      out.write("    .sidebar { \n");
      out.write("        width: var(--sidebar-width); \n");
      out.write("        background: var(--sidebar-bg); \n");
      out.write("        border-right: 2px solid #fed7aa; \n");
      out.write("        color: #9a3412; \n");
      out.write("        position: fixed; \n");
      out.write("        height: 100vh; \n");
      out.write("        padding: 30px 24px; \n");
      out.write("        z-index: 1050; \n");
      out.write("        transition: transform 0.3s ease-in-out;\n");
      out.write("    }\n");
      out.write("    \n");
      out.write("    .brand { font-size: 24px; font-weight: 600; color: var(--primary); margin-bottom: 40px; display: flex; align-items: center; gap: 12px; }\n");
      out.write("    .brand i { transform: rotate(-10deg); }\n");
      out.write("    .nav-link { color: #9a3412; padding: 12px 18px; border-radius: 50px; margin-bottom: 6px; display: flex; align-items: center; gap: 12px; text-decoration: none; transition: 0.3s; font-weight: 600; font-size: 1rem; }\n");
      out.write("    .nav-link:hover { background: var(--primary-soft); color: var(--primary); transform: translateX(4px); }\n");
      out.write("    .nav-link.active { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3); }\n");
      out.write("\n");
      out.write("    /* MAIN CONTENT */\n");
      out.write("    .main-content { margin-left: var(--sidebar-width); padding: 0; transition: margin-left 0.3s ease-in-out; }\n");
      out.write("\n");
      out.write("    /* NAVBAR */\n");
      out.write("    .top-navbar { \n");
      out.write("        background: rgba(255, 251, 235, 0.85); \n");
      out.write("        backdrop-filter: blur(8px); \n");
      out.write("        padding: 16px 40px; \n");
      out.write("        display: flex; justify-content: space-between; align-items: center; \n");
      out.write("        position: sticky; top: 0; z-index: 900; \n");
      out.write("    }\n");
      out.write("    \n");
      out.write("    .search-wrapper { position: relative; width: 350px; }\n");
      out.write("    .search-wrapper input { width: 100%; padding: 12px 15px 12px 50px; border-radius: 50px; border: 2px solid #fed7aa; background: white; font-size: 0.95rem; transition: 0.3s; color: var(--secondary); }\n");
      out.write("    .search-wrapper input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px var(--primary-soft); }\n");
      out.write("    .search-wrapper i { position: absolute; left: 20px; top: 50%; transform: translateY(-50%); color: var(--primary); font-size: 1.1rem; }\n");
      out.write("    .search-btn-hidden { display: none; }\n");
      out.write("\n");
      out.write("    /* ICONS */\n");
      out.write("    .nav-icons { display: flex; align-items: center; gap: 25px; }\n");
      out.write("    .notification-btn { position: relative; color: #ea580c; font-size: 1.3rem; cursor: pointer; transition: 0.2s; }\n");
      out.write("    .notification-btn:hover { transform: scale(1.1); }\n");
      out.write("    .user-profile { display: flex; align-items: center; gap: 12px; cursor: pointer; padding: 6px 12px; border-radius: 50px; border: 2px solid transparent; transition: 0.3s; }\n");
      out.write("    .user-profile:hover { background: white; border-color: #fed7aa; }\n");
      out.write("    .avatar { width: 40px; height: 40px; background: #fde68a; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #b45309; border: 2px solid white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }\n");
      out.write("\n");
      out.write("    /* CARDS & BODY */\n");
      out.write("    .page-body { padding: 30px 40px; }\n");
      out.write("    \n");
      out.write("    .saas-card { \n");
      out.write("        background: white; \n");
      out.write("        border-radius: var(--border-radius-lg); \n");
      out.write("        padding: 24px; \n");
      out.write("        box-shadow: var(--card-shadow); \n");
      out.write("        height: 100%; \n");
      out.write("        border: 2px solid #fff7ed; \n");
      out.write("        transition: 0.3s; \n");
      out.write("    }\n");
      out.write("    .card-link { text-decoration: none; color: inherit; display: block; height: 100%; }\n");
      out.write("    .card-link:hover .saas-card { transform: translateY(-6px); border-color: var(--primary); }\n");
      out.write("    \n");
      out.write("    /* Highlight Active Filter */\n");
      out.write("    .active-filter .saas-card { background: #fff7ed; border-color: var(--primary); box-shadow: 0 0 0 4px var(--primary-soft); }\n");
      out.write("\n");
      out.write("    .stat-val { font-size: 2.2rem; font-weight: 700; color: var(--secondary); margin: 5px 0; font-family: 'Fredoka'; }\n");
      out.write("    .stat-lbl { color: #9a3412; font-size: 0.9rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }\n");
      out.write("\n");
      out.write("    /* TABLES */\n");
      out.write("    .table-responsive { overflow-x: auto; }\n");
      out.write("    .table thead th { background: var(--primary-soft); color: var(--secondary); font-family: 'Fredoka'; font-weight: 500; border-bottom: none; padding: 18px; text-transform: uppercase; font-size: 0.85rem; white-space: nowrap; }\n");
      out.write("    .table tbody td { padding: 18px; vertical-align: middle; border-bottom: 1px solid #fff7ed; color: var(--secondary); font-weight: 600; white-space: nowrap; }\n");
      out.write("    \n");
      out.write("    .badge-pill { padding: 6px 14px; border-radius: 30px; font-size: 0.8rem; font-family: 'Fredoka'; }\n");
      out.write("    .bg-bird { background: #e0f2fe; color: #0ea5e9; }\n");
      out.write("    .bg-mammal { background: #ffedd5; color: #f97316; }\n");
      out.write("\n");
      out.write("    .btn-action { width: 34px; height: 34px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; background: #fef9c3; color: #ca8a04; transition: 0.2s; text-decoration: none; border: 2px solid white; }\n");
      out.write("    .btn-action:hover { background: var(--primary); color: white; transform: rotate(10deg); }\n");
      out.write("\n");
      out.write("    /* === RESPONSIVE STYLES === */\n");
      out.write("    /* Mobile Overlay */\n");
      out.write("    .sidebar-overlay {\n");
      out.write("        position: fixed; top: 0; left: 0; width: 100%; height: 100%;\n");
      out.write("        background: rgba(0,0,0,0.5); z-index: 1040;\n");
      out.write("        display: none; opacity: 0; transition: opacity 0.3s;\n");
      out.write("    }\n");
      out.write("    .sidebar-overlay.show { display: block; opacity: 1; }\n");
      out.write("\n");
      out.write("    @media (max-width: 991.98px) {\n");
      out.write("        .sidebar { transform: translateX(-100%); box-shadow: 0 0 20px rgba(0,0,0,0.1); }\n");
      out.write("        .sidebar.show { transform: translateX(0); }\n");
      out.write("        \n");
      out.write("        .main-content { margin-left: 0; }\n");
      out.write("        \n");
      out.write("        .top-navbar { padding: 15px 20px; gap: 15px; }\n");
      out.write("        .search-wrapper { width: 100%; }\n");
      out.write("        \n");
      out.write("        .page-body { padding: 20px 15px; }\n");
      out.write("        .stat-val { font-size: 1.8rem; }\n");
      out.write("        \n");
      out.write("        /* Hide text in user profile on mobile, show only avatar */\n");
      out.write("        .user-profile .text-end { display: none !important; }\n");
      out.write("    }\n");
      out.write("</style>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("\n");
      out.write("<div class=\"sidebar-overlay\" id=\"sidebarOverlay\" onclick=\"toggleSidebar()\"></div>\n");
      out.write("\n");
      out.write("<div class=\"sidebar\" id=\"sidebar\">\n");
      out.write("    <div class=\"d-flex justify-content-between align-items-center mb-4\">\n");
      out.write("        <div class=\"brand m-0\"><i class=\"fas fa-paw\"></i> AnimMate</div>\n");
      out.write("        <button class=\"btn btn-sm btn-light d-lg-none\" onclick=\"toggleSidebar()\"><i class=\"fas fa-times\"></i></button>\n");
      out.write("    </div>\n");
      out.write("    \n");
      out.write("    <div class=\"d-flex flex-column gap-2 mt-2\">\n");
      out.write("        <small class=\"text-uppercase fw-bold ps-3 mb-2\" style=\"font-size:11px; color:#c2410c;\">Shelter</small>\n");
      out.write("        <a href=\"index.jsp\" class=\"nav-link active\"><i class=\"fas fa-chart-pie\"></i> Dashboard</a>\n");
      out.write("        <a href=\"viewAnimals.jsp\" class=\"nav-link\"><i class=\"fas fa-dog\"></i> Our Animals</a>\n");
      out.write("        <a href=\"addAnimal.jsp\" class=\"nav-link\"><i class=\"fas fa-plus-circle\"></i> New Arrival</a>\n");
      out.write("        <small class=\"text-uppercase fw-bold ps-3 mt-4 mb-2\" style=\"font-size:11px; color:#c2410c;\">Care</small>\n");
      out.write("        <a href=\"HealthRecordPanel.jsp\" class=\"nav-link\"><i class=\"fas fa-heartbeat\"></i> Health</a>\n");
      out.write("        <a href=\"CaretakerCRUD.jsp\" class=\"nav-link\"><i class=\"fas fa-users\"></i> Care Team</a>\n");
      out.write("    </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<div class=\"main-content\">\n");
      out.write("    \n");
      out.write("    <div class=\"top-navbar\">\n");
      out.write("        <button class=\"btn btn-light rounded-circle d-lg-none me-2\" style=\"width:40px; height:40px; color:var(--primary);\" onclick=\"toggleSidebar()\">\n");
      out.write("            <i class=\"fas fa-bars\"></i>\n");
      out.write("        </button>\n");
      out.write("\n");
      out.write("        <form action=\"index.jsp\" method=\"get\" class=\"m-0 flex-grow-1\">\n");
      out.write("            <div class=\"search-wrapper\">\n");
      out.write("                <i class=\"fas fa-search\"></i>\n");
      out.write("                <input type=\"text\" name=\"q\" placeholder=\"Find a furry friend...\" value=\"");
      out.print( (searchQuery!=null)?searchQuery:"" );
      out.write("\">\n");
      out.write("                <button type=\"submit\" class=\"search-btn-hidden\"></button>\n");
      out.write("            </div>\n");
      out.write("        </form>\n");
      out.write("\n");
      out.write("        <div class=\"nav-icons ms-3\">\n");
      out.write("            <div class=\"notification-btn\"><i class=\"fas fa-bell\"></i></div>\n");
      out.write("            <div class=\"dropdown\">\n");
      out.write("                <div class=\"user-profile\" data-bs-toggle=\"dropdown\">\n");
      out.write("                    <div class=\"text-end d-none d-md-block\">\n");
      out.write("                        <div style=\"font-weight:700; font-size:1rem; color:var(--secondary); font-family:'Fredoka';\">Dr. Prathmesh</div>\n");
      out.write("                        <div style=\"font-size:0.85rem; color:#ca8a04;\">Head Vet</div>\n");
      out.write("                    </div>\n");
      out.write("                    <div class=\"avatar\">PD</div>\n");
      out.write("                </div>\n");
      out.write("                <ul class=\"dropdown-menu dropdown-menu-end shadow border-0 mt-3 p-2 rounded-4\">\n");
      out.write("                    <li><a class=\"dropdown-item\" href=\"#\">My Profile</a></li>\n");
      out.write("                    <li><hr class=\"dropdown-divider\"></li>\n");
      out.write("                    <li><a class=\"dropdown-item text-danger\" href=\"logout.jsp\">Logout</a></li>\n");
      out.write("                </ul>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"page-body\">\n");
      out.write("        \n");
      out.write("        <div class=\"mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2\">\n");
      out.write("            ");
 if(isSearchMode){ 
      out.write("\n");
      out.write("                <div>\n");
      out.write("                    <h3 class=\"fw-bold m-0\" style=\"color:var(--secondary);\">Search Results</h3>\n");
      out.write("                    <p class=\"text-muted m-0\">Matches for \"");
      out.print( searchQuery );
      out.write("\"</p>\n");
      out.write("                </div>\n");
      out.write("                <a href=\"index.jsp\" class=\"btn btn-outline-warning text-dark border-2 rounded-pill px-4 fw-bold\"><i class=\"fas fa-arrow-left me-2\"></i>Back</a>\n");
      out.write("            ");
 } else { 
      out.write("\n");
      out.write("                <div>\n");
      out.write("                    <h3 class=\"fw-bold m-0\" style=\"color:var(--secondary);\">Hello, Dr. Prathmesh! 👋</h3>\n");
      out.write("                    <p class=\"text-muted m-0\">Here's what's happening at the shelter today.</p>\n");
      out.write("                </div>\n");
      out.write("            ");
 } 
      out.write("\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("        <div class=\"row g-4 mb-4\">\n");
      out.write("            <div class=\"col-12 col-sm-6 col-xl-3 ");
      out.print( (!isFilterMode && !isSearchMode) ? "active-filter" : "" );
      out.write("\">\n");
      out.write("                <a href=\"index.jsp\" class=\"card-link\">\n");
      out.write("                    <div class=\"saas-card\">\n");
      out.write("                        <div class=\"d-flex justify-content-between\">\n");
      out.write("                            <div>\n");
      out.write("                                <div class=\"stat-lbl\">Total Animals</div>\n");
      out.write("                                <div class=\"stat-val\">");
      out.print( totalAnimals );
      out.write("</div>\n");
      out.write("                                <span class=\"badge bg-secondary bg-opacity-10 text-secondary rounded-pill px-3\">Show All</span>\n");
      out.write("                            </div>\n");
      out.write("                            <div style=\"color:#fed7aa; font-size:2.5rem;\"><i class=\"fas fa-globe\"></i></div>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                </a>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"col-12 col-sm-6 col-xl-3 ");
      out.print( (isFilterMode && "BIRD".equals(filterType)) ? "active-filter" : "" );
      out.write("\">\n");
      out.write("                <a href=\"index.jsp?type=BIRD\" class=\"card-link\">\n");
      out.write("                    <div class=\"saas-card\">\n");
      out.write("                        <div class=\"d-flex justify-content-between\">\n");
      out.write("                            <div>\n");
      out.write("                                <div class=\"stat-lbl text-info\">Birds</div>\n");
      out.write("                                <div class=\"stat-val\">");
      out.print( birdCount );
      out.write("</div>\n");
      out.write("                                <span class=\"badge bg-info bg-opacity-10 text-info rounded-pill px-3\">Filter Birds</span>\n");
      out.write("                            </div>\n");
      out.write("                            <div style=\"color:#e0f2fe; font-size:2.5rem;\"><i class=\"fas fa-dove\"></i></div>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                </a>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"col-12 col-sm-6 col-xl-3 ");
      out.print( (isFilterMode && "NON_BIRD".equals(filterType)) ? "active-filter" : "" );
      out.write("\">\n");
      out.write("                <a href=\"index.jsp?type=NON_BIRD\" class=\"card-link\">\n");
      out.write("                    <div class=\"saas-card\">\n");
      out.write("                        <div class=\"d-flex justify-content-between\">\n");
      out.write("                            <div>\n");
      out.write("                                <div class=\"stat-lbl\" style=\"color:#ea580c;\">Mammals</div>\n");
      out.write("                                <div class=\"stat-val\">");
      out.print( mammalCount );
      out.write("</div>\n");
      out.write("                                <span class=\"badge bg-warning bg-opacity-10 text-warning rounded-pill px-3\">Filter Mammals</span>\n");
      out.write("                            </div>\n");
      out.write("                            <div style=\"color:#ffedd5; font-size:2.5rem;\"><i class=\"fas fa-dog\"></i></div>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                </a>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"col-12 col-sm-6 col-xl-3\">\n");
      out.write("                <a href=\"HealthRecordPanel.jsp\" class=\"card-link\">\n");
      out.write("                    <div class=\"saas-card\" style=\"border-bottom: 4px solid #ef4444;\">\n");
      out.write("                        <div class=\"d-flex justify-content-between\">\n");
      out.write("                            <div>\n");
      out.write("                                <div class=\"stat-lbl text-danger\">Needs Care</div>\n");
      out.write("                                <div class=\"stat-val\">");
      out.print( medicalCases );
      out.write("</div>\n");
      out.write("                                <span class=\"badge bg-danger bg-opacity-10 text-danger rounded-pill px-3\">Critical</span>\n");
      out.write("                            </div>\n");
      out.write("                            <div style=\"color:#fee2e2; font-size:2.5rem;\"><i class=\"fas fa-hand-holding-medical\"></i></div>\n");
      out.write("                        </div>\n");
      out.write("                    </div>\n");
      out.write("                </a>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("        ");
 if(!isSearchMode) { 
      out.write("\n");
      out.write("        <div class=\"row g-4 mb-4\">\n");
      out.write("            <div class=\"col-lg-8\"><div class=\"saas-card\"><h5 class=\"fw-bold mb-4\">Monthly Intake</h5><div style=\"height:320px;\"><canvas id=\"activityChart\"></canvas></div></div></div>\n");
      out.write("            <div class=\"col-lg-4\"><div class=\"saas-card\"><h5 class=\"fw-bold mb-4\">Species Diversity</h5><div style=\"height:280px;\"><canvas id=\"speciesChart\"></canvas></div></div></div>\n");
      out.write("        </div>\n");
      out.write("        ");
 } 
      out.write("\n");
      out.write("\n");
      out.write("       <div class=\"saas-card\" id=\"resultsSection\">\n");
      out.write("\n");
      out.write("            \n");
      out.write("            <div class=\"d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2\">\n");
      out.write("                <h5 class=\"fw-bold m-0\" style=\"font-family:'Fredoka'; color:var(--secondary);\">\n");
      out.write("                    ");
 if(isSearchMode) { 
      out.write(" Search Results \n");
      out.write("                    ");
 } else if (isFilterMode && "BIRD".equals(filterType)) { 
      out.write(" <i class=\"fas fa-feather-alt text-info me-2\"></i> Bird Registry \n");
      out.write("                    ");
 } else if (isFilterMode && "NON_BIRD".equals(filterType)) { 
      out.write(" <i class=\"fas fa-paw text-warning me-2\"></i> Mammal Registry \n");
      out.write("                    ");
 } else { 
      out.write(" <i class=\"fas fa-clock text-muted me-2\"></i> Recent Arrivals ");
 } 
      out.write("\n");
      out.write("                </h5>\n");
      out.write("                ");
 if(isFilterMode || isSearchMode) { 
      out.write("\n");
      out.write("                    <a href=\"index.jsp\" class=\"btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold\">Clear Filters</a>\n");
      out.write("                ");
 } 
      out.write("\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"table-responsive\">\n");
      out.write("                <table class=\"table table-hover align-middle\">\n");
      out.write("                    <thead><tr><th class=\"ps-4\">Name & ID</th><th>Species</th><th>Date Added</th><th class=\"text-end pe-4\">Actions</th></tr></thead>\n");
      out.write("                    <tbody>\n");
      out.write("                        ");
 
                        boolean hasA = false;
                        if(rsAnimals != null) { 
                            while(rsAnimals.next()) { hasA = true; 
                                String sp = rsAnimals.getString("species");
                                String badgeClass = (sp != null && sp.matches("(?i).*(Bird|Parrot|Eagle|Owl).*")) ? "bg-bird" : "bg-mammal";
                        
      out.write("\n");
      out.write("                        <tr>\n");
      out.write("                            <td class=\"ps-4\">\n");
      out.write("                                <div class=\"d-flex align-items-center gap-3\">\n");
      out.write("                                    <div style=\"width:36px; height:36px; background:#ffedd5; color:#f97316; border-radius:10px; display:flex; align-items:center; justify-content:center; font-weight:700;\">");
      out.print( rsAnimals.getString("name").substring(0,1) );
      out.write("</div>\n");
      out.write("                                    <div>\n");
      out.write("                                        <div style=\"font-weight:700;\">");
      out.print( rsAnimals.getString("name") );
      out.write("</div>\n");
      out.write("                                        <small class=\"text-muted\">#");
      out.print( rsAnimals.getInt("animal_id") );
      out.write("</small>\n");
      out.write("                                    </div>\n");
      out.write("                                </div>\n");
      out.write("                            </td>\n");
      out.write("                            <td><span class=\"badge-pill ");
      out.print( badgeClass );
      out.write('"');
      out.write('>');
      out.print( sp );
      out.write("</span></td>\n");
      out.write("                            <td class=\"text-muted\">");
      out.print( rsAnimals.getDate("arrival_date") );
      out.write("</td>\n");
      out.write("                            <td class=\"text-end pe-4\"><a href=\"updateAnimals.jsp?id=");
      out.print( rsAnimals.getInt("animal_id") );
      out.write("\" class=\"btn-action\" title=\"View Details\"><i class=\"fas fa-pen\"></i></a></td>\n");
      out.write("                        </tr>\n");
      out.write("                        ");
 }} 
      out.write("\n");
      out.write("                        ");
 if(!hasA) { 
      out.write("<tr><td colspan=\"5\" class=\"text-center py-5 text-muted fw-bold\">No fuzzy friends found here! 🐾</td></tr>");
 } 
      out.write("\n");
      out.write("                    </tbody>\n");
      out.write("                </table>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            ");
 if(isSearchMode) { 
      out.write("\n");
      out.write("            <hr class=\"my-4\" style=\"opacity:0.1; border-top: 2px dashed #ccc;\">\n");
      out.write("            <h5 class=\"fw-bold mb-3 ms-2\" style=\"font-family:'Fredoka';\">Matched Caretakers</h5>\n");
      out.write("            <div class=\"table-responsive\">\n");
      out.write("                <table class=\"table table-hover align-middle\">\n");
      out.write("                    <thead><tr><th class=\"ps-4\">Name</th><th>Shift</th><th>Phone</th><th class=\"text-end pe-4\">Contact</th></tr></thead>\n");
      out.write("                    <tbody>\n");
      out.write("                        ");
 
                        boolean hasC = false;
                        if(rsCaretakers != null) { 
                            while(rsCaretakers.next()) { hasC = true; 
                        
      out.write("\n");
      out.write("                        <tr>\n");
      out.write("                            <td class=\"ps-4 fw-bold text-dark\"><i class=\"fas fa-user-nurse text-warning me-2\"></i> ");
      out.print( rsCaretakers.getString("name") );
      out.write("</td>\n");
      out.write("                            <td><span class=\"badge bg-light text-dark border\">");
      out.print( rsCaretakers.getString("shift") );
      out.write("</span></td>\n");
      out.write("                            <td>");
      out.print( rsCaretakers.getString("phone") );
      out.write("</td>\n");
      out.write("                            <td class=\"text-end pe-4\"><button class=\"btn btn-sm btn-outline-warning rounded-pill px-3 fw-bold\">Call</button></td>\n");
      out.write("                        </tr>\n");
      out.write("                        ");
 }} 
      out.write("\n");
      out.write("                        ");
 if(!hasC) { 
      out.write("<tr><td colspan=\"5\" class=\"text-center py-4 text-muted\">No caretakers found.</td></tr>");
 } 
      out.write("\n");
      out.write("                    </tbody>\n");
      out.write("                </table>\n");
      out.write("            </div>\n");
      out.write("            ");
 } 
      out.write("\n");
      out.write("            ");
 if(con != null) con.close(); 
      out.write("\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("    </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("    function toggleSidebar() {\n");
      out.write("        const sidebar = document.getElementById('sidebar');\n");
      out.write("        const overlay = document.getElementById('sidebarOverlay');\n");
      out.write("        sidebar.classList.toggle('show');\n");
      out.write("        overlay.classList.toggle('show');\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    ");
 if(!isSearchMode) { 
      out.write("\n");
      out.write("    // Chart Colors: Pet Theme (Orange, Amber, Brown, Teal, Red)\n");
      out.write("    const ctxPie = document.getElementById('speciesChart');\n");
      out.write("    if(ctxPie){\n");
      out.write("        new Chart(ctxPie, {\n");
      out.write("            type: 'doughnut',\n");
      out.write("            data: {\n");
      out.write("                labels: [");
      out.print( chartLabels.toString() );
      out.write("],\n");
      out.write("                datasets: [{ \n");
      out.write("                    data: [");
      out.print( chartData.toString() );
      out.write("], \n");
      out.write("                    backgroundColor: ['#f97316', '#fbbf24', '#78350f', '#14b8a6', '#ef4444'],\n");
      out.write("                    borderWidth: 2,\n");
      out.write("                    borderColor: '#ffffff',\n");
      out.write("                    hoverOffset: 8\n");
      out.write("                }]\n");
      out.write("            },\n");
      out.write("            options: { cutout: '70%', plugins: { legend: { position:'bottom', labels:{boxWidth:12, padding:15, font:{family:'Fredoka'}} } } }\n");
      out.write("        });\n");
      out.write("    }\n");
      out.write("    \n");
      out.write("    const ctxBar = document.getElementById('activityChart');\n");
      out.write("    if(ctxBar){\n");
      out.write("        new Chart(ctxBar, {\n");
      out.write("            type: 'bar',\n");
      out.write("            data: {\n");
      out.write("                labels: ['Aug','Sep','Oct','Nov','Dec','Jan'],\n");
      out.write("                datasets: [{ \n");
      out.write("                    label: 'New Animals', \n");
      out.write("                    data: [12, 19, 15, 25, 22, 30], \n");
      out.write("                    backgroundColor: '#f97316', \n");
      out.write("                    borderRadius: 12,\n");
      out.write("                    barThickness: 25\n");
      out.write("                }]\n");
      out.write("            },\n");
      out.write("            options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero:true, grid:{ color:'#fff7ed' } }, x: { grid:{ display:false } } } }\n");
      out.write("        });\n");
      out.write("    }\n");
      out.write("    ");
 } 
      out.write("\n");
      out.write("</script>\n");
      out.write("\n");
      out.write("<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js\"></script>\n");
      out.write("<script>\n");
      out.write("    // Auto scroll to results when filter or search is used\n");
      out.write("    const isFilter = \"");
      out.print( isFilterMode );
      out.write("\";\n");
      out.write("    const isSearch = \"");
      out.print( isSearchMode );
      out.write("\";\n");
      out.write("\n");
      out.write("    if(isFilter === \"true\" || isSearch === \"true\"){\n");
      out.write("        const el = document.getElementById(\"resultsSection\");\n");
      out.write("        if(el){\n");
      out.write("            el.scrollIntoView({ behavior: \"smooth\", block: \"start\" });\n");
      out.write("        }\n");
      out.write("    }\n");
      out.write("</script>\n");
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
