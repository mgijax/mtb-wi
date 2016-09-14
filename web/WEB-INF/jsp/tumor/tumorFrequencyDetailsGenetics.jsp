<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Tumor Genetics"/>
    </c:import>
</head>

<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="Tumor Genetics"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td valign="top">
            <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                <tr>
                    <td>
                        <!--======================= Start Tumor Genetics Section ===================-->    
                <c:choose>
                    <c:when test="${not empty tumorFreq.tumorGenetics}">
                        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                            <tr>
                                <td colspan="5" class="resultsHeaderLeft">
                                    <font class="larger">Tumor Genetics</font>
                                </td>
                            </tr>
                            <tr>
                                <td class="headerLabel">Marker<br>Symbol</td>
                                <td class="headerLabel">Marker<br>Name</td>
                                <td class="headerLabel">Mouse<br>Chromosome</td>
                                <td class="headerLabel">Mutation<br>Types</td>
                                <td class="headerLabel">Genetic<br>Change</td>
                            </tr>

                            <c:forEach var="genetics" items="${tumorFreq.tumorGenetics}" varStatus="status">
                                <c:choose>
                                    <c:when test="${status.index%2==0}">
                                        <tr class="stripe1">
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="stripe2">
                                    </c:otherwise>
                                </c:choose>
                                <td>
                                <c:choose>
                                    <c:when test="${not empty genetics.geneSymbol}">
                                        <c:choose>
                                            <c:when test="${fn:indexOf(genetics.geneSymbol, '+')<0}">
                                                <a href="redirect?key=${genetics.markerKey}&type=1" target="MGI"><c:out value="${genetics.geneSymbol}" escapeXml="false"/></a>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${genetics.geneSymbol}" escapeXml="false"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        &nbsp;
                                    </c:otherwise>
                                </c:choose>
                                </td>
                                <td>
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(genetics.geneName, 'placeholder')}">
                                        &nbsp;
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${genetics.geneName}" escapeXml="false"/>
                                    </c:otherwise>
                                </c:choose>
                                </td>
                                <td align="center">
                                <c:out value="${genetics.chromosome}" escapeXml="false"/>
                                </td>

                                <td>
                                <c:out value="${genetics.alleleType}" escapeXml="false"/>
                                </td>


                                <td>

                                <c:choose>
                                    <c:when test="${not empty genetics.allele1Symbol && not empty genetics.allele2Symbol}">
                                        <c:out value="${genetics.allele1Symbol} / ${genetics.allele2Symbol}" escapeXml="false"/>

                                    </c:when>
                                    <c:when test="${not empty genetics.allele1Symbol && empty genetics.allele2Symbol}">
                                        <c:out value="${genetics.allele1Symbol}"   escapeXml="false"/>
                                    </c:when>
                                    <c:when test="${empty genetics.allele1Symbol && not empty genetics.allele2Symbol}">
                                        <c:out value="${genetics.allele2Symbol}"  escapeXml="false"/>
                                    </c:when>
                                    <c:otherwise>
                                        &nbsp;
                                    </c:otherwise>
                                </c:choose>



                                </td>


                                </tr>
                            </c:forEach>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <!-- No genetics for this frequency record //-->
                    </c:otherwise>
                </c:choose>





                <!--======================= End Tumor Genetics Section =====================-->    
        </td>
    </tr>
    <tr>
        <td>
            <!- Cytogenetics -->
    <c:choose>
        <c:when test="${not empty tumorFreq.tumorCytogenetics}">
            <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                <tr>
                    <td colspan="6" class="resultsHeaderLeft">
                        <font class="larger">Tumor Cytogenetics</font>

                    </td>
                </tr>
            </table>

            <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">

                <tr>

                    <td class="headerLabel">Name</td>
                    <td class="headerLabel">Mouse<br>Chromosome</td>
                    <td class="headerLabel">Mutation<br>Types</td>
                    <td class="headerLabel">Assay<br>Type</td>
                    <td class="headerLabel">Notes</td>
                    <td class="headerLabel">Images</td>
                </tr>

                <c:forEach var="genetics" items="${tumorFreq.tumorCytogenetics}" varStatus="status">
                    <c:choose>
                        <c:when test="${status.index%2==0}">
                            <tr class="stripe1">
                        </c:when>
                        <c:otherwise>
                            <tr class="stripe2">
                        </c:otherwise>
                    </c:choose>

                    <td>

                    <c:out value="${genetics.name}" escapeXml="false"/>

                    </td>
                    <td align="center">
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
                                            <tr class="${rowClass}">
                                        </c:if>

                                        <td valign="top">                                
                                            <table border=0 cellspacing=5 cellpadding=5>
                                                <tr>
                                                    <td width="160">

                                                        <a href="assayImageDetails.do?key=${image.assayImagesKey}">
                                                            <img width="150" src="${applicationScope.assayImageURL}/${applicationScope.assayImagePath}/${image.lowResName}"></a>
                                                    </td>
                                                    <td valign="top" align="left">
                                                        <table border=0 cellspacing=1 cellpadding=1 align="left">
                                                            <tr>
                                                                <td class="small" align="right"><b>Image ID</b>:</td>
                                                                <td class="small">${image.assayImagesKey}</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="small" align="right"><b>Source</b>:</td>
                                                                <td class="small">

                                                                    ${image.createUser}

                                                                </td>
                                                            </tr>

                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="small" colspan=2>
                                                        <b>Image Caption</b>:<br>
                                                        ${image.caption}
                                                    </td>
                                                </tr>
                                            </table>

                                        </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    &nbsp; 
                                </c:otherwise>
                            </c:choose>
                        </table>
                    </td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
        <c:otherwise>
            <!-- No genetics for this frequency record //-->
        </c:otherwise>
    </c:choose>





    <!-- End Cytogentics -->
</td>

</tr>

</table>
</body>
</html> 
