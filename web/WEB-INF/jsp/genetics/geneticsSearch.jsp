<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain and Tumor Genetics Search Form" help="genetics">
	<jax:searchform action="geneticsSearchResults" sortby="Gene Symbol,Mutation Type,Chromosome">
	<fieldset>
		<legend>Strain and Tumor Genetics</legend>
		<fieldset>
			<legend data-tip="This field offers a text based search against Marker Symbol, Name and Synonym records. If a gene of interest is not found on the list please check the Mouse Genome Database to ensure that the gene symbol and name you are searching for is current.">Gene/Marker</legend>
			<html:select property="markerNameComparison">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins </html:option>
			<html:option value="Equals"> Equals </html:option>
			</html:select>
			<html:text property="markerName" size="20" maxlength="50"/>
		</fieldset>
		<fieldset>
			<legend data-tip="If a gene of interest is not found on the list please check the Mouse Genome Database to ensure that the gene symbol and name you are searching for is current.">Allele</legend>
			<html:select property="alleleNameComparison">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins </html:option>
			<html:option value="Equals"> Equals </html:option>
			</html:select>
			<html:text property="alleleName" size="20" maxlength="50"/>
		</fieldset>
		<fieldset>
			<legend data-tip="The type of mutation, chromosomal aberration, or other genetic change observed in the strain and/or in the tumor tissue. The values for type of genetic change are selected from a controlled vocabulary list.">Mutations/Aberrations</legend>
			<html:select property="alleleGroupType" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="alleleGroupTypeValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend data-tip="Chromosome number an allele is found on. This search is used to find allele records associated with a specific chromosome number using a pick list.">Chromosome</legend>
			<html:select property="chromosome" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="chromosomeValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<fieldset>
			<legend data-tip="Some cytogenetic records include assay images selecting this check box will return only cytognetic records with assay images.">Assay Images</legend>
			<html:checkbox property="assayImages">Restrict search to entries with associated assay images. </html:checkbox>
		</fieldset>
	</fieldset>	
	</jax:searchform>
</jax:mmhcpage>

