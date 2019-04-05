<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Gene Expression Data Set Search Form" help="geneexpression">
	<jax:searchform action="geneExpressionSearchResults">
	<fieldset>
		<legend>Search Criteria</legend>		
		<fieldset>
			<legend data-tip="The value for this field is selected from a list of controlled vocabulary terms.">Organ</legend>
			<html:select property="organ" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="organValues" property="value" labelProperty="label"/>
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
			<legend data-tip="Strain names in MTB, where possible, follow the international nomenclature guidelines for the naming of laboratory mouse strains.">Strain Name</legend>
			<html:select property="likeClause">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins </html:option>
			<html:option value="Equals"> Equals </html:option>
			</html:select>
			<html:text property="strainName" size="30" maxlength="255"/>
		</fieldset>
		<fieldset>
			<legend data-tip="Platforms.">Platform</legend>
			<html:select property="platform" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="platformValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<p><strong>Note</strong>: Searching with criteria from more than one category may produce zero results.</p>
	</fieldset>	
	</jax:searchform>
</jax:mmhcpage>

