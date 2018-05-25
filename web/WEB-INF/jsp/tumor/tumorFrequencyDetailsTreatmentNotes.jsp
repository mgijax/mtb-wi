<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Tumor Treatment Note">

<!-- ////  Start Additional Notes Records  //// -->

<c:choose>
	<c:when test="${not empty tumorFreq.note}">

<table class="results">
	<tr>
		<td colspan="2" class="results-header-left">
			<h3>Treatment Note</h3>
				</td>
					</tr>
						<tr>
							<td class="results-header">Note</td>
								<td class="results-header">Reference</td>
						</tr>

<c:if test="${not empty tumorFreq.note}">
	<c:set var="noteRow" value="1"/>
		<tr>
			<td>${tumorFreq.note}</td>
				<td><a href="nojavascript.jsp" onclick="focusBackToOpener('referenceDetails.do?accId=${tumorFreq.reference}');return false;">${tumorFreq.reference}</a></td>
					</tr>
						</c:if>

</table>
	</c:when>
		<c:otherwise>
			<!-- No notes for this frequency record //-->
		</c:otherwise>
		</c:choose>

<!-- ////  End Additional Notes Records  //// -->

</jax:mmhcpage>

