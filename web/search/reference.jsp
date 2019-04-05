<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<fieldset>
	<legend>Reference</legend>
	<fieldset>
		<legend data-tip="Search title, abstract, and indexed lesions.">Text</legend>
		<html:select property="titleComparison">
		<html:option value="Contains"> Contains </html:option>
		<html:option value="Begins"> Begins </html:option>
		</html:select>  
		<html:text property="title" size="40" maxlength="255"/>
	</fieldset>		
	<fieldset>
		<legend data-tip="Conducts a text string search against first author names.">Author</legend>
		<html:select property="firstAuthorComparison">
		<html:option value="Contains"> Contains </html:option>
		<html:option value="Begins"> Begins </html:option>
		<html:option value="Equals"> Equals </html:option>
		</html:select>  
		<html:text property="firstAuthor" size="40" maxlength="255"/>
	</fieldset>
<!--
	<fieldset>
		<legend data-tip="Conducts a text string search against all author names.">Authors</legend>
		contains <html:text property="authors" size="40" maxlength="255"/>
	</fieldset>
-->
	<fieldset>
		<legend data-tip="Text string search against the abbreviated name of the journal in which the published reference appears.">Journal</legend>
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
			<legend data-tip="Conducts a text string search for the volume of a journal in which an article was published.">Volume</legend>
			<html:text property="volume" size="10" maxlength="20"/>
		</fieldset>
		<fieldset>
			<legend data-tip="Conducts a text string search for the BEGINNING page number of a journal article.">Page</legend>
			<html:text property="pages"	size="10" maxlength="20"/>
		</fieldset>
	</fieldset>
</fieldset>
