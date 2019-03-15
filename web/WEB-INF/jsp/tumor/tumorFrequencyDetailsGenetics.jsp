<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<c:if test="${not empty tumorFreq.tumorGenetics}">
<table>
	<caption>Tumor Genetics</caption>
	<tr>
		<th>Marker Symbol</th>
		<th>Marker Name</th>
		<th>Mouse Chromosome</th>
		<th>Mutation Types</th>
		<th>Genetic Change</th>
	</tr>
	<c:forEach var="genetics" items="${tumorFreq.tumorGenetics}" varStatus="status">
	<tr>
		<td>
			<c:if test="${not empty genetics.geneSymbol}">
				<c:choose>
				<c:when test="${fn:indexOf(genetics.geneSymbol, '+')<0}">
					<a href="redirect?key=${genetics.markerKey}&type=1" target="MGI"><c:out value="${genetics.geneSymbol}" escapeXml="false"/></a>
				</c:when>
				<c:otherwise>
					<c:out value="${genetics.geneSymbol}" escapeXml="false"/>
				</c:otherwise>
				</c:choose>
			</c:if>
		</td>
		<td>
			<c:choose>
				<c:when test="${fn:containsIgnoreCase(genetics.geneName, 'placeholder')}">
				</c:when>
				<c:otherwise>
					<c:out value="${genetics.geneName}" escapeXml="false"/>
				</c:otherwise>
			</c:choose>
		</td>
		<td><c:out value="${genetics.chromosome}" escapeXml="false"/></td>
		<td><c:out value="${genetics.alleleType}" escapeXml="false"/></td>
		<td>
			<c:choose>
			<c:when test="${not empty genetics.allele1Symbol && not empty genetics.allele2Symbol}">
			<c:out value="${genetics.allele1Symbol} / ${genetics.allele2Symbol}" escapeXml="false"/>
			</c:when>
			<c:when test="${not empty genetics.allele1Symbol && empty genetics.allele2Symbol}">
			<c:out value="${genetics.allele1Symbol}"	 escapeXml="false"/>
			</c:when>
			<c:when test="${empty genetics.allele1Symbol && not empty genetics.allele2Symbol}">
			<c:out value="${genetics.allele2Symbol}"	escapeXml="false"/>
			</c:when>
			<c:otherwise>
			</c:otherwise>
			</c:choose>
		</td>
	</tr>
	</c:forEach>
</table>
</c:if>

<c:if test="${not empty tumorFreq.tumorCytogenetics}">
<table>
	<caption>Tumor Cytogenetics</caption>
	<tr>
		<th>Name</th>
		<th>Mouse Chromosome</th>
		<th>Mutation Types</th>
		<th>Assay Type</th>
		<th>Notes</th>
		<th>Images</th>
	</tr>
	<c:forEach var="genetics" items="${tumorFreq.tumorCytogenetics}" varStatus="status">
	<tr>
		<td>
			<c:out value="${genetics.name}" escapeXml="false"/>
		</td>
		<td>
			<c:out value="${genetics.displayChromosomes}" escapeXml="false"/>
		</td>
		<td>
			<c:out value="${genetics.alleleTypeName}" escapeXml="false"/>
		</td>
		<td>
			<c:out value="${genetics.assayType}" escapeXml="false"/>
		</td>
		<td>
			<c:out value="${genetics.notes}" escapeXml="false"/>
		</td>
		<td>
			<table>
				<c:if test="${not empty genetics.assayImages}">
				<c:forEach var="image" items="${genetics.assayImages}" varStatus="status2">
				<c:if test="${status2.first!=true}">
				<tr>
				</c:if>
				<td>																
					<table>
						<tr>
							<td>
								<a href="assayImageDetails.do?key=${image.assayImagesKey}">
								<img width="150" src="${applicationScope.assayImageURL}/${applicationScope.assayImagePath}/${image.lowResName}"></a>
							</td>
							<td>
								<table>
									<tr>
										<th>Image ID</th>
										<td>${image.assayImagesKey}</td>
									</tr>
									<tr>
										<th>Source</th>
										<td>${image.createUser}</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<strong>Image Caption</strong>:
								${image.caption}
							</td>
						</tr>
					</table>
				</td>
				</tr>
				</c:forEach>
				</c:if>

			</table>
		</td>
	</tr>
	</c:forEach>
</table>
</c:if>

