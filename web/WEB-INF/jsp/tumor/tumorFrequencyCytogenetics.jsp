<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Tumor Cytogenetics"/>
    </c:import>
</head>

<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="Tumor Cytogenetics"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td valign="top">
            <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                <tr>
                    <td>
                        <!- Cytogenetics -->
                <c:choose>
                    <c:when test="${not empty tumorFreqs}">
                        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                            <tr>
                                <td colspan="6" class="resultsHeaderLeft">
                                    <font class="larger">Tumor Cytogenetics</font>

                                </td>
                            </tr>
                        </table>

                        <c:forEach var="tumorFreq" items="${tumorFreqs}" varStatus="statusTF">

                            <!------------------------------------------------------------------------------>
                            <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                                <tr>
                                    <td class="resultsHeader">MTB ID</td>
                                    <td class="resultsHeader">Organ Affected</td>
                                    <td class="resultsHeader">Treatment Type<br><font size="-2"><i>Agents</i></font></td>
                                    <td class="resultsHeader">Strain Sex</td>
                                    <td class="resultsHeader">Reproductive Status</td>
                                    <td class="resultsHeader">Frequency</td>
                                    <td class="resultsHeader">Age Of<br>Onset</td>
                                    <td class="resultsHeader">Age Of<br>Detection</td>
                                    <td class="resultsHeader">Reference</td>
                                </tr>
                                <tr class="stripe1">
                                    <td>MTB:${tumorFreq.tumorFrequencyKey}</td>
                                    <td>
                                <c:choose>
                                    <c:when test="${not empty tumorFreq.organAffected}">
                                        <c:choose>
                                            <c:when test="${tumorFreq.parentFrequencyKey>0}">
                                                <font color="red">
                                                    <c:out value="${tumorFreq.organAffected}" escapeXml="false"/>
                                                </font>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${tumorFreq.organAffected}" escapeXml="false"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        &nbsp;
                                        <!--There is no organ affected associated with this tumor frequency record . //-->
                                    </c:otherwise>
                                </c:choose>
                                </td>
                                <td>
                                <c:out value="${tumorFreq.treatmentType}" escapeXml="false"/>
                                <c:choose>
                                    <c:when test="${not empty tumorFreq.agents}">
                                        <i>
                                            <c:forEach var="agent" items="${tumorFreq.agents}" varStatus="status">
                                                <font size="-2">
                                                    ${agent}
                                                    <c:if test="${status.last != true}">
                                                        <br>
                                                    </c:if>
                                                </font>
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
                                    <br>
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
                                        &nbsp;
                                        <!--There is no reference associated with this tumor frequency record . //-->
                                    </c:otherwise>
                                </c:choose>
                                </td>
                            </table>   



                            <!------------------------------------------------------------------------>


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
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- No genetics for this frequency record //-->
                    </c:otherwise>
                </c:choose>

        </td>

    </tr>

</table>
</body>
</html> 
