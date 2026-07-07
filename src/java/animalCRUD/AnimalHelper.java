package animalCRUD;

import java.sql.*;

public class AnimalHelper {

    private static final String URL = "jdbc:mysql://localhost:3306/animal_management";
    private static final String USER = "root";
    private static final String PASS = "1234";

    // Get Connection
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // INSERT
    public static void insertAnimal(String name, String species, String breed, String gender, int age, String date) {
        try {
            Connection con = getConnection();
            String sql = "INSERT INTO animal(name,species,breed,gender,age,arrival_date) VALUES(?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, species);
            ps.setString(3, breed);
            ps.setString(4, gender);
            ps.setInt(5, age);
            ps.setString(6, date);

            ps.executeUpdate();
            System.out.println("Animal inserted successfully");

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // READ
    public static void viewAnimals() {
        try {
            Connection con = getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM animal");

            while(rs.next()) {
                System.out.println(
                    rs.getInt("animal_id")+"  "+
                    rs.getString("name")+"  "+
                    rs.getString("species")+"  "+
                    rs.getString("breed")+"  "+
                    rs.getString("gender")+"  "+
                    rs.getInt("age")+"  "+
                    rs.getDate("arrival_date")
                );
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // UPDATE
    public static void updateAnimalAge(int id, int newAge) {
        try {
            Connection con = getConnection();
            String sql = "UPDATE animal SET age=? WHERE animal_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, newAge);
            ps.setInt(2, id);

            ps.executeUpdate();
            System.out.println("Animal updated successfully");

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // DELETE
    public static void deleteAnimal(int id) {
        try {
            Connection con = getConnection();
            String sql = "DELETE FROM animal WHERE animal_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);
            ps.executeUpdate();

            System.out.println("Animal deleted successfully");

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
   
}
