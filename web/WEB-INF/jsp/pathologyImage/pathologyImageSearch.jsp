<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>
<head>
<c:import url="../../../meta.jsp">
		<c:param name="pageTitle" value="Pathology Image Search Form"/>
</c:import>
</head>

<body>
	<c:import url="../../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<html:form action="pathologyImageSearchResults" method="GET">

<header>
	<h1>Pathology Image Search Form</h1>
	<a class="help" href="userHelp.jsp#pathology"></a>
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
														<html:radio property="sortBy" value="organ">Organ of origin</html:radio>  
														<html:radio property="sortBy" value="strain">Strain of origin</html:radio>  
														<html:radio property="sortBy" value="method">Method</html:radio>  
														<html:radio property="sortBy" value="antibody">Antibody</html:radio>
										</td>
								</tr>
								<tr>
										<td>
												<span class="label">Max number of pathology reports returned:</span>
														<html:radio property="maxItems" value="5">5</html:radio>  
														<html:radio property="maxItems" value="10">10</html:radio>  
														<html:radio property="maxItems" value="100">100</html:radio>  
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
						Tumors
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

												<html:select property="organTissueOrigin" size="8" multiple="true">
														<html:option value="">ANY</html:option>
														<html:options collection="organsOfOrigin" property="value" labelProperty="label"/>
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
														<html:options collection="tumorClassifications" property="value" labelProperty="label"/>
												</html:select>
										</td>
								</tr>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The organ (or tissue) in which tumor cells are found.
<!-- \n -->

<!-- \n -->
The organ/tissue affected by a tumor can be different than the organ/tissue of tumor origin when there is a metastatic event or if the original tumor is transplanted into a different mouse.
<!-- \n -->

<!-- \n -->
The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ/Tissue Affected');" onmouseout="return nd();">Organ/Tissue Affected</a>:</strong>
												
<!-- \n -->

												<html:select property="organTissueAffected" size="8" multiple="false">
														<html:option value="">ANY</html:option>
														<html:options collection="organsAffected" property="value" labelProperty="label"/>
												</html:select>
										</td>
								</tr>
						</table>
				</td>
		</tr>
		<tr class="stripe-2">
				<td class="cat-2">
						Image
				</td>
				<td class="data-2">
						<table>
								<%--
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field offers a text based search against the diagnosis and description fields associated with a Pathological record.', CAPTION, 'Diagnosis or Description');" onmouseout="return nd();">Diagnosis or Description</a>:</strong>
												
<!-- \n -->

												contains &nbsp;
												<html:text property="diagnosisDescription" size="40" maxlength="50"/>
										</td>
								</tr>
								--%>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field searches for specific histological procedures from a select list of procedures.', CAPTION, 'Stain / Method');" onmouseout="return nd();">Stain / Method</a>:</strong>
												
<!-- \n -->

												<html:select property="method">
														<html:option value="">ANY</html:option>
														<html:options collection="methods" property="value" labelProperty="label"/>
												</html:select>
										</td>
								</tr>
								<tr>
										<td>
												<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field searches for antibodies used in staining procedures.
<!-- \n -->

<!-- \n -->
Searches are conducted from a list of antibody names which include clone numbers, when available.', CAPTION, 'Antibody');" onmouseout="return nd();">Antibody</a>:</strong>
												
<!-- \n -->

												<html:select property="antibody" size="8" multiple="true">
														<html:option value="">ANY</html:option>
														<html:options collection="antibodies" property="value" labelProperty="label"/>
												</html:select>
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

