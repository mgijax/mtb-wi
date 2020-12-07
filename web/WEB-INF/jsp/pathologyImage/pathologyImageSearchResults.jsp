<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Pathology Image Search Results">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
	</jsp:attribute>
	<jsp:body>
        <div style="padding-left:20px; font-size: 14px">
	<table >
		<caption>
			<div class="result-summary">
				<h4>Search Summary</h4>
				<jax:dl dt="Organ/Tissue of Origin" dts="Organs/Tissues of Origin" dds="${organOriginSelected}"/>
				<jax:dl dt="Tumor Classification" dds="${tumorClassificationsSelected}"/>
				<jax:dl dt="Organ/Tissue Affected" dd="${organsAffectedSelected}"/>
				<jax:dl dt="Diagnosis or Description" dd="Contains ${diagnosisDescription}"/>
				<jax:dl dt="Method" dd="${methodSelected}"/>
				<jax:dl dt="Antibody" dts="Antibodies" dds="${antibodiesSelected}"/>
				<jax:dl dt="Contributor" dds="${imageContributors}"/>
				<jax:dl dt="Accession Id" dd="${accId}"/>
				<jax:dl dt="Sort By" dd="${sortBy}"/>
				<jax:dl dt="Display Limit" dd="${maxItems}"/>
			</div>
			<div class="result-count">
				<c:choose>
				<c:when test="${numberOfResults != totalResults}">
				<c:out value="${numberOfResults}" default="0"/> (of <c:out value="${totalResults}" default="0"/>) pathology reports displayed, including <c:out value="${totalNumOfPathImages}" default="0"/> images.
				</c:when>
				<c:otherwise>
				<c:out value="${numberOfResults}" default="0"/> (of <c:out value="${totalResults}" default="0"/>) pathology reports displayed, including <c:out value="${totalNumOfPathImages}" default="0"/> images.
				</c:otherwise>
				</c:choose>
			</div>
		</caption>
	</table>

	<c:choose>
	<c:when test="${not empty pathologyImages}">
        <table style="padding-left:20px;">
	<c:forEach var="pathRec" items="${pathologyImages}" varStatus="status">
	<!-- \n -->
	<!-- \n -->
                <tr>
                    <td colspan="12"><hr></td>
                </tr>
		<tr>
                        <td><b>MTB ID</b></td>
			<td><b>Tumor Name</b></td>
			<td><b>Organ(s) Affected</b></td>
			<td><b>Treatment Type</b></td>
			<td><b>Agents</b></td>
                        <td><b>Strain Name</b></td>
                        <td><b>Strain Sex</b></td>
			<td><b>Reproductive Status</b></td>
			<td><b>Tumor Frequency</b></td>
			<td><b>Age at Necropsy</b></td>
			<td><b>Description</b></td>
			<td><b>Reference</b></td>
		</tr>
		<tr>
			<td><a href="tumorSummary.do?tumorFrequencyKeys=${pathRec.tumorFrequencyKey}">MTB:${pathRec.tumorFrequencyKey}</a></td>
			<td>${pathRec.organOriginName} &nbsp; ${pathRec.tumorClassName}</td>
			<td>${pathRec.organAffectedName}</td>
                        <td><c:out value="${pathRec.treatmentType}" escapeXml="false"/></td>
                        <td>	
                            <c:if test="${not empty pathRec.agents}">	
					<c:forEach var="agent" items="${pathRec.agents}" varStatus="status">
					<c:out value="${agent}" escapeXml="false"/>
					<c:if test="${status.last != true}">
                                            <c:out value=", "/>
					</c:if>
					</c:forEach>
				</c:if>
			</td>
                        <td><h5><a href="strainDetails.do?key=${pathRec.strainKey}"><c:out value="${pathRec.strainName}" escapeXml="false"/></a></h5></td>
                        <td>${pathRec.strainSex}</td>
                        <td>${pathRec.reproductiveStatus}</td>
			<td>${pathRec.frequencyString}</td>
			<td>${pathRec.ageAtNecropsy}</td>
			<td>${pathRec.note}</td>
			<td><a href="referenceDetails.do?accId=${pathRec.accID}">${pathRec.accID}</a></td>
		</tr>
                <tr>
                    <td colspan="12">
			<table>
                            <c:forEach var="image" items="${pathRec.images}" varStatus="status">
                                <tr>
                                    <td colspan="2">
                                        <b>Image Caption:</b>${image.imageCaption}</div>
                                    </td>
                                <tr>
                                    <td width="300px">
                                            <a href="pathologyImageDetails.do?key=${image.imageId}" target="_blank">
                                            <img width="300" src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${image.imageThumbName}" alt="${image.imageId}"></a>
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <b>Image ID:<b>${image.imageId}
                                                </td>    
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b>Source of Image:</b>${image.sourceOfImage}
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b>Pathologist:</b>${image.pathologist}
                                                </td>
                                            </tr>
                                            <c:choose>
                                            <c:when test="${not empty image.stainMethod}">
                                            <tr>
                                                <td>
                                                    <b>Method / Stain:</b>${image.stainMethod}
                                                </td>
                                            </tr>
                                            </c:when>
                                            </c:choose>
                                        </table>
                                    </td>
                                   
                                </tr>
				
		</c:forEach>
              </table>
	</td>
	</tr>
       
	</c:forEach>
        </table>
	</c:when>
	<c:otherwise>
	<!-- No results found. //-->
	</c:otherwise>
	</c:choose>
	<!-- ////  End Results  //// -->
        </div>
	</jsp:body>
</jax:mmhcpage>


