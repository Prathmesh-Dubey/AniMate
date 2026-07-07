package animalCRUD;

import java.sql.*;

public class TestConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/animal_management";
    private static final String USER = "root";
    private static final String PASS = "1234";

    public static void main(String[] args) {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(URL, USER, PASS);

            System.out.println("Database Connected Successfully");

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM animal");

            System.out.println("\n--- Animal Table Data ---");

            while(rs.next()) {
                System.out.println(
                        rs.getInt("animal_id") + " | " +
                        rs.getString("name") + " | " +
                        rs.getString("species") + " | " +
                        rs.getInt("age")
                );
            }

            con.close();

        } catch (Exception e) {
            System.out.println("Connection Failed");
            e.printStackTrace();
        }
    }
}
