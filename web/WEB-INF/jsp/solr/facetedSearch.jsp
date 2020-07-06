<%@ page language="java" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Advanced Search" help="#">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/facet.css"/>		
		<script>
			const contextPath = '${pageContext.request.contextPath}';
		</script>
		<script type="text/javascript" src="/_res/js/jquery-ui-sortable.min.js"></script>	
		<script type="text/javascript" src="./live/www/js/facet.js"></script>
	</jsp:attribute>
	<jsp:body>
		<div id="facet-ui">
			<div id="facet-controls">
				<div><a id="collapse-all" href="#"><i class="fa fa-minus"></i>Collapse All</a></div>
				<div><a id="clear-all" href="#"><i class="fa fa-times"></i>Clear All</a></div>
			</div>				
			<div id="facets"></div>
		</div>
		<div id="facet-results">
			<table>
				<caption>
					<div id="result-count">
						<a id="result-prev" href="#"><i class="fa fa-arrow-left"></i></a>
						Displaying <span id="result-first"></span> to <span id="result-last"></span> of <span id="result-total"></span>
						<a id="result-next" href="#"><i class="fa fa-arrow-right"></i></a></p>
					</div>
				</caption>
				<thead>
					<!--<tr>
						<th colspan="4">Tumor Model</th>
						<th colspan="4" class="fqc"></th>
						<th colspan="2"></th>
					</tr>-->
					<tr>
						<th data-sort="yes">Model Name</th>
						<th data-sort="yes">Organ Affected</th>
						<th>Tumor Inducing Agent(s)</th>
						<th data-sort="yes">Strain</th>
						<th data-sort="yes" class="fqc">Frequency Range</th>
<!--
						<th data-sort="yes" class="fqc">Female</th>
						<th data-sort="yes" class="fqc">Male</th>
						<th data-sort="yes" class="fqc">Mixed</th>
						<th data-sort="yes" class="fqc">Unknown</th>
-->
						<th>Additional Information</th>
						<th>Model Details</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>			
	</jsp:body>				
</jax:mmhcpage>

