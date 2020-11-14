<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*, java.text.NumberFormat"%>
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

<title></title>
</head>
<body>

<form method="post" action="AdminDashboard.jsp">
	<input type="submit" value="Go back to administrator dashboard">
</form>

<h2>The highest revenue customer is:</h2>

<%
ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();


String selectTickets = ""; 
String selectReservations = "";
PreparedStatement ps;
ResultSet result;
PreparedStatement psTickets = con.prepareStatement(selectTickets);
PreparedStatement psReservations = con.prepareStatement(selectReservations);
//we give select and ps empty values for now so that their are no compile errors

//left outer join
ps = con.prepareStatement("SELECT * FROM ((SELECT User_ID,SUM(total_fare) AS ticketRevenue FROM OnlineResTravelSystem.User NATURAL JOIN OnlineResTravelSystem.Flight_Ticket GROUP BY User_ID ORDER BY SUM(total_fare) DESC) AS fl) LEFT OUTER JOIN ((SELECT User_ID,COUNT(User_ID)*25 AS reservationRevenue FROM OnlineResTravelSystem.User NATURAL JOIN OnlineResTravelSystem.Reservation GROUP BY User_ID ORDER BY COUNT(User_ID) DESC) AS rev ) ON fl.User_ID = rev.User_ID");
result = ps.executeQuery();

//go through table and save the user id of the person with the highest combined revenue
int highestRevenueCustomer = -1;
Double highestRevenue = -1.0;
while(result.next()) {
	Double totalRevenue = result.getDouble("ticketRevenue") + result.getDouble("reservationRevenue");
	if(totalRevenue > highestRevenue) {
		highestRevenueCustomer = result.getInt("User_ID");
		highestRevenue = totalRevenue;
	}
}
result.close();
ps.close();

//right outer join
ps = con.prepareStatement("SELECT * FROM ((SELECT User_ID,SUM(total_fare) AS ticketRevenue FROM OnlineResTravelSystem.User NATURAL JOIN OnlineResTravelSystem.Flight_Ticket GROUP BY User_ID ORDER BY SUM(total_fare) DESC) AS fl) RIGHT OUTER JOIN ((SELECT User_ID,COUNT(User_ID)*25 AS reservationRevenue FROM OnlineResTravelSystem.User NATURAL JOIN OnlineResTravelSystem.Reservation GROUP BY User_ID ORDER BY COUNT(User_ID) DESC) AS rev ) ON fl.User_ID = rev.User_ID");
result = ps.executeQuery();

//go through table and save the user id of the person with the highest combined revenue

while(result.next()) {
	Double totalRevenue = result.getDouble("ticketRevenue") + result.getDouble("reservationRevenue");
	if(totalRevenue > highestRevenue) {
		highestRevenueCustomer = result.getInt("User_ID");
		highestRevenue = totalRevenue;
	}
}
result.close();
ps.close();

ps = con.prepareStatement("SELECT * FROM OnlineResTravelSystem.User WHERE User_ID = ?");
ps.setInt(1,highestRevenueCustomer);
ResultSet currentInfo = ps.executeQuery();
currentInfo.next();
out.println(currentInfo.getString("First_Name") + " " + currentInfo.getString("Last_Name") + " - " + currentInfo.getString("Username"));
currentInfo.close();
ps.close();
%>
<br>
Total revenue:



<%
NumberFormat formatter = NumberFormat.getCurrencyInstance();
out.println(formatter.format(highestRevenue));
con.close();
%>
</body>
</html>