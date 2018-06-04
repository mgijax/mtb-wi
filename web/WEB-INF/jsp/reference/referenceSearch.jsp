<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Search Form" help="references">
	<jax:searchform action="referenceSearchResults" sortby="Year[year desc],First Author[primaryAuthor]">
	<fieldset>
		<legend>Reference</legend>
		<fieldset>
			<legend data-tip="Conducts a text string search against first author names.">First Author</legend>
			<html:select property="firstAuthorComparison">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins </html:option>
			<html:option value="Equals"> Equals </html:option>
			</html:select>  
			<html:text property="firstAuthor" size="40" maxlength="255"/>
		</fieldset>
		<fieldset>
			<legend data-tip="Conducts a text string search against all author names.">Authors</legend>
			contains <html:text property="authors" size="40" maxlength="255"/>
		</fieldset>
		<fieldset>
			<legend data-tip="Text string search against the abbreviated name of the journal in which the published reference appears.">Journal</legend>:
			<html:select property="journalComparison">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins </html:option>
			<html:option value="Equals"> Equals </html:option>
			</html:select>  
			<html:text property="journal" size="40" maxlength="255"/>
		</fieldset>
		<fieldset>
			<fieldset>
				<legend data-tip="Conducts a text string search for publication year.">Year</legend>
				<html:select property="yearComparison">
				<html:option value="="> Equals </html:option>
				<html:option value=">"> Greater Than </html:option>
				<html:option value="<"> Less Than </html:option>
				</html:select>  
				<html:text property="year" size="5" maxlength="4"/>
			</fieldset>
			<fieldset>
				<legend data-tip="Conducts a text string search for the volume of a journal in which an article was published.">Volume</legend>:
				<html:text property="volume" size="10" maxlength="20"/>
			</fieldset>
			<fieldset>
				<legend data-tip="Conducts a text string search for the BEGINNING page number of a journal article.">Page</legend>
				<html:text property="pages"	size="10" maxlength="20"/>
			</fieldset>
		</fieldset>
		<fieldset>
			<legend data-tip="Conducts a text string search for an article title.">Title</legend>
			<html:select property="titleComparison">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins </html:option>
			</html:select>  
			<html:text property="title" size="40" maxlength="255"/>
		</fieldset>
	</fieldset>
	<!--
	<fieldset>
		<legend>Tumor Type</legend>
		<fieldset>
			<legend> data-tip="The specific organ (or tissue) in which tumor cells originate.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Organ/Tissue of Origin</legend>:
			<html:select property="organTissue" size="5" >
			<html:option value="">ANY</html:option>
			<html:options collection="organTissueValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend data-tip="The value for this field is selected from a list of controlled vocabulary terms.&#10;This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.">Tumor Classification</legend>:
			<html:select property="tumorClassification" size="5" >
			<html:option value="">ANY</html:option>
			<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
	</fieldset>
	--> 
	</jax:searchform>
</jax:mmhcpage>
