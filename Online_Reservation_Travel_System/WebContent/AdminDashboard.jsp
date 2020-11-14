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

<title>Administrator: Dashboard</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

String currentUserName;
try {
	currentUserName = session.getAttribute("CurrentUser").toString();
}catch (Exception e) {
	currentUserName = "no login";
}

out.print("<h1>Dashboard for Administrator: " + currentUserName + "</h1> ");
out.println("<div> <form method = \"post\" action = \"LogOutPage.jsp\"> <input type = \"submit\" value = \"LOG OUT\"></form> </div>");
%>

<h1>What would you like to do?</h1>

<h2>Add a user</h2>
<form method="post" action="AdminAddUserInfo.jsp">
<input type="submit" value="Add user">
</form>

<h2>Edit a user</h2>
<form method = "post" action = "AdminEditUserSelection.jsp">
<input type = "submit" value = "Edit user">
</form>

<h2>Delete a user</h2>
<form method = "post" action = "AdminDeleteUserSelection.jsp">
<input type = "submit" value = "Delete user">
</form>

<h2>Get reservations</h2>
<form method = "post" action = "AdminRes.jsp">
<input type = "submit" value = "Get reservations">
</form>

<h2>Get sales reports for a flight, airline, customer, or month</h2>
<form method = "post" action = "AdminSalesReportSelection.jsp">
<input type = "submit" value = "Get sales reports">
</form>

<h2>Get highest revenue customer</h2>
<form method = "post" action = "AdminHighestRevenueCustomer.jsp">
<input type = "submit" value = "Get highest revenue customer">
</form>

<h2>Get most active flights</h2>
<form method = "post" action = "AdminMostActiveFlights.jsp">
Get the top
<input type = "text" name = "numFlights" value = "5">flights
<input type = "submit" value = "Go">
</form>

<h2>List flights for an airport</h2>
<form method = "post" action = "AdminListFlightsSelection.jsp">
<input type = "submit" value = "List flights">
</form>

</body>
</html>