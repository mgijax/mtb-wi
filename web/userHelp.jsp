<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>

<head>

<c:set var="pageTitle" scope="request" value="Mouse Tumor Biology Database User Help Reference"/>
<c:import url="meta.jsp"/>

</head>
<body class="alt">

<div class="wrap">
<nav><c:import url="toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>${pageTitle}</h1>
	<a class="help" href="userHelp.jsp"></a>
</header>

<!-- ////  Start Help  //// -->

<c:import url="/live/www/html/userHelp.html"/>

<!-- ////  End Help  //// -->

</section>
</div>
</body>
</html>
 

