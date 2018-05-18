<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>

<head>

<c:import url="meta.jsp">
		<c:param name="pageTitle" value="Mouse Tumor Biology Database User Help Reference"/>
</c:import>

</head>
<body class="alt">

<div class="wrap">
<nav><c:import url="toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>Mouse Tumor Biology Database User Help Reference</h1>
	<a class="help" href="userHelp.jsp"></a>
</header>
<table class="results">

</table>

<!-- ////  Start Help  //// -->

<c:import url="/live/www/html/userHelp.html"/>

<!-- ////  End Help  //// -->


</section>
</div>
</body>
</html>
 

