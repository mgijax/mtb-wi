<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Genetics">
	<!-- ////  Start Tumor Genetics Section  //// -->
	<c:choose>
	<c:when test="${not empty tumorFreq.tumorGenetics}">
	<table>
		<tr>
			<td colspan="5" class="results-header-left">
				<h3>Tumor Genetics</h3>
			</td>
		</tr>
		<tr>
			<th>Marker
				<!-- \n -->
			Symbol</th>
			<th>Marker
				<!-- \n -->
			Name</th>
			<th>Mouse
				<!-- \n -->
			Chromosome</th>
			<th>Mutation
				<!-- \n -->
			Types</th>
			<th>Genetic
				<!-- \n -->
			Change</th>
		</tr>
		<c:forEach var="genetics" items="${tumorFreq.tumorGenetics}" varStatus="status">
		<tr>
			<td>
				<c:choose>
				<c:when test="${not empty genetics.geneSymbol}">
				<c:choose>
				<c:when test="${fn:indexOf(genetics.geneSymbol, '+')<0}">
				<a href="redirect?key=${genetics.markerKey}&type=1" target="MGI"><c:out value="${genetics.geneSymbol}" escapeXml="false"/></a>
				</c:when>
				<c:otherwise>
				<c:out value="${genetics.geneSymbol}" escapeXml="false"/>
				</c:otherwise>
				</c:choose>
				</c:when>
				<c:otherwise>
				</c:otherwise>
				</c:choose>
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
			<td>
				<c:out value="${genetics.chromosome}" escapeXml="false"/>
			</td>
			<td>
				<c:out value="${genetics.alleleType}" escapeXml="false"/>
			</td>
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
	</c:when>
	<c:otherwise>
	<!-- No genetics for this frequency record //-->
	</c:otherwise>
	</c:choose>
	<!-- ////  End Tumor Genetics Section  //// -->
	<!-- Cytogenetics -->
	<c:choose>
	<c:when test="${not empty tumorFreq.tumorCytogenetics}">
	<table>
		<tr>
			<td colspan="6" class="results-header-left">
				<h3>Tumor Cytogenetics</h3>
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<th>Name</th>
			<th>Mouse
				<!-- \n -->
			Chromosome</th>
			<th>Mutation
				<!-- \n -->
			Types</th>
			<th>Assay
				<!-- \n -->
			Type</th>
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
					<c:choose>
					<c:when test="${not empty genetics.assayImages}">
					<c:forEach var="image" items="${genetics.assayImages}" varStatus="status2">
					<c:if test="${status2.first!=true}">
					<tr class="${rowClass}">
						</c:if>
						<td>																
							<table>
								<tr>
									<td width="160">
										<a href="assayImageDetails.do?key=${image.assayImagesKey}">
										<img width="150" src="${applicationScope.assayImageURL}/${applicationScope.assayImagePath}/${image.lowResName}"></a>
									</td>
									<td align="left">
										<table align="left">
											<tr>
												<td class="small" align="right"><strong>Image ID</strong>:</td>
												<td class="small">${image.assayImagesKey}</td>
											</tr>
											<tr>
												<td class="small" align="right"><strong>Source</strong>:</td>
												<td class="small">
													${image.createUser}
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td class="small" colspan=2>
										<strong>Image Caption</strong>:
										<!-- \n -->
										${image.caption}
									</td>
								</tr>
							</table>
						</td>
					</tr>
					</c:forEach>
					</c:when>
					<c:otherwise>
					</c:otherwise>
					</c:choose>
				</table>
			</td>
		</tr>
		</c:forEach>
	</table>
	</c:when>
	<c:otherwise>
	<!-- No genetics for this frequency record //-->
	</c:otherwise>
	</c:choose>
</jax:mmhcpage>




