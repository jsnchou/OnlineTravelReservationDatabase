<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
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
<title>Add Airport</title>
</head>
<body>

<form method = "post" action = "AddAirportDB.jsp">

<h2>Enter the airport information below:</h2>

Airport ID:
<input type = "text" name = "airportID" required="required">

<br> <br>
Airport Name:
<input type = "text" name = "airportName" required="required">

<br> <br>
Country:
<input type = "text" name = "airportCountry" required="required">

<br> <br> <br>
<input type = "submit" value = "Add new airport!">

</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

</body>
</html>