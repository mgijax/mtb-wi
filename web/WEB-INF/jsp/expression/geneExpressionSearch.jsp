<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Gene Expression Data Set Search Form" help="geneexpression">
	<html:form action="geneExpressionSearchResults" method="GET">
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
				</table>
			</td>
		</tr>
		<tr>
			<td>
				Search Criteria
			</td>
			<td>
				<table>
					<tr>
						<td>
							<dl class="tip"><dt>Organ</dt><dd>Organ
								<!-- \n -->
						The value for this field is selected from a list of controlled vocabulary terms.</dd></dl>:
						<!-- \n -->
						<html:select property="organ" size="8" multiple="true">
						<html:option value="">ANY</html:option>
						<html:options collection="organValues" property="value" labelProperty="label"/>
						</html:select>
					</td>
				</tr>
				<tr>
					<td>
						<dl class="tip"><dt>Tumor Classification</dt><dd>The value for this field is selected from a list of controlled vocabulary terms.
							<!-- \n -->
							<!-- \n -->
					This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.</dd></dl>:
					<!-- \n -->
					<html:select property="tumorClassification" size="8" multiple="true">
					<html:option value="">ANY</html:option>
					<html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
					</html:select>
				</td>
			</tr>
			<tr>
				<td>
					<dl class="tip"><dt>Strain Name:</dt><dd>Strain names in MTB, where possible, follow the international nomenclature guidelines for the naming of laboratory mouse strains.</dd></dl>
					<!-- \n -->
					<html:select property="likeClause">
					<html:option value="Contains"> Contains </html:option>
					<html:option value="Begins"> Begins </html:option>
					<html:option value="Equals"> Equals </html:option>
					</html:select>
					<html:text property="strainName" size="30" maxlength="255"/>
				</td>
			</tr>
			<tr>
				<td>
					<dl class="tip"><dt>Platform</dt><dd>Platforms.</dd></dl>:
					<!-- \n -->
					<html:select property="platform" size="8" multiple="true">
					<html:option value="">ANY</html:option>
					<html:options collection="platformValues" property="value" labelProperty="label"/>
					</html:select>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Note</strong>: Searching with criteria from more than one category may produce zero results.
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

