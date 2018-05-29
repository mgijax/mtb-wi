<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Gene Expression" help="pdxdetails">
	<jsp:attribute name="head">
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<script type="text/javascript">
	google.load("visualization", "1", {packages:["corechart"]});
	google.setOnLoadCallback(drawBarCharts); 
	function drawBarCharts(){
		rankData = google.visualization.arrayToDataTable([${rank}]);
		rankBarChart = new google.visualization.BarChart(document.getElementById('bar_chart_div3'));
		rank();		
	}
	function rankSelectHandler(e){
		var selection = rankBarChart.getSelection();
		var item = selection[0];
		if (item.row != null){
			window.open("pdxDetails.do?modelID="+rankData.getValue(item.row,2),"rankData.getValue(item.row,2)");
		}	
	}
	function rank() { 
		if(rankData.getNumberOfRows()>0){
			rankData.sort(1);
			var rankView = new google.visualization.DataView(rankData);
			if(rankData.getNumberOfColumns()==3){
				rankView.setColumns([0, 1]);
			}
			if(rankData.getNumberOfColumns() == 4){
				rankView.setColumns([0, 1, 3]);
			}
			var options = {
				fontSize:10,
				vAxis: {title: 'Model : Sample', titleTextStyle: {color: 'red'}},
				legend: {position: 'none'},
				chartArea:{top:20, height:${chartSize}},
				bar:{groupWidth:10}
			};
			google.visualization.events.addListener(rankBarChart, 'select', rankSelectHandler);
			rankBarChart.draw(rankView, options);
		}
	}
</script>
</jsp:attribute>
<jsp:body>
<input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdx-request-button" onclick="window.location='pdxRequest.do'">
<table>
	<caption><h5 class="label">Search Summary</h5>
		<!-- \n -->
		<c:choose>
		<c:when test="${not empty modelID}">
		<h5 class="label">Model ID:</h5>${modelID}
		<!-- \n -->
		</c:when>
		</c:choose>
		<c:choose>
		<c:when test="${not empty primarySites}">
		<c:choose>
		<c:when test="${fn:length(primarySites)>1}">
		<h5 class="label">Primary Sites:</h5>
		</c:when>
		<c:otherwise>
		<h5 class="label">Primary Site:</h5>
		</c:otherwise>
		</c:choose>
		<c:forEach var="site" items="${primarySites}" varStatus="status">
		<c:choose>
		<c:when test="${status.last != true}">
		${site},
		</c:when>
		<c:otherwise>
		${site}
		</c:otherwise>
		</c:choose>
		</c:forEach>
		<!-- \n -->
		</c:when>
		<c:otherwise>
		<h5 class="label">Primary Sites:</h5> Any
		<!-- \n -->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty diagnoses}">
		<c:choose>
		<c:when test="${fn:length(diagnoses)>1}">
		<h5 class="label">Diagnoses:</h5>
		</c:when>
		<c:otherwise>
		<h5 class="label">Diagnosis:</h5>
		</c:otherwise>
		</c:choose>
		<c:forEach var="diagnosis" items="${diagnoses}" varStatus="status">
		<c:choose>
		<c:when test="${status.last != true}">
		${diagnosis},
		</c:when>
		<c:otherwise>
		${diagnosis}
		</c:otherwise>
		</c:choose>
		</c:forEach>
		<!-- \n -->
		</c:when>
		<c:otherwise>
		<h5 class="label">Diagnosis:</h5> Any
		<!-- \n -->
		</c:otherwise>
		</c:choose>
		<h5 class="label">Gene:</h5>${gene2}
		<!-- \n -->
		<c:choose>
		<c:when test="${not empty variant}">
		<h5 class="label">Variant:</h5>${variant}
		<!-- \n -->
		</c:when>
		</c:choose>
	</caption>
	<tr class="buttons">
		<c:choose>
		<c:when test="${not empty noResults}">
		<td colspan="2">
			<strong>${noResults}</strong>
		</td>
		</c:when>
		<c:otherwise>
		<td colspan="2">
			<!-- \n -->
			<strong>Rank based Z score expression of ${gene2}</strong>
			<!-- \n -->
			${message}
			<!-- \n -->
			Click on a rank bar to go to the model's details page.
			<!-- \n -->
			<div id="bar_chart_div3" style="height:${divSize}px"></div>
		</td>
		</c:otherwise>
		</c:choose>
	</tr>
</table>
</jsp:body>
</jax:mmhcpage>

