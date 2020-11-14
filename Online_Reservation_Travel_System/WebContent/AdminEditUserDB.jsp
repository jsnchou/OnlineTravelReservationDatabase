<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/> <!--  now we will be able to use CSS in our code -->
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<style>
body {
  	background-image: url("CloudImage.jpeg");
  	background-repeat: no-repeat;
  	background-size: cover;
  	text-align: center;
  	background-position: fixed;
  	background-top:0;
  	background-left:0;
  	background-min-width: 100%;
  	background-min-height: 100%;
}

h1 {
	color: #0074D9;
  	font-family: geometric sans-serif;
  	font-size: 200%;
  	text-align: center;
}

p{
	font-size: 200%;
}
input{
	background-color: transparent;
	font-family: geometric sans-serif;
	font-size: 75%;
}

</style>

<title>Administrator: User Edit Confirmation</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

int id = Integer.parseInt((String)session.getAttribute("userIDToEdit"));





//getting edited values from previous page
String username = request.getParameter("Username");
String password = request.getParameter("Password");
String address = request.getParameter("Address");
String firstname = request.getParameter("First Name");
String lastname = request.getParameter("Last Name");
String phonenumber = request.getParameter("Phone Number");

// edit the information of the user in the User Table in the DB
PreparedStatement psInsert = con.prepareStatement("UPDATE OnlineResTravelSystem.User SET Username = ?,Password = ?,Address = ?,First_Name = ?,Last_Name = ?,Phone_Number = ? WHERE USER_ID = ?");
psInsert.setString(1,username);
psInsert.setString(2,password);
psInsert.setString(3,address);
psInsert.setString(4,firstname);
psInsert.setString(5,lastname);
psInsert.setString(6,phonenumber);
psInsert.setInt(7,id);
try {
	psInsert.executeUpdate(); // the INSERT function in SQL needs to be run using the executeUpdate()
	out.println("User edit succeeded.");
	psInsert.close();
}
catch(SQLException e) {
	out.println("There was an error editing the user in the database. Please make sure your data is valid.");
}

con.close();
%>

<form action = "AdminEditUserSelection.jsp">
<input type = "submit" value = "Edit another user">
</form>

<form action = "AdminDashboard.jsp">
<input type = "submit" value = "Go back to administrator dashboard">
</form>

</body>
</html>