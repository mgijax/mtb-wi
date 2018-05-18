<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>

<head>

<c:import	url="../../../meta.jsp">
		<c:param name="pageTitle" value="Strain Search Form"/>
</c:import>

</head>

<body>
	<c:import url="../../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<html:form action="strainSearchResults" method="GET">

<header>
	<h1>Strain Search Form</h1>
	<a class="help" href="userHelp.jsp#strains"></a>
</header>
<table class="results">

<tr class="buttons">
				<td colspan="2">
						<table>
								<tr>
										<td>
												<input type="submit" VALUE="Search">
												<input type="reset" VALUE="Reset">
										</td>
								</tr>
								<tr>
										<td>
												<span class="label">Sort By:</span>
														<html:radio property="sortBy" value="name">Strain Name</html:radio>  
														<html:radio property="sortBy" value="type">Strain Type</html:radio>
										</td>
								</tr>
								<tr>
										<td>
												<span class="label">Max number of items returned:</span>
														<html:radio property="maxItems" value="25">25</html:radio>  
														<html:radio property="maxItems" value="100">100</html:radio>  
														<html:radio property="maxItems" value="500">500</html:radio>  
														<html:radio property="maxItems" value="No Limit">No Limit</html:radio>
										</td>
								</tr>
						</table>
				</td>
		</tr>

<!-- ////  Start Error Section  //// -->

<%--
<logic:messagesPresent message="true">
		<tr class="error">
				<td class="error-label">Errors</td>
				<td class="error-value">
						<ul>
					 <html:messages id="message" message="true">
							 <li>${message}</li>
					 </html:messages>
					 </ul>
			 </td>
	 </tr>
</logic:messagesPresent>
--%>

<!-- ////  End Error Section  //// -->

<tr class="stripe-1">
				<td class="cat-1">
						Strain
				</td>
				<td class="data-1">
						<table>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Strain names in MTB, where possible, follow the international nomenclature guidelines for the naming of laboratory mouse strains.', CAPTION, 'Strain Name');" onmouseout="return nd();">Strain Name:</a></strong>
												
<!-- \n -->

												<html:select property="likeClause">
														<html:option value="Contains"> Contains </html:option>
														<html:option value="Begins"> Begins </html:option>
														<html:option value="Equals"> Equals </html:option>
												</html:select>
												<html:text property="strainName" size="30" maxlength="255"/>
												<%--
												<html:checkbox property="caseSensitive" value="1"/>Case Sensitive
												--%>
										</td>
								</tr>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Indicates method of strain derivation.
<!-- \n -->

<!-- \n -->
The values for these fields are selected from lists of controlled vocabulary terms.', CAPTION, 'Strain Type');" onmouseout="return nd();">Strain Type:</a></strong>
												
<!-- \n -->

												<html:select property="strainTypes" size="8" multiple="true">
														<html:option value="">ANY</html:option>
														<html:options collection="strainTypeValues" property="value" labelProperty="label"/>
												</html:select>
										</td>
								</tr>
						</table>
				</td>
		</tr>
		<tr class="stripe-2">
				<td class="cat-2">
						Genetics
				</td>
				<td class="data-2">
						<table>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field offers a text based search for strains with known germline genotype at specific genes/loci.
<!-- \n -->

<!-- \n -->
This field searches Gene symbols, Gene names, and synonyms. The default operator for this search is \'CONTAINS\'.
<!-- \n -->

<!-- \n -->
If you have difficulty locating records of interest, you may want to consult the Mouse Genome Database to ensure that the search string is appropriate for the gene/locus of interest.', CAPTION, 'Gene or Allele');" onmouseout="return nd();">Gene or Allele:</a></strong>
												
<!-- \n -->

												<html:text property="geneticName" size="30" maxlength="255"/> <em>(Symbol/Name/Synonym)</em>
										</td>
								</tr>
						</table>
				</td>
		</tr>
		<tr class="stripe-1">
				<td class="cat-1">
						Other Database Links
				</td>
				<td class="data-2">
						<table>
								<tr>
										<td>
												<strong>Search for strain records with <a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('You can restrict your search for strains that were obtained from the JAX&reg;Mice or NCI Mouse Repositories.', CAPTION, 'Other Database Links');" onmouseout="return nd();">outside links</a> to:</strong>
												
<!-- \n -->

												<table>
														<tr>
																<td>
																		<html:checkbox property="siteJaxMice"/>JAX<sup>&reg;</sup>Mice &nbsp; &nbsp; <a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('A serial stock number assigned to strains sold by The Jackson Laboratory.
<!-- \n -->

<!-- \n -->
Users interested in a specific strain of mouse that is offered through The Jackson Laboratorys JAX Research Systems can query by the stock number of that mouse.', CAPTION, 'JAX&reg; Mice Stock Number');" onmouseout="return nd();">Stock No.</a>:<html:text property="jaxStockNumber" size="6" maxlength="10"/>
																		
<!-- \n -->

																		<html:checkbox property="siteNCIMR"/>NCI Mouse Repository
																</td>
														</tr>
													 
												</table>
										</td>
								</tr>
						</table>
				</td>
		</tr>
		<tr class="buttons">
				<td colspan="2">
						<table>
								<tr>
										<td>
												<input type="submit" VALUE="Search">
												<input type="reset" VALUE="Reset">
										</td>
								</tr>
						</table>
				</td>
		</tr>
</table>

</html:form>

</section>
	</div>
</body>

</html> 
