<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Search Form" help="tumors">
	<jax:searchform action="tumorSearchResults" sortby="Organ of tumor origin[organ],Strain of tumor origin[strain]">
	<fieldset>
		<legend>Associated Tumors</legend>
		<fieldset>
			<legend data-tip="The specific organ (or tissue) in which tumor cells originate.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Organ/Tissue of Origin</legend>
			<html:select property="organTissueOrigin" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="organTissueValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend data-tip="The value for this field is selected from a list of controlled vocabulary terms.&#10;This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.">Tumor Classification</legend>
			<html:select property="tumorClassification" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend data-tip="This is a combination of the value from the Organ/Tissue of Origin field and the value from the Tumor Classification field.&#10;The default operator is CONTAINS.&#10;Search for a text string in the tumor name box is conducted against tumor name and synonym records.">Tumor Name</legend>
			contains <html:text property="tumorName" size="30" maxlength="255"/>
		</fieldset>
		<fieldset>
			<legend data-tip="This field is used to distinguish tumors that arose under particular treatment conditions from those that arose spontaneously.&#10;Treatment type offers a means to search for tumors induced by agents falling under a shared classification (based on source/mechanism of action).&#10;The value for this field is selected from a list of controlled vocabulary terms.">Treatment Type</legend>:
			<html:select property="agentType">
			<html:option value="">ANY</html:option>
			<html:options collection="agentTypes" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend class="tip">Treatment Agent</legend>
			<div role="tooltip"><p>Agents are the specific chemicals, drugs, types of radiation, etc. which were given to the mice.</p><p>Examples of possible agents:</p><ul><li>1-methyl-1-nitrosourea (MNU)</li><li>12-O-tetradecanoylphorbol-13-acetate (TPA)</li><li>angiostatin</li><li>benzo[a]pyrene (BP) (BaP) (B[a]P)</li><li>estrogen</li><li>testosterone</li><li>gamma-radiation</li><li>MMTV (mouse mammary tumor virus)</li></ul></div>
			contains <html:text property="agent" size="30" maxlength="255"/>
		</fieldset>
		<fieldset>
			<legend class="tip">Metastasis</legend>
			<div role="tooltip"><p>Used to search for tumors that have been reported to metastasize to a particular organ.</p><p>First choose the <em>Restrict search to metastasis tumors only</em> then select an organ from the <em>Metastasizes to the</em> menu.</p></div>
			<html:checkbox property="metastasisLimit"/> Restrict search to metastatic tumors only. 
			<fieldset>
				<legend>Metastasizes to the</legend>
				<html:select property="organTissueAffected" size="8" multiple="true">
				<html:option value="">ANY</html:option>
				<html:options collection="organTissueValuesMets" property="value" labelProperty="label"/>
				</html:select>
			</fieldset>
		</fieldset>
		<fieldset>
			<legend class="tip">Pathology Images</legend>
			<div role="tooltip"><p>Pathology images (histology photomicrographs) of the tumor.<p></p>To search for tumor records associated with Pathology images, choose the box next to <em>Restrict search to entries with associated pathology images</em></p></div>
			<html:checkbox property="mustHaveImages"/> Restrict search to entries with associated pathology images.
		</fieldset>
	</fieldset>	
	</jax:searchform>						
</jax:mmhcpage>
