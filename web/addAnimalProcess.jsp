<%@ page import="java.sql.*" %>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
    "root","1234");

    PreparedStatement ps = con.prepareStatement(
    "INSERT INTO animal(name,species,breed,gender,age,arrival_date) VALUES(?,?,?,?,?,?)");

    ps.setString(1, request.getParameter("name"));
    ps.setString(2, request.getParameter("species"));
    ps.setString(3, request.getParameter("breed"));
    ps.setString(4, request.getParameter("gender"));
    ps.setInt(5, Integer.parseInt(request.getParameter("age")));
    ps.setString(6, request.getParameter("date"));

    ps.executeUpdate();
    con.close();
response.sendRedirect("result.jsp?msg=Animal Added Successfully");

%>

Animal Added Successfully  
<br><a href="index.jsp">Back</a>

<%
}
catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>
