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

<title>Administrator: Select an Airport to View its Flights</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

%>
Select an airport to view all its flights:
<form method = "post" action = "AdminListFlightsView.jsp">

<select name = "Airport">

<%
select = "SELECT 3_letter_ID,AirportName FROM OnlineResTravelSystem.Airports";
ps = con.prepareStatement(select);
result = ps.executeQuery();
while(result.next()) {
	String airportName = result.getString("AirportName");
	String id = result.getString("3_letter_ID");
	out.print("<option value = \"" + id + "\">" + id + " - " + airportName + "</option>"); 
	
}
result.close();
ps.close();
con.close();
%>

</select>

<input type = "submit" value = "View flights">
</form>

<form method="post" action="AdminDashboard.jsp">
	<input type="submit" value="CANCEL">
</form>

</body>
</html>