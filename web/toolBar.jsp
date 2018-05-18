<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

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
												<html:form action="quickSearchResults" method="GET">
												<table class="toolbar-search">
														<tr>
																<td>
																		<span class="toolbar-searchTitle">Search</span> for
																</td>
																<td align="right">
																		<a class="help" href="<c:url value='/userHelp.jsp#searchbox'/>"><img src="${applicationScope.urlImageDir}/help_small.png" height=16 width=16 alt="help"></a>
																</td>
														</tr>
														<tr>
																<td colspan=2>
																		<input class="toolbar-input" name="quickSearchTerm" size=12>
																		<input class="toolbar-button" type="submit" value="Go">
																</td>
														</tr>
														<tr>
																<td colspan=2>
																	 in these sections
																</td>
														</tr>
														<tr>
																<td colspan=2>
																		<select name="quickSearchSections" class="toolbar-select" size="5" multiple>
																				<option value="all"> All Sections </option>
																				<option value="tumorSearch" selected> Tumor </option>
																				<option value="organSearch"> Organ </option>
																				<option value="strainSearch"> Strain </option>
																				<option value="geneticsSearch"> Genetics </option>
																		</select>
																</td>
														</tr>
												</table>
												</html:form>
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

