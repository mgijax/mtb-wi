<%@ tag description="Jax search form template" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ attribute name="action" required="true" %>
<%@ attribute name="sortby" required="false" %>
<%@ attribute name="maxitems" required="false" %>
<html:form action="${action}" styleClass="search-form">
<fieldset class="form-buttons">
	<input type="submit" value="Search">
	<input type="reset" value="Reset">
</fieldset>
<c:if test="${not empty sortby}">
<fieldset class="form-sort">
	<legend>Sort by</legend>
	<c:forTokens items="${sortby}" delims="," var="sortOption">
	<c:set var="sortPair" value="${fn:split(sortOption, '=')}" />
	<c:set var="sortLabel" value="${sortPair[0]}" />
	<c:choose>
	<c:when test="${fn:length(sortPair) gt 1}">
	<c:set var="sortValue" value="${sortPair[1]}" />
	</c:when>
	<c:otherwise>
	<c:set var="sortValue" value="${sortPair[0]}" />
	</c:otherwise>
	</c:choose>
	<html:radio property="sortBy" value="${sortValue}">${sortLabel}</html:radio>  
	</c:forTokens>
</fieldset>
</c:if>
<fieldset class="form-max-items">
	<legend>Max number of items returned</legend>
	<html:radio property="maxItems" value="25">25</html:radio>  
	<html:radio property="maxItems" value="100">100</html:radio>  
	<html:radio property="maxItems" value="500">500</html:radio>  
	<html:radio property="maxItems" value="No Limit">No Limit</html:radio>
</fieldset>
<jsp:doBody/>
<fieldset class="form-buttons">
	<input type="submit" value="Search">
	<input type="reset" value="Reset">
</fieldset>
</html:form>
