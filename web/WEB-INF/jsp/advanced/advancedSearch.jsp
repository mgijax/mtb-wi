<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Advanced Search Form" help="advanced">
	<html:form action="advancedSearchResults" method="GET">
	<table>
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
							<h5 class="label">Sort By:</h5>
							<html:radio property="sortBy" value="tumorclassification">Tumor Classification</html:radio>  
							<html:radio property="sortBy" value="organ">Organ of tumor origin</html:radio>  
							<html:radio property="sortBy" value="strainname">Strain name</html:radio>  
							<html:radio property="sortBy" value="straintype">Strain Type</html:radio>  
							<html:radio property="sortBy" value="treatmenttype">Treatment Type</html:radio>
						</td>
					</tr>
					<tr>
						<td>
							<h5 class="label">Max number of items returned:</h5>
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
			<td>
				<h4>Strain / Genetics</h4>
			</td>
			<td>
				<table>
					<tr>
						<td>
							<a data-tip="Strain names in MTB, where possible, follow the international nomenclature guidelines for the naming of laboratory mouse strains.">Strain Name:</a>
								<!-- \n -->
								<html:select property="strainNameComparison">
								<html:option value="Contains"> Contains </html:option>
								<html:option value="Begins"> Begins </html:option>
								<html:option value="Equals"> Equals </html:option>
								</html:select>
								<html:text property="strainName" size="30" maxlength="255"/>
							</td>
						</tr>
						<tr>
							<td>
								<a data-tip="Indicates method of strain derivation.&#10;The values for these fields are selected from lists of controlled vocabulary terms.">Strain Type:</a>							<!-- \n -->
							<html:select property="strainTypes" size="8" multiple="true">
							<html:option value="">ANY</html:option>
							<html:options collection="strainTypeValues" property="value" labelProperty="label"/>
							</html:select>
						</td>
					</tr>
					<tr>
						<td>
							<a data-tip="This field offers a text based search for strains with known germline genotype at specific genes/loci.&#10;This field searches Gene symbols, Gene names, and synonyms. The default operator for this search is CONTAINS.&#10;If you have difficulty locating records of interest, you may want to consult the Mouse Genome Database to ensure that the search string is appropriate for the gene/locus of interest.">Gene or Allele:</a>							
							<html:text property="geneticName" size="30" maxlength="255"/> <em>(Symbol/Name/Synonym)</em>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<h4>Tumor</h4>
			</td>
			<td>
				<table>
					<tr>
						<td>
							<a data-tip="The specific organ (or tissue) in which tumor cells originate.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Organ/Tissue of Origin</a>:
								<html:select property="organTissueOrigin" size="8" multiple="true">
								<html:option value="">ANY</html:option>
								<html:options collection="organTissueValues" property="value" labelProperty="label"/>
								</html:select>
							</td>
						</tr>
						<tr>
							<td>
								<a data-tip="The value for this field is selected from a list of controlled vocabulary terms.&#10;This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.">Tumor Classification</a>:
							<html:select property="tumorClassification" size="8" multiple="true">
							<html:option value="">ANY</html:option>
							<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
							</html:select>
						</td>
					</tr>
					<tr>
						<td>
							<a data-tip="This field is used to distinguish tumors that arose under particular treatment conditions from those that arose spontaneously.&#10;Treatment type offers a means to search for tumors induced by agents falling under a shared classification (based on source/mechanism of action).&#10;The value for this field is selected from a list of controlled vocabulary terms.">Treatment Type</a>:
							<html:select property="agentType">
							<html:option value="">ANY</html:option>
							<html:options collection="agentTypes" property="value" labelProperty="label"/>
							</html:select>
						</td>
					</tr>
					<tr>
						<td>
							<a class="tip">Metastasis<div role="tooltip"><p>Used to search for tumors that have been reported to metastasize to a particular organ.</p><p>First choose the <em>Restrict search to metastasis tumors only</em> then select an organ from the <em>Metastasizes to the</em> menu.</p></div></a>:
							<html:checkbox property="metastasisLimit"/> Restrict search to metastatic tumors only. 
						</td>
					</tr>
					<tr>
						<td>
							<a class="tip">Pathology Images<div role="tooltip"><p>Pathology images (histology photomicrographs) of the tumor.</p><p> To search for tumor records associated with Pathology images, choose the box next to <em>Restrict search to entries with associated pathology images</em></p></div></a>:
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

