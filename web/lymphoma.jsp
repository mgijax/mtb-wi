<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Lymphoma Pathology Report" help="#">

	<jsp:body>	
		<section class="container">

			<p><a href="${applicationScope.urlBase}/html/Lymphoma.html">Download in HTML format</a></p>
			<p><a href="${applicationScope.urlBase}/html/Lymphoma.xlsx">Download in Microsoft<sup>&reg;</sup> Excel format</a></p>

		</section>
	</jsp:body>
	
</jax:mmhcpage>
