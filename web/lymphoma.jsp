<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Lymphoma Pathology Report">

	<jsp:body>	
		<section class="container content">

			<p>Identification of different types of lymphomas and leukemia’s is a complex task involving assessment of pathology, histology, and immunology. Different markers are expressed at different levels in different tumors and help define a tumor type. The MMHCdb Lymphoma pathology page contains details about markers used to characterize lymphomas/leukemia’s in mouse models. The examples are linked by Case # to whole slide images that illustrate staining patterns and levels of a specific markers for a particular tumor type. The information in this report was submitted by Dr. Jerrold Ward from a 2001 NIH study set.</p>

			<p><a href="${applicationScope.urlBase}/html/Lymphoma.html">Download in HTML format</a></p>
			<p><a href="${applicationScope.urlBase}/html/Lymphoma.xlsx">Download in Microsoft<sup>&reg;</sup> Excel format</a></p>

		</section>
	</jsp:body>
	
</jax:mmhcpage>
