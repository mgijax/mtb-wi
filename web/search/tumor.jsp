<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<fieldset>
	<legend>Tumor</legend>
	<fieldset>
		<legend data-tip="Organ of origin, tumor classification, organ affected, tumor synonym, or common name.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Tumor name</legend>
		<html:select property="tumorName" size="8" multiple="true" styleClass="term">
		<html:option value="">ANY</html:option>
		<html:options collection="organTissueValues" property="value" labelProperty="label"/>
		<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
		</html:select>			
	</fieldset>
	<fieldset>
		<legend data-tip="This field is used to distinguish tumors that arose under particular treatment conditions from those that arose spontaneously.&#10;Treatment type offers a means to search for tumors induced by agents falling under a shared classification (based on source/mechanism of action).&#10;The value for this field is selected from a list of controlled vocabulary terms.">Treatment Type</legend>:
		<html:select property="agentType" styleClass="term">
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
		<html:checkbox property="metastasisLimit"/> Has metastases
	</fieldset>
	<fieldset>
		<legend class="tip">Pathology Images</legend>
		<div role="tooltip"><p>Pathology images (histology photomicrographs) of the tumor.<p></p>To search for tumor records associated with Pathology images, choose the box next to <em>Restrict search to entries with associated pathology images</em></p></div>
		<html:checkbox property="mustHaveImages"/> Restrict search to entries with associated pathology images.
	</fieldset>
</fieldset>
