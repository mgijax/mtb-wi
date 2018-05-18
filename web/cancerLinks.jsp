<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>

<head>
<c:import url="meta.jsp" />
</head>
<body class="alt">
<div class="wrap">
<nav><c:import url="toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>Web-Based Resources for Basic Cancer Research</h1>
	<a class="help" href="userHelp.jsp"></a>
</header>


<table class="results">

</table>

<!-- ////  Start Links  //// -->

<c:import url="/live/www/html/cancerLinks.html"/>

<!-- ////  End Links  //// -->


</section>
</div>
</body>
</html>
 

