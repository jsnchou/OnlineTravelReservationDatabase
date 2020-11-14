<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<meta charset="UTF-8">
<style> 

body {
  background-image: url("CloudImage.jpeg");
  background-repeat: no-repeat;
  background-size: cover;
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
  	text-align: right;
  	
}
h2 {
	color: #0074D9;
  	font-family: geometric sans-serif;
  	font-size: 200%;
  	text-align: left;
  	
}
p {
	font-size: 200%;
	text-align: left;
}
input {
	background-color: transparent;
	font-family: geometric sans-serif;
	font-size: 90%;
	border-style: solid;
  	border-width: 1px;
  	border-color: black;
}
div {
	text-align:right; 
}
hr {
border-color: black;
}
option {
font-family: geometric sans-serif;
font-size: 150%;
}

</style>
<title>Customer Representative Page</title>
</head>
<body>
<%

ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;
%>

<% String currentUserName = session.getAttribute("CurrentUser").toString();
out.print("<h1>Dashboard for Customer Representative: " + currentUserName + "</h1> ");
%>
<div> <form method = "post" action = "LogOutPage.jsp"> <input type = "submit" value = "LOG OUT"></form> </div>
<h2> Make or Edit flight reservations for a user: </h2>

<form action = "CustomerRepUserEdit.jsp">
<select name = "User">
<%
select = "SELECT First_Name,Last_Name,Username FROM OnlineResTravelSystem.User WHERE User_Type = 1";
ps = con.prepareStatement(select);
result = ps.executeQuery();

while(result.next()) {
	String UserName = result.getString("Username");
	String FirstName = result.getString("First_Name");
	String LastName = result.getString("Last_Name");
	out.print("<option value = \"" + UserName + "\">" + FirstName + " " + LastName + " (Username: " + UserName + ")" + "</option>");
}


result.close();
ps.close();

%>
</select>
<input type = "submit" value = "Go">
</form>

<h2> Add, Edit, or Delete information for: </h2>
<form method = post action = "CustomerRepModifyAircrafts.jsp">
<input type = "submit" value = "aircrafts">
</form>

<form method = post action = "CustomerRepModifyAirports.jsp">
<input type = "submit" value = "airports">
</form>

<form method = post action = "CustomerRepModifyFlights.jsp">
<input type = "submit" value = "flights">
</form>

<h2> Retrieve a list of all passengers who are on the waiting list for a particular flight: </h2>

<form action = "CustomerRepUserEdit.jsp">
<select name = "User">
<%
select = "SELECT flight_number,date_of_flight,departure_time,arrival_time,departure_airport_ID,arrival_airport_ID FROM OnlineResTravelSystem.Flight";
ps = con.prepareStatement(select);
result = ps.executeQuery();
while(result.next()) {
	out.print("<option value = \"" + result.getString("flight_number") + "\">" + "Flight  Number: " + result.getString("flight_number") + " Date of Flight: " 
+ result.getString("date_of_flight") + " Departure Time: " + result.getString("departure_time") + " Arrival Time: " + result.getString("arrival_time") 
+ " Departure Airport: " + result.getString("departure_airport_ID") + " Arrival Airport: " + result.getString("arrival_airport_ID") + "</option>");
}
result.close();
ps.close();

%>
</select>
<input type = "submit" value = "Go">
</form>

<%
con.close();
%>

</body>
</html>