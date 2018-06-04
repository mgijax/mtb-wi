<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Pathology Image Search Form" help="pathology">
	<html:form action="pathologyImageSearchResults" method="GET">
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
							<html:radio property="sortBy" value="organ">Organ of origin</html:radio>  
							<html:radio property="sortBy" value="strain">Strain of origin</html:radio>  
							<html:radio property="sortBy" value="method">Method</html:radio>  
							<html:radio property="sortBy" value="antibody">Antibody</html:radio>
						</td>
					</tr>
					<tr>
						<td>
							<h5 class="label">Max number of pathology reports returned:</h5>
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
		<tr>
			<td>
				Tumors
			</td>
			<td>
				<table>
					<tr>
						<td>
							<a data-tip="The specific organ (or tissue) in which tumor cells originate.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Organ/Tissue of Origin</a>:
						<html:select property="organTissueOrigin" size="8" multiple="true">
						<html:option value="">ANY</html:option>
						<html:options collection="organsOfOrigin" property="value" labelProperty="label"/>
						</html:select>
					</td>
				</tr>
				<tr>
					<td>
						<a data-tip="The value for this field is selected from a list of controlled vocabulary terms.&#10;This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.">Tumor Classification</a>:
					<html:select property="tumorClassification" size="8" multiple="true">
					<html:option value="">ANY</html:option>
					<html:options collection="tumorClassifications" property="value" labelProperty="label"/>
					</html:select>
				</td>
			</tr>
			<tr>
				<td>
					<a data-tip="The organ (or tissue) in which tumor cells are found.&#10;The organ/tissue affected by a tumor can be different than the organ/tissue of tumor origin when there is a metastatic event or if the original tumor is transplanted into a different mouse.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Organ/Tissue Affected</a>:
				<html:select property="organTissueAffected" size="8" multiple="false">
				<html:option value="">ANY</html:option>
				<html:options collection="organsAffected" property="value" labelProperty="label"/>
				</html:select>
			</td>
		</tr>
	</table>
</td>
</tr>
<tr>
	<td>
		Image
	</td>
	<td>
		<table>
			<%--
			<tr>
				<td>
					<a data-tip="This field offers a text based search against the diagnosis and description fields associated with a Pathological record.">Diagnosis or Description</a>:
					<!-- \n -->
					contains &nbsp;
					<html:text property="diagnosisDescription" size="40" maxlength="50"/>
				</td>
			</tr>
			--%>
			<tr>
				<td>
					<a data-tip="This field searches for specific histological procedures from a select list of procedures.">Stain / Method</a>:
					<html:select property="method">
					<html:option value="">ANY</html:option>
					<html:options collection="methods" property="value" labelProperty="label"/>
					</html:select>
				</td>
			</tr>
			<tr>
				<td>
					<a data-tip="This field searches for antibodies used in staining procedures.&#10;Searches are conducted from a list of antibody names which include clone numbers, when available.">Antibody</a>:
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
</jax:mmhcpage>

