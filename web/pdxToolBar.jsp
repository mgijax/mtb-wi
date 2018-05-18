<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 

<style type="text/css">

.survey{
 border: 1px solid blue;
 padding: 4px;}

</style>

<!-- ////  Start Include Navigation Menu  //// -->

<table class="toolbar">			
		<tr>
				<td>
					 <a href="<c:url value='/index.do'/>"><img src="${applicationScope.urlImageDir}/mtb_logo_side.png" alt="Mouse Tumor Biology Database (MTB)"></a>
					 
<!-- \n -->

					 <a href="<c:url value='/index.do'/>">MTB Home</a>&nbsp;&nbsp;&nbsp;<a href="<c:url value='/userHelp.jsp'/>">Help</a>
				</td>
		</tr>

		<tr>
				<td>
						<table class="results">
								<tr>
										<td>
								<form name="placeholder" ></form>
										</td>
								</tr>
						</table>
				</td>
		</tr>
		<tr>
				<td>
						<div class="toolbar-title">Search Forms</div>
						<a href="<c:url value='/tumorSearch.do'/>">Tumor</a>
						
<!-- \n -->

						<a href="<c:url value='/strainSearch.do'/>">Strain</a>
						
<!-- \n -->

						<a href="<c:url value='/geneticsSearch.do'/>">Genetics</a>
						
<!-- \n -->

						<a href="<c:url value='/pathologyImageSearch.do'/>">Pathology Images</a>
						
<!-- \n -->

						<a href="<c:url value='/referenceSearch.do'/>">Reference</a>
						
<!-- \n -->

						<span style="white-space:nowrap"><a href="<c:url value='/advancedSearch.do'/>">Advanced</a></span>
						
<!-- \n -->

						<a href="<c:url value='/orthologySearch.do'/>">Search MTB Using Human Genes</a>
						
<!-- \n -->

						<a href="<c:url value='/geneExpressionSearch.do'/>">Gene Expression Data Sets</a> 
						
<!-- \n -->
 
						<div><hr></div>
						
				</td>
		</tr>
		<tr>
				<td>
						<div class="toolbar-title">Additional Resources</div>
						
						
						<img src="${applicationScope.urlImageDir}/new.jpg" alt="new">
						<a href="http://www.pdxfinder.org">PDX Finder</a> 
						
<!-- \n -->

						 
						
						<a href="<c:url value='/facetedSearch.do'/>">Faceted Tumor Search</a> 
						
<!-- \n -->

						
						
						
							<a href="<c:url value='/pdxSearch.do'/>">PDX Model Search</a>
						
<!-- \n -->

						
						<c:if test="${applicationScope.publicDeployment == false}">
						
						 <a href="<c:url value='/pdxComparison.do'/>">PDX Comparison</a>
						
<!-- \n -->

						
						 <a href="<c:url value='/pdxLogin.do'/>">PDX Login</a>
						
<!-- \n -->

						</c:if>			
						 <a href="<c:url value='/viewer.do'/>">Cancer QTL Viewer</a>
						
<!-- \n -->

						<c:if test="${not empty applicationScope.urlMTBPathWI}">
								<span style="white-space:nowrap"><a href="${applicationScope.urlMTBPathWI}">Submit Pathology Images</a></span>
								
<!-- \n -->

						</c:if>
						<span style="white-space:nowrap"><a href="<c:url value='/tumorFrequencyGrid.do'/>">Tumor Frequency Grid</a></span>
					 
						
<!-- \n -->

						 <span style="white-space:nowrap"><a href="<c:url value='/dynamicGrid.do'/>">Dynamic Tumor Frequency Grid</a></span> 
				 
					 
						
<!-- \n -->

						<a href="<c:url value='/cancerLinks.jsp'/>">Other Cancer Websites</a>
						
<!-- \n -->

						<a href="<c:url value='/immunohistochemistry.jsp'/>">Immunohistochemistry</a>
						 
<!-- \n -->

						<a href="<c:url value='/lymphomaPathology.jsp'/>">Lymphoma Pathology</a>
						<div><hr></div>
				</td>
		</tr>
		<tr>
				<td>
						<div>
						<a href="http://www.informatics.jax.org"><img src="${applicationScope.urlImageDir}/logos/mgi_logo.gif" alt="Mouse Genome Informatics"></a>
<!-- \n -->

						<a href="http://www.jax.org/"><img height=80 width=160 src="${applicationScope.urlImageDir}/JaxLogo.gif" alt="The Jackson Laboratory"></a>
						<hr>
						</div>
				</td>
		</tr>
		<tr>
				<td>
						<a href="<c:url value='/citation.jsp'/>">Citing These Resources</a>
						
<!-- \n -->

						<a href="<c:url value='/copyright.jsp'/>">Warranty Disclaimer 
<!-- \n -->
&amp; Copyright Notice</a>
						
<!-- \n -->

						Send Questions and 
<!-- \n -->
Comments to
						<a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">User Support</a>.
						<div>
						<hr>
						<div class="toolbar-small">
						Last Database Update
<!-- \n -->

						${applicationScope.dbLastUpdateDate}
<!-- \n -->

						MTB ${applicationScope.wiVersion}
						</div>
						</div>
				</td>
		</tr>
</table>

<!-- ////  End Include Navigation Menu  //// -->

