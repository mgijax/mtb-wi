<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
	<c:set var="pageTitle" scope="request" value="Lymphoma Pathology"/>
	<c:import url="meta.jsp" />
</head>

<body class="alt">

<div class="wrap">
<nav><c:import url="toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>${pageTitle}</h1>
	<a class="help" href="userHelp.jsp"></a>
</header>

Click <a href="${applicationScope.urlBase}/html/Lymphoma.html">here</a> for Lymphoma Pathology in HTML format.

<!-- \n -->

<!-- \n -->

Click <a href="${applicationScope.urlBase}/html/Lymphoma.xlsx">here</a> to download in Microsoft<sup>&reg;</sup> Excel format.

</section>
</div>
</body>
</html>
 
