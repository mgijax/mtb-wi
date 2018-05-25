<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Human Gene Search Form" help="humangene">
	<html:form action="orthologySearch" method="GET" >


<table class="results">

<tr class="page-info"></tr>

<tr class="buttons">
	<td colspan="2">
		<table>
			<tr>
				<td>

<input type="submit" VALUE="Search">
	<input type="reset" VALUE="Reset">
		</td>
			</tr>
				<tr>
					<td>
						<span class="label">Sort By:</span>
							<html:radio property="sortBy" value="HumanGS">Human Gene Symbol</html:radio>  
								<html:radio property="sortBy" value="MouseGS">Mouse Gene Symbol</html:radio>  

</td>
	</tr>

</table>
	</td>
		</tr>

<tr class="stripe-1">
	<td class="cat-1">
		Human Genes:
			</td>
				<td class="data-1">
					<table>

<tr>
	<td>
		<table>
			<tr>
				<td align="top">
					<html:select property="compare">
						<html:option value="Contains"> Contains </html:option>
							<html:option value="Begins"> Begins with </html:option>
								<html:option value="Equals"> Equals </html:option>
									<html:option value="Ends"> Ends with </html:option>
										</html:select>
											</td><strong>
												 Entering human gene symbols, names or Entrez IDs returns a list of orthologous mouse symbols and associated data. 
<!-- \n -->

</strong>Entrez ID searches must use 'equals'.
	<td><html:textarea property="humanGS" rows="3" cols="50"/></td>
		</tr>

</table>
	</td>
		</tr>
			</table>
				</td>
					</tr>

<tr class="buttons">
	<td colspan="2">
		<table>
			<tr>
				<td>
					<input type="submit" VALUE="Search">
						<input type="reset" VALUE="Reset">
							</td>
								</tr>
									</table>
										</td>
										</tr>
									</table>

</html:form>
	</td>
		</tr>
	<c:set var="url" value="/orthologySearch.do?sortBy=HumanGS&compare=Equals&reference=" />
	<c:set var="asList" value="&asList=true" />
		<tr>

<td>		

<table>
	<tr>
		<td><h3><strong>Sample references containing human cancer genes:</strong></h3></td>
			</tr>
				<tr><td></td></tr>

<c:forEach var="reference" items="${references}" >
	<tr>
		<td>${reference.authors}</td>
			<td>

<c:if test="${not empty reference.url}">
	<a href="<c:url value='${reference.url}'/>">PubMed abstract</a>
		</c:if>

</td>
	</tr>
		<tr>
			<td>
				<strong>${reference.title}</strong>,&nbsp;${reference.journal}&nbsp;${reference.year}
					<c:if test="${not empty reference.volume}">
						;${reference.volume}
							</c:if>
								<c:if test="${not empty reference.issue}">
									(${reference.issue})
										</c:if>
											<c:if test="${not empty reference.pages}">
												:${reference.pages}
											</c:if>
										</td>
									 <td>
										<a href="<c:url value='${url}${reference.referenceKey}'/>">Search MTB using human genes from this paper</a>
										</td>

</tr>
	<tr>
		 <td>${reference.note}</td>
			<td>
				<a href="<c:url value='${url}${reference.referenceKey}${asList}'/>">List of human genes</a>
					</td>
						</tr>
							<tr><td colspan="2"><hr></td></tr>
								</c:forEach>

</table>

</jax:mmhcpage>

