<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>
		<head>
		<c:import url="../../../meta.jsp">
				<c:param name="pageTitle" value="No matching PDX models"/>
		</c:import>

<body>
			<c:import url="../../../body.jsp" />

		<div class="wrap">
<nav><c:import url="../../../pdxToolBar.jsp" /></nav>
<section class="main">
<header>
	<h1>There is no available PDX model with ID <em>${modelID}</em></h1>
	<a class="help" href="userHelp.jsp#pdxsearch"></a>	
</header>
<input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdx-request-button" onclick="window.location='pdxRequest.do'">
	
</section>
</div>									

</body>
</html> 
