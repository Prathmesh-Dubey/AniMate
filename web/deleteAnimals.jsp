<%@ page import="java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
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
%>

<!DOCTYPE html>
<html>
<head>
<title>Delete Result</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">

<% if(deleted){ %>

<div class="card p-5 text-center shadow">
    <h2 class="text-success">Deleted Successfully</h2>
    <p>Animal ID <b><%=animalId%></b> removed.</p>
    <a href="viewAnimals.jsp" class="btn btn-success mt-3">Back to List</a>
</div>

<% } else { %>

<div class="card p-5 shadow">
    <h2 class="text-danger">Delete Failed</h2>
    <p><%=errorMsg%></p>

    <% if(rsHealth!=null && rsHealth.isBeforeFirst()){ %>
    <h5 class="mt-4">Health Records Linked</h5>
    <table class="table table-bordered">
        <tr>
            <th>ID</th><th>Disease</th><th>Treatment</th><th>Date</th>
        </tr>
        <% while(rsHealth.next()){ %>
        <tr>
            <td><%=rsHealth.getInt(1)%></td>
            <td><%=rsHealth.getString(2)%></td>
            <td><%=rsHealth.getString(3)%></td>
            <td><%=rsHealth.getDate(4)%></td>
        </tr>
        <% } %>
    </table>
    <% } else if(rsHealth!=null){ %>
        <p class="text-muted">No health records found.</p>
    <% } %>

    <a href="viewAnimals.jsp" class="btn btn-secondary mt-3">Back</a>
</div>

<% } %>

</div>
</body>
</html>

<% if(con!=null) con.close(); %>
