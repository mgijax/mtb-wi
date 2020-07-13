<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Gene Expression">
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
		<section id="summary">
			<div class="container">
				<table>
					<tbody>						
						<tr>
							<td><h4>Model ID</h4></td>
							<td>${modelID}</td>
						</tr>		
						<tr>
							<td><h4>Primary Site</h4></td>
							<td>${primarySites}</td><!-- any -->
						</tr>	
						<tr>
							<td><h4>Diagnosis</h4></td>
							<td>${diagnoses}</td><!-- any -->
						</tr>	
						<tr>
							<td><h4>Gene</h4></td>
							<td>${gene2}</td>
						</tr>	
						<tr>
							<td><h4>Variant</h4></td>
							<td>"${variant}</td>
						</tr>	
					</tbody>
				</table>	
				<p><a href="pdxRequest.do">Request more information on the JAX PDX program</a></p>
			</div>
		</section>																					
		
		<section id="detail">
			<c:choose>
				<c:when test="${not empty noResults}">
					<h3>${noResults}</h3>
				</c:when>
				<c:otherwise>
					<h3>Rank based Z score expression of ${gene2}</h3>
					<p>${message}</p>
					<p>Click on a rank bar to go to the model's details page.</p>
					<div id="bar_chart_div3" style="height:${divSize}px"></div>
				</c:otherwise>
			</c:choose>
		</section>

	</jsp:body>
</jax:mmhcpage>
