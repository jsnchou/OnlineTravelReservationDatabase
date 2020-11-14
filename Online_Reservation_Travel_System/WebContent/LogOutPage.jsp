<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/> <!--  now we will be able to use CSS in our code -->
<meta charset="UTF-8">

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
b {
	
}

</style>


<title>Log Out Page</title>
</head>
<body>

<%
	// end the current user's session
	session.invalidate();

	out.println("<b>You are now logged out.</b>");
	out.println("<br></br>");
	out.println("<br> <form method = \"post\" action = \"login.jsp\"> <input type = \"submit\" value = \"LOG IN PAGE\"></form> <br>");
%>




</body>
</html>