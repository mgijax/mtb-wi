<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Mouse Models of Human Cancer Database (MMHCdb)">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/home.css"/>
	</jsp:attribute>
	<jsp:body>
	
		<section class="container" id="mmhc-summary">
	
	
			<p>MMHCdb is a comprehensive, expertly curated resource of diverse mouse models of human cancer.</p>
			<p>We focus on:</p>
			<ul><li>spontaneous and induced tumors in mice</li><li>genetically defined mouse models of cancer (inbred, hybrid, mutant, and genetically engineered strains of mice)</li><li>Patient Derived Xenograft (PDX) models</li></ul>
	
			
		</section>
		
		<section class="container" id="mmhc-detail">
		
	
			<div id="model-counts">
				<table>
					<caption>
						<h2>Top Mouse Models of Human Cancer</h2>
					</caption>
					<thead>
						<tr>
							<th></th>
							<th colspan="2"><a href="https://www.cancer.org/content/dam/cancer-org/research/cancer-facts-and-statistics/annual-cancer-facts-and-figures/2019/cancer-facts-and-figures-2019.pdf" target="_blank">American Cancer Society Facts &amp; Figures 2019</a></th>
							<th colspan="4">Mouse Models</th>
						</tr>
						<tr>
							<th>Cancer Site</th>
							<th data-tip="Data: American Cancer Society Facts &amp; Figures">Mortality Rank</th>
							<th data-tip="Data: American Cancer Society Facts &amp; Figures">Estimated deaths USA</th>
							<th data-tip="Mutant strains: targeted, transgenic, gene trapped, chemically induced, radiation induced, etc.">Mutant Strains</th>
							<th data-tip="Non mutant strains: inbred, hybrid, outbred, fostered, chimeric, etc.">Other Strains</th>
							<th>All Strains</th>
							<th data-tip="PDX Models: Patient derived xenograft">PDX Models</th>
						</tr>
					</thead>
					${modelCounts}
				</table>
			</div>
			
			<div id="updates" class="col-md-3 col-xs-12">
				<h2>News &amp; Events</h2>
				<ul>
				${whatsNewText}
				</ul>
				(<a href="whatsNew.jsp">View all...</a>)
			</div>
				
		</section>


	</jsp:body>
</jax:mmhcpage>
