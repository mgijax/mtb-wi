<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Pathology Image Search Form">
	<jax:searchform action="pathologyImageSearchResults" sortby="Organ of origin[organ],Strain of origin[strain],Method[method],Antibody[antibody]" maxitems="5,10,100">
	<fieldset>
		<legend>Tumors</legend>
		<fieldset>
			<legend data-tip="The specific organ (or tissue) in which tumor cells originate.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Organ/Tissue of Origin</legend>
			<html:select property="organTissueOrigin" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="organsOfOrigin" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>			
			<legend data-tip="The value for this field is selected from a list of controlled vocabulary terms.&#10;This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.">Tumor Classification</legend>
			<html:select property="tumorClassification" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="tumorClassifications" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend data-tip="The organ (or tissue) in which tumor cells are found.&#10;The organ/tissue affected by a tumor can be different than the organ/tissue of tumor origin when there is a metastatic event or if the original tumor is transplanted into a different mouse.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Organ/Tissue Affected</legend>
			<html:select property="organTissueAffected" size="8" multiple="false">
			<html:option value="">ANY</html:option>
			<html:options collection="organsAffected" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
	</fieldset>
	<fieldset>
		<legend>Image</legend>
		<%--
		<fieldset>
			<legend data-tip="This field offers a text based search against the diagnosis and description fields associated with a Pathological record.">Diagnosis or Description</legend>
			contains
			<html:text property="diagnosisDescription" size="40" maxlength="50"/>
		</fieldset>
		--%>
		<fieldset>
			<legend data-tip="This field searches for specific histological procedures from a select list of procedures.">Stain / Method</legend>
			<html:select property="method">
			<html:option value="">ANY</html:option>
			<html:options collection="methods" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend data-tip="This field searches for antibodies used in staining procedures.&#10;Searches are conducted from a list of antibody names which include clone numbers, when available.">Antibody</legend>
			<html:select property="antibody" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="antibodies" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
	</fieldset>	
	</jax:searchform>			
</jax:mmhcpage>
