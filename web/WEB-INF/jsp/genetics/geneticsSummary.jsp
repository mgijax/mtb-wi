<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Genetic Change Summary" help="geneticchange">
	<table class="results">
		<!-- ////  Start Genetics Summary Header  //// -->
		<tr>
			<td><h4>Gene Symbol</h4></td>
			<td>
				<c:out value="${genetics.geneSymbol}" escapeXml="false"/>
			</td>
		</tr>
		<tr>
			<td><h4>Gene Name</h4></td>
			<td>
				<c:out value="${genetics.geneName}" escapeXml="false"/>
			</td>
		</tr>
		<tr>
			<td><h4>Mouse Chromosome</h4></td>
			<td>
				<c:out value="${genetics.mouseChromosome}" escapeXml="false"/>
			</td>
		</tr>
		<tr>
			<td><h4>Genetic Change Type</h4></td>
			<td>
				<c:out value="${genetics.geneticChangeTypeName}" escapeXml="false"/>
			</td>
		</tr>
	</table>
	<!-- ////  End Genetics Summary Header  //// -->
	<!-- \n -->
	<!-- ////  Start Search Results List  //// -->
	<c:choose>
	<c:when test="${not empty genetics.alleleRecs}">
	<table class="results">
		<tr class="results">
			<th>Mutation Location</th>
			<th>Tumor Name</th>
			<th>Treatment Type</th>
			<th>Number of Associated Tumor Frequencies</th>
		</tr>
		<c:set var="names" value="${genetics.names}"/>
		<c:set var="mutationSymbols" value="${genetics.mutationSymbols}"/>
		<c:set var="counter" value="0"/>
		<c:set var="items" value="0"/>
		<c:forEach var="rec" items="${genetics.alleleRecs}" varStatus="status">
		<c:set var="key" value="${rec.key}"/>
		<c:set var="counter" value="${counter+1}"/>
		<c:choose>
		<c:when test="${status.index%2==0}">
		<c:set var="classVal" value="stripe1"/>
		</c:when>
		<c:otherwise>
		<c:set var="classVal" value="stripe2"/>
		</c:otherwise>
		</c:choose>
		<tr class="${classVal}">
			<c:choose>
			<c:when test="${fn:length(rec.value.recsCollection)>1}">
			<td rowspan="${fn:length(rec.value.recsCollection)}">
				${mutationSymbols[key]}
				<c:if test="${not empty names[key]}">
				<!-- \n -->
				<span size="-2"><em>${names[key]}</em></span>
				</c:if>
			</td>
			</c:when>
			<c:otherwise>
			<td>
				${mutationSymbols[key]}
				<c:if test="${not empty names[key]}">
				<!-- \n -->
				<span size="-2"><em>${names[key]}</em></span>
				</c:if>
			</td>
			</c:otherwise>
			</c:choose>
			<c:forEach var="subRec" items="${rec.value.recsCollection}" varStatus="status">
			<c:if test="${status.index!=0}">
			<tr class="${classVal}">
				</c:if>
				<c:set var="items" value="${items + 1}"/>
				<td>${subRec.tumorName}</td>
				<td>${subRec.agentType}</td>
				<td>(<a href="tumorSearchResults.do?allelePairKey=${subRec.allelePairKey}&amp;organTissueOrigin=${subRec.organKey}&amp;tumorClassification=${subRec.tumorClassificationKey}&amp;agentType=${subRec.agentTypeKey}&amp;maxItems=No+Limit">${subRec.count}</a>)</td>
			</tr>
			</c:forEach>
			</c:forEach>
		</table>
		<%--
		<pre>
			+---------------------+
			Debug Information
			+---------------------+
			Rows: ${counter}
			Total Items: ${items}
			+---------------------+
		</pre>
		--%>
		</c:when>
		<c:otherwise>
		No summary information found.
		</c:otherwise>
		</c:choose>
		<!-- ////  End Search Results List  //// -->
	</jax:mmhcpage>
	
