<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>
		<head>
		<c:import url="../../../meta.jsp">
				<c:param name="pageTitle" value="Patient Derived Xenograft Dashboard"/>
		</c:import>

		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
		<script type="text/javascript">
				
				var disableResult = "${disableResults}";
				if(disableResult.length > 0){
						disableResult = disableResult.replace(/,/g, "\n");
						alert(disableResult);
				}
				
				function disableClick(){
						var count = document.getElementById("disableIDs").value.split(",").length
						ok = confirm("You are about to disable "+count+" mice.\n"+document.getElementById("disableIDs").value.replace(/,/g,"\n"));
						if(ok==true){
								return true
						}
						return false;
				}
				
				google.load("visualization", "1", {packages:["corechart"]});
				google.setOnLoadCallback(drawCharts);
			
				function drawCharts(){
						drawPieChart();
						drawBarChart();
				}
			
				function drawPieChart() {
						var data = google.visualization.arrayToDataTable([${modelStats}]);

						var options = { 
								colors: ["#109618","#dc3912","#3366cc","#ff9900","#b82e2e","#316395","#994499","#22aa99","#aaaa11"],
								title: 'PDX Mouse Engraftment (${tissue}, ${site}) ',
								chartArea: {top: 40, left:0, width:"100%"},
								tooltip:{text:'percentage'},
								sliceVisibilityThreshold: 0.001,
								legend:{textStyle: {fontSize: 11}}
						};

						var pieChart = new google.visualization.PieChart(document.getElementById('pie_chart_div'));
						pieChart.draw(data, options);
				}
			
			
				
				function selectHandler(e){
						var selection = barChart.getSelection();
						var item = selection[0];
						if (item.row != null){
								window.open("pdxSearchResults.do?primarySites="+barData.getValue(item.row,0),"barData.getValue(item.row,0)");
						}	
				}
			
			
				function drawBarChart() {
						barData = google.visualization.arrayToDataTable([${modelStatsByTissue}]);

						var options = {
								title: 'Engraftment by Primary Site',
								vAxis: {title: 'Tissue', titleTextStyle: {color: 'red'}},
								hAxis: {title: 'Engrafted Mice',titleTextStyle: {color: 'red'}},
								chartArea:{top:20, height:${chartSize}}
								 , colors: ["#109618","#3366cc","#dc3912","#ff9900","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#994499","#22aa99","#aaaa11"]
								 ${stacked}
						};

						barChart = new google.visualization.BarChart(document.getElementById('bar_chart_div'));
						
						google.visualization.events.addListener(barChart, 'select', selectHandler);
						
						barChart.draw(barData, options);
				
				
				}
				
									
			 
							 
			 
		</script>

</head>
<body class="alt">
<body>
	<c:import url="../../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>Patient Derived Xenograft Dashboard</h1>
	<a class="help" href="userHelp.jsp#pdxDashboard"></a>
</header>
<table class="results">

										<tr class="buttons">
												<td colspan="2">
														<input type="button" value="Open PDX Genomics Dashboard" onclick="window.open('	http://pdx-dashboard.jax.org/v4/');">
												</td>
										</tr>

										<tr class="buttons">
												<td colspan="2">
														<table>
																<tr>
																		<td colspan="6">
																				<strong>Download PDX Reports</strong>
																		</td>
																</tr>

																<tr>
																		<td>
																<html:form action="pdxDashboard" method="POST">
																		<input type="submit" name="statusReport" VALUE="PDX Status Report">
																</html:form>
												</td>
												<td>
										<html:form action="pdxDashboard" method="POST">
												<input type="submit" name="engraftmentSummary" VALUE="PDX Engraftment Status Summary">
										</html:form>
						</td> 
						<td>
				<html:form action="pdxDashboard" method="POST">
						<input type="submit" name="familyHistory" VALUE="PDX Patient History">
				</html:form>
						</td>
						<td>
						<html:form action="pdxDashboard" method="POST">
								<input type="submit" name="patientClinical" VALUE="PDX Patient Clinical">
						</html:form>
						</td>

						<td>
						<html:form action="pdxDashboard" method="POST">
								<input type="submit" name="consortium" VALUE="PDX Consortium Report"> 
						</html:form>
						</td>
						
						 <td>
						
								 <a class="none" href="http://bhmtbdb01.jax.org/usrlocalmgi/mtb/live/www/pdx/treatment_response_summary.xlsx"><input type="button"	VALUE="Drug Response Summary"></a>
						
						</td>
						</tr>
						<tr>
								<td colspan=5>
										Reports loaded ${freshnessDate} E.S.T. 

								</td>
						<tr>
								<td colspan=5>
						<html:form action="pdxDashboard" method="POST">
								<input type="submit" name="refresh" VALUE="Refresh Reports">
						</html:form>
						</td>

