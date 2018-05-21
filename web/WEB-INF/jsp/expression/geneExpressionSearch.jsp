<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>
<head>
	<c:set var="pageTitle" scope="request" value="Gene Expression Data Set Search Form"/>
	<c:import url="../../../meta.jsp"/>
</head>

<body>
	<c:import url="../../../body.jsp" />

	
	<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>${pageTitle}</h1>
	<a class="help" href="userHelp.jsp#geneexpression"></a>
</header>

<html:form action="geneExpressionSearchResults" method="GET">

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
											
										</table>
									</td>
								</tr>
								
								<tr class="stripe-1">
								<td class="cat-1">
									Search Criteria
								</td>
								<td class="data-1">
								<table>
									
									<tr>
										<td>
											<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Organ
<!-- \n -->
The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ');" onmouseout="return nd();">Organ</a>:</strong>
											
<!-- \n -->

											<html:select property="organ" size="8" multiple="true">
												<html:option value="">ANY</html:option>
												<html:options collection="organValues" property="value" labelProperty="label"/>
											</html:select>
										</td>
									</tr>
									
									<tr>
										<td>
											<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The value for this field is selected from a list of controlled vocabulary terms.
<!-- \n -->

<!-- \n -->
This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.', CAPTION, 'Tumor Classification');" onmouseout="return nd();">Tumor Classification</a>:</strong>
											
<!-- \n -->

											<html:select property="tumorClassification" size="8" multiple="true">
												<html:option value="">ANY</html:option>
												<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
											</html:select>
										</td>
									</tr>
									
									
									
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
											
										</td>
									</tr>
									
									<tr>
										<td>
											<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Platforms.', CAPTION, 'Platforms');" onmouseout="return nd();">Platform</a>:</strong>
											
<!-- \n -->

											<html:select property="platform" size="8" multiple="true">
												<html:option value="">ANY</html:option>
												<html:options collection="platformValues" property="value" labelProperty="label"/>
											</html:select>
										</td>
									</tr>
									<tr>
										<td>
											<strong>Note</strong>: Searching with criteria from more than one category may produce zero results.
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
 
