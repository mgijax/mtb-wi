<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 

<!doctype html>
<html>
<head>
<c:set var="pageTitle" scope="request" value="Processing. Please Wait..."/>

<!-- The following two lines are required, they instruct the browser to not cache the wait page. -->
<!-- This way we can better guarantee that when the user hits the 'Back' button, they don't get the wait page instead of the form. -->
<META http-equiv="CACHE-CONTROL" content="NO-CACHE">	<!-- For HTTP 1.1 -->
<META http-equiv="PRAGMA" content="NO-CACHE">				 <!-- For HTTP 1.0 -->
<META http-equiv="refresh" content="0; URL=${url}">

<c:import url="../../meta.jsp"/>

</head>

<body>
	<c:import url="../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../toolBar.jsp" /></nav>
<section class="main">


<header>
	<h1>${pageTitle}</h1>
	<a class="help" href=""></a>
</header>

		<h4>Generating Tumor Frequency Grid</h4>
		<img src="${applicationScope.urlImageDir}/loading.gif"/>


</section>
</div>
</body>
</html>
 
