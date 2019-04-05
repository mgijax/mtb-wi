<%@ page language="java" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Faceted Search" help="#">
	<jsp:attribute name="head">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/live/www/css/faceted-search.css"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/live/www/js/faceted-search.js"></script>
	</jsp:attribute>
	<jsp:body>
	<form id="facets">
		<fieldset>
			<legend>Require in results</legend>
			<label><input type="checkbox" id="pathology-images" onClick="pathologyImagesCB()">Pathology Images</label>
			<label><input type="checkbox" id="cyto-images" onClick="cytoImagesCB()">Cytogenetic Images</label>
			<label><input type="checkbox" id="untreated" onClick="untreatedCB()">Spontaneous</label>
			<label><input type="checkbox" id="metastatic" onClick="metastaticCB()">Metastatic</label>
			<label><input type="checkbox" id="gene-expression" onClick="geneExpressionCB()">Gene Expression Data</label>
			<label><input type="checkbox" id="min-fc" onClick="minFCCB()">Freq. >= 80% C. size >= 20</label>
			<label><input type="checkbox" id="all-strains" onclick="mutantCheck('a',true)" checked >All Strains</label>
			<label><input type="checkbox" id="mutant-strains" onclick="mutantCheck('m',true)">Mutant Strains</label>
			<label><input type="checkbox" id="non-mutant-strains" onclick="mutantCheck('n',true)">Non-Mutant Strains</label>
			<label><input type="checkbox" id="as-csv" onClick="asCSVCB()">Results as CSV</label>
		</fieldset>
		<fieldset>
			<legend>Active Filters</legend>
			<div id="filters"></div>				
			<div id="facet-count"></div>
			<label for="organ-parent">Organ of Origin</label>
			<div class="facet-list" id="organ-parent"></div>
			<div onclick='moreFacets()' class="more-facets"></div>
			<label for="tc-parent">Tumor Classification</label>
			<div class="facet-list" id="tc-parent"></div>
			<div onclick='moreFacets()' class="more-facets"></div>
			<label for="agent-type">Agent Type</label>
			<div class="facet-list" id="agent-type"></div>
			<div onclick='moreFacets()' class="more-facets"></div>
			<label for="strain-type">Strain Type</label>
			<div class="facet-list" id="strain-type"></div>
			<div onclick='moreFacets()' class="more-facets"></div>
			<label for="mets-to">Metastasizes To</label>
			<div class="facet-list" id="mets-to"></div>
			<div onclick='moreFacets()' class="more-facets"></div>
			<label for="strain-marker">Germline Mutant Alleles</label>
			<div class="facet-list" id="strain-marker"></div>
			<div onclick='moreFacets()' class="more-facets"></div>
			<label for="human-tissue">Human Tissue Model</label>
			<div class="facet-list" id="human-tissue"></div>
			<div onclick='moreFacets()' class="more-facets"></div>		
		</fieldset>		
	</form>
	<div id="results"></div>
	</jsp:body>				
</jax:mmhcpage>

