<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Human Gene Search Form" help="humangene">
	<jax:searchform action="orthologySearch" sortby="Human Gene Symbol[HumanGS],Mouse Gene Symbol[MouseGS]">
	<fieldset>
		<legend>Human Genes</legend>
		<fieldset>
			<legend class="tip">Human Gene Symbol</legend>
			<div role="tooltip"><p>Entering human gene symbols, names or Entrez IDs returns a list of orthologous mouse symbols and associated data.</p><p>Entrez ID searches must use 'equals'.</p></div>			
			<html:select property="compare">
			<html:option value="Contains"> Contains </html:option>
			<html:option value="Begins"> Begins with </html:option>
			<html:option value="Equals"> Equals </html:option>
			<html:option value="Ends"> Ends with </html:option>
			</html:select>
			<html:textarea property="humanGS" rows="3" cols="50"/>
		</fieldset>
	</fieldset>	
	</jax:searchform>
	<c:set var="url" value="/orthologySearch.do?sortBy=HumanGS&compare=Equals&reference=" />
	<c:set var="asList" value="&asList=true" />
	
	<table>
		<caption>Sample references containing human cancer genes:</caption>
		<tbody>
			<c:forEach var="reference" items="${references}" >
			<tr>
				<td>${reference.authors}</td>
				<td>
					<c:if test="${not empty reference.url}">
					<a href="<c:url value='${reference.url}'/>">PubMed abstract</a>
					</c:if>
				</td>
			</tr>
			<tr>
				<td>
					<strong>${reference.title}</strong>,&nbsp;${reference.journal}&nbsp;${reference.year}
					<c:if test="${not empty reference.volume}">
					;${reference.volume}
					</c:if>
					<c:if test="${not empty reference.issue}">
					(${reference.issue})
					</c:if>
					<c:if test="${not empty reference.pages}">
					:${reference.pages}
					</c:if>
				</td>
				<td>
					<a href="<c:url value='${url}${reference.referenceKey}'/>">Search MTB using human genes from this paper</a>
				</td>
			</tr>
			<tr>
				<td>${reference.note}</td>
				<td>
					<a href="<c:url value='${url}${reference.referenceKey}${asList}'/>">List of human genes</a>
				</td>
			</tr>
			<tr><td colspan="2"><hr></td></tr>
			</c:forEach>
		</tbody>
	</table>
</jax:mmhcpage>
