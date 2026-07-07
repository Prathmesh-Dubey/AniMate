<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    // --- BACKEND LOGIC ---
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AnimMate | New Registration</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        /* PET THEME PALETTE */
        --primary: #f97316;       /* Warm Paw Orange */
        --primary-soft: #ffedd5;  
        --secondary: #78350f;     /* Earthy Brown */
        
        --sidebar-bg: #fff7ed;    
        --body-bg: #fffbeb;       
        
        --card-shadow: 0 10px 25px rgba(120, 53, 15, 0.08);
        --border-radius-lg: 24px;
        --sidebar-width: 260px;
    }

    body { 
        background-color: var(--body-bg); 
        font-family: 'Nunito', sans-serif; 
        color: var(--secondary);
        margin: 0; 
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
    .nav-link { color: #9a3412; padding: 12px 18px; border-radius: 50px; margin-bottom: 6px; display: flex; align-items: center; gap: 12px; text-decoration: none; transition: 0.3s; font-weight: 600; font-size: 1rem; }
    .nav-link:hover { background: var(--primary-soft); color: var(--primary); transform: translateX(4px); }
    .nav-link.active { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3); }

    /* MAIN CONTENT */
    .main-content { margin-left: var(--sidebar-width); padding: 0; transition: margin-left 0.3s ease-in-out; }
    
    .top-navbar { 
        background: rgba(255, 251, 235, 0.85); 
        backdrop-filter: blur(8px); 
        padding: 16px 40px; 
        display: flex; justify-content: space-between; align-items: center; 
        position: sticky; top: 0; z-index: 900; 
    }
    
    .search-wrapper { position: relative; width: 350px; }
    .search-wrapper input { width: 100%; padding: 12px 15px 12px 50px; border-radius: 50px; border: 2px solid #fed7aa; background: white; font-size: 0.95rem; outline: none; color: var(--secondary); }
    .search-wrapper i { position: absolute; left: 20px; top: 50%; transform: translateY(-50%); color: var(--primary); }
    
    .user-profile { display: flex; align-items: center; gap: 12px; cursor: pointer; padding: 6px 12px; border-radius: 50px; background: white; border: 2px solid #fed7aa; }
    .avatar { width: 40px; height: 40px; background: #fde68a; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #b45309; }

    /* FORM CARD DESIGN */
    .page-body { padding: 40px; display: flex; justify-content: center; }
    
    .form-card {
        background: white;
        border-radius: var(--border-radius-lg);
        width: 100%;
        max-width: 700px;
        box-shadow: var(--card-shadow);
        border: 2px solid #fff7ed;
        overflow: hidden;
    }

    .card-header-custom {
        background: var(--primary-soft);
        padding: 30px;
        text-align: center;
        border-bottom: 2px dashed #fed7aa;
    }
    
    .header-icon {
        width: 70px; height: 70px;
        background: white;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        margin: 0 auto 15px;
        color: var(--primary);
        font-size: 1.8rem;
        box-shadow: 0 4px 10px rgba(249, 115, 22, 0.2);
    }

    .card-body-custom { padding: 40px; }

    .form-label { font-weight: 700; color: #9a3412; font-size: 0.9rem; margin-bottom: 8px; margin-left: 5px; }
    
    .form-control, .form-select {
        border-radius: 15px;
        border: 2px solid #fed7aa;
        padding: 12px 15px;
        font-weight: 600;
        color: var(--secondary);
        background: #fff;
    }
    .form-control:focus, .form-select:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 4px var(--primary-soft);
    }

    .btn-save {
        background: var(--primary);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 50px;
        font-size: 1rem;
        font-weight: 700;
        font-family: 'Fredoka', sans-serif;
        box-shadow: 0 4px 15px rgba(249, 115, 22, 0.4);
        transition: 0.3s;
    }
    .btn-save:hover { background: #ea580c; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(249, 115, 22, 0.5); color: white; }

    /* ALERTS */
    .custom-alert { border-radius: 15px; padding: 20px; text-align: center; margin-bottom: 25px; border: 2px solid transparent; }
    .success-msg { background: #dcfce7; color: #166534; border-color: #86efac; }
    .error-msg { background: #fee2e2; color: #991b1b; border-color: #fca5a5; }

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
        .page-body { padding: 20px 15px; }
        .user-profile .text-end { display: none !important; }
        .card-body-custom { padding: 25px; }
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

    <div class="d-flex flex-column gap-2 mt-4">
        <small class="text-uppercase fw-bold ps-3 mb-2" style="font-size:11px; color:#c2410c;">Shelter</small>
        <a href="index.jsp" class="nav-link"><i class="fas fa-chart-pie"></i> Dashboard</a>
        <a href="viewAnimals.jsp" class="nav-link"><i class="fas fa-dog"></i> Our Animals</a>
        <a href="addAnimal.jsp" class="nav-link active"><i class="fas fa-plus-circle"></i> New Arrival</a>
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

        <div class="search-wrapper flex-grow-1 me-3 d-none d-sm-block">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Search...">
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
            <input type="text" placeholder="Search...">
        </div>
    </div>

    <div class="page-body">
        
        <div class="form-card">
            
            <div class="card-header-custom">
                <div class="header-icon">
                    <i class="fas fa-paw"></i>
                </div>
                <h3 class="m-0" style="color:#78350f; font-weight:700;">New Registration</h3>
                <p class="text-muted m-0 small">Add a new friend to the shelter</p>
            </div>

            <div class="card-body-custom">

                <% if(successMsg != null){ %>
                <div class="custom-alert success-msg">
                    <i class="fas fa-check-circle fa-2x mb-2"></i><br>
                    <span style="font-size:1.1rem; font-weight:700;"><%=successMsg%></span>
                    <div class="mt-3 d-flex justify-content-center gap-2">
                        <a href="viewAnimals.jsp" class="btn btn-sm btn-success rounded-pill fw-bold px-3">View List</a>
                        <a href="addAnimal.jsp" class="btn btn-sm btn-outline-success rounded-pill fw-bold px-3">Add Another</a>
                    </div>
                </div>
                <% } %>

                <% if(errorMsg != null){ %>
                <div class="custom-alert error-msg">
                    <i class="fas fa-exclamation-triangle fa-2x mb-2"></i><br>
                    <%=errorMsg%>
                </div>
                <% } %>

                <form method="post">
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Name</label>
                            <input type="text" name="name" class="form-control" placeholder="e.g. Charlie" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Species</label>
                            <input type="text" name="species" class="form-control" placeholder="e.g. Dog, Cat" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Breed</label>
                            <input type="text" name="breed" class="form-control" placeholder="e.g. Labrador">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Gender</label>
                            <select name="gender" class="form-select">
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Unknown">Unknown</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Age (Years)</label>
                            <input type="number" name="age" class="form-control" min="0" placeholder="e.g. 5">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Admission Date</label>
                            <input type="date" name="date" class="form-control" required>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-4 pt-2">
                        <a href="index.jsp" class="text-decoration-none fw-bold" style="color:#9a3412;">
                            <i class="fas fa-arrow-left me-1"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-save">
                            <i class="fas fa-save me-2"></i> Save Record
                        </button>
                    </div>

                </form>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.toggle('show');
        overlay.classList.toggle('show');
    }
</script>
</body>
</html>