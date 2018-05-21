<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %> 
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %> 

<!doctype html>
<html>
<head>
	<c:set var="pageTitle" scope="request" value="Processing. Please Wait..."/>

<!-- The following two lines are required, they instruct the browser to not cache the wait page. -->
<!-- This way we can better guarantee that when the user hits the 'Back' button, they don't get the wait page instead of the form. -->
<META http-equiv="CACHE-CONTROL" content="NO-CACHE">	<!-- For HTTP 1.1 -->
<META http-equiv="PRAGMA" content="NO-CACHE">				 <!-- For HTTP 1.0 -->
<META http-equiv="refresh" content="0; URL=<bean:write name="action_path_key" property="actionPath"/>">
	<c:import url="meta.jsp"/>

</head>

<body>
	<c:import url="body.jsp" />

<div class="wrap">
<nav><c:import url="toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>${pageTitle}</h1>
	<a class="help" href=""></a>
</header>

Please wait....

</section>
</div>
</body>
</html>
 
