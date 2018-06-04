<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Advanced Search Form" help="advanced">
	<jax:searchform action="advancedSearchResults" sortby="Tumor Classification[tumorclassification],Organ of tumor origin[organ],Strain name[strainname],Strain Type[straintype],Treatment Type[treatmenttype]">
	<fieldset>
		<legend>>Strain / Genetics</legend>
		<fieldset>
			<legend data-tip="Strain names in MTB, where possible, follow the international nomenclature guidelines for the naming of laboratory mouse strains.">Strain Name</legend>
			<html:select property="strainNameComparison">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins </html:option>
			<html:option value="Equals"> Equals </html:option>
			</html:select>
			<html:text property="strainName" size="30" maxlength="255"/>
		</fieldset>
		<fieldset>
			<legend data-tip="Indicates method of strain derivation.&#10;The values for these fields are selected from lists of controlled vocabulary terms.">Strain Type</legend>
			<html:select property="strainTypes" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="strainTypeValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend data-tip="This field offers a text based search for strains with known germline genotype at specific genes/loci.&#10;This field searches Gene symbols, Gene names, and synonyms. The default operator for this search is CONTAINS.&#10;If you have difficulty locating records of interest, you may want to consult the Mouse Genome Database to ensure that the search string is appropriate for the gene/locus of interest.">Gene or Allele</legend>							
			<html:text property="geneticName" size="30" maxlength="255"/> <em>(Symbol/Name/Synonym)</em>
		</fieldset>
	</fieldset>
	<fieldset>
		<legend>Tumor</legend>
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
			<legend data-tip="This field is used to distinguish tumors that arose under particular treatment conditions from those that arose spontaneously.&#10;Treatment type offers a means to search for tumors induced by agents falling under a shared classification (based on source/mechanism of action).&#10;The value for this field is selected from a list of controlled vocabulary terms.">Treatment Type</legend>
			<html:select property="agentType">
			<html:option value="">ANY</html:option>
			<html:options collection="agentTypes" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend class="tip">Metastasis</legend>
			<div role="tooltip"><p>Used to search for tumors that have been reported to metastasize to a particular organ.</p><p>First choose the <em>Restrict search to metastasis tumors only</em> then select an organ from the <em>Metastasizes to the</em> menu.</p></div>
			<html:checkbox property="metastasisLimit"/> Restrict search to metastatic tumors only. 
		</fieldset>
		<fieldset>
			<legend class="tip">Pathology Images</legend>
			<div role="tooltip"><p>Pathology images (histology photomicrographs) of the tumor.</p><p> To search for tumor records associated with Pathology images, choose the box next to <em>Restrict search to entries with associated pathology images</em></p></div>
			<html:checkbox property="mustHaveImages"/> Restrict search to entries with associated pathology images.
		</fieldset>
	</fieldset>
	</jax:searchform>
</jax:mmhcpage>