</tr>
</table>
</td>
</tr>

<tr class="buttons">
		<td>
				<a id="sites"></a>
				<table>
						<tr>
								<td width="20%" style="vertical-align:top">
						<html:form action="pdxDashboard" method="POST">
								<table>
										<tr>
												<td>
														<strong>Primary Site</strong>
												</td>
										</tr>
										<tr>
												<td>
										<html:select property="tissues" size="20">
												<html:option value="Any">ANY</html:option>
												<html:options collection="tissueValues" property="value" labelProperty="label"/>
										</html:select>
										</td>
										</tr>
										<tr>
												<td>
														<strong>Contributing Organization</strong>
												</td>
										</tr>
										<tr>
												<td>
										<html:select property="sites" size="10">
												<html:option value="Any">ANY</html:option>
												<html:options collection="siteValues" property="value" labelProperty="label"/>
										</html:select>
										</td>

										</tr>

										<tr>
												<td>
														<input type="submit" VALUE="Update Pie Chart">
												</td>
										</tr>
								</table>
						</html:form>
		</td>
		<td width="80%">
				<div id="pie_chart_div" style="width: 100%; height: 500px;"></div>
		</td>
</tr>
</table>
</td>
</tr>
<tr class="buttons">
		<td>
				<table>
						<tr>
								<td width="25%" style="vertical-align:top">
						<html:form action="pdxDashboard" method="POST">
								<table>
										<tr>
												<td>
														<strong>Contributing Organization</strong>
												</td>
										</tr>
										<tr>
												<td>
										<html:select property="sites2" size="20">
												<html:option value="Any">ANY</html:option>
												<html:options collection="siteValues" property="value" labelProperty="label"/>
										</html:select>
										</td>
										</tr>
										<tr>
												<td>
														<input type="submit" VALUE="Update Bar Chart">
												</td>
										</tr>
										<tr>
												<td>
														<strong>Active (available or in progress) models by tissue.</strong>
												</td>
										</tr>

										<tr>

												<td>
														<input type="submit" name="aipReport" VALUE="Available or in progress">
												</td>
										</tr>
										<tr>

												<td>
														<input type="submit" name="aipReportSheet" VALUE="Available or in progress-Spreadsheet">
												</td>
										</tr>
										<tr>
												<td>
														<input type="submit" name="aipReport5" VALUE="Available or in progress (5 < active models)">
												</td>
										</tr>
										<tr>
												<td>
														<input type="submit" name="aipReport5Sheet" VALUE="Available or in progress (5 < active models)-Spreadsheet">
												</td>
										</tr>
								</table>
						</html:form>

						<td>
						<c:if test="${not empty modelStatsByTissue}">
								<div id="bar_chart_div" style="width: 100%; height: ${divSize}px;"></div>
						</c:if>
						<c:if test="${empty modelStatsByTissue}">
								<div id="bar_chart_div" style="visibility: hidden"></div>
						</c:if>		
		</td>
</tr>

<!--

<tr class="buttons">
		<td>
				<table>
						<tr>
								<td>
										<strong>Disable Mice</strong>
								</td>
						</tr>
						<tr>

								<td>
						<html:form action="pdxDashboard" method="post" onsubmit="return disableClick()" >
								Enter mouse ID's to disable 
								<input type="text" name="disableIDs" size="100" id="disable-i-ds">
								<input type="submit" name="disableButton" value="Disable" >
						</html:form>
		</td>

</tr>
</table>
</td>
</tr>	-->

</table>


</section>
</div>
<c:if test="${not empty bySite}">
		<script>
				document.location="#sites"
		</script>
</c:if>
</body>
</html>
 
