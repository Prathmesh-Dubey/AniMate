<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AnimMate | Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    :root {
        /* PET THEME PALETTE */
        --primary: #f97316;       /* Warm Paw Orange */
        --primary-soft: #ffedd5;  /* Soft Orange Tint */
        --secondary: #78350f;     /* Earthy Brown */
        
        --sidebar-bg: #fff7ed;    /* Creamy sidebar */
        --body-bg: #fffbeb;       /* Warmer Cream background */
        
        --card-shadow: 0 8px 20px rgba(120, 53, 15, 0.08);
        --border-radius-lg: 24px;
        --sidebar-width: 260px;
    }

    body { 
        background-color: var(--body-bg); 
        font-family: 'Nunito', sans-serif; 
        color: var(--secondary);
        margin: 0; 
        /* Paw print pattern */
        background-image: radial-gradient(#fed7aa 2px, transparent 2px), radial-gradient(#fed7aa 2px, transparent 2px);
        background-size: 32px 32px;
        background-position: 0 0, 16px 16px;
    }

    h1, h2, h3, h4, h5 { font-family: 'Fredoka', sans-serif; }

    /* SIDEBAR */
    .sidebar { 
        width: var(--sidebar-width); 
        background: var(--sidebar-bg); 
        border-right: 2px solid #fed7aa; 
        color: #9a3412; 
        position: fixed; 
        height: 100vh; 
        padding: 30px 24px; 
        z-index: 1050; 
        transition: transform 0.3s ease-in-out;
    }
    
    .brand { font-size: 24px; font-weight: 600; color: var(--primary); margin-bottom: 40px; display: flex; align-items: center; gap: 12px; }
    .brand i { transform: rotate(-10deg); }
    .nav-link { color: #9a3412; padding: 12px 18px; border-radius: 50px; margin-bottom: 6px; display: flex; align-items: center; gap: 12px; text-decoration: none; transition: 0.3s; font-weight: 600; font-size: 1rem; }
    .nav-link:hover { background: var(--primary-soft); color: var(--primary); transform: translateX(4px); }
    .nav-link.active { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3); }

    /* MAIN CONTENT */
    .main-content { margin-left: var(--sidebar-width); padding: 0; transition: margin-left 0.3s ease-in-out; }

    /* NAVBAR */
    .top-navbar { 
        background: rgba(255, 251, 235, 0.85); 
        backdrop-filter: blur(8px); 
        padding: 16px 40px; 
        display: flex; justify-content: space-between; align-items: center; 
        position: sticky; top: 0; z-index: 900; 
    }
    
    .search-wrapper { position: relative; width: 350px; }
    .search-wrapper input { width: 100%; padding: 12px 15px 12px 50px; border-radius: 50px; border: 2px solid #fed7aa; background: white; font-size: 0.95rem; transition: 0.3s; color: var(--secondary); }
    .search-wrapper input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px var(--primary-soft); }
    .search-wrapper i { position: absolute; left: 20px; top: 50%; transform: translateY(-50%); color: var(--primary); font-size: 1.1rem; }
    .search-btn-hidden { display: none; }

    /* ICONS */
    .nav-icons { display: flex; align-items: center; gap: 25px; }
    .notification-btn { position: relative; color: #ea580c; font-size: 1.3rem; cursor: pointer; transition: 0.2s; }
    .notification-btn:hover { transform: scale(1.1); }
    .user-profile { display: flex; align-items: center; gap: 12px; cursor: pointer; padding: 6px 12px; border-radius: 50px; border: 2px solid transparent; transition: 0.3s; }
    .user-profile:hover { background: white; border-color: #fed7aa; }
    .avatar { width: 40px; height: 40px; background: #fde68a; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #b45309; border: 2px solid white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }

    /* CARDS & BODY */
    .page-body { padding: 30px 40px; }
    
    .saas-card { 
        background: white; 
        border-radius: var(--border-radius-lg); 
        padding: 24px; 
        box-shadow: var(--card-shadow); 
        height: 100%; 
        border: 2px solid #fff7ed; 
        transition: 0.3s; 
    }
    .card-link { text-decoration: none; color: inherit; display: block; height: 100%; }
    .card-link:hover .saas-card { transform: translateY(-6px); border-color: var(--primary); }
    
    /* Highlight Active Filter */
    .active-filter .saas-card { background: #fff7ed; border-color: var(--primary); box-shadow: 0 0 0 4px var(--primary-soft); }

    .stat-val { font-size: 2.2rem; font-weight: 700; color: var(--secondary); margin: 5px 0; font-family: 'Fredoka'; }
    .stat-lbl { color: #9a3412; font-size: 0.9rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

    /* TABLES */
    .table-responsive { overflow-x: auto; }
    .table thead th { background: var(--primary-soft); color: var(--secondary); font-family: 'Fredoka'; font-weight: 500; border-bottom: none; padding: 18px; text-transform: uppercase; font-size: 0.85rem; white-space: nowrap; }
    .table tbody td { padding: 18px; vertical-align: middle; border-bottom: 1px solid #fff7ed; color: var(--secondary); font-weight: 600; white-space: nowrap; }
    
    .badge-pill { padding: 6px 14px; border-radius: 30px; font-size: 0.8rem; font-family: 'Fredoka'; }
    .bg-bird { background: #e0f2fe; color: #0ea5e9; }
    .bg-mammal { background: #ffedd5; color: #f97316; }

    .btn-action { width: 34px; height: 34px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; background: #fef9c3; color: #ca8a04; transition: 0.2s; text-decoration: none; border: 2px solid white; }
    .btn-action:hover { background: var(--primary); color: white; transform: rotate(10deg); }

    /* === RESPONSIVE STYLES === */
    /* Mobile Overlay */
    .sidebar-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0,0,0,0.5); z-index: 1040;
        display: none; opacity: 0; transition: opacity 0.3s;
    }
    .sidebar-overlay.show { display: block; opacity: 1; }

    @media (max-width: 991.98px) {
        .sidebar { transform: translateX(-100%); box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .sidebar.show { transform: translateX(0); }
        
        .main-content { margin-left: 0; }
        
        .top-navbar { padding: 15px 20px; gap: 15px; }
        .search-wrapper { width: 100%; }
        
        .page-body { padding: 20px 15px; }
        .stat-val { font-size: 1.8rem; }
        
        /* Hide text in user profile on mobile, show only avatar */
        .user-profile .text-end { display: none !important; }
    }
</style>
</head>
<body>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<div class="sidebar" id="sidebar">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="brand m-0"><i class="fas fa-paw"></i> AnimMate</div>
        <button class="btn btn-sm btn-light d-lg-none" onclick="toggleSidebar()"><i class="fas fa-times"></i></button>
    </div>
    
    <div class="d-flex flex-column gap-2 mt-2">
        <small class="text-uppercase fw-bold ps-3 mb-2" style="font-size:11px; color:#c2410c;">Shelter</small>
        <a href="index.jsp" class="nav-link active"><i class="fas fa-chart-pie"></i> Dashboard</a>
        <a href="viewAnimals.jsp" class="nav-link"><i class="fas fa-dog"></i> Our Animals</a>
        <a href="addAnimal.jsp" class="nav-link"><i class="fas fa-plus-circle"></i> New Arrival</a>
        <small class="text-uppercase fw-bold ps-3 mt-4 mb-2" style="font-size:11px; color:#c2410c;">Care</small>
        <a href="HealthRecordPanel.jsp" class="nav-link"><i class="fas fa-heartbeat"></i> Health</a>
        <a href="CaretakerCRUD.jsp" class="nav-link"><i class="fas fa-users"></i> Care Team</a>
    </div>
</div>

<div class="main-content">
    
    <div class="top-navbar">
        <button class="btn btn-light rounded-circle d-lg-none me-2" style="width:40px; height:40px; color:var(--primary);" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>

        <form action="index.jsp" method="get" class="m-0 flex-grow-1">
            <div class="search-wrapper">
                <i class="fas fa-search"></i>
                <input type="text" name="q" placeholder="Find a furry friend..." value="<%= (searchQuery!=null)?searchQuery:"" %>">
                <button type="submit" class="search-btn-hidden"></button>
            </div>
        </form>

        <div class="nav-icons ms-3">
            <div class="notification-btn"><i class="fas fa-bell"></i></div>
            <div class="dropdown">
                <div class="user-profile" data-bs-toggle="dropdown">
                    <div class="text-end d-none d-md-block">
                        <div style="font-weight:700; font-size:1rem; color:var(--secondary); font-family:'Fredoka';">Dr. Prathmesh</div>
                        <div style="font-size:0.85rem; color:#ca8a04;">Head Vet</div>
                    </div>
                    <div class="avatar">PD</div>
                </div>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-3 p-2 rounded-4">
                    <li><a class="dropdown-item" href="#">My Profile</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>

    <div class="page-body">
        
        <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
            <% if(isSearchMode){ %>
                <div>
                    <h3 class="fw-bold m-0" style="color:var(--secondary);">Search Results</h3>
                    <p class="text-muted m-0">Matches for "<%= searchQuery %>"</p>
                </div>
                <a href="index.jsp" class="btn btn-outline-warning text-dark border-2 rounded-pill px-4 fw-bold"><i class="fas fa-arrow-left me-2"></i>Back</a>
            <% } else { %>
                <div>
                    <h3 class="fw-bold m-0" style="color:var(--secondary);">Hello, Dr. Prathmesh! 👋</h3>
                    <p class="text-muted m-0">Here's what's happening at the shelter today.</p>
                </div>
            <% } %>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-12 col-sm-6 col-xl-3 <%= (!isFilterMode && !isSearchMode) ? "active-filter" : "" %>">
                <a href="index.jsp" class="card-link">
                    <div class="saas-card">
                        <div class="d-flex justify-content-between">
                            <div>
                                <div class="stat-lbl">Total Animals</div>
                                <div class="stat-val"><%= totalAnimals %></div>
                                <span class="badge bg-secondary bg-opacity-10 text-secondary rounded-pill px-3">Show All</span>
                            </div>
                            <div style="color:#fed7aa; font-size:2.5rem;"><i class="fas fa-globe"></i></div>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-12 col-sm-6 col-xl-3 <%= (isFilterMode && "BIRD".equals(filterType)) ? "active-filter" : "" %>">
                <a href="index.jsp?type=BIRD" class="card-link">
                    <div class="saas-card">
                        <div class="d-flex justify-content-between">
                            <div>
                                <div class="stat-lbl text-info">Birds</div>
                                <div class="stat-val"><%= birdCount %></div>
                                <span class="badge bg-info bg-opacity-10 text-info rounded-pill px-3">Filter Birds</span>
                            </div>
                            <div style="color:#e0f2fe; font-size:2.5rem;"><i class="fas fa-dove"></i></div>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-12 col-sm-6 col-xl-3 <%= (isFilterMode && "NON_BIRD".equals(filterType)) ? "active-filter" : "" %>">
                <a href="index.jsp?type=NON_BIRD" class="card-link">
                    <div class="saas-card">
                        <div class="d-flex justify-content-between">
                            <div>
                                <div class="stat-lbl" style="color:#ea580c;">Mammals</div>
                                <div class="stat-val"><%= mammalCount %></div>
                                <span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3">Filter Mammals</span>
                            </div>
                            <div style="color:#ffedd5; font-size:2.5rem;"><i class="fas fa-dog"></i></div>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <a href="HealthRecordPanel.jsp" class="card-link">
                    <div class="saas-card" style="border-bottom: 4px solid #ef4444;">
                        <div class="d-flex justify-content-between">
                            <div>
                                <div class="stat-lbl text-danger">Needs Care</div>
                                <div class="stat-val"><%= medicalCases %></div>
                                <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3">Critical</span>
                            </div>
                            <div style="color:#fee2e2; font-size:2.5rem;"><i class="fas fa-hand-holding-medical"></i></div>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <% if(!isSearchMode) { %>
        <div class="row g-4 mb-4">
            <div class="col-lg-8"><div class="saas-card"><h5 class="fw-bold mb-4">Monthly Intake</h5><div style="height:320px;"><canvas id="activityChart"></canvas></div></div></div>
            <div class="col-lg-4"><div class="saas-card"><h5 class="fw-bold mb-4">Species Diversity</h5><div style="height:280px;"><canvas id="speciesChart"></canvas></div></div></div>
        </div>
        <% } %>

       <div class="saas-card" id="resultsSection">

            
            <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                <h5 class="fw-bold m-0" style="font-family:'Fredoka'; color:var(--secondary);">
                    <% if(isSearchMode) { %> Search Results 
                    <% } else if (isFilterMode && "BIRD".equals(filterType)) { %> <i class="fas fa-feather-alt text-info me-2"></i> Bird Registry 
                    <% } else if (isFilterMode && "NON_BIRD".equals(filterType)) { %> <i class="fas fa-paw text-warning me-2"></i> Mammal Registry 
                    <% } else { %> <i class="fas fa-clock text-muted me-2"></i> Recent Arrivals <% } %>
                </h5>
                <% if(isFilterMode || isSearchMode) { %>
                    <a href="index.jsp" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold">Clear Filters</a>
                <% } %>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead><tr><th class="ps-4">Name & ID</th><th>Species</th><th>Date Added</th><th class="text-end pe-4">Actions</th></tr></thead>
                    <tbody>
                        <% 
                        boolean hasA = false;
                        if(rsAnimals != null) { 
                            while(rsAnimals.next()) { hasA = true; 
                                String sp = rsAnimals.getString("species");
                                String badgeClass = (sp != null && sp.matches("(?i).*(Bird|Parrot|Eagle|Owl).*")) ? "bg-bird" : "bg-mammal";
                        %>
                        <tr>
                            <td class="ps-4">
                                <div class="d-flex align-items-center gap-3">
                                    <div style="width:36px; height:36px; background:#ffedd5; color:#f97316; border-radius:10px; display:flex; align-items:center; justify-content:center; font-weight:700;"><%= rsAnimals.getString("name").substring(0,1) %></div>
                                    <div>
                                        <div style="font-weight:700;"><%= rsAnimals.getString("name") %></div>
                                        <small class="text-muted">#<%= rsAnimals.getInt("animal_id") %></small>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge-pill <%= badgeClass %>"><%= sp %></span></td>
                            <td class="text-muted"><%= rsAnimals.getDate("arrival_date") %></td>
                            <td class="text-end pe-4"><a href="updateAnimals.jsp?id=<%= rsAnimals.getInt("animal_id") %>" class="btn-action" title="View Details"><i class="fas fa-pen"></i></a></td>
                        </tr>
                        <% }} %>
                        <% if(!hasA) { %><tr><td colspan="5" class="text-center py-5 text-muted fw-bold">No fuzzy friends found here! 🐾</td></tr><% } %>
                    </tbody>
                </table>
            </div>

            <% if(isSearchMode) { %>
            <hr class="my-4" style="opacity:0.1; border-top: 2px dashed #ccc;">
            <h5 class="fw-bold mb-3 ms-2" style="font-family:'Fredoka';">Matched Caretakers</h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead><tr><th class="ps-4">Name</th><th>Shift</th><th>Phone</th><th class="text-end pe-4">Contact</th></tr></thead>
                    <tbody>
                        <% 
                        boolean hasC = false;
                        if(rsCaretakers != null) { 
                            while(rsCaretakers.next()) { hasC = true; 
                        %>
                        <tr>
                            <td class="ps-4 fw-bold text-dark"><i class="fas fa-user-nurse text-warning me-2"></i> <%= rsCaretakers.getString("name") %></td>
                            <td><span class="badge bg-light text-dark border"><%= rsCaretakers.getString("shift") %></span></td>
                            <td><%= rsCaretakers.getString("phone") %></td>
                            <td class="text-end pe-4"><button class="btn btn-sm btn-outline-warning rounded-pill px-3 fw-bold">Call</button></td>
                        </tr>
                        <% }} %>
                        <% if(!hasC) { %><tr><td colspan="5" class="text-center py-4 text-muted">No caretakers found.</td></tr><% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
            <% if(con != null) con.close(); %>
        </div>

    </div>
</div>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.toggle('show');
        overlay.classList.toggle('show');
    }

    <% if(!isSearchMode) { %>
    // Chart Colors: Pet Theme (Orange, Amber, Brown, Teal, Red)
    const ctxPie = document.getElementById('speciesChart');
    if(ctxPie){
        new Chart(ctxPie, {
            type: 'doughnut',
            data: {
                labels: [<%= chartLabels.toString() %>],
                datasets: [{ 
                    data: [<%= chartData.toString() %>], 
                    backgroundColor: ['#f97316', '#fbbf24', '#78350f', '#14b8a6', '#ef4444'],
                    borderWidth: 2,
                    borderColor: '#ffffff',
                    hoverOffset: 8
                }]
            },
            options: { cutout: '70%', plugins: { legend: { position:'bottom', labels:{boxWidth:12, padding:15, font:{family:'Fredoka'}} } } }
        });
    }
    
    const ctxBar = document.getElementById('activityChart');
    if(ctxBar){
        new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: ['Aug','Sep','Oct','Nov','Dec','Jan'],
                datasets: [{ 
                    label: 'New Animals', 
                    data: [12, 19, 15, 25, 22, 30], 
                    backgroundColor: '#f97316', 
                    borderRadius: 12,
                    barThickness: 25
                }]
            },
            options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero:true, grid:{ color:'#fff7ed' } }, x: { grid:{ display:false } } } }
        });
    }
    <% } %>
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto scroll to results when filter or search is used
    const isFilter = "<%= isFilterMode %>";
    const isSearch = "<%= isSearchMode %>";

    if(isFilter === "true" || isSearch === "true"){
        const el = document.getElementById("resultsSection");
        if(el){
            el.scrollIntoView({ behavior: "smooth", block: "start" });
        }
    }
</script>

</body>
</html>