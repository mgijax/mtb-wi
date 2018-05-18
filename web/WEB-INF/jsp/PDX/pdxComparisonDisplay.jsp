<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html>
		<head>
		<c:import url="../../../meta.jsp">
				<c:param name="pageTitle" value="Patient Derived Xenograft Comparison"/>
		</c:import>
</head>
<body>
			<c:import url="../../../body.jsp" />

		
		<script type="text/javascript">
				
				function showAllMutations(){
						var genes = document.getElementsByName("mtGene");
					
						for(var i=0; i<genes.length; i++){
								if(genes[i].style.cursor == "pointer"){
										showMutations(genes[i].textContent);
								}
						}
						if(document.getElementById("show-all").textContent =="+"){
								document.getElementById("show-all").textContent ="-";
						}else{
								document.getElementById("show-all").textContent="+";
						}
				
				}
				
				function showMutations(gene){
						var tds = document.getElementsByName(gene);
						for(var i=0; i< tds.length; i++){
										if(tds[i].textContent.length > 1){
														tds[i].textContent=" ";
														tds[i].style ="background-color:#000000";
														
										}else{
														tds[i].removeAttribute("style");
														tds[i].textContent = tds[i].getAttribute("mutation");
										}
						}
				}

</script>
		

		<div class="wrap">
<nav><c:import url="../../../pdxToolBar.jsp" /></nav>
<section class="main">

<html:form action="pdxComparison" method="GET">

								<header>
	<h1>Patient Derived Xenograft Comparison</h1>
	<a href="nojavascript.jsp" onClick="popSizedPathWin('${applicationScope.urlBase}/html/userHelp.html#pdxcomparison', 'comparisonhelp',350,1000);return false;"></a>
<input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdx-request-button" onclick="window.location='pdxRequest.do'">
</header>
<table>

										
											<tr class="summary">
												<td >
														<span class="label">Search Summary</span>
<!-- \n -->

																				<c:choose>
												<c:when test="${not empty primarySites}">
														<c:choose>
																<c:when test="${fn:length(primarySites)>1}">
																		<span class="label">Primary Sites:</span>
																</c:when>
																<c:otherwise>
																		<span class="label">Primary Site:</span>
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
														<span class="label">Primary Sites:</span> Any
<!-- \n -->

												</c:otherwise>
										</c:choose>

										<c:choose>
												<c:when test="${not empty diagnoses}">
														<c:choose>
																<c:when test="${fn:length(diagnoses)>1}">
																		<span class="label">Diagnoses:</span>
																</c:when>
																<c:otherwise>
																		<span class="label">Diagnosis:</span>
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
														<span class="label">Diagnosis:</span> Any
<!-- \n -->

												</c:otherwise>
										</c:choose>
								</td> 
								<td>
										 <table>
		<tr><td>Rank Z based expression scale</td>
		<tr>
				<td>
						<table>
								<tr>
								<td style="text-align:center;color:#FFFFFF;background-color:#006900">-15</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#007300">-14</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#007d00">-13</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#008700">-12</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#009100">-11</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#009b00">-10</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00a500">-9</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00af00">-8</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00b900">-7</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00c300">-6</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00cd00">-5</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00d700">-4</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00e100">-3</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00eb00">-2</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#00f500">-1</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#808080"> 0 </td>
								<td style="text-align:center;color:#FFFFFF;background-color:#f50000">+1</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#eb0000">+2</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#e10000">+3</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#d70000">+4</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#cd0000">+5</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#c30000">+6</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#b90000">+7</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#af0000">+8</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#a50000">+9</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#9b0000">+10</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#910000">+11</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#870000">+12</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#7d0000">+13</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#730000">+14</td>
								<td style="text-align:center;color:#FFFFFF;background-color:#690000">+15</td>
								<td style="text-align:center;background-color:#FFFFFF">No Value</td>
								</tr>
						</table>
						
				</td>
		</tr>
		<tr><td>
						<table>
								<tr><td>CNV color coding</td></tr>
								<tr>
										<td style="text-align:center;color:#000000;background-color:#FFA500">Amplification</td>
										<td style="text-align:center;color:#000000;background-color:#0000FF">Deletion</td>
										<td style="text-align:center;color:#000000;background-color:#808080">Normal</td>
										<td style="text-align:center;color:#000000;background-color:#FFFFFF">No Value</td>
								</tr>
						</table>
				</td>
		</tr>
	</table>
								</td>
								</tr>

<tr>
										<tr><td colspan="4">
														${table}
												</td>
										</tr>
						<!--				<tr><td>Rank Z based expression scale</td>
										<tr>
												<td>
														${gradient}
												</td>
										</tr>
										<tr><td>
														<table>
																<tr><td>CNV color coding</td></tr>
																<tr>
																		<td style="text-align:center;color:#000000;background-color:#FFA500">Amplification</td>
																		<td style="text-align:center;color:#000000;background-color:#0000FF">Deletion</td>
																		<td style="text-align:center;color:#000000;background-color:#808080">Normal</td>
																		<td style="text-align:center;color:#000000;background-color:#FFFFFF">No Value</td>
																</tr>
														</table>
												</td>
										</tr>		-->

								</table>
						</html:form>

</section>
</div>

</body>
</html> 
