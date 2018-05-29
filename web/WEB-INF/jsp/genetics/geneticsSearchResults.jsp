<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Genetics Search Results" help="geneticsresults">
	<a name="top"></a>
	<table>
		<caption>
			<div class="search-summary">		
				<h4>Search Summary</h4>
				<!-- \n -->
				<c:if test="${not empty alleleName}">
				<h5 class="label">Allele Name:</h5> ${alleleNameComparison} "${alleleName}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty markerName}">
				<h5 class="label">Marker Name:</h5> ${markerNameComparison} "${markerName}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty chromosomes}">
				<c:choose>
				<c:when test="${chromosomes>'1'}">
				<h5 class="label">Chromosomes:</h5>
				</c:when>
				<c:otherwise>
				<h5 class="label">Chromosome:</h5>
				</c:otherwise>
				</c:choose>
				${chromosomes}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty mutations}">
				<c:choose>
				<c:when test="${mutations>'1'}">
				<h5 class="label">Mutations / Aberrations:</h5>
				</c:when>
				<c:otherwise>
				<h5 class="label">Mutation / Aberration:</h5>
				</c:otherwise>
				</c:choose>
				${mutations}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty assayImages}">
				<h5 class="label">Restrict results to records that include assay images</h5>
				<!-- \n -->
				</c:if>
				<h5 class="label">Sort By:</h5> ${sortBy}
				<!-- \n -->
				<h5 class="label">Display Limit:</h5> ${maxItems} in each section
			</div>
			<div class="display-counts">
				<p>
					<c:choose>
					<c:when test="${numberOfResultsStrains != totalResultsStrains}">
					${numberOfResultsStrains} of ${totalResultsStrains} matching strains displayed.
					</c:when>
					<c:otherwise>
					<c:out value="${numberOfResultsStrains}" default="0"/> matching strains displayed.
					</c:otherwise>
					</c:choose>
				</p>
				<p>
					<c:choose>
					<c:when test="${numberOfResultsTumors != totalResultsTumors}">
					${numberOfResultsTumors} of ${totalResultsTumors} matching markers analyzed in the tumor displayed.
					</c:when>
					<c:otherwise>
					<c:out value="${numberOfResultsTumors}" default="0"/> matching markers analyzed in the tumor displayed.
					</c:otherwise>
					</c:choose>
				</p>
				<p>
					<c:choose>
					<c:when test="${numberOfCytoTumors != totalCytoTumors}">
					${numberOfCytoTumors} of ${totalCytoTumors} matching cytogenetic observations in tumors displayed.
					</c:when>
					<c:otherwise>
					<c:out value="${numberOfCytoTumors}" default="0"/> matching cytogenetic observations in tumors displayed.
					</c:otherwise>
					</c:choose>
				</p>
			</div>
		</caption>
	</table>
	<!-- ////  Start Strain Genetics Results List  //// -->
	<c:choose>
	<c:when test="${not empty strainGenetics}">
	<a name="strainGenetics"></a>
	<c:if test="${not empty tumorGenetics}">
	<a class="jump-nav" href="#tumorGenetics"><i class="fa fa-arrow-down"></i>Jump to Genetic Changes in Tumors</a>
	</c:if>
	<c:if test="${not empty cytoGenetics}">
	<a href="#cytoGenetics"><i class="fa fa-arrow-down"></i>Jump to Cytogenetic Changes in Tumors</a>
	</c:if>
	<table>
		<caption>
			<h2>Genes, Alleles and Transgenes carried by Strains</h2>
		</caption>				
		<thead>
			<tr>
				<th>Mouse Chrom.</th>
				<th>Symbol, Name</th>
				<th>Type</th>
				<th>Genotype <span>(number of associated strains)</span></th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="rec" items="${strainGenetics}" varStatus="status">
			<tr>
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
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- No strain results found. //-->
	</c:otherwise>
	</c:choose>
	<!-- ////  Start Tumor Genetics Results List  //// -->
	<c:choose>
	<c:when test="${not empty tumorGenetics}">
	<a name="tumorGenetics"></a>
	<c:if test="${not empty strainGenetics}">
	<a class="jump-nav" href="#strainGenetics"><i class="fa fa-arrow-up"></i>Jump to Genes, Alleles and Transgenes in Strains</a>
	</c:if>
	<table>
		<caption>
			<h2>Genetic Markers analyzed in the Tumor</h2>
		</caption>	
		<thead>			
			<tr>
				<th>Mouse Chrom.</th>
				<th>Gene Symbol, Name</th>
				<th>Marker Type Observed <span>(Number of Observations)</span></th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="rec" items="${tumorGenetics}" varStatus="status">
			<tr>
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
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- No tumor results found. //-->
	</c:otherwise>
	</c:choose>
	<c:choose>
	<c:when test="${not empty cytoGenetics}">
	<a name="cytoGenetics"></a>
	<c:if test="${not empty tumorGenetics}">
	<a class="jump-nav" href="#strainGenetics"><i class="fa fa-arrow-up"></i>Jump to Genes, Alleles and Transgenes in Strains</a>
	</c:if>
	<table>
		<caption>
			<h2>Cytogenetic observations in the Tumor</h2>
		</caption>
		<thead>
			
			<tr>
				<th>Mouse Chroms.</th>
				<th>Type</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="rec" items="${cytoGenetics}" varStatus="status">
			<tr>
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
		</tbody>
	</table>
	</c:when> 
	<c:otherwise>
	<!-- No tumor results found. -->
	<p></p>
	</c:otherwise>
	</c:choose>
	<!-- ////  End Results  //// -->
</jax:mmhcpage>




