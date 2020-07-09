<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Antibody Staining Report" help="#">

	<jsp:body>	
		<section class="container content">
			
			<p>Immunological staining is a powerful tool in studying biology. Antibodies used to study these stainings have different species specificity and optimal conditions. Knowing these details allows a researcher to choose the best antibody for their purposes. The MMHCdb Immunohistochemistry page contains a detailed list of antibodies that have been tested in mice by researchers. The page contains antibody details and links to provider and antibody pages, conditions the antibody has been tested under and results of testing. Negative results are included.</p>

			<p><a href="${applicationScope.urlBase}/html/antibodies.html">Download in HTML format</a></p>
			<p><a href="${applicationScope.urlBase}/html/antibodies.xls">Download in Microsoft<sup>&reg;</sup> Excel format</a></p>

		</section>
	</jsp:body>
	
</jax:mmhcpage>
