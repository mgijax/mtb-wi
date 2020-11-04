<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Gene Expression" help="userHelp.jsp#pdxexpression">
	<jsp:attribute name="head">
            <link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
		<script type="text/javascript">
			google.load("visualization", "1", {packages:["corechart"]});
			google.setOnLoadCallback(drawBarCharts); 
                        
                        var showDiagnosis = false;
                        
			function drawBarCharts(){
				rankData = google.visualization.arrayToDataTable([${rank}]);
				rankBarChart = new google.visualization.BarChart(document.getElementById('bar_chart_div3'));
				rank(showDiagnosis);		
			}
			function rankSelectHandler(e){
				var selection = rankBarChart.getSelection();
				var item = selection[0];
				if (item.row != null){
					window.open("pdxDetails.do?modelID="+rankData.getValue(item.row,3),"rankData.getValue(item.row,3)");
				}	
			}
                        
                        var options = {
                                        fontSize:10,
                                        vAxis: {title: 'Model : Sample', titleTextStyle: {color: 'red'}},
                                        legend: {position: 'none'},
                                        chartArea:{top:20, height:${chartSize}, left:400, width:'80%'},
                                        bar:{groupWidth:10}
					};
                        
			function rank(showDiagnosis) {
                                firstCol = 0;
                                sortCol = 2;
                                if(showDiagnosis){
                                    firstCol = 1;
                                    sortCol = 1;
                                }
				if(rankData.getNumberOfRows()>0){
					rankData.sort(sortCol);
					var rankView = new google.visualization.DataView(rankData);
					if(rankData.getNumberOfColumns()==4){
						rankView.setColumns([firstCol, 2]);
					}
					if(rankData.getNumberOfColumns() == 5){
						rankView.setColumns([firstCol, 2, 4]);
					}
					
					google.visualization.events.addListener(rankBarChart, 'select', rankSelectHandler);
					rankBarChart.draw(rankView, options);
				}
			}
                        
                        function toggleDisplay(){
                            showDiagnosis = !showDiagnosis;
                            rank(showDiagnosis);
                            if(showDiagnosis){
                                document.getElementById("toggleButton").value="Order by expression"
                            }else{
                                document.getElementById("toggleButton").value="Order by diagnosis"
                            }
                        }
                        
                        
		</script>
	</jsp:attribute>
	<jsp:body>
            <div class="container">
		<section id="summary">
			
                            
                            <jax:dl dt="Model ID" dd="${mouse.location}" />
                            <jax:dl dt="Primary Site" dts="Primary Sites" dds="${primarySites}" />
                            <jax:dl dt="Diagnosis" dts="Diagnoses" dds="${diagnoses}" />
                            <jax:dl dt="Gene" dd="${gene2}" />
                            <jax:dl dt="Variant" dd="${variant}" />
                            
                            
                          
				</section>	
			</div>
																						
		
		<section id="detail">
			<c:choose>
				<c:when test="${not empty noResults}">
					<h3>${noResults}</h3>
				</c:when>
				<c:otherwise>
                                    <html:form action="pdxSearchResults" method="POST">
                                    <section style="padding-left: 10px; font-size:12px;">
					<h3>Rank based Z score expression of ${gene2}</h3>
					<p>${message}</p>
					<p>Click on a rank bar to go to the model's details page.</p>
                                        <p><input type="button" onclick="toggleDisplay();" value="Order by diagnosis" id="toggleButton"/></p><br><br>
                                        <div id="bar_chart_div3" style="height:${divSize}px"></div><br>
                                        <p><input type="submit" value="Download as CSV"/></p>
                                    </section>
                                    <input type="hidden" name="csv" value="${rank}">
                                    </html:form>
				</c:otherwise>
			</c:choose>
		</section>
                            
	</jsp:body>
</jax:mmhcpage>
