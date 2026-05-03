package com.inception.skillsewa.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/skillsewa";
    private static final String USER = "root";
    private static final String PASSWORD = "";

//    public static void main(String[] args) throws SQLException{
//        try{
//            Connection conn = getConnection();
//            if (conn != null){
//                System.out.println("Connection to database success.");
//            }
//            else {
//                System.out.println("Connection to database fail.");
//            }
//        } catch (SQLException e){
//            throw new SQLException("JDBC Driver Problem!!");
//        }
//    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver Problem!!");
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

}
