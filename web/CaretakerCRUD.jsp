<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AnimMate | Caretaker Staff</title>

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

    /* PAGE LAYOUT */
    .page-body { padding: 40px; }
    
    .saas-card {
        background: white;
        border-radius: var(--border-radius-lg);
        box-shadow: var(--card-shadow);
        border: 2px solid #fff7ed;
        overflow: hidden;
        height: 100%;
    }

    .card-header-custom {
        padding: 20px 25px;
        background: var(--primary-soft);
        border-bottom: 2px dashed #fed7aa;
        display: flex; align-items: center; gap: 10px;
    }

    /* FORM STYLES */
    .form-control {
        border-radius: 12px;
        border: 2px solid #fed7aa;
        padding: 10px 15px;
        font-weight: 600;
        color: var(--secondary);
    }
    .form-control:focus { border-color: var(--primary); box-shadow: 0 0 0 4px var(--primary-soft); }
    .form-label { font-weight: 700; color: #9a3412; font-size: 0.9rem; margin-bottom: 5px; }

    .btn-action { width: 100%; border-radius: 50px; padding: 10px; font-weight: 700; font-family: 'Fredoka'; transition: 0.3s; border: none; margin-bottom: 10px; }
    .btn-add { background: #22c55e; color: white; }
    .btn-add:hover { background: #16a34a; transform: translateY(-2px); }
    .btn-update { background: #3b82f6; color: white; }
    .btn-update:hover { background: #2563eb; transform: translateY(-2px); }
    .btn-delete { background: #ef4444; color: white; }
    .btn-delete:hover { background: #dc2626; transform: translateY(-2px); }

    /* TABLE STYLES */
    .table-responsive { overflow-x: auto; }
    .table thead th { background: #fff7ed; color: #9a3412; font-family: 'Fredoka'; font-weight: 500; border-bottom: none; padding: 15px; text-transform: uppercase; font-size: 0.85rem; white-space: nowrap; }
    .table tbody td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #fff7ed; color: var(--secondary); font-weight: 600; white-space: nowrap; }
    .table tbody tr { cursor: pointer; transition: 0.2s; }
    .table tbody tr:hover { background-color: #fff7ed; transform: scale(1.01); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

    /* ALERTS */
    .custom-alert { border-radius: 15px; padding: 15px; font-weight: 700; margin-bottom: 20px; border: 2px solid transparent; }
    .success-msg { background: #dcfce7; color: #166534; border-color: #86efac; }
    .update-msg { background: #dbeafe; color: #1e40af; border-color: #93c5fd; }
    .delete-msg { background: #fee2e2; color: #991b1b; border-color: #fca5a5; }

    /* RESPONSIVE CSS */
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
        /* Hide text in user profile on mobile, show only avatar */
        .user-profile .text-end { display: none !important; }
    }
</style>

<script>
function fillForm(id, name, phone, shift){
    document.getElementsByName("id")[0].value = id;
    document.getElementsByName("name")[0].value = name;
    document.getElementsByName("phone")[0].value = phone;
    document.getElementsByName("shift")[0].value = shift;
    
    // Highlight form visually
    document.getElementById("formCard").style.borderColor = "#f97316";
    setTimeout(() => { document.getElementById("formCard").style.borderColor = "#fff7ed"; }, 1000);
    
    // On mobile, scroll up to form
    if(window.innerWidth < 992) {
        document.getElementById("formCard").scrollIntoView({behavior: 'smooth'});
    }
}
</script>

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
        <a href="addAnimal.jsp" class="nav-link"><i class="fas fa-plus-circle"></i> New Arrival</a>
        <small class="text-uppercase fw-bold ps-3 mt-4 mb-2" style="font-size:11px; color:#c2410c;">Care</small>
        <a href="HealthRecordPanel.jsp" class="nav-link"><i class="fas fa-heartbeat"></i> Health</a>
        <a href="CaretakerCRUD.jsp" class="nav-link active"><i class="fas fa-users"></i> Care Team</a>
    </div>
</div>

<div class="main-content">

    <div class="top-navbar">
        <button class="btn btn-light rounded-circle d-lg-none me-2" style="width:40px; height:40px; color:var(--primary);" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>

        <div class="search-wrapper flex-grow-1 me-3 d-none d-sm-block">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Search staff...">
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
            <input type="text" placeholder="Search staff...">
        </div>
    </div>

    <div class="page-body">
        
        <div class="mb-4">
            <h3 class="fw-bold m-0" style="color:var(--secondary);">Caretaker Management</h3>
            <p class="text-muted m-0">Manage staff schedules and contact info.</p>
        </div>

        <%
        String action = request.getParameter("action");
        String msg = "";
        String msgClass = "";

        if(action != null){
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                "root","1234");

                if(action.equals("Add")){
                    PreparedStatement ps = con.prepareStatement("INSERT INTO caretaker(name,phone,shift) VALUES(?,?,?)");
                    ps.setString(1,request.getParameter("name"));
                    ps.setString(2,request.getParameter("phone"));
                    ps.setString(3,request.getParameter("shift"));
                    ps.executeUpdate();
                    msg = "<i class='fas fa-check-circle me-2'></i> Caretaker Added Successfully!";
                    msgClass = "success-msg";
                }

                if(action.equals("Update")){
                    PreparedStatement ps = con.prepareStatement("UPDATE caretaker SET name=?, phone=?, shift=? WHERE caretaker_id=?");
                    ps.setString(1,request.getParameter("name"));
                    ps.setString(2,request.getParameter("phone"));
                    ps.setString(3,request.getParameter("shift"));
                    ps.setInt(4,Integer.parseInt(request.getParameter("id")));
                    ps.executeUpdate();
                    msg = "<i class='fas fa-sync-alt me-2'></i> Record Updated Successfully!";
                    msgClass = "update-msg";
                }

                if(action.equals("Delete")){
                    PreparedStatement ps = con.prepareStatement("DELETE FROM caretaker WHERE caretaker_id=?");
                    ps.setInt(1,Integer.parseInt(request.getParameter("id")));
                    ps.executeUpdate();
                    msg = "<i class='fas fa-trash-alt me-2'></i> Caretaker Removed.";
                    msgClass = "delete-msg";
                }
                con.close();
            } catch(Exception e) {
                msg = "Error: " + e.getMessage();
                msgClass = "delete-msg";
            }
        }
        %>

        <% if(!msg.equals("")){ %>
            <div class="custom-alert <%=msgClass%>"><%=msg%></div>
        <% } %>

        <div class="row g-4">
            
            <div class="col-lg-4 order-lg-1 order-1">
                <div class="saas-card" id="formCard">
                    <div class="card-header-custom">
                        <i class="fas fa-user-edit text-primary fs-4"></i>
                        <h5 class="m-0 fw-bold" style="color:var(--secondary);">Manage Staff</h5>
                    </div>
                    <div class="p-4">
                        <form method="post">
                            <div class="mb-3">
                                <label class="form-label">ID (Auto/Select)</label>
                                <input type="number" name="id" class="form-control" placeholder="Select from list..." readonly style="background:#fdfce8;">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Full Name</label>
                                <input type="text" name="name" class="form-control" placeholder="e.g. John Doe" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Phone Number</label>
                                <input type="text" name="phone" class="form-control" placeholder="e.g. 555-0123" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">Shift Timing</label>
                                <select name="shift" class="form-select form-control">
                                    <option>Morning (6AM - 2PM)</option>
                                    <option>Afternoon (2PM - 10PM)</option>
                                    <option>Night (10PM - 6AM)</option>
                                </select>
                            </div>

                            <div class="d-grid gap-2">
                                <button class="btn-action btn-add" type="submit" name="action" value="Add">
                                    <i class="fas fa-plus me-2"></i> Add Staff
                                </button>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <button class="btn-action btn-update" type="submit" name="action" value="Update">
                                            <i class="fas fa-save me-2"></i> Update
                                        </button>
                                    </div>
                                    <div class="col-6">
                                        <button class="btn-action btn-delete" type="submit" name="action" value="Delete" onclick="return confirm('Are you sure?');">
                                            <i class="fas fa-trash me-2"></i> Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-8 order-lg-2 order-2">
                <div class="saas-card">
                    <div class="card-header-custom">
                        <i class="fas fa-list text-primary fs-4"></i>
                        <h5 class="m-0 fw-bold" style="color:var(--secondary);">Team List</h5>
                        <small class="ms-auto text-muted d-none d-sm-block">Click row to edit</small>
                    </div>
                    <div class="table-responsive">
                        <table class="table mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Phone</th>
                                    <th>Shift</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                try{
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection con = DriverManager.getConnection(
                                    "jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                                    "root","1234");

                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT * FROM caretaker");

                                    while(rs.next()){
                                %>
                                <tr onclick="fillForm(
                                    '<%= rs.getInt("caretaker_id") %>',
                                    '<%= rs.getString("name") %>',
                                    '<%= rs.getString("phone") %>',
                                    '<%= rs.getString("shift") %>'
                                )">
                                    <td><span class="badge bg-warning text-dark">#<%= rs.getInt("caretaker_id") %></span></td>
                                    <td class="fw-bold"><i class="fas fa-user-circle text-muted me-2"></i><%= rs.getString("name") %></td>
                                    <td><%= rs.getString("phone") %></td>
                                    <td><span class="badge bg-light text-primary border"><%= rs.getString("shift") %></span></td>
                                </tr>
                                <%
                                    }
                                    con.close();
                                } catch(Exception e){
                                    out.println("<tr><td colspan='4' class='text-danger'>Error loading data: "+e.getMessage()+"</td></tr>");
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
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