<%@ page language="java" contentType="text/html" %>
<form action="quickSearchResults.do" method="GET">
	<select id="search-type" name="quickSearchSections">
		<option value="any" data-ph="Tumor, organ, strain, gene, or allele" selected="selected">Any</option>
		<option value="tumor" data-ph="Classification or name">Tumor</option>
		<option value="organ" data-ph="Organ or tissue">Organ</option>
		<option value="strain" data-ph="Name or type">Strain</option>
		<option value="genetics" data-ph="Gene symbol, allele, or mutation">Genetics</option>
	</select>
	<input id="search-term" name="quickSearchTerm" type="text">
	<input type="submit" value="&#xf002;">
</form>
