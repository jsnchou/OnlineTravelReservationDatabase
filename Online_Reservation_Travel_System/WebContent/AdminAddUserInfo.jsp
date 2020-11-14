<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/> <!--  now we will be able to use CSS in our code -->
<meta charset="UTF-8">
<title>Administrator: Create User</title>

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

	<!--  Here we can ask the user to create an account -->
	
	<br>
	<form method="post" action="AdminAddUserDB.jsp">
	<input type="radio" name="userType" value="Customer" checked>Customer<br>
	<input type="radio" name="userType" value = "Customer Representative">Customer Representative<br>
		<table border="1" style = "width:400px">
			<tr>
				<td>Username</td>
				<td><input type="text" name="Username" required="required"></td>
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="password" name="Password" required="required"></td>
			</tr>
			<tr>
				<td>Address</td>
				<td><input type="text" name="Address" required="required"></td>
			</tr>
			<tr>
				<td>First Name</td>
				<td><input type="text" name="First Name" required="required"></td>
			</tr>
			<tr>
				<td>Last Name</td>
				<td><input type="text" name="Last Name" required="required"></td>
			</tr>
			<tr>
				<td>Phone Number</td>
				<td><input type="text" name="Phone Number" required="required"></td>
			</tr>
		</table>
		<br>
		<input type="submit" value="Create User">
	</form>
	<br>
	<form method="post" action="AdminDashboard.jsp">
		<input type="submit" value="CANCEL">
	</form>
	<br>
	<br>
</body>
</html>