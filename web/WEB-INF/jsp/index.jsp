<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!doctype html>
<%--
<t:TimerTag title="Index">
--%>

<html>

		<head>

				<c:import url="../../meta.jsp">
						<c:param name="pageTitle" value="Mouse Tumor Biology System (MTB)"/>
				</c:import>

				<script type="text/javascript">
						var mc = false;
						function toggle() {
								if (mc) {
										document.getElementById("mc").style.display = 'block';
										document.getElementById("all-mc").style.display = 'none';
										mc = false;
								} else {
										document.getElementById("mc").style.display = 'none';
										document.getElementById("all-mc").style.display = 'block';
										mc = true;
								}
						}
				</script>
		</head>

<body>
			<c:import url="../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../toolBar.jsp"/></nav>
<section class="main">
<header>
	<h1>Welcome to the Mouse Tumor Biology (MTB) Database</h1>
</header>

<p> The Mouse Tumor Biology (MTB) Database supports the use of the mouse as a model system of human cancers by providing access to information on and data for:</p>
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
																				
<!-- \n -->

																		</td></tr>
														</table>

														<hr>
														<p></p>
																<%--
																		<div>
																		<html:form action="tumorSearchResults" method="GET">
																		<html:hidden property="maxItems" value="No Limit"/>
																		

<table class="results">
																				<tr>
																						<td>
																								<table class="quick-search">
																										<tr>
																												<td>
																														<h4>Quick <a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The specific organ (or tissue) in which tumor cells originate.
<!-- \n -->

<!-- \n -->
The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ / Tissue of Origin');" onmouseout="return nd();">Organ/Tissue</a> Search</em></h4>
																												</td>
																												<td align="right">
																														<a class="help" href="userHelp.jsp#quickorgan"><img src="${applicationScope.urlImageDir}/help_small.png" height=16 width=16 alt="help"></a>
																												</td>
																										</tr>
																										<tr>
																												<td colspan=2>
																														<html:select property="organTissueOrigin" size="8" multiple="true">
																																<html:option value="">ANY</html:option>
																																<html:options collection="organTissueValues" property="value" labelProperty="label"/>
																														</html:select>
																														
<!-- \n -->

																														<INPUT TYPE="submit" NAME="find" VALUE="Search">
																														<INPUT TYPE="reset" VALUE="Reset">
																												</td>
																										</tr>
																								</table>
																						</td>
																				</tr>
																			 
																		</table>
																		</html:form>
																		</div>--%>
														<p></p>
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
														<p></p>
														<hr>
														<p></p>

																<span class="toolbar-title">What's new in MTB?</span>
																		${whatsNewText}
																
<!-- \n -->

																(<a href="whatsNew.jsp">View all...</a>)

														<p></p>
														<hr>
														<p></p>


</section>
</div>
</body>
</html>
 

