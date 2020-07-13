<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Antibody Staining Report">

	<jsp:body>	
		<section class="container content">
			
			<p>Antibodies used for immunohistochemistry (IHC) vary in species specificity and optimal assay conditions. The MMHCdb Immunohistochemistry page summarizes information for antibodies that have been tested on mouse tissues, including antibody providers, conditions used to test antibody staining, and results of the testing. Negative results are included.</p>

			<p>The data in this report were submitted by Dr. John Sundberg and Lesley Bechtel (The Jackson Laboratory), Dr. Peter Vogel (St. Jude), and Drs. Robert Coffey and Kelli Boyd (Vanderbilt).</p>

			<p><a href="${applicationScope.urlBase}/html/antibodies.html">Download in HTML format</a></p>
			<p><a href="${applicationScope.urlBase}/html/antibodies.xls">Download in Microsoft<sup>&reg;</sup> Excel format</a></p>

		</section>
	</jsp:body>
	
</jax:mmhcpage>
