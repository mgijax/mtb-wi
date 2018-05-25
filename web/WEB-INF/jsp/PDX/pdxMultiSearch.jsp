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


<html:form action="pdxMultiSearch" method="GET">

<input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdx-request-button" onclick="window.location = 'pdxRequest.do'">

<table class="results">

<tr class="page-info">
	<td colspan="3">
		<table>
			<tr>
				<td>
					&nbsp;Patient Derived Xenograft (PDX) models for cancer research are created by the implantation of human cells and tumor tissue into immune compromised mouse hosts.	PDX models provide a platform for in vivo cancer biology studies and pre-clinical cancer drug efficacy testing.	The current state of the art mouse host is the "NOD-SCID-Gamma2" (NSG) mouse. NSG mice lack mature T and B cells, have no functional natural killer cells, and are deficient in both innate immunity and cytokine signaling.	 

<!-- \n -->

<!-- \n -->

<!-- \n -->

<!-- \n -->

<table class="mi-table">
	<tr><td border="5px">
		<p class="mi-title">PDX minimal information data standards are now public. Read about it in Cancer Research, <a href="https://www.ncbi.nlm.nih.gov/pubmed/29092942">Meehan et al., 2017</a></p>
			<ul>
				<li class="real-list"><a href="${applicationScope.urlBase}/html/PDXMI_README.docx">PDX Minimal Information Read Me (doc)</a>
<!-- \n -->

<li class="real-list"><a href="${applicationScope.urlBase}/html/PDXMIPublication.xlsx">PDX Minimal Information Specification (xls)</a>
<!-- \n -->

<li class="real-list"><a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">PDX Minimal Information Feedback (web form)</a>
<!-- \n -->

</ul>

<!-- \n -->

</td></tr>
	</table>
		</td>

<td>
	<img src="${applicationScope.urlImageDir}/NSG_lg.jpg" height="225" width="450" alt="NSG Mouse">
		<td>
			</tr>

</table>
	</td>

</tr>
	<tr class="buttons">
		<td colspan="3" style="padding: 20px">
			The format for the input should be one or more cases as follows
<!-- \n -->

CASE &lt;unique case identifier&gt;
<!-- \n -->

Followed by one or more gene descriptions with an optional U or K to indicate known or unknown significance	(U and K are used for formatting and have no bearing on search results)
																						Gene descriptions can be of three types, one per line
<!-- \n -->

&lt;Gene&gt;,&lt;Variant&gt;,&lt;K|U&gt;
<!-- \n -->

&lt;Gene&gt;,<strong>Amplified</strong>,&lt;K|U&gt;
<!-- \n -->

&lt;Gene&gt;,<strong>Deleted</strong>,&lt;K|U&gt;
<!-- \n -->

Example:
<!-- \n -->

<!-- \n -->

CASE 1
<!-- \n -->

KRAS,Amplified,K (search for models with amplified KRAS, classified as known significance)
<!-- \n -->

TP53,A159V,K		 (search for models with A159V variant of TP53, classified as known significance)
<!-- \n -->

ALB,Deleted,U		(search for models with deleted ALB, classified as unknown)
<!-- \n -->

<!-- \n -->

CASE 2
<!-- \n -->

CDK4,Amplified
<!-- \n -->

ETNK1,Amplified
<!-- \n -->

KRAS,Deleted
<!-- \n -->

</td>
	</tr>

<tr class="buttons">
	<td colspan="3">
		<table>
			<tr>
				<td>
					<input type="submit" VALUE="Search">
						<input type="button" VALUE="Reset" onclick="clearForm();">

</td>

</tr>
	</table>
		</td>
			</tr>

<tr>

<td class="cat-1">
	Enter Case information here:

</td>

<td class="data-1">
	<input type="checkbox" name="asCSV" value="asCSV"/> Return results as a CSV file &nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="actionable" value="actionable"/> Include models with actionable variants for supplied genes

<!-- \n -->

<textarea rows="20" cols="50" name="cases">${cases}</textarea>
	</td>
		<td class="data-1">
			${table}
				</td>
					</tr>

<tr class="buttons">
	<td colspan="3">
		<table>
			<tr>
				<td>
					<input type="submit" VALUE="Search">
						<input type="button" VALUE="Reset" onclick="clearForm();">
							</td>
								</tr>
									</table>
										</td>
											</tr>
												</html:form>

</table>

<!-- If the page reloads to update variants don't go back to the top of the page -->
	<c:if test="${not empty update}">
	<script>
		document.location = "#variantsLocation"
	</script>
		</c:if>
</jax:mmhcpage>

