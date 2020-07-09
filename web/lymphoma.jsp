<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Lymphoma Pathology Report" help="#">

	<jsp:body>	
		<section class="container content">
			
			<p>Identification of different types of lymphomas and leukemia’s is a complex task involving pathological examination and histological and immunological staining. Different markers are expressed at different levels in different tumors and help define a tumor type. The MMHCdb Lymphoma pathology page contains a list of different lymphomas/leukemia’s stained for different markers, the tissue and staining level, background strain and Case #s. The Case # is a link to a web page containing detailed information on staining pattern and level of a specific marker in that tumor, pathological notes on characteristic of that tumor that help identify specific type, a link to a whole-slide scanned image and probe information. This information was submitted by Jerrold Ward and is from a 2001 NIH study set.</p>

			<p><a href="${applicationScope.urlBase}/html/Lymphoma.html">Download in HTML format</a></p>
			<p><a href="${applicationScope.urlBase}/html/Lymphoma.xlsx">Download in Microsoft<sup>&reg;</sup> Excel format</a></p>

		</section>
	</jsp:body>
	
</jax:mmhcpage>
