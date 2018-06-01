<%@ tag description="Tool page template" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ attribute name="defaultTitle" required="true" %>
<%@ attribute name="defaultKeywords" required="true" %>
<%@ attribute name="defaultDescription" required="true" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="keywords" required="false" %>
<%@ attribute name="description" required="false" %>
<%@ attribute name="defaultHead" fragment="true" %>
<%@ attribute name="header" fragment="true" %>
<%@ attribute name="defaultSubnav" fragment="true" %>
<%@ attribute name="footer" fragment="true" %>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<c:choose>
	<c:when test="${empty keywords}">
	<meta name="keywords" content="${defaultKeywords}">
	</c:when>
	<c:otherwise>
	<meta name="keywords" content="${keywords}">
	</c:otherwise>	 
	</c:choose>				
	<c:choose>
	<c:when test="${empty description}">
	<meta name="description" content="${defaultDescription}">
	</c:when>
	<c:otherwise>
	<meta name="description" content="${description}">
	</c:otherwise>	 
	</c:choose>				
	<c:choose>
	<c:when test="${empty title}">
	<title><c:out value="${defaultTitle}" escapeXml="false"/></title>
	</c:when>
	<c:otherwise>
	<title><c:out value="${title}" escapeXml="false"/></title>
	</c:otherwise>	 
	</c:choose>		   
	<jsp:invoke fragment="defaultHead" />
</head>

<body>
	<header>
		<nav>
			<jsp:invoke fragment="header" />
		</nav>
	</header>
	<section>
		<header>
			<h1>${title}</h1>
			<jsp:invoke fragment="defaultSubnav" />
		</header>
		<jsp:doBody/>
	</section>
	<footer>
		<div>
			<a href="https://www.jax.org"><img src="/_res/img/logo-mono.png" alt="The Jackson Laboratory"></a>
			<jsp:invoke fragment="footer" />
		</div>
	</footer>
	
</body>

</html>
