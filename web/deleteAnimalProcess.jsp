<%@ page import="java.sql.*" %>

<%
try{

String idStr = request.getParameter("id");

if(idStr == null || idStr.trim().equals("")){
    response.sendRedirect("result.jsp?msg=Animal ID is missing");
    return;
}

int id = Integer.parseInt(idStr);

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root","1234");

PreparedStatement ps = con.prepareStatement(
"DELETE FROM animal WHERE animal_id=?");

ps.setInt(1, id);
ps.executeUpdate();
con.close();

response.sendRedirect("result.jsp?msg=Animal Deleted Successfully");

}
catch(Exception e){
    response.sendRedirect("result.jsp?msg=Error while deleting animal");
}
%>
