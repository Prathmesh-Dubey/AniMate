<%@ page import="java.sql.*" %>

<%
try{

String ageStr = request.getParameter("age");
String idStr = request.getParameter("id");

if(ageStr == null || idStr == null || ageStr.trim().equals("") || idStr.trim().equals("")){
    response.sendRedirect("result.jsp?msg=Age or ID missing");
    return;
}

int age = Integer.parseInt(ageStr);
int id = Integer.parseInt(idStr);

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/animal_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root","1234");

PreparedStatement ps = con.prepareStatement(
"UPDATE animal SET age=? WHERE animal_id=?");

ps.setInt(1, age);
ps.setInt(2, id);

ps.executeUpdate();
con.close();

response.sendRedirect("result.jsp?msg=Animal Updated Successfully");

}
catch(Exception e){
    response.sendRedirect("result.jsp?msg=Error while updating animal");
}
%>
