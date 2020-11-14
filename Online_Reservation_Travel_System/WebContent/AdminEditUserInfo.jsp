<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/> <!--  now we will be able to use CSS in our code -->
<meta charset="UTF-8">
<title>Admin: Edit User</title>

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
	input {
	background-color: transparent;
	font-family: geometric sans-serif;
	font-size: 80%;
	}
	table {
    margin: 0 auto;
    
	}
	td {
  	background-color: transparent;
	} 
	input[type='text']{
	background-color: transparent;
	width: 100%;
	}
	input[type='password']{
	background-color: transparent;
	width: 100%;
	}
	b  {
  	color: #0074D9;
  	font-family: geometric sans-serif;
  	font-size: 200%;
  	text-align: center;
	}
	</style>
</head>
<body>

<%
session.setAttribute("userIDToEdit",request.getParameter("User"));

ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

//obtain a result set of the current user id
ps = con.prepareStatement("SELECT * FROM OnlineResTravelSystem.User WHERE User_ID = ?");
ps.setInt(1,Integer.parseInt(request.getParameter("User")));
ResultSet currentInfo = ps.executeQuery();
currentInfo.next();
out.println("<h2>You are currently editing: " + currentInfo.getString("First_Name") + " " + currentInfo.getString("Last_Name") + " - (Username: " + currentInfo.getString("Username")+")</h2>");

%>

Enter new information for the user below:

	<!--  Here we can ask the user to create an account -->
	
	<br>
	<form method="post" action="AdminEditUserDB.jsp">
			<table border="1" style = "width:400px">
			<tr>
				<td>Username</td>
				<td><input type="text" name="Username" required="required" value="<%out.print(currentInfo.getString("Username")); %>"></td>
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="password" name="Password" required="required"></td>
			</tr>
			<tr>
				<td>Address</td>
				<td><input type="text" name="Address" required="required" value="<%out.print(currentInfo.getString("Address")); %>"></td>
			</tr>
			<tr>
				<td>First Name</td>
				<td><input type="text" name="First Name" required="required" value="<%out.print(currentInfo.getString("First_Name")); %>"></td>
			</tr>
			<tr>
				<td>Last Name</td>
				<td><input type="text" name="Last Name" required="required" value="<%out.print(currentInfo.getString("Last_Name")); %>"></td>
			</tr>
			<tr>
				<td>Phone Number</td>
				<td><input type="text" name="Phone Number" required="required" value="<%out.print(currentInfo.getString("Phone_Number")); %>"></td>
			</tr>
		</table>
		<br>
		<input type="submit" value="Edit User">
	</form>
	<br>
	<form method="post" action="AdminDashboard.jsp">
		<input type="submit" value="CANCEL">
	</form>
	<br>
	<br>
</body>
</html>
<%
currentInfo.close();
ps.close();
con.close();
%>