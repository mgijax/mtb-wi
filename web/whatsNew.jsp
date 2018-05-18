<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>

<html>
<head>
<c:import url="meta.jsp" />
<title>What's New at MTB?</title>
</head>
<body class="alt">

<div class="wrap">
<nav><c:import url="toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>What's New in MTB?</h1>
	<a class="help" href="userHelp.jsp"></a>
</header>
<table class="results">

</table>

<c:import url="/live/www/html/whatsNew.html"/>


</section>
</div>
</body>
</html>
 
