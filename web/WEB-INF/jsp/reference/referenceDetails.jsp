<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Detail" help="referencedetail">
	<table class="results">
		<!-- ////  Start Reference Detail //// -->
		<tr>
			<td class="cat-1">
				Reference
			</td>
			<td class="data-1">
				<table>
					<tr>
						<td class="label">Title: </td>
						<td >${reference.title}${reference.title2}</td>
					</tr>
					<tr>
						<td class="label">Authors: </td>
						<td >${reference.authors}${reference.authors2}</td>
					</tr>
					<tr>
						<td class="label">Journal: </td>
						<td >${reference.journal}</td>
					</tr>
					<tr>
						<td class="label">Volume: </td>
						<td >${reference.volume}</td>
					</tr>
					<tr>
						<td class="label">Issue: </td>
						<td >${reference.issue}</td>
					</tr>
					<%--
					<tr>
						<td class="label">Date: </td>
						<td >${reference.referenceDate}</td>
					</tr>
					//--%>
					<tr>
						<td class="label">Year: </td>
						<td >${reference.year}</td>
					</tr>
					<tr>
						<td class="label">Pages: </td>
						<td >${reference.pages}</td>
					</tr>
					<%--
					<tr>
						<td class="label">Review Status: </td>
						<td ><em>Not implemented.</em></td>
					</tr>
					--%>
					<tr>
						<td class="label">Abstract: </td>
						<td >${reference.abstractText}</td>
					</tr>
				</table>
			</td>
		</tr>
		<!-- ////  End Reference Detail  //// -->
		<!-- ////  Start Reference Additional Info  //// -->
		<c:set var="lbl" value="2"/>
		<c:choose>
		<c:when test="${not empty reference.additionalInfo}">
		<c:if test="${reference.hasAdditionalInfo}">
		<c:set var="lbl" value="${lbl+1}"/>
		<tr>
			<td class="cat${(lbl%2)+1}">Additional
				<!-- \n -->
				Information
				<!-- \n -->
			in MTB </td>
			<td class="data${(lbl%2)+1}">
				<table>
					<c:forEach var="info" items="${reference.additionalInfo}" varStatus="status">
					<c:choose>
					<c:when test="${info.label=='Tumor Records'}">
					<c:if test="${info.value!=0}">
					<tr><td>${info.label} (<a href="tumorSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td></tr>
					</c:if>
					</c:when>
					<c:when test="${info.label=='Strains'}">
					<c:if test="${info.value!=0}">
					<tr><td>${info.label} (<a href="strainSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td></tr>
					</c:if>
					</c:when>
					<c:when test="${info.label=='Pathology Images'}">
					<c:if test="${info.value!=0}">
					<tr><td>${info.label} (<a href="pathologyImageSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td></tr>
					</c:if>
					</c:when>
					<c:otherwise>
					<!-- ERROR //-->
					</c:otherwise>
					</c:choose>
					</c:forEach>
				</table>
			</td>
		</tr>
		</c:if>
		</c:when>
		<c:otherwise>
		<!-- There is no additional information in MTB associated with this reference. //-->
		</c:otherwise>
		</c:choose>
		<!-- ////  End Reference Additional Info  //// -->
		<!-- ////  Start Other Accession Ids  //// -->
		<c:choose>
		<c:when test="${not empty reference.otherAccessionIds}">
		<c:set var="lbl" value="${lbl+1}"/>
		<tr>
			<td class="cat${(lbl%2)+1}">Other
				<!-- \n -->
				Accession
				<!-- \n -->
			IDs</td>
			<td class="data${(lbl%2)+1}">
				<table>
					<c:forEach var="info" items="${reference.otherAccessionIds}" varStatus="status">
					<c:choose>
					<c:when test="${status.index%2==1}">
					<tr >
						</c:when>
						<c:otherwise>
						<tr >
							</c:otherwise>
							</c:choose>
							<td>
								${info.data}&nbsp; <a target="_new" href="${info.value}">${info.label}</a>
							</td>
						</tr>
						</c:forEach>
					</table>
				</td>
			</tr>
			</c:when>
			<c:otherwise>
			<!-- There are no other Accession Ids in MTB associated with this reference. //-->
			</c:otherwise>
			</c:choose>
			<!-- ////  End Other Accession Ids  //// -->
			<!-- ////  End Detail Section  //// -->
		</table>
	</jax:mmhcpage>
	
