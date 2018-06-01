<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Cytogenetics">
	<!- Cytogenetics -->
	<c:choose>
	<c:when test="${not empty tumorFreqs}">
	<table>
		<tr>
			<td colspan="6" class="results-header-left">
				<h3>Tumor Cytogenetics</h3>
			</td>
		</tr>
	</table>
	<c:forEach var="tumorFreq" items="${tumorFreqs}" varStatus="statusTF">
	<!-----------------------------------  ------------------------------------------->
	<table>
		<tr>
			<th>MTB ID</th>
			<th>Organ Affected</th>
			<th>Treatment Type <em>Agents</em></th>
			<th>Strain Sex</th>
			<th>Reproductive Status</th>
			<th>Frequency</th>
			<th>Age Of Onset</th>
			<th>Age Of Detection</th>
			<th>Reference</th>
		</tr>
		<tr>
			<td>MTB:${tumorFreq.tumorFrequencyKey}</td>
			<td>
				<c:choose>
				<c:when test="${not empty tumorFreq.organAffected}">
				<c:choose>
				<c:when test="${tumorFreq.parentFrequencyKey>0}">
				<span color="red">
					<c:out value="${tumorFreq.organAffected}" escapeXml="false"/>
				</span>
				</c:when>
				<c:otherwise>
				<c:out value="${tumorFreq.organAffected}" escapeXml="false"/>
				</c:otherwise>
				</c:choose>
				</c:when>
				<c:otherwise>
				<!--There is no organ affected associated with this tumor frequency record . //-->
				</c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:out value="${tumorFreq.treatmentType}" escapeXml="false"/>
				<c:choose>
				<c:when test="${not empty tumorFreq.agents}">
				<em>
					<c:forEach var="agent" items="${tumorFreq.agents}" varStatus="status">
					
						${agent}
						<c:if test="${status.last != true}">
						<!-- \n -->
						</c:if>
					
					</c:forEach>
					</c:when>
					<c:otherwise>
					<!--There are no agents associated with this tumorFreq. //-->
					</c:otherwise>
					</c:choose>
				</td>
				<td><c:out value="${tumorFreq.strainSex}" default="&nbsp;" escapeXml="false"/></td>
				<td><c:out value="${tumorFreq.reproductiveStatus}" default="&nbsp;" escapeXml="false"/></td>
				<td>
					${tumorFreq.frequencyString}
					<c:if test="${rec.numMiceAffected>=0&&rec.colonySize>=0}">
					<!-- \n -->
					(${rec.numMiceAffected} of ${rec.colonySize} mice)
					</c:if>
				</td>
				<td><c:out value="${tumorFreq.ageOnset}" default="&nbsp;" escapeXml="false"/></td>
				<td><c:out value="${tumorFreq.ageDetection}" default="&nbsp;" escapeXml="false"/></td>
				<td>
					<c:choose>
					<c:when test="${not empty tumorFreq.reference}">
					<a href="referenceDetails.do?accId=${tumorFreq.reference}">${tumorFreq.reference}</a>
					</c:when>
					<c:otherwise>
					<!--There is no reference associated with this tumor frequency record . //-->
					</c:otherwise>
					</c:choose>
				</td>
			</table>	 
			<!------------------------------------------------------------------------>
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
				<tr>						<td>
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
								<tr>
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
				</c:forEach>
				</c:when>
				<c:otherwise>
				<!-- No genetics for this frequency record //-->
				</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</table>
</jax:mmhcpage>

