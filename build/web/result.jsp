<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AnimMate | Status</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        /* PET THEME PALETTE */
        --primary: #f97316;       /* Warm Paw Orange */
        --primary-soft: #ffedd5;  
        --secondary: #78350f;     /* Earthy Brown */
        
        --success-bg: #dcfce7;
        --success-text: #15803d;
        --error-bg: #fee2e2;
        --error-text: #b91c1c;
        
        --body-bg: #fffbeb;       
        --card-shadow: 0 15px 35px rgba(120, 53, 15, 0.1);
    }

    body { 
        background-color: var(--body-bg); 
        font-family: 'Nunito', sans-serif; 
        color: var(--secondary);
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        /* Paw Pattern */
        background-image: radial-gradient(#fed7aa 2px, transparent 2px), radial-gradient(#fed7aa 2px, transparent 2px);
        background-size: 32px 32px;
        background-position: 0 0, 16px 16px;
    }

    h2 { font-family: 'Fredoka', sans-serif; font-weight: 600; letter-spacing: 0.5px; }

    .result-card {
        background: white;
        border-radius: 30px;
        max-width: 500px;
        width: 90%;
        padding: 40px 30px;
        text-align: center;
        box-shadow: var(--card-shadow);
        border: 4px solid #fff7ed;
        position: relative;
        overflow: hidden;
    }

    /* Icon Animation */
    .icon-wrapper {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 3rem;
        margin: 0 auto 25px;
        animation: popIn 0.6s cubic-bezier(0.68, -0.55, 0.27, 1.55);
    }

    @keyframes popIn {
        0% { transform: scale(0); opacity: 0; }
        80% { transform: scale(1.1); opacity: 1; }
        100% { transform: scale(1); }
    }

    .btn-action {
        padding: 12px 25px;
        border-radius: 50px;
        font-weight: 700;
        font-family: 'Fredoka', sans-serif;
        text-decoration: none;
        transition: 0.3s;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .btn-dashboard {
        background: white;
        color: #9a3412;
        border: 2px solid #fed7aa;
    }
    .btn-dashboard:hover { background: #fff7ed; color: var(--primary); }

    .btn-list {
        background: var(--primary);
        color: white;
        border: 2px solid var(--primary);
        box-shadow: 0 4px 15px rgba(249, 115, 22, 0.3);
    }
    .btn-list:hover { background: #ea580c; border-color: #ea580c; color: white; transform: translateY(-2px); }

</style>
</head>
<body>

<%
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
%>

<div class="result-card">
    
    <div class="icon-wrapper" style="background-color: <%= iconBg %>; color: <%= iconColor %>;">
        <i class="<%= iconClass %>"></i>
    </div>

    <h2 style="color: <%= iconColor %>;"><%= title %></h2>
    <p class="text-muted mb-4 fs-5" style="font-weight: 600;"><%= (msg != null) ? msg : "Operation completed." %></p>

    <div class="d-grid gap-2 d-sm-flex justify-content-center">
        <a href="index.jsp" class="btn-action btn-dashboard">
            <i class="fas fa-home"></i> Dashboard
        </a>
        <a href="viewAnimals.jsp" class="btn-action btn-list">
            <i class="fas fa-list-ul"></i> View Animals
        </a>
    </div>

</div>

</body>
</html>