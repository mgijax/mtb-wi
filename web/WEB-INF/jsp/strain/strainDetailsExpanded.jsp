<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Strain Tumor Overview (Expanded View)" help="straindetail">

<table class="results">

<tr>
	<td class="cat-1">
		Strain
			</td>
				<td class="data-1">
					<table>
						<tr>
							<td width="70%">
								<table>
									<tr>
										<td class="enhance" colspan="2"><c:out value="${strain.name}" escapeXml="false"/></td>
											</tr>

<!-- ////  Start Strain Synonyms  //// -->

<c:choose>
	<c:when test="${not empty strain.synonyms}">
		<tr>
			<td class="label">Strain Synonyms</td>
				<td>
					<c:forEach var="synonym" items="${strain.synonyms}" varStatus="status">
						<c:out value="${synonym.name}" escapeXml="false"/>
							<c:if test="${status.last != true}">
								&nbsp;&#8226;&nbsp;
									</c:if>
										</c:forEach>
											</td>
												</tr>
													</c:when>
														<c:otherwise>
															<!-- There are no synonyms associated with this strain. -->
														</c:otherwise>
														</c:choose>

<c:if test="${not empty strain.description}">
	<tr>
		<td class="label">Strain Note: </td>
			<td>${strain.description}</td>
				</tr>
					</c:if>
						</table>
							</td>
								<td width="30%" align="right">
									<a href="strainDetails.do?page=collapsed&amp;key=${strain.strainKey}">Strain Tumor Overview Collapsed View</a>
										</td>
								</tr>
						</table>
				</td>
		</tr>

<!-- ////  End Strain Header  //// -->
	<c:set var="num" value="1"/>

<!-- ////  Start Strain Tumors  //// -->

<c:choose>
	<c:when test="${not empty strain.tumors}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Tumors</h4></td>
				<td class="data${num}">
	<c:set var="statsBean" value="${strain.tumorStats}"/>
		${statsBean.label} unique tumor sub-types displayed. <!-- representing ${statsBean.value} tumor detail records. -->

<!-- \n -->

<!-- \n -->

<em>A tumor sub-type is a set of tumors that share the same tumor name, organ affected, treatment agent, and metastatic status/localization.</em>

<!-- \n -->

<!-- \n -->

<table class="results">
	<tr>
		<td class="header-label">Tumor Name</td>
			<td class="header-label">Organ(s) Affected</td>
				<td class="header-label">Treatment Type
<!-- \n -->
<span size="-2"><em>Agents</em></span></td>
	<td class="header-label-small">Metastasizes
<!-- \n -->
To</td>
	<td class="header-label">References</td>
		<td class="header-label">Number of
<!-- \n -->
Tumor Sub-type Records</td>
	<td class="header-label">Frequency Range</td>
		</tr>
			<c:forEach var="tumor" items="${strain.tumors}" varStatus="status">
				<c:choose>
					<c:when test="${status.index%2==0}">
						<tr>
							</c:when>
								<c:otherwise>
									<tr>
										</c:otherwise>
											</c:choose>
												<td width="250"><c:out value="${tumor.tumorName}" escapeXml="false"/></td>
													<td><c:out value="${tumor.organAffectedName}" escapeXml="false"/></td>
														<td width="200">
															<c:out value="${tumor.treatmentType}" escapeXml="false"/>
																<c:if test="${not empty tumor.agents}">

<!-- \n -->

<span size="-2"><em>
	<c:forEach var="agent" items="${tumor.agents}" varStatus="status">
		<c:out value="${agent}" escapeXml="false"/>
			<c:if test="${status.last != true}">

<!-- \n -->

</c:if>
	</c:forEach>
		</em></span> 
			</c:if>
				</td>
					<td>
						<c:choose>
							<c:when test="${not empty tumor.metastasizesToDisplay}">
								<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
									${organ}
										<c:if test="${status.last != true}">

<!-- \n -->

</c:if>
	</c:forEach>
		</c:when>
			<c:otherwise>

</c:otherwise>
	</c:choose>
		</td>
			<td>
				<c:choose>
					<c:when test="${not empty tumor.sortedRefAccIds}">
						<c:forEach var="ref" items="${tumor.sortedRefAccIds}" varStatus="status">
							<a href="referenceDetails.do?accId=${ref}">${ref}</a>
								<c:if test="${status.last != true}">

<!-- \n -->

</c:if>
	</c:forEach>
		</c:when>
			<c:otherwise>

</c:otherwise>
	</c:choose>
		</td>
			<td>
				 <a href="tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}">${tumor.numberTFRecords}</a>
					</td>
						<td><c:out value="${tumor.freqAllString}" escapeXml="false"/></td>
							</tr>
								</c:forEach>
								</table>
						</td>
				</tr>
		</c:when>
		<c:otherwise>
			<!-- There is no tumor information associated with this strain. -->
		</c:otherwise>
		</c:choose>

<!-- ////  End Strain Tumors  //// -->

<!-- ////  Start Other Database Links  //// -->

<c:choose>
	<c:when test="${not empty strain.links || not empty strain.linksGeneral}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Other Database Links</h4></td>
				<td class="data${num}">

<table class="results">
	<c:choose>
		<c:when test="${not empty strain.links}">
			<tr>
				<td class="header-label" colspan=2><strong>Additional information about these mice:</strong></td>
					</tr>
						<c:forEach var="link" items="${strain.links}" varStatus="status">
							<c:choose>
								<c:when test="${status.index%2==0}">
									<tr>
										</c:when>
											<c:otherwise>
												<tr>
													</c:otherwise>
														</c:choose>
														<%--
														<td><a href="${link.siteUrl}" target="${link.siteName}"><c:out value="${link.siteName}" escapeXml="false"/></a></td>
														--%>
														<td><c:out value="${link.siteName}" escapeXml="false"/></td>
														<td><a href="${link.accessionUrl}" target="${link.siteName}"><c:out value="${link.accessionUrl}" escapeXml="false"/></a></td>
														</tr>
												</c:forEach>
										</c:when>
										<c:otherwise>
											<!-- There are is no additional information associated with this strain. -->
										</c:otherwise>
										</c:choose>

<c:choose>
	<c:when test="${not empty strain.linksGeneral}">
		<tr>
			<td class="header-label" colspan=2><strong>Information about mice carrying the same mutant allele(s):</strong></td>
				</tr>
					<c:forEach var="linkGeneral" items="${strain.linksGeneral}" varStatus="status">
						<c:choose>
							<c:when test="${status.index%2==0}">
								<tr>
									</c:when>
										<c:otherwise>
											<tr>
												</c:otherwise>
													</c:choose>

<td><a href="${linkGeneral.siteUrl}" target="${linkGeneral.siteName}"><c:out value="${linkGeneral.siteName}" escapeXml="false"/></a></td>
	<td><a href="${linkGeneral.accessionUrl}" target="${linkGeneral.siteName}"><c:out value="${linkGeneral.accessionUrl}" escapeXml="false"/></a></td>
		</tr>
			</c:forEach>
				</c:when>
					<c:otherwise>
						<!-- There are no other database links associated with this strain. //-->
							</c:otherwise>
								</c:choose>
								</table>
						</td>
				</tr>
		</c:when>
		<c:otherwise>
			<!-- There are no other database links associated with this strain. -->
		</c:otherwise>
		</c:choose>

<!-- ////  End Other Database Links  //// -->

</table>

<!-- ////  End Detail Section  //// -->

</jax:mmhcpage>

