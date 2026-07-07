<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AnimMate | Animal Registry</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        /* ANIMAL THEME PALETTE */
        --primary: #f97316;       /* Warm Paw Orange */
        --primary-soft: #ffedd5;  /* Soft Orange Tint */
        --secondary: #78350f;     /* Earthy Brown */
        --accent-blue: #0ea5e9;   /* Sky Blue (for birds/accents) */
        
        --sidebar-bg: #fff7ed;    /* Creamy sidebar */
        --body-bg: #fffbeb;       /* Warmer Cream background */
        
        --card-shadow: 0 8px 20px rgba(120, 53, 15, 0.08); /* Soft warm shadow */
        --border-radius-lg: 24px; /* Extra rounded */
        --sidebar-width: 260px;
    }

    body { 
        background-color: var(--body-bg); 
        font-family: 'Nunito', sans-serif; /* Soft body font */
        color: var(--secondary);
        margin: 0; 
        /* Cute subtle paw pattern background */
        background-image: radial-gradient(#fed7aa 2px, transparent 2px), radial-gradient(#fed7aa 2px, transparent 2px);
        background-size: 32px 32px;
        background-position: 0 0, 16px 16px;
    }

    h1, h2, h3, h4, h5, .brand, .nav-header {
        font-family: 'Fredoka', sans-serif; /* Playful heading font */
    }

    /* ===== SIDEBAR ===== */
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
    
    .brand { 
        font-size: 24px; 
        font-weight: 600; 
        color: var(--primary); 
        margin-bottom: 40px; 
        display: flex; 
        align-items: center; 
        gap: 12px; 
    }
    .brand i { transform: rotate(-10deg); } /* Playful tilt */

    .nav-header { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 600; margin-top: 30px; margin-bottom: 15px; color: #c2410c; opacity: 0.7; }

    .nav-link { 
        color: #9a3412;
        padding: 12px 18px; 
        border-radius: 50px; /* Soft pill shape */
        margin-bottom: 6px; 
        display: flex; 
        align-items: center; 
        gap: 12px; 
        text-decoration: none; 
        transition: all 0.3s ease; 
        font-weight: 600; 
        font-size: 1rem;
    }
    .nav-link:hover { background: var(--primary-soft); color: var(--primary); transform: translateX(4px); }
    .nav-link.active { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3); }

    /* ===== MAIN CONTENT ===== */
    .main-content { margin-left: var(--sidebar-width); padding: 0; transition: margin-left 0.3s ease-in-out; }

    /* ===== NAVBAR ===== */
    .top-navbar { 
        background: rgba(255, 251, 235, 0.85); /* Semi-transparent cream */
        backdrop-filter: blur(8px); 
        padding: 16px 40px; 
        display: flex; justify-content: space-between; align-items: center; 
        position: sticky; top: 0; z-index: 900; 
    }

    .search-wrapper { position: relative; width: 320px; }
    .search-wrapper input { 
        width: 100%; 
        padding: 12px 15px 12px 50px; 
        border-radius: 50px; 
        border: 2px solid #fed7aa; 
        background: white; 
        font-size: 0.95rem;
        transition: 0.3s; 
        color: var(--secondary);
    }
    .search-wrapper input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px var(--primary-soft); }
    .search-wrapper i { position: absolute; left: 20px; top: 50%; transform: translateY(-50%); color: var(--primary); font-size: 1.1rem; }

    .user-profile { display: flex; align-items: center; gap: 12px; cursor: pointer; padding: 6px 12px; border-radius: 50px; background: white; border: 2px solid #fed7aa; }
    .avatar { width: 40px; height: 40px; background: #fde68a; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #b45309; }

    /* ===== TABLE CARD DESIGN ===== */
    .page-container { padding: 40px; }

    .content-header { margin-bottom: 30px; display: flex; justify-content: space-between; align-items: end; flex-wrap: wrap; gap: 20px; }
    .page-title { font-size: 2rem; font-weight: 600; color: var(--secondary); margin: 0; }
    .page-subtitle { color: #9a3412; margin-top: 5px; font-size: 1rem; }

    .pet-card {
        background: white;
        border-radius: var(--border-radius-lg);
        box-shadow: var(--card-shadow);
        border: 2px solid #fff7ed;
        overflow: hidden;
    }

    .table-responsive { overflow-x: auto; }
    .table { margin-bottom: 0; }
    
    .table thead th { 
        background: var(--primary-soft); 
        color: var(--secondary);
        font-family: 'Fredoka', sans-serif;
        font-weight: 500; 
        font-size: 0.9rem; 
        text-transform: uppercase; 
        letter-spacing: 0.05em;
        padding: 22px 24px;
        border-bottom: none;
        white-space: nowrap;
    }

    .table tbody td { 
        padding: 20px 24px; 
        vertical-align: middle; 
        border-bottom: 1px solid #fff7ed;
        color: var(--secondary);
        font-size: 1rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .table tbody tr { transition: background-color 0.2s; }
    .table tbody tr:hover { background-color: #fff7ed; }

    /* Visual Elements */
    /* Pet Tag Avatar style */
    .animal-avatar {
        width: 44px; height: 44px;
        border-radius: 14px; /* Squircle shape like a tag */
        display: flex; align-items: center; justify-content: center;
        font-family: 'Fredoka', sans-serif;
        font-weight: 600; color: white;
        font-size: 1.2rem;
        background: linear-gradient(135deg, var(--primary), #fb923c);
        box-shadow: 2px 4px 8px rgba(249, 115, 22, 0.2);
        border: 2px solid white;
    }
    
    .badge-soft { 
        padding: 8px 14px; 
        border-radius: 30px; 
        font-size: 0.85rem; 
        font-family: 'Fredoka', sans-serif;
        font-weight: 500; 
    }
    /* Themed Badges */
    .badge-soft.bird { background: #e0f2fe; color: var(--accent-blue); } 
    .badge-soft.mammal { background: var(--primary-soft); color: var(--primary); }

    .btn-add {
        background: var(--primary);
        color: white;
        padding: 12px 26px;
        border-radius: 50px;
        font-family: 'Fredoka', sans-serif;
        font-weight: 500;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
        transition: 0.2s;
        border: 2px solid white;
    }
    .btn-add:hover { background: #ea580c; transform: translateY(-2px); color: white; }

    .action-btn {
        width: 36px; height: 36px;
        border-radius: 50%;
        display: inline-flex; align-items: center; justify-content: center;
        color: #ca8a04; background: #fef9c3; /* Warm yellow style */
        transition: 0.2s;
        text-decoration: none;
        border: 2px solid white;
    }
    .action-btn:hover { background: var(--primary); color: white; transform: rotate(10deg); }
    .action-btn.delete { color: #dc2626; background: #fee2e2; }
    .action-btn.delete:hover { background: #dc2626; color: white; }

    /* === RESPONSIVE STYLES === */
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
        .page-container { padding: 20px 15px; }
        .user-profile .text-end { display: none !important; }
        
        .content-header { flex-direction: column; align-items: flex-start; gap: 15px; }
        .btn-add { width: 100%; justify-content: center; }
    }
</style>
</head>
<body>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<div class="sidebar" id="sidebar">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="brand m-0"><i class="fas fa-paw fa-lg"></i> AnimMate</div>
        <button class="btn btn-sm btn-light d-lg-none" onclick="toggleSidebar()"><i class="fas fa-times"></i></button>
    </div>
    
    <div class="nav-header">Shelter Overview</div>
    <a href="index.jsp" class="nav-link"><i class="fas fa-home"></i> Dashboard</a>
    <a href="viewAnimals.jsp" class="nav-link active"><i class="fas fa-dog"></i> Our Animals</a>
    <a href="addAnimal.jsp" class="nav-link"><i class="fas fa-plus-circle"></i> New Arrival</a>
    
    <div class="nav-header">Care & Staff</div>
    <a href="HealthRecordPanel.jsp" class="nav-link"><i class="fas fa-hand-holding-heart"></i> Health Checks</a>
    <a href="CaretakerCRUD.jsp" class="nav-link"><i class="fas fa-users"></i> Care Team</a>
</div>

<div class="main-content">

    <div class="top-navbar">
        <button class="btn btn-light rounded-circle d-lg-none me-2" style="width:40px; height:40px; color:var(--primary);" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>

        <div class="search-wrapper flex-grow-1 me-3 d-none d-sm-block">
            <i class="fas fa-search"></i>
            <input type="text" id="tableSearch" placeholder="Find a furry friend...">
        </div>

        <div class="d-flex align-items-center gap-3">
            <div class="text-end d-none d-md-block">
                <div style="font-weight:700; font-size:1rem; color:var(--secondary); font-family:'Fredoka';">Dr. Prathmesh</div>
                <div style="font-size:0.85rem; color:#ca8a04;">Head Vet</div>
            </div>
            <div class="avatar">PD</div>
        </div>
    </div>
    
    <div class="p-3 d-sm-none bg-white border-bottom">
         <div class="search-wrapper w-100">
            <i class="fas fa-search"></i>
            <input type="text" id="mobileTableSearch" placeholder="Find a furry friend...">
        </div>
    </div>

    <div class="page-container">
        
        <div class="content-header">
            <div>
                <h1 class="page-title">Registry <i class="fas fa-bone text-warning ms-2" style="transform: rotate(45deg);"></i></h1>
                <p class="page-subtitle">The complete list of all our lovely residents.</p>
            </div>
            <a href="addAnimal.jsp" class="btn-add">
                <i class="fas fa-paw"></i> Add New Friend
            </a>
        </div>

        <div class="pet-card">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th class="ps-4">Name & ID</th>
                            <th>Family</th>
                            <th>Breed</th>
                            <th>Gender</th>
                            <th>Age</th>
                            <th>Arrival</th>
                            <th class="text-end pe-4">Care Actions</th>
                        </tr>
                    </thead>
                    <tbody>

                    <%
                    Connection con = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                            "root","1234");

                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery("SELECT * FROM animal ORDER BY animal_id DESC");

                        while(rs.next()){
                            String name = rs.getString("name");
                            String species = rs.getString("species");
                            char initial = (name != null && name.length() > 0) ? name.charAt(0) : '?';
                            
                            // Badge color logic based on species
                            String badgeClass = "badge-soft";
                            if(species != null && species.matches("(?i).*(Bird|Parrot|Eagle|Owl|Macaw).*")) {
                                badgeClass += " bird";
                            } else {
                                badgeClass += " mammal";
                            }
                    %>
                        <tr>
                            <td class="ps-4">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="animal-avatar"><%= initial %></div>
                                    <div>
                                        <div style="font-family:'Fredoka'; font-size:1.1rem;"><%= name %></div>
                                        <div style="font-size:0.85rem; color:#ca8a04; font-weight:700;">#<%= rs.getInt("animal_id") %></div>
                                    </div>
                                </div>
                            </td>
                            <td><span class="<%= badgeClass %>"><%= species %></span></td>
                            <td><%= rs.getString("breed") %></td>
                            <td>
                                <% if("Male".equalsIgnoreCase(rs.getString("gender"))) { %>
                                    <i class="fas fa-mars text-primary me-1"></i> Male
                                <% } else { %>
                                    <i class="fas fa-venus text-danger me-1"></i> Female
                                <% } %>
                            </td>
                            <td><%= rs.getInt("age") %> <small class="text-muted">yrs</small></td>
                            <td style="color:#9a3412;"><i class="far fa-calendar-alt me-2 opacity-50"></i><%= rs.getDate("arrival_date") %></td>
                            <td class="text-end pe-4">
                                <a href="updateAnimals.jsp?id=<%=rs.getInt("animal_id")%>" class="action-btn" title="Edit Details">
                                    <i class="fas fa-pen-fancy" style="font-size:0.9rem;"></i>
                                </a>
                                <a href="deleteAnimals.jsp?id=<%=rs.getInt("animal_id")%>" class="action-btn delete ms-2" title="Remove Record" onclick="return confirm('Are you sure you want to remove <%= name %>?');">
                                    <i class="fas fa-heart-broken" style="font-size:0.9rem;"></i>
                                </a>
                            </td>
                        </tr>
                    <%
                        }
                        con.close();
                    } catch(Exception e) {
                    %>
                        <tr>
                            <td colspan="7" class="text-center p-5 text-danger">
                                <i class="fas fa-frown-open fa-3x mb-3"></i><br>
                                <span style="font-family:'Fredoka'; font-size:1.2rem;">Oops! Couldn't load the animals.</span><br>
                                <small><%= e.getMessage() %></small>
                            </td>
                        </tr>
                    <%
                    }
                    %>

                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="d-flex justify-content-between align-items-center mt-4 px-2">
            <div style="color:#9a3412; font-weight:600;">Viewing all pets</div>
            <nav>
                <ul class="pagination pagination-sm m-0 shadow-sm" style="border-radius: 50px; overflow:hidden;">
                    <li class="page-item disabled"><a class="page-link border-0 bg-white text-muted" href="#">Prev</a></li>
                    <li class="page-item active"><a class="page-link border-0 bg-primary text-white" href="#">1</a></li>
                    <li class="page-item"><a class="page-link border-0 bg-white text-warning" href="#">2</a></li>
                    <li class="page-item"><a class="page-link border-0 bg-white" href="#">Next</a></li>
                </ul>
            </nav>
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

    // Connect both search bars (desktop and mobile) to the filter function
    const filterTable = (val) => {
        let rows = document.querySelectorAll('tbody tr');
        rows.forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(val) ? '' : 'none';
        });
    };

    document.getElementById('tableSearch')?.addEventListener('keyup', function() {
        filterTable(this.value.toLowerCase());
    });
    
    document.getElementById('mobileTableSearch')?.addEventListener('keyup', function() {
        filterTable(this.value.toLowerCase());
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>