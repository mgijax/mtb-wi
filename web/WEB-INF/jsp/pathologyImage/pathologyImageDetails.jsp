<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Pathology Image Detail">

<jsp:attribute name="head">
<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
	<c:choose>
  		<c:when test="${not empty pathology.zoomifyDir}">  	
  			<script type="text/javascript" src="${applicationScope.urlBase}/zoomify/ZoomifyImageViewerFree-min.js"></script>
  			<script type="text/javascript"> Z.showImage("myContainer", "${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${pathology.zoomifyDir}"); </script>
 		</c:when>
	</c:choose>

</jsp:attribute>
<jsp:body>

<section id="image-detail">

				<c:choose>
 					<c:when test="${not empty pathology.zoomifyDir}">
  						<div id="myContainer" style="width:900px; height:500px; margin:auto; border:1px; border-style:solid; border-color:#696969; background-color:#000000;" ></div>
 					</c:when>
 					<c:otherwise>
  						<!-- IMAGE HAS NOT BEEN ZOOMIFIED -->
  						<img src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${pathology.imageName}">
 					</c:otherwise>
				</c:choose>
</section>
<section id="summary">
	<div class="container">
		
		<table>
			<tbody>
				<jax:sumrow dt="Caption" dd="${pathology.caption}" />
				<jax:sumrow dt="Description" dd="${pathology.pathologyDescription}" />
				<jax:sumrow dt="Age at Necropsy" dd="${pathology.ageAtNecropsy}" />
				<jax:sumrow dt="Notes" dd="${pathology.pathologyNote}" />
				<jax:sumrow dt="Contributor" dd="${pathology.sourceOfImage} (<a href='referenceDetails.do?key=${pathology.imgRefKey}'>${pathology.imgRefAccId}</a>)" />
				<jax:sumrow dt="Pathologist" dd="${pathology.pathologist} (<a href='referenceDetails.do?key=${pathology.pathologistRefKey}'>{pathology.pathologistAccId}</a>)" />
				<jax:sumrow dt="Copyright" dd="${pathology.copyright}" />
				<jax:sumrow dt="Method" dd="${pathology.method}" />  			
			</tbody>
		</table>
		


	<c:if test="${not empty pathology.probes}">	
		<table>
			<caption>Image Probes</caption>
			<tbody>
				<c:forEach var="probe" items="${pathology.probes}" varStatus="status">
				<tr>
					<td><h4>Type: ${probe.type}</h4></td>
					<td>
						<jax:dl dt="Name" dd="<a href='${probe.url}'>${probe.name}</a>" test="${not empty probe.url}" />
						<jax:dl dt="Name" dd="${probe.name}" test="${empty probe.url}" />
						<jax:dl dt="Target" dd="${probe.target}" />
						<jax:dl dt="Supplier" dd="<a href=''${probe.supplierUrl}'>${probe.supplierName}</a>" test="${not empty probe.supplierUrl}" />
						<jax:dl dt="Supplier" dd="${probe.supplierName}" test="${empty probe.supplierUrl}" />
						<jax:dl dt="Notes" dd="${probe.notes}" />  					
					</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>		
	</c:if>
	
		<table>
			<tbody>
				<tr>
					<td><h4>Model</h4></td>
					<td>
						<jax:dl dt="MMHC ID" dd="<a href='tumorSummary.do?tumorFrequencyKeys=${pathology.tumorFrequencyKey}'>MTB:${pathology.tumorFrequencyKey}</a>" />
						<jax:dl dt="Tumor Name" dd="${pathology.organOrigin}&nbsp;&#8226;&nbsp;${pathology.tumorClassName}" />
						<jax:dl dt="Treatment Type" dd="${pathology.treatmentType}" />
						<jax:dl dt="Agent" dts="Agents" dds="${pathology.agents}" />
						<dl>
							<dt>Tumor Synonyms</dt>
							<c:forEach var="tumorSynonym" items="${pathology.tumorSynonyms}">
							<dd><c:out value="${tumorSynonym.name}" escapeXml="false"/></dd>
							</c:forEach>
						</dl>
						<jax:dl dt="Organ Affected" dd="${pathology.organAffected}" />
						<jax:dl dt="Frequency" dd="${pathology.frequencyString}" />
						<jax:dl dt="Frequency Note" dd="${pathology.frequencyNote}" />
						<jax:dl dt="Reference" dd="<a href='referenceDetails.do?key=${pathology.referenceKey}'>${pathology.accessionId}</a>" />
					</td>
				</tr>
			</tbody>
		</table>
		
		<table>
			<tbody>
				<tr>
					<td><h4>Strain</h4></td>
					<td>
						<jax:dl dt="Strain" dd="<a href='strainDetails.do?key=${pathology.strainKey}'>${pathology.strainName}</a>" />
						<dl>
							<dt>Strain Types</dt>
							<c:forEach var="st" items="${pathology.strainTypes}">
							<dd><c:out value="${st.type}" escapeXml="false"/></dd>
							</c:forEach>
						</dl>			
						<jax:dl dt="General Note" dd="${pathology.strainNote}"/>
						<dl>
							<dt>Strain Synonyms</dt>
							<c:forEach var="synonym" items="${pathology.strainSynonyms}">
							<dd><c:out value="${synonym.name}" escapeXml="false"/></dd>
							</c:forEach>
						</dl>
						<jax:dl dt="Strain Sex" dd="${pathology.sex}" />
						<jax:dl dt="Reproductive Status" dd="${pathology.reproductiveStatus}" />
						<jax:dl dt="Age of Onset" dd="${pathology.ageOfOnset}" />
						<jax:dl dt="Age of Detection" dd="${pathology.ageOfDetection}" />
						
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</section>

</jsp:body>
</jax:mmhcpage>

