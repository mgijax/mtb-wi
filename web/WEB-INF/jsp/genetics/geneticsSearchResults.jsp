<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Genetics Search Results" help="geneticsresults">

<a name="top"></a>


<table class="results">

<!-- ////  Start Search Summary  //// -->

<tr class="summary">
	<td>
		<span class="label">Search Summary</span>
<!-- \n -->

<c:if test="${not empty alleleName}">
	<span class="label">Allele Name:</span> ${alleleNameComparison} "${alleleName}"
<!-- \n -->

</c:if>

<c:if test="${not empty markerName}">
	<span class="label">Marker Name:</span> ${markerNameComparison} "${markerName}"
<!-- \n -->

</c:if>

<c:if test="${not empty chromosomes}">
	<c:choose>
		<c:when test="${chromosomes>'1'}">
			<span class="label">Chromosomes:</span>
				</c:when>
					<c:otherwise>
						<span class="label">Chromosome:</span>
							</c:otherwise>
								</c:choose>

${chromosomes}

<!-- \n -->

</c:if>

<c:if test="${not empty mutations}">
	<c:choose>
		<c:when test="${mutations>'1'}">
			<span class="label">Mutations / Aberrations:</span>
				</c:when>
					<c:otherwise>
						<span class="label">Mutation / Aberration:</span>
							</c:otherwise>
								</c:choose>

${mutations}

<!-- \n -->

</c:if>

<c:if test="${not empty assayImages}">
	<span class="label">Restrict results to records that include assay images</span>
<!-- \n -->

</c:if>

<span class="label">Sort By:</span> ${sortBy}
<!-- \n -->

<span class="label">Display Limit:</span> ${maxItems} in each section
	</td>
		</tr>
			<tr class="summary">
				<td>

<!-- ////  Start Display Limit  //// -->

<table>
	<tr>

<td>
	<c:choose>
		<c:when test="${numberOfResultsStrains != totalResultsStrains}">
			${numberOfResultsStrains} of ${totalResultsStrains} matching strains displayed.
				</c:when>
					<c:otherwise>
						<c:out value="${numberOfResultsStrains}" default="0"/> matching strains displayed.
							</c:otherwise>
								</c:choose>
								</td>
							</tr>
							<tr>

<td>
	<c:choose>
		<c:when test="${numberOfResultsTumors != totalResultsTumors}">
			${numberOfResultsTumors} of ${totalResultsTumors} matching markers analyzed in the tumor displayed.
				</c:when>
					<c:otherwise>
						<c:out value="${numberOfResultsTumors}" default="0"/> matching markers analyzed in the tumor displayed.
							</c:otherwise>
								</c:choose>
								</td>
							</tr>

<tr>
	<td>
		<c:choose>
			<c:when test="${numberOfCytoTumors != totalCytoTumors}">
				${numberOfCytoTumors} of ${totalCytoTumors} matching cytogenetic observations in tumors displayed.
					</c:when>
						<c:otherwise>
							<c:out value="${numberOfCytoTumors}" default="0"/> matching cytogenetic observations in tumors displayed.
								</c:otherwise>
									</c:choose>
								</td>
							</tr>

</tr>
	</table>

<!-- ////  End Display Limit  //// -->

</td>
	</tr>
		</table>

<!-- ////  End Search Summary  //// -->

<!-- \n -->

<!-- ////  Start Results  //// -->

<!-- ////  Start Strain Genetics Results List  //// -->

<c:choose>
	<c:when test="${not empty strainGenetics}">
		<a name="strainGenetics"></a>
		<c:if test="${not empty tumorGenetics}">
			<div align="right"><a href="#tumorGenetics"><img align="middle" src="${applicationScope.urlImageDir}/down_arrow.png" alt="Jump to Genetic Changes in Tumors">Jump to Genetic Changes in Tumors</a></div>
<!-- \n -->

<!-- \n -->

</c:if>

<c:if test="${not empty cytoGenetics}">
	<div align="right"><a href="#cytoGenetics"><img align="middle" src="${applicationScope.urlImageDir}/down_arrow.png" alt="Jump to Cytogenetic Changes in Tumors">Jump to Cytogenetic Changes in Tumors</a></div>
<!-- \n -->

<!-- \n -->

</c:if>

<table class="results">
	<tr>
		<td class="results-header-left" colspan="4"><h3>Genes, Alleles and Transgenes carried by Strains</h3></td>
		</tr>				
		<tr>

<td class="results-header">Mouse
<!-- \n -->
Chrom.</td>
	<td class="results-header">Symbol, Name</td>
		<td class="results-header">Type</td>
			<td class="results-header">Genotype
<!-- \n -->
<small>(number of associated strains)</small></td>
	</tr>

<c:forEach var="rec" items="${strainGenetics}" varStatus="status">
	<c:choose>
		<c:when test="${status.index%2==0}">
			<tr>
			</c:when>
			<c:otherwise>
				<tr>
			</c:otherwise>
		</c:choose>

<td><c:out value="${rec.chromosome}" default="&nbsp;" escapeXml="false"/></td>
	<td>
		<c:choose>
			<c:when test="${empty rec.geneSymbol}">
				${rec.geneName}
				</c:when>
				<c:otherwise>
					${rec.geneSymbol}, ${rec.geneName}
				</c:otherwise>
			</c:choose>
			<c:if test="${rec.isTransgene==true}">
				(${rec.organism})
			</c:if>
			<c:forEach var="pe" items="${rec.promotersEnhancers}">

