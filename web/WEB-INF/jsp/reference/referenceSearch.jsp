<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Search Form" help="references">
	<html:form action="referenceSearchResults" method="GET">
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
							<html:radio property="sortBy" value="year desc">Year</html:radio>  
							<html:radio property="sortBy" value="primaryAuthor">First Author</html:radio>  
							<%--
							<html:radio property="sortBy" value="numericPart">J Number</html:radio>
							--%>
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
		<tr>
			<td>
				Reference
			</td>
			<td>
				<table>
					<tr>
						<td>
							<a data-tip="Conducts a text string search against first author names.">First Author</a>:
							<!-- \n -->
							<html:select property="firstAuthorComparison">
							<html:option value="Contains"> Contains </html:option>
							<html:option value="Begins"> Begins </html:option>
							<html:option value="Equals"> Equals </html:option>
							</html:select>  
							<html:text property="firstAuthor" size="40" maxlength="255"/>
						</td>
					</tr>
					<tr>
						<td>
							<a data-tip="Conducts a text string search against all author names.">Authors</a>:
							<!-- \n -->
							contains <html:text property="authors" size="40" maxlength="255"/>
						</td>
					</tr>
					<tr>
						<td>
							<a data-tip="Text string search against the abbreviated name of the journal in which the published reference appears.">Journal</a>:
							<!-- \n -->
							<html:select property="journalComparison">
							<html:option value="Contains"> Contains </html:option>
							<html:option value="Begins"> Begins </html:option>
							<html:option value="Equals"> Equals </html:option>
							</html:select>  
							<html:text property="journal" size="40" maxlength="255"/>
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td>
										<a data-tip="Conducts a text string search for publication year.">Year</a>:
										<!-- \n -->
										<html:select property="yearComparison">
										<html:option value="="> Equals </html:option>
										<html:option value=">"> Greater Than </html:option>
										<html:option value="<"> Less Than </html:option>
										</html:select>  
										<html:text property="year" size="5" maxlength="4"/>
									</td>
									<td width="30"></td>
									<td>
										<a data-tip="Conducts a text string search for the volume of a journal in which an article was published.">Volume</a>:
										<!-- \n -->
										<html:text property="volume" size="10" maxlength="20"/>
									</td>
									<td width="30"></td>
									<td>
										<a data-tip="Conducts a text string search for the BEGINNING page number of a journal article.">Page</a>:
									<!-- \n -->
									<html:text property="pages"	size="10" maxlength="20"/>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<a data-tip="Conducts a text string search for an article title.">Title</a>:
						<!-- \n -->
						<html:select property="titleComparison">
						<html:option value="Contains"> Contains </html:option>
						<html:option value="Begins"> Begins </html:option>
						</html:select>  
						<html:text property="title" size="40" maxlength="255"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<!--
	<tr>
		<td>
			Tumor Type
		</td>
		<td>
			<table>
				<tr>
					<td>
						<a data-tip="The specific organ (or tissue) in which tumor cells originate.&#10;The value for this field is selected from a list of controlled vocabulary terms.">Organ/Tissue of Origin</a>:
					<html:select property="organTissue" size="5" >
					<html:option value="">ANY</html:option>
					<html:options collection="organTissueValues" property="value" labelProperty="label"/>
					</html:select>
				</td>
			</tr>
			<tr>
				<td>
					<a data-tip="The value for this field is selected from a list of controlled vocabulary terms.&#10;This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.">Tumor Classification</a>:
				<html:select property="tumorClassification" size="5" >
				<html:option value="">ANY</html:option>
				<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
				</html:select>
			</td>
		</tr>
	</table>
</td>
</tr>
--> 
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

