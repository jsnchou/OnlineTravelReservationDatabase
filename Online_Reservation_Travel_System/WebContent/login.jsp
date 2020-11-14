<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/> <!--  now we will be able to use CSS in our code -->
<meta charset="ISO-8859-1">
<style> 
h1 {
  color: #0074D9;
  font-family: geometric sans-serif;
  font-size: 400%;
  text-align: center;
}
h2 {
  color: #0074D9;
  font-family: geometric sans-serif;
  text-align: center;
}
b  {
  color: #0074D9;
  font-family: geometric sans-serif;
  font-size: 150%;
  text-align: center;
}
table {
    margin: 0 auto;
}
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
td {
  background-color: transparent;
}
input {
background-color: transparent;
}
div {
text-align:right; 
}

</style>
<title>Satoshi Aviation Booking Services Login Page</title> <!-- This is the title of the webpage in the URL section -->
</head>


<body style = "text-align: center">

<div class="header">
<h1> Satoshi Aviation Booking Services </h1>
<h2> <i>Airline Booking Made Easier</i></h2>

<form method="post" action="AboutPage.jsp">
<div> <input id = "about" type="submit" value="ABOUT">  </div>
</form>

</div>
<hr />
<!-- Here we have the user sign in to their account -->
<b>Please Sign In:</b>
	<form method="post" action="userLogin.jsp">
	<table border = "1" style = "width:100px">
	<tr>    
	<td>Username</td><td><input type="text" name="Username" required="required"></td>
	</tr>
	<tr>
	<td>Password</td><td><input type="password" name="Password" required="required"></td>
	</tr>
	</table>
	<input type="submit" value="LOG IN!">
	</form>
	
<!-- Here we have a button that can help a new user go register for a new account -->
	<form method="post" action="registerInfo.jsp">
	<input type="submit" value="NEW USER?">
	</form>


</body>
</html>