<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Tumor Search Form" help="tumors">

	<html:form action="tumorSearchResults" method="GET">

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
											<html:radio property="sortBy" value="organ">Organ of tumor origin</html:radio>  
												<html:radio property="sortBy" value="strain">Strain of tumor origin</html:radio>  
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
		Associated Tumors
			</td>
				<td class="data-1">
					<table>
						<tr>
							<td>
								<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The specific organ (or tissue) in which tumor cells originate.
<!-- \n -->

<!-- \n -->
The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ / Tissue of Origin');" onmouseout="return nd();">Organ/Tissue of Origin</a>:</strong>

<!-- \n -->

<html:select property="organTissueOrigin" size="8" multiple="true">
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

<html:select property="tumorClassification" size="8" multiple="true">
	<html:option value="">ANY</html:option>
		<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
			</html:select>
				</td>
					</tr>
						<tr>
							<td>
								<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This is a combination of the value from the Organ/Tissue of Origin field and the value from the Tumor Classification field.
<!-- \n -->

<!-- \n -->
The default operator is CONTAINS.
<!-- \n -->

<!-- \n -->
Search for a text string in the tumor name box is conducted against tumor name and synonym records.', CAPTION, 'Tumor Name');" onmouseout="return nd();">Tumor Name</a>:</strong>

<!-- \n -->

contains <html:text property="tumorName" size="30" maxlength="255"/>
	</td>
		</tr>
			<tr>
				<td>
					<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field is used to distinguish tumors that arose under particular treatment conditions from those that arose spontaneously.
<!-- \n -->

<!-- \n -->
Treatment type offers a means to search for tumors induced by agents falling under a shared classification (based on source/mechanism of action).
<!-- \n -->

<!-- \n -->
The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Treatment Type');" onmouseout="return nd();">Treatment Type</a>:</strong>

<!-- \n -->

<html:select property="agentType">
	<html:option value="">ANY</html:option>
		<html:options collection="agentTypes" property="value" labelProperty="label"/>
			</html:select>
				</td>
					</tr>
						<tr>
							<td>
								<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Agents are the specific chemicals, drugs, types of radiation, etc. which were given to the mice.
<!-- \n -->

<!-- \n -->
Examples of possible agents:<ul><li>1-methyl-1-nitrosourea (MNU)</li><li>12-O-tetradecanoylphorbol-13-acetate (TPA)</li><li>angiostatin</li><li>benzo[a]pyrene (BP) (BaP) (B[a]P)</li><li>estrogen</li><li>testosterone</li><li>gamma-radiation</li><li>MMTV (mouse mammary tumor virus)</li></ul>', CAPTION, 'Treatment Agent');" onmouseout="return nd();">Treatment Agent</a>:</strong>

<!-- \n -->

contains <html:text property="agent" size="30" maxlength="255"/>
	</td>
		</tr>

<tr>
	<td>
		<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Used to search for tumors that have been reported to metastasize to a particular organ.
<!-- \n -->

<!-- \n -->
First choose the <em>Restrict search to metastasis tumors only</em> then select an organ from the <em>Metastasizes to the</em> menu.', CAPTION, 'Metastasis');" onmouseout="return nd();">Metastasis</a>:</strong>

<!-- \n -->

<html:checkbox property="metastasisLimit"/> Restrict search to metastatic tumors only. 

<!-- \n -->

<table>
	<tr>
		<td align="right" width="200">
			Metastasizes to the:
				</td>
					<td>
						<html:select property="organTissueAffected" size="8" multiple="true">
							<html:option value="">ANY</html:option>
								<html:options collection="organTissueValuesMets" property="value" labelProperty="label"/>
									</html:select>
										</td>
											</tr>
												</table>
										</td>
								</tr>
								<tr>
									<td>
										<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Pathology images (histology photomicrographs) of the tumor.
<!-- \n -->

<!-- \n -->
To search for tumor records associated with Pathology images, choose the box next to <em>Restrict search to entries with associated pathology images</em>.', CAPTION, 'Pathology Images');" onmouseout="return nd();">Pathology Images</a>:</strong>

<!-- \n -->

<html:checkbox property="mustHaveImages"/> Restrict search to entries with associated pathology images.
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