<small style="font-size:90%">
<!-- \n -->
${pe}</small>
	</c:forEach>
		</td>
		<td>${rec.alleleType}</td>
		<td>

<c:choose>
	<c:when test="${not empty rec.allele2Symbol}">
		<c:choose>
			<c:when test="${rec.isTransgene==true}">
				${rec.allele1Symbol}/${rec.allele2Symbol}
					</c:when>
						<c:otherwise>
							<em>${rec.allele1Symbol}/${rec.allele2Symbol}</em>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${rec.isTransgene==true}">
							${rec.allele1Symbol}
						</c:when>
						<c:otherwise>
							<em>${rec.allele1Symbol}</em>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>

<c:if test="${rec.allelePairCount>0}">
	(<a href="strainSearchResults.do?allelePairKey=${rec.allelePairKey}&amp;maxItems=No+Limit">${rec.allelePairCount}</a>)
		</c:if>

<c:if test="${status.last != true}">

<!-- \n -->

</c:if>

</td>
	</tr>
	</c:forEach>
</table>
</c:when>
<c:otherwise>
	<!-- No strain results found. //-->
</c:otherwise>
</c:choose>

<!-- ////  End Strain Genetics Results List  //// -->

<!-- \n -->

<!-- \n -->

<!-- ////  Start Tumor Genetics Results List  //// -->

<c:choose>
<c:when test="${not empty tumorGenetics}">
<a name="tumorGenetics"></a>
<c:if test="${not empty strainGenetics}">
	<div align="right"><a href="#strainGenetics"><img align="middle" src="${applicationScope.urlImageDir}/up_arrow.png" alt="Jump to Genes, Alleles and Transgenes in Strains">Jump to Genes, Alleles and Transgenes in Strains</a></div>
<!-- \n -->

<!-- \n -->

</c:if>

<table class="results">
<tr>
	<td class="results-header-left" colspan="3"><h3>Genetic Markers analyzed in the Tumor</h3></td>
</tr>				
<tr>
	<td class="results-header">Mouse
<!-- \n -->
Chrom.</td>
	<td class="results-header">Gene Symbol, Name</td>
	<td class="results-header">Marker Type Observed
<!-- \n -->
<small>(Number of Observations)</small></td>
</tr>

<c:forEach var="rec" items="${tumorGenetics}" varStatus="status">
	<c:choose>
		<c:when test="${status.index%2==0}">
			<tr>
		</c:when>
		<c:otherwise>
			<tr>
		</c:otherwise>
	</c:choose>

<td><c:out value="${rec.chromosome}" default="&nbsp;" escapeXml="false"/></td>
	<td>
		<c:choose>
			<c:when test="${fn:containsIgnoreCase(rec.geneName, 'placeholder')}">

</c:when>
	<c:otherwise>
		${rec.geneSymbol}, ${rec.geneName}
			</c:otherwise>
		</c:choose>
	</td>
	<td>
		<c:out value="${rec.alleleType}" escapeXml="true"/>
		<c:if test="${rec.count>0}">
			(<a href="geneticsSummary.do?alleleTypeKey=${rec.alleleTypeKey}&amp;markerKey=${rec.markerKey}">${rec.count}</a>)
		</c:if>
	</td>
	</tr>
</c:forEach>
</table>
</c:when>
<c:otherwise>
	<!-- No tumor results found. //-->
</c:otherwise>
</c:choose>

<!-- ////  End Tumor Genetics Results List  //// -->

<c:choose>
<c:when test="${not empty cytoGenetics}">
<a name="cytoGenetics"></a>
<c:if test="${not empty tumorGenetics}">
	<div align="right"><a href="#strainGenetics"><img align="middle" src="${applicationScope.urlImageDir}/up_arrow.png" alt="Jump to Genes, Alleles and Transgenes in Strains">Jump to Genes, Alleles and Transgenes in Strains</a></div>
<!-- \n -->

<!-- \n -->

</c:if>

<table class="results">
<tr>
	<td class="results-header-left" colspan="4"><h3>Cytogenetic observations in the Tumor</h3></td>
</tr>				
<tr>
	<td class="results-header">Mouse
<!-- \n -->
Chroms.</td>

<td class="results-header">Type</td>

</tr>

<c:forEach var="rec" items="${cytoGenetics}" varStatus="status">
	<c:choose>
		<c:when test="${status.index%2==0}">
			<tr>
		</c:when>
		<c:otherwise>
			<tr>
		</c:otherwise>
	</c:choose>

<td>

${rec.displayChromosomes}
	</td>

<td>
	${rec.alleleTypeName}
		(<a href="tumorSummary.do?tumorChangeKeys=${rec.keys}">${rec.size}</a>)	 

<c:choose>	
	<c:when test="${rec.hasImages==true}">
		<img src="${applicationScope.urlImageDir}/pic.gif" alt="Records include assay images" title="Records include assay images">
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
	<!--	 No tumor results found.	-->
	<p></p>
</c:otherwise>
</c:choose>

<!-- ////  End Results  //// -->

</jax:mmhcpage>

