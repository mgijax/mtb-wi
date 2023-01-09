<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Assay Image Detail">

    <jsp:attribute name="head">
        <link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
    </jsp:attribute>
    <jsp:body>
        <section id ="image-detail">
            <img src="${applicationScope.assayImageURL}/${applicationScope.assayImagePath}/${assayImage.imageName}" >
        </section>
        <section id="summary">
            <div class="container">
                <table>
                    <tbody>
                    <jax:sumrow dt="Caption" dd="${assayImage.caption}" />
                    <jax:sumrow dt="Contributor" dd ="${assayImage.sourceOfImage} (<a href='referenceDetails.do?key=${assayImage.imgRefKey}'>${assayImage.imgRefAccId}</a>)"/>
                    <jax:sumrow dt="Instituion" dd="${image.institution}" />
                    <jax:sumrow dt="Copyright" dd="${assayImage.copyright}" />

                    </tbody>
                </table>



                <table>
                    <caption>Genetic Changes</caption>
                    <tbody>
                        <tr>
                            <th>Mouse Chromosome</th>
                            <th>Name</th>
                            <th>Cytogenetic Type</th>
                            <th>Assay Type</th>
                            <th>Notes</th>
                        </tr>
                        <c:forEach var="dtoTGC" items="${dtoTGCs}" varStatus="status">
                            <tr>

                                <td>
                                    <jax:dl dt="" dd="${dtoTGC.displayChromosomes}" />
                                </td>
                                <td style="font-size:1em;">
                                    <jax:dl dt="" dd="${dtoTGC.name}" />
                                </td>
                                <td>
                                    <jax:dl dt="" dd="${dtoTGC.alleleTypeName}" />
                                </td>
                                <td>
                                    <jax:dl dt="" dd="${dtoTGC.assayType}" />
                                </td>
                                <td>
                                    <jax:dl dt="" dd="${dtoTGC.notes}" />  					
                                </td>
                        </tr>
                    </c:forEach>
                       
                    </tbody>
                </table>		




                <table>
                    <caption>Model Details</caption>
                    <tbody>
                        <tr>
                            
                            <td>
                    <jax:dl dt="MMHC ID" dd="<a href='tumorSummary.do?tumorFrequencyKeys=${assayImage.tumorFrequencyKey}'>MTB:${assayImage.tumorFrequencyKey}</a>" />
                    <jax:dl dt="Tumor Name" dd="${assayImage.organOrigin}&nbsp;&#8226;&nbsp;${assayImage.tumorClassName}" />
                    <jax:dl dt="Treatment Type" dd="${assayImage.treatmentType}" />
                    <jax:dl dt="Agent" dts="Agents" dds="${assayImage.agents}" />
                    <dl>
                        <dt>Tumor Synonyms</dt>
                        <c:forEach var="tumorSynonym" items="${assayImage.tumorSynonyms}">
                            <dd><c:out value="${tumorSynonym.name}" escapeXml="false"/></dd>
                        </c:forEach>
                    </dl>
                    <jax:dl dt="Organ Affected" dd="${assayImage.organAffected}" />
                    <jax:dl dt="Frequency" dd="${assayImage.frequencyString}" />
                    <jax:dl dt="Frequency Note" dd="${assayImage.frequencyNote}" />
                    <jax:dl dt="Reference" dd="<a href='referenceDetails.do?key=${assayImage.referenceKey}'>${assayImage.accessionId}</a>" />
                    </td>
                    </tr>
                    </tbody>
                </table>

                <table>
                    <caption>Strain Details</caption>
                    <tbody>
                        <tr>
                            
                            <td>
                    <jax:dl dt="Strain" dd="<a href='strainDetails.do?key=${assayImage.strainKey}'>${assayImage.strainName}</a>" />
                    <dl>
                        <dt>Strain Types</dt>
                        <c:forEach var="st" items="${assayImage.strainTypes}">
                            <dd><c:out value="${st.type}" escapeXml="false"/></dd>
                        </c:forEach>
                    </dl>			
                    <jax:dl dt="General Note" dd="${assayImage.strainNote}"/>
                    <dl>
                        <dt>Strain Synonyms</dt>
                        <c:forEach var="synonym" items="${assayImage.strainSynonyms}">
                            <dd><c:out value="${synonym.name}" escapeXml="false"/></dd>
                        </c:forEach>
                    </dl>
                    <jax:dl dt="Strain Sex" dd="${assayImage.sex}" />
                    <jax:dl dt="Reproductive Status" dd="${assayImage.reproductiveStatus}" />
                    <jax:dl dt="Age of Onset" dd="${assayImage.ageOfOnset}" />
                    <jax:dl dt="Age of Detection" dd="${assayImage.ageOfDetection}" />

                    </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>

    </jsp:body>
</jax:mmhcpage>

