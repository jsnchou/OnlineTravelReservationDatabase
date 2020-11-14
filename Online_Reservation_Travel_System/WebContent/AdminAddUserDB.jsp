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

<title>Administrator: User Creation Confirmation</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

String username = request.getParameter("Username");
//check if duplicate

ps = con.prepareStatement("SELECT Username FROM OnlineResTravelSystem.User WHERE Username = ?");
ps.setString(1,username);
ResultSet M = ps.executeQuery();
if(M.next() == false) {
	//Create a SQL statement to find the current max user ID
	Statement stmt = con.createStatement();
	
	//store the result of the query in the ResultSet
	ResultSet S = stmt.executeQuery("SELECT MAX(User_ID) as max FROM OnlineResTravelSystem.User");
	
	//the index of the ResultSet starts at a NULL value, need to go to the next value in in order to get to the first query
	S.next();
	int maxID = S.getInt("max");
	
	//this new maxID number will be the ID of the new Customer added
	maxID++;
	S.close();
	stmt.close();
	
	String password = request.getParameter("Password");
	String address = request.getParameter("Address");
	String firstname = request.getParameter("First Name");
	String lastname = request.getParameter("Last Name");
	String phonenumber = request.getParameter("Phone Number");
	int userType = 1;
	if(request.getParameter("userType").equals("Customer Representative")) {
		userType = 2;
	}
	
	// insert the information of the new user in the User Table in the DB
	PreparedStatement psInsert = con.prepareStatement("INSERT INTO OnlineResTravelSystem.User VALUES (" + maxID + ",?,?,?,?,?,?,?)");
	psInsert.setString(1,username);
	psInsert.setString(2,password);
	psInsert.setString(3,address);
	psInsert.setString(4,firstname);
	psInsert.setString(5,lastname);
	psInsert.setString(6,phonenumber);
	psInsert.setInt(7,userType);
	try {
		psInsert.executeUpdate(); // the INSERT function in SQL needs to be run using the executeUpdate()
		out.println("User creation succeeded.");
		psInsert.close();
	}
	catch(SQLException e) {
		out.println("There was an error adding the user to the database. Please make sure your data is valid.");
	}
	
}
else {
	//stuff if there's a duplicate
	out.println("That username already exists.");
}
con.close();
%>

<form action = "AdminAddUserInfo.jsp">
<input type = "submit" value = "Add another user">
</form>

<form action = "AdminDashboard.jsp">
<input type = "submit" value = "Go back to administrator dashboard">
</form>

</body>
</html>