<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>
<head>
<c:import url="../../../meta.jsp">
		<c:param name="pageTitle" value="Reference Search Form"/>
</c:import>
</head>

<body>
	<c:import url="../../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<html:form action="referenceSearchResults" method="GET">

<header>
	<h1>Reference Search Form</h1>
	<a class="help" href="userHelp.jsp#references"></a>
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
														<html:radio property="sortBy" value="year desc">Year</html:radio>  
														<html:radio property="sortBy" value="primaryAuthor">First Author</html:radio>  
														<%--
														<html:radio property="sortBy" value="numericPart">J Number</html:radio>
														--%>
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

		
		<tr class="stripe-1">
				<td class="cat-1">
						Reference
				</td>
				<td class="data-1">
						<table>
							 
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search against first author names.', CAPTION, 'First Author');" onmouseout="return nd();">First Author</a>:</strong>
												
<!-- \n -->

												<html:select property="firstAuthorComparison">
														<html:option value="Contains"> Contains </html:option>
														<html:option value="Begins"> Begins </html:option>
														<html:option value="Equals"> Equals </html:option>
												</html:select>  
												<html:text property="firstAuthor" size="40" maxlength="255"/>
										</td>
								</tr>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search against all author names.', CAPTION, 'Authors');" onmouseout="return nd();">Authors</a>:</strong>
												
<!-- \n -->

												contains <html:text property="authors" size="40" maxlength="255"/>
										</td>
								</tr>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Text string search against the abbreviated name of the journal in which the published reference appears.', CAPTION, 'Journal');" onmouseout="return nd();">Journal</a>:</strong>
												
<!-- \n -->

												<html:select property="journalComparison">
														<html:option value="Contains"> Contains </html:option>
														<html:option value="Begins"> Begins </html:option>
														<html:option value="Equals"> Equals </html:option>
												</html:select>  
												<html:text property="journal" size="40" maxlength="255"/>
										</td>
								</tr>
								<tr>
										<td>
												<table>
														<tr>
																<td>
																		<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search for publication year.', CAPTION, 'Year');" onmouseout="return nd();">Year</a>:</strong>
																		
<!-- \n -->

																		<html:select property="yearComparison">
																				<html:option value="="> Equals </html:option>
																				<html:option value=">"> Greater Than </html:option>
																				<html:option value="<"> Less Than </html:option>
																		</html:select>  
																		<html:text property="year" size="5" maxlength="4"/>
																</td>
																<td width="30"></td>
																<td>
																		<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search for the volume of a journal in which an article was published.', CAPTION, 'Volume');" onmouseout="return nd();">Volume</a>:</strong>
																		
<!-- \n -->

																	 
																		<html:text property="volume" size="10" maxlength="20"/>
																</td>
																<td width="30"></td>
																<td>
																		<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search for the <em>BEGINNING</em> page number of a journal article.', CAPTION, 'Page');" onmouseout="return nd();">Page</a>:</strong>
																		
<!-- \n -->

																		
																		<html:text property="pages"	size="10" maxlength="20"/>
																</td>
														</tr>
												</table>
										</td>
								</tr>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search for an article title.', CAPTION, 'Title');" onmouseout="return nd();">Title</a>:</strong>
												
<!-- \n -->

												<html:select property="titleComparison">
														<html:option value="Contains"> Contains </html:option>
														<html:option value="Begins"> Begins </html:option>
												</html:select>  
												<html:text property="title" size="40" maxlength="255"/>
										</td>
								</tr>
						</table>
				</td>
		</tr>
		<!--
		<tr class="stripe-2">
				<td class="cat-2">
						Tumor Type
				</td>
				<td class="data-1">
						<table>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The specific organ (or tissue) in which tumor cells originate.
<!-- \n -->

<!-- \n -->
The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ/Tissue of Origin');" onmouseout="return nd();">Organ/Tissue of Origin</a>:</strong>
												
<!-- \n -->

												<html:select property="organTissue" size="5" >
														<html:option value="">ANY</html:option>
														<html:options collection="organTissueValues" property="value" labelProperty="label"/>
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

												<html:select property="tumorClassification" size="5" >
														<html:option value="">ANY</html:option>
														<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
												</html:select>
										</td>
								</tr>
						</table>
				</td>
		</tr>
							 --> 
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
 

