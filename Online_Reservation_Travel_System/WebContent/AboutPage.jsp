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
  font-size: 300%;
  text-align: left;
}
hr { 
border-color: black;
}
p{
text-indent: 50px;
font-size: 150%;
font-family: geometric sans-serif;
}
form {
text-align: right;
}
input {
background-color: transparent;
font-family: geometric sans-serif;
}


</style>
<title>About Page</title>
</head>
<body>
	
	<h1> About Satoshi Aviation Booking Services </h1>
	<hr>
	<p> Satoshi Aviation Booking Services was started by four members at Rutgers University taking CS336 (Principles of Information and Data Management).
		The four members include: Chris Zachariah, Brain Cheng, Jason Chou and Jonathan Tsai. This website is simply a mock version of other popular Online
		Travel Reservation sites like Expedia, Skyscanner and Kayak. 
	</p>
	<p> Customers, Customer-Representatives and Site Administrators can log in and have access to many functions like buying flight tickets and editing 
		user info and such. All the data is stored in a database hosted by AWS RDS and accessed through MySQL Workbench. This website is hosted by AWS 
		EC2 and uses Tomcat 7.0 to manage the various connected JSP pages. 
	</p>
	<p>	Any personal info (if given) is not saved and used for any other purpose, other than offering  a close to real-life
		representation of purchasing flight tickets online through our services. We hope that you find the site easy to navigate. 
	</p>
	<p>	Please feel free to email chris.zachariah@rutgers.edu if you have any questions or concerns. Happy Travels!
	</p>
	 <form method = "post" action = "login.jsp"> <input type = "submit" value = "BACK TO LOG IN PAGE"></form>
	
</body>
</html>