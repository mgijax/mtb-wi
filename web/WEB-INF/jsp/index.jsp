<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Test Title" keywords="a,b,c" description="Test description">
	<p>The Mouse Tumor Biology (MTB) Database supports the use of the mouse as a model system of human cancers by providing access to information on and data for:</p>
	<ul>
		<li>spontaneous and induced tumors in mice,</li>
		<li>genetically defined mice (inbred, hybrid, mutant, and genetically engineered strains of mice) in which tumors arise,</li>
		<li>genetic factors associated with tumor susceptibility in mice,</li>
		<li>somatic genetic-mutations observed in tumors,</li>
		<li>Patient Derived Xenograft (PDX) models</li>
	</ul>
	<p>Examples of the data accessible from MTB include:</p>
	<ul>
		<li>tumor frequency & latency data,</li>
		<li>tumor genomic data,</li>
		<li>tumor pathology reports and images,</li>
		<li>associations of models to the scientific literature,</li>
		<li>links additional on-line cancer resources</li>
	</ul>

<table class="mi-table">
	<tr><td border="5px">
		<p class="mi-title">PDX minimal information data standards are now public. Read about it in Cancer Research, <a href="https://www.ncbi.nlm.nih.gov/pubmed/29092942">Meehan et al., 2017</a></p>
			<ul>
				<li class="real-list"><a href="${applicationScope.urlBase}/html/PDXMI_README.docx">PDX Minimal Information Read Me (doc)</a></li>
				<li class="real-list"><a href="${applicationScope.urlBase}/html/PDXMIPublication.xlsx">PDX Minimal Information Specification (xls)</a></li>
				<li class="real-list"><a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">PDX Minimal Information Feedback (web form)</a></li>
			</ul>
		</td></tr>
	</table>

<hr>

<div id="mc">		
	<div>
		${modelCounts}
		</div> 
	</div>
	<div id="all-mc" style="display: none">
		<div>
			${allModelCounts}
		</div>
	</div>

<hr>
	<span class="toolbar-title">What's new in MTB?</span>
		${whatsNewText}
		(<a href="whatsNew.jsp">View all...</a>)

<hr>
</jax:mmhcpage>

