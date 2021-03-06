<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Processing. Please Wait...">
	<jsp:attribute name="head">
	<!-- The following two lines are required, they instruct the browser to not cache the wait page. -->
	<!-- This way we can better guarantee that when the user hits the 'Back' button, they don't get the wait page instead of the form. -->
	<meta http-equiv="CACHE-CONTROL" content="NO-CACHE">	<!-- For HTTP 1.1 -->
	<meta http-equiv="PRAGMA" content="NO-CACHE">				 <!-- For HTTP 1.0 -->
	<meta http-equiv="refresh" content="0; URL=${url}">
	</jsp:attribute>
	<jsp:body>
	<h4>Generating Tumor Frequency Grid</h4>
	<img src="${applicationScope.urlImageDir}/loading.gif"/>	
	</jsp:body>
</jax:mmhcpage>
