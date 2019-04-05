<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Search Form" help="pdxsearch">
	<jsp:attribute name="head">
	<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
	<script type="text/javascript">
		function clearForm() {
			document.forms[1].cases.value = "";
			document.forms[1].submit();
		}
	</script>
	</jsp:attribute>
	<jsp:body>
	<p>Patient Derived Xenograft (PDX) models for cancer research are created by the implantation of human cells and tumor tissue into immune compromised mouse hosts.	PDX models provide a platform for in vivo cancer biology studies and pre-clinical cancer drug efficacy testing.	The current state of the art mouse host is the "NOD-SCID-Gamma2" (NSG) mouse. NSG mice lack mature T and B cells, have no functional natural killer cells, and are deficient in both innate immunity and cytokine signaling.</p>
	<img src="${applicationScope.urlImageDir}/NSG_lg.jpg" alt="NSG Mouse">
	<a href="pdxRequest.do" target="_blank">Request more information on the JAX PDX program.</a>
	<h3>PDX minimal information data standards are now public.</h3>
	<p>Read about it in Cancer Research, <a href="https://www.ncbi.nlm.nih.gov/pubmed/29092942">Meehan et al., 2017</a></p>
	<ul>
		<li class="real-list"><a href="${applicationScope.urlBase}/html/PDXMI_README.docx">PDX Minimal Information Read Me (doc)</a></li>
		<li class="real-list"><a href="${applicationScope.urlBase}/html/PDXMIPublication.xlsx">PDX Minimal Information Specification (xls)</a></li>
		<li class="real-list"><a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">PDX Minimal Information Feedback (web form)</a></li>
	</ul>
	<jax:searchform action="pdxMultiSearch">
	<fieldset>
		<legend>Enter Case information here</legend>		
		<p>The format for the input should be one or more cases as follows:</p>
		<ul>
			<li>CASE &lt;unique case identifier&gt;</li>
		</ul>
		<p>Followed by one or more gene descriptions with an optional U or K to indicate known or unknown significance	(U and K are used for formatting and have no bearing on search results)</p>
		<p>Gene descriptions can be of three types, one per line:</p>
		<ul>
			<li>&lt;Gene&gt;,&lt;Variant&gt;,&lt;K|U&gt;</li>
			<li>&lt;Gene&gt;,<strong>Amplified</strong>,&lt;K|U&gt;</li>
			<li>&lt;Gene&gt;,<strong>Deleted</strong>,&lt;K|U&gt;</li>
		</ul>
		<p>Examples</p>
		
		<ul>
			<li>CASE 1</li>
			<li>KRAS,Amplified,K (search for models with amplified KRAS, classified as known significance)</li>
			<li>TP53,A159V,K (search for models with A159V variant of TP53, classified as known significance)</li>
			<li>ALB,Deleted,U (search for models with deleted ALB, classified as unknown)</li>
		</ul>
		<ul>
			<li>CASE 2</li>
			<li>CDK4,Amplified</li>
			<li>ETNK1,Amplified</li>
			<li>KRAS,Deleted</li>
		</ul>
		<fieldset>
			<label><input type="checkbox" name="asCSV" value="asCSV"/>Return results as a CSV file</label>
			<label><input type="checkbox" name="actionable" value="actionable"/> Include models with actionable variants for supplied genes</label>
			<textarea rows="20" cols="50" name="cases">${cases}</textarea>
			<div>
				${table}
			</div>
		</fieldset>
	</fieldset>	
	</jax:searchform>
	<!-- If the page reloads to update variants don't go back to the top of the page -->
	<c:if test="${not empty update}">
	<script>
		document.location='#variantsLocation';
	</script>
	</c:if>
	</jsp:body>
</jax:mmhcpage>
