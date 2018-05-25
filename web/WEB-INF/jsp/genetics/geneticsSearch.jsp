<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Strain and Tumor Genetics Search Form" help="genetics">
	<html:form action="geneticsSearchResults" method="GET">


<table class="results">

<tr class="page-info">

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
										<tr>
											<td>
												<span class="label">Sort By:</span>
													<html:radio property="sortBy" value="Gene Symbol">Gene Symbol</html:radio>  
														<html:radio property="sortBy" value="Mutation Type">Mutation Type</html:radio>  
															<html:radio property="sortBy" value="Chromosome">Chromosome</html:radio>  
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

<tr>
	<td class="cat-1">
		Strain and Tumor Genetics:
			</td>
				<td class="data-1">
					<table>

<tr>
	<td>
		<table>
			<tr>
				<td></td>
					<td></td>

</tr>
	<tr>
		<td align="right"><strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field offers a text based search against Marker Symbol, Name and Synonym records.
<!-- \n -->

<!-- \n -->
If a gene of interest is not found on the list please check the Mouse Genome Database to ensure that the gene symbol and name you are searching for is current.', CAPTION, 'Gene / Marker');" onmouseout="return nd();">Gene / Marker</a>:</strong></td>
	<td>
		<html:select property="markerNameComparison">
			<html:option value="Contains"> Contains </html:option>
				<html:option value="Begins"> Begins </html:option>
					<html:option value="Equals"> Equals </html:option>
						</html:select>
							</td>
								<td><html:text property="markerName" size="20" maxlength="50"/></td>
									</tr>
										<tr>
											<td align="right"><strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('If a gene of interest is not found on the list please check the Mouse Genome Database to ensure that the gene symbol and name you are searching for is current.', CAPTION, 'Allele');" onmouseout="return nd();">Allele</a>:</strong></td>
												<td>
													<html:select property="alleleNameComparison">
														<html:option value="Contains"> Contains </html:option>
															<html:option value="Begins"> Begins </html:option>
																<html:option value="Equals"> Equals </html:option>
																	</html:select>
																		</td>
																			<td><html:text property="alleleName" size="20" maxlength="50"/></td>
																				</tr>
																				</table>
																		</td>
																</tr>
																<tr>
																	<td>
																		<table>
																			<tr>
																				<td>
																					<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The type of mutation, chromosomal aberration, or other genetic change observed in the strain and/or in the tumor tissue.
<!-- \n -->

<!-- \n -->
The values for type of genetic change are selected from a controlled vocabulary list.', CAPTION, 'Mutations / Aberrations');" onmouseout="return nd();">Mutations / Aberrations</a>:</strong>

<!-- \n -->

<html:select property="alleleGroupType" size="8" multiple="true">
	<html:option value="">ANY</html:option>
		<html:options collection="alleleGroupTypeValues" property="value" labelProperty="label"/>
			</html:select>

</td>

<td>
	<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Chromosome number an allele is found on.
<!-- \n -->

<!-- \n -->
This search is used to find allele records associated with a specific chromosome number using a pick list.', CAPTION, 'Chromosome');" onmouseout="return nd();">Chromosome</a>:</strong>

<!-- \n -->

<html:select property="chromosome" size="8" multiple="true">
	<html:option value="">ANY</html:option>
		<html:options collection="chromosomeValues" property="value" labelProperty="label"/>
			</html:select>
				</td>
					</tr>
						<tr>
							<td colspan="2">
								<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Some cytogenetic records include assay images selecting this check box will return only cytognetic records with assay images.', CAPTION, 'Assay Images');" onmouseout="return nd();">Assay Images</a>:</strong>

<!-- \n -->

<html:checkbox property="assayImages">Restrict search to entries with associated assay images. </html:checkbox>
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

</jax:mmhcpage>

