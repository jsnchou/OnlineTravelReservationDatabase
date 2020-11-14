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

<title>Administrator: Get Reservations</title>
</head>
<body>

<%
	ApplicationDB db = new ApplicationDB();
	
	Connection con = db.getConnection();
	String select;
	PreparedStatement ps;
	ResultSet result;
%>

<h2>Get reservations for a flight:</h2>
<form method = "post" action = "AdminResView.jsp">
Flight Number:
<select name = "flightNumber">

<%
	ps = con.prepareStatement("SELECT flight_number FROM OnlineResTravelSystem.Flight ORDER BY flight_number ASC");
	
	result = ps.executeQuery();
	
	while(result.next()) {
		int flightNumber = result.getInt("flight_number");
		out.print("<option value = \"" + result.getString("flight_number") +  "\">" + flightNumber + "</option>");
	}
	
	result.close();
	ps.close();
%>

</select>

<input type = "submit" value = "Go">
</form>

<h2>Get reservations for a customer:</h2>
<form method = "post" action = "AdminResView.jsp">

<select name = "id">

<%
	
	ps = con.prepareStatement("SELECT First_Name, Last_Name, User_ID FROM OnlineResTravelSystem.User WHERE User_Type = 1");
	result = ps.executeQuery();
	
	while(result.next()) {
		String name = result.getString("First_Name") + " " + result.getString("Last_Name");
		int id = result.getInt("User_ID");
		out.print("<option value =\"" + result.getString("User_ID")+"\">" + name + "</option>");
	}
	result.close();
	ps.close();
	
%>

</select>

<input type = "submit" value = "Go">
</form>

<br>

<form method = "post" action = "AdminDashboard.jsp">
<input type = "submit" value = "Go back to administrator dashboard">
</form>

<% con.close(); %>

</body>
</html>