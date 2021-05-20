<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Comparison">
	<jsp:attribute name="head">
            <script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
	<script type="text/javascript">
             $(document).ready(function () {
             table = $('#comparisonTable').DataTable( {
                    searching:      false,
                    info:           false,
                    scrollY:        '50vh',
                    scrollX:        '50vh',
                    scrollCollapse: true,
                    paging:         false,
                    ordering:       false,
                    stripe:         true
                    } );
            
             });
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
	<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
	
	
	
	</jsp:attribute>
	<jsp:attribute name="subnav">
	<%--<a href="pdxRequest.do">Request more information on the JAX PDX program</a> --%>
	</jsp:attribute>
	<jsp:body>
	
	
	<section id="summary">
		<div class="container">
			<table>
				<tbody>
					<tr>
                                            <jax:dl dt="Primary Site" dts="Primary Sites" dds="${primarySites}" dd="Any"/>
					</tr>
					<tr>
                                            <jax:dl dt="Diagnosis" dts="Diagnoses" dds="${diagnoses}" dd="Any"/>
					</tr>
				</tbody>
			</table>
		</div>
	</section>		
	
	<section id="detail" style="background-color: inherit">		
	
	<html:form action="pdxComparison" method="GET">
	<table class="detail-table" >

		<caption>
			<div class="result-legend">
				<table>
					<caption>Rank Z based expression scale</caption>
					<tbody>
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
					</tbody>
				</table>
				<table>
					<caption>CNV color coding</caption>
					<tbody>
						<tr>
							<td style="text-align:center;color:#000000;background-color:#FFA500">Amplification</td>
							<td style="text-align:center;color:#000000;background-color:#0000FF">Deletion</td>
							<td style="text-align:center;color:#000000;background-color:#808080">Normal</td>
							<td style="text-align:center;color:#000000;background-color:#FFFFFF">No Value</td>
						</tr>
					</tbody>
				</table>
				
			</div>
		</caption>
		</table>
            <br>
			
                ${table}
				
		
	
	</html:form>
	</section>
	</jsp:body>
</jax:mmhcpage>
