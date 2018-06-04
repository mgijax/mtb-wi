<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Search Form" help="strains">
	<html:form action="strainSearchResults" method="GET">
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
							<html:radio property="sortBy" value="name">Strain Name</html:radio>  
							<html:radio property="sortBy" value="type">Strain Type</html:radio>
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
				Strain
			</td>
			<td>
				<table>
					<tr>
						<td>
							<a data-tip="Strain names in MTB, where possible, follow the international nomenclature guidelines for the naming of laboratory mouse strains.">Strain Name:</a>
							<!-- \n -->
							<html:select property="likeClause">
							<html:option value="Contains"> Contains </html:option>
							<html:option value="Begins"> Begins </html:option>
							<html:option value="Equals"> Equals </html:option>
							</html:select>
							<html:text property="strainName" size="30" maxlength="255"/>
							<%--
							<html:checkbox property="caseSensitive" value="1"/>Case Sensitive
							--%>
						</td>
					</tr>
					<tr>
						<td>
							<a data-tip="Indicates method of strain derivation.&#10;The values for these fields are selected from lists of controlled vocabulary terms.">Strain Type:</a>
						<!-- \n -->
						<html:select property="strainTypes" size="8" multiple="true">
						<html:option value="">ANY</html:option>
						<html:options collection="strainTypeValues" property="value" labelProperty="label"/>
						</html:select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Genetics
		</td>
		<td>
			<table>
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
		Other Database Links
	</td>
	<td>
		<table>
			<tr>
				<td>
					Search for strain records with <a data-tip="You can restrict your search for strains that were obtained from the JAX&reg;Mice or NCI Mouse Repositories.">outside links</a> to:
					<!-- \n -->
					<table>
						<tr>
							<td>
								<html:checkbox property="siteJaxMice"/>JAX<sup>&reg;</sup>Mice &nbsp; &nbsp; <a data-tip="A serial stock number assigned to strains sold by The Jackson Laboratory.&#10;Users interested in a specific strain of mouse that is offered through The Jackson Laboratorys JAX Research Systems can query by the stock number of that mouse.">Stock No.</a>:<html:text property="jaxStockNumber" size="6" maxlength="10"/>
							<!-- \n -->
							<html:checkbox property="siteNCIMR"/>NCI Mouse Repository
						</td>
					</tr>
				</table>
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

