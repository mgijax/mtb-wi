<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Search Form" help="strains">
	<jax:searchform action="strainSearchResults" sortby="Strain Name[name],Strain Type[type]">
	<fieldset>
		<legend>Strain</legend>
		<fieldset>
			<legend data-tip="Strain names in MTB, where possible, follow the international nomenclature guidelines for the naming of laboratory mouse strains.">Strain Name:</legend>
			<html:select property="likeClause">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins </html:option>
			<html:option value="Equals"> Equals </html:option>
			</html:select>
			<html:text property="strainName" size="30" maxlength="255"/>
			<%--
			<html:checkbox property="caseSensitive" value="1"/>Case Sensitive
			--%>
		</fieldset>
		<fieldset>
			<legend data-tip="Indicates method of strain derivation.&#10;The values for these fields are selected from lists of controlled vocabulary terms.">Strain Type:</legend>
			<!-- \n -->
			<html:select property="strainTypes" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="strainTypeValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
	</fieldset>
	<fieldset>
		<legend>Genetics</legend>
		<fieldset>
			<legend data-tip="This field offers a text based search for strains with known germline genotype at specific genes/loci.&#10;This field searches Gene symbols, Gene names, and synonyms. The default operator for this search is CONTAINS.&#10;If you have difficulty locating records of interest, you may want to consult the Mouse Genome Database to ensure that the search string is appropriate for the gene/locus of interest.">Gene or Allele:</legend>
			<html:text property="geneticName" size="30" maxlength="255"/> <em>(Symbol/Name/Synonym)</em>
		</fieldset>
	</fieldset>
	<fieldset>
		<legend>Other Database Links</legend>
		<fieldset>
			<legend data-tip="You can restrict your search for strains that were obtained from the JAX&reg;Mice or NCI Mouse Repositories.">Search for strain records with outside links to</legend>
			<html:checkbox property="siteJaxMice"/>JAX<sup>&reg;</sup>Mice &nbsp; &nbsp; <a data-tip="A serial stock number assigned to strains sold by The Jackson Laboratory.&#10;Users interested in a specific strain of mouse that is offered through The Jackson Laboratorys JAX Research Systems can query by the stock number of that mouse.">Stock No.</a>:<html:text property="jaxStockNumber" size="6" maxlength="10"/>
			<html:checkbox property="siteNCIMR"/>NCI Mouse Repository
		</fieldset>
	</fieldset>	
	</jax:searchform>
</jax:mmhcpage>
