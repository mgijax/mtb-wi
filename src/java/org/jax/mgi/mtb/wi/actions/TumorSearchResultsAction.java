/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.SearchResults;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBStrainTumorSummaryDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBStrainUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBUtilitiesDAO;
import org.jax.mgi.mtb.dao.custom.mtb.param.StrainSearchParams;
import org.jax.mgi.mtb.dao.custom.mtb.param.TumorFrequencySearchParams;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.forms.TumorSearchForm;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * The TumorSearchResultsAction class performs the search for tumor frequency
 * records.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class TumorSearchResultsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(TumorSearchResultsAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Perform the search.
     *
     * @param mapping the action mapping that determines where we need to go
     * @param form the form bean
     * @param request standard servlet request
     * @param response standard servlet response
     * @return the ActionForward object that indicates where to go
     * @throws Exception if the application business logic throws an exception.
     * @see org.apache.struts.action.ActionMapping
     * @see org.apache.struts.action.ActionForm
     * @see javax.servlet.http.HttpServletRequest
     * @see javax.servlet.http.HttpServletResponse
     */
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
        throws Exception {

        // default target to success
        String strTarget = "success";

        // time the overall execution
        Timer timer = new Timer();
        timer.start();

        // retrieve the parameters

        ///////////////////////////////////////////////////////////////////////
        // from the tumor search form
        ///////////////////////////////////////////////////////////////////////
        TumorSearchForm formSearch = (TumorSearchForm)form;

        String[] arrStrOrganTissueOrigin = formSearch.getOrganTissueOrigin();
        List<String> arrOrganTissueOrigin = new ArrayList<String>();
        String[] arrStrTumorClassification = formSearch.getTumorClassification();
        List<String> arrTumorClassification = new ArrayList<String>();
        String strTumorName = formSearch.getTumorName();
        String strAgentType = formSearch.getAgentType();
        String strAgent = formSearch.getAgent();
        boolean bMetastasisLimit = formSearch.getMetastasisLimit();
        String[] arrStrOrganTissueAffected = formSearch.getOrganTissueAffected();
        List<String> arrOrganTissueAffected = new ArrayList<String>();
        boolean bMustHaveImages = formSearch.getMustHaveImages();
        boolean bExcludePlasias = false;
        String strSortBy = formSearch.getSortBy();
        String strMaxItems = formSearch.getMaxItems(); 

        ///////////////////////////////////////////////////////////////////////
        // from the genetics summary page
        // allelePairKey,organTissueOrigin,tumorClassification,agentType
        ///////////////////////////////////////////////////////////////////////
        String strAllelePairKeys = request.getParameter("allelePairKey");
        if(strAllelePairKeys != null){
            String[] apKeys = strAllelePairKeys.split(",");
            StringBuilder apSB = new StringBuilder();
            for(int i = 0; i < apKeys.length; i++ ){
                try{
                    if(apSB.length()>0){
                        apSB.append(",").append(new Long(apKeys[i].trim()).toString());
                    }else{
                        apSB.append(new Long(apKeys[i].trim()).toString());
                    }
                }catch(Exception e){
                    // ignore bad characters
                }
            }
            strAllelePairKeys = apSB.toString();
        }
        ///////////////////////////////////////////////////////////////////////
        // from the reference detail page
        // referenceKey
        ///////////////////////////////////////////////////////////////////////
        String referenceKeyStr = request.getParameter("referenceKey");

        ///////////////////////////////////////////////////////////////////////
        // from Ulli (caMOD)
        ///////////////////////////////////////////////////////////////////////
        String strAnatomicalSystemOriginName = request.getParameter("anatomicalSystemOriginName");
        String strOrganOriginName = request.getParameter("organOriginName");
        String strOrganOriginComparison = request.getParameter("organOriginNameComparison");
        String strOrganAffectedName = request.getParameter("organAffectedName");
        String strOrganAffectedComparison = request.getParameter("organAffectedNameComparison");
        String strColonySize = request.getParameter("colonySize");
        String strFrequency = request.getParameter("frequency");

        int nColonySize = -1;
        int nColonySizeComparison = TumorFrequencySearchParams.NUMERIC_COMPARE_GREATERTHAN;
        double dFrequency = -1.0;
        int nFrequencyComparison = TumorFrequencySearchParams.NUMERIC_COMPARE_GREATERTHAN;
        int nOrganOriginNameComparison = TumorFrequencySearchParams.STRING_COMPARE_CONTAINS;
        int nOrganAffectedNameComparison = TumorFrequencySearchParams.STRING_COMPARE_CONTAINS;

        if ("NC".equals(strOrganOriginComparison)) {
            nOrganOriginNameComparison = TumorFrequencySearchParams.STRING_COMPARE_NOTCONTAINS;
        }

        if ("NC".equals(strOrganAffectedComparison)) {
            nOrganAffectedNameComparison = TumorFrequencySearchParams.STRING_COMPARE_NOTCONTAINS;
        }

        ///////////////////////////////////////////////////////////////////////
        // from the tumor frequency grid
        // fromGrid replaces excludeMets=on&strainTypes=8&exactStrainTypes=on&agentType=0
        ///////////////////////////////////////////////////////////////////////
        String strGrid = request.getParameter("grid");
        String strStrainKey = request.getParameter("strainKey");
        String strStrainFamilyKey = request.getParameter("strainFamilyKey");
        String strOrganOriginKey = request.getParameter("organKey");
        String strOrganOriginParentKey = request.getParameter("organParentKey");

        String strAccId = null;
        long lMaxItems = -1;
        long lAgentType = -1;
        long lReferenceKey = -1;
        long lStrainKey = -1;
        long lStrainFamilyKey = -1;
        long lOrganOriginKey = -1;
        long lOrganOriginParentKey = -1;
        int  sexKey = -1;
        boolean bExcludeMets = false;
        boolean bExactStrainTypes = false;
        List<String> listStrainTypes = new ArrayList<String>();

        // from the grid
        if ("1".equalsIgnoreCase(strGrid)) {
            listStrainTypes.add("8");
            bExcludeMets = true;
            bExactStrainTypes = true;
            bExcludePlasias = true;
            lAgentType = 0;
            strAgentType = "0";
            strMaxItems = "No Limit";

            // parse the string to numerics
            lStrainKey = WIUtils.stringToLong(strStrainKey, -1);
            lStrainFamilyKey = WIUtils.stringToLong(strStrainFamilyKey, -1);
            lOrganOriginKey = WIUtils.stringToLong(strOrganOriginKey, -1);
            lOrganOriginParentKey = WIUtils.stringToLong(strOrganOriginParentKey, -1);
        }
        
        
        // need to expand options for marker grid ie add params
        // sex key
        // marker grid
        // difference between 2 and 3 is only setting strAgentType
        if ("2".equalsIgnoreCase(strGrid)) {
         //   listStrainTypes.add("8");
            bExcludeMets = true;
         //   bExactStrainTypes = true;
            bExcludePlasias = true;
            lAgentType = 0;
            strAgentType = "-1";  // any
            strMaxItems = "No Limit";

            // parse the string to numerics
            lStrainKey = WIUtils.stringToLong(strStrainKey, -1);
            lStrainFamilyKey = WIUtils.stringToLong(strStrainFamilyKey, -1);
            lOrganOriginKey = WIUtils.stringToLong(strOrganOriginKey, -1);
            lOrganOriginParentKey = WIUtils.stringToLong(strOrganOriginParentKey, -1);
        }
        
         // marker grid
        if ("3".equalsIgnoreCase(strGrid)) {
         //   listStrainTypes.add("8");
            bExcludeMets = true;
         //   bExactStrainTypes = true;
            bExcludePlasias = true;
            lAgentType = 0;
            strAgentType = "0";  //  only spontaneous
            strMaxItems = "No Limit";

            // parse the string to numerics
            lStrainKey = WIUtils.stringToLong(strStrainKey, -1);
            lStrainFamilyKey = WIUtils.stringToLong(strStrainFamilyKey, -1);
            lOrganOriginKey = WIUtils.stringToLong(strOrganOriginKey, -1);
            lOrganOriginParentKey = WIUtils.stringToLong(strOrganOriginParentKey, -1);
        }
        

        // convert the arrays to Lists and remove the empty values
        arrOrganTissueOrigin = WIUtils.arrayToCleanKeyList(arrStrOrganTissueOrigin);
        arrTumorClassification = WIUtils.arrayToCleanKeyList(arrStrTumorClassification);
        // this is only for metastisis apparently
        arrOrganTissueAffected = WIUtils.arrayToCleanKeyList(arrStrOrganTissueAffected);

        // parse the string to numerics
      
        lReferenceKey = WIUtils.stringToLong(referenceKeyStr, 0);
        lAgentType = WIUtils.stringToLong(strAgentType, -1);
        lMaxItems = WIUtils.stringToLong(strMaxItems, -1);
        nColonySize = WIUtils.stringToInt(strColonySize, -1);
        dFrequency = WIUtils.stringToDouble(strFrequency, -1.0);

        TumorFrequencySearchParams tfParams = new TumorFrequencySearchParams();
        tfParams.setOrgansAffected(arrOrganTissueAffected);
        tfParams.setOrgansOrigin(arrOrganTissueOrigin);
        tfParams.setTumorClassifications(arrTumorClassification);
        tfParams.setAgent(strAgent);
        tfParams.setAgentTypeKey(lAgentType);
        tfParams.setRestrictToMetastasis(bMetastasisLimit);
        tfParams.setMustHaveImages(bMustHaveImages);
        tfParams.setExcludeMets(bExcludeMets);
        tfParams.setExcludePlasias(bExcludePlasias);
        tfParams.setTumorName(strTumorName);
        tfParams.setReferenceKey(lReferenceKey);
        tfParams.setAnatomicalSystemOriginName(strAnatomicalSystemOriginName);
        tfParams.setOrganOriginName(strOrganOriginName);
        tfParams.setOrganOriginNameComparison(nOrganOriginNameComparison);
        tfParams.setOrganAffectedName(strOrganAffectedName);
        tfParams.setOrganAffectedNameComparison(nOrganAffectedNameComparison);
        tfParams.setOrganOriginKey(lOrganOriginKey);
        tfParams.setOrganOriginParentKey(lOrganOriginParentKey);
        tfParams.setAllelePairKeys(strAllelePairKeys);
        tfParams.setColonySize(nColonySize);
        tfParams.setColonySizeComparison(nColonySizeComparison);
        tfParams.setFrequency(dFrequency);
        tfParams.setFrequencyComparison(nFrequencyComparison);
        tfParams.setSexKey(sexKey);
        
        
        StrainSearchParams strainParams = new StrainSearchParams();
        strainParams.setStrainKey(lStrainKey);
        strainParams.setStrainFamilyKey(lStrainFamilyKey);
        strainParams.setStrainTypes(listStrainTypes);
        strainParams.setExactStrainTypes(bExactStrainTypes);
        strainParams.setStrainKeyComparison("=");
        
        // time the dao
        Timer timerDao = new Timer();
        timerDao.start();

        // perform the search
        MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();

        // create the collection of matching tumor to return
        SearchResults<MTBStrainTumorSummaryDTO> result = null;
        try {
            result = daoTumorUtil.searchNewSummary(tfParams,
                                                   strainParams,
                                                   strSortBy,
                                                   lMaxItems);
        } catch (Exception e) {
            log.error("Error searching for tumors", e);
        }

        timerDao.stop();

        if (log.isDebugEnabled()) {
            log.debug("TumorSearchResultsAction: DAO TIME: " +
                      timerDao.toString());
        }

        List<MTBStrainTumorSummaryDTO> colTumors = null;

        strAccId = getAccessionId(lReferenceKey);
    
        if(request.getParameter("asJson")!=null){
          asJason(result.getList(), response);
          return null;
        }
        
        if (result != null) {
            colTumors = result.getList();

            // put all the matching tumors in the request
            request.setAttribute("tumors", colTumors);
            request.setAttribute("numberOfResults", colTumors.size() + "");
            request.setAttribute("totalResults", result.getTotal() + "");
            request.setAttribute("tumorFrequencyRecords",
                    result.getAncillaryTotal() + "");
        }

        request.setAttribute("anatomicalSystemOriginName", strAnatomicalSystemOriginName);
        request.setAttribute("tumorName", strTumorName);
        request.setAttribute("organTissueOrigins",
                WIUtils.organKeysToLabel(arrOrganTissueOrigin));
        request.setAttribute("organsAffected",
                WIUtils.organKeysToLabel(arrOrganTissueAffected));
        request.setAttribute("tumorClassifications",
                WIUtils.tumorclassificationKeysToLabel(arrTumorClassification));
        request.setAttribute("accessionId", getAccessionId(lReferenceKey));
        request.setAttribute("agent", strAgent);
        request.setAttribute("agentType", WIUtils.agenttypeKeyToLabel(lAgentType));
        request.setAttribute("accId", strAccId);

        if (bMetastasisLimit) {
            request.setAttribute("metastasisLimit", "Yes");
        }

        if (bMustHaveImages) {
            request.setAttribute("mustHaveImages", "Yes");
        }

        if (lStrainKey > 0) {
            String strStrainName = MTBStrainUtilDAO.getInstance().getStrainName(lStrainKey);
            request.setAttribute("strainName", strStrainName);
        }

        if (lStrainFamilyKey > 0) {
            String strStrainFamilyName = MTBStrainUtilDAO.getInstance().getStrainFamilyName(lStrainFamilyKey);
            request.setAttribute("strainFamilyName", strStrainFamilyName);
        }

        if (lOrganOriginKey > 0) {
            String strOrganName = MTBUtilitiesDAO.getInstance().getOrganName(lOrganOriginKey);
            request.setAttribute("organOriginName", strOrganName);
        } else if (StringUtils.hasValue(strOrganOriginName)) {
            if (nOrganOriginNameComparison == TumorFrequencySearchParams.STRING_COMPARE_NOTCONTAINS) {
                request.setAttribute("organOriginName", "<i>not</i> " + strOrganOriginName);
            } else {
                request.setAttribute("organOriginName", strOrganOriginName);
            }
        }

        if (lOrganOriginParentKey > 0) {
            String strOrganName = MTBUtilitiesDAO.getInstance().getOrganName(lOrganOriginParentKey);
            request.setAttribute("organOriginName", strOrganName);
        }

        if (StringUtils.hasValue(strOrganAffectedName)) {
            if (nOrganAffectedNameComparison == TumorFrequencySearchParams.STRING_COMPARE_NOTCONTAINS) {
                request.setAttribute("organAffectedName", "<i>not</i> " + strOrganAffectedName);
            } else {
                request.setAttribute("organAffectedName", strOrganAffectedName);
            }
        }

        if (nColonySize > -1) {
            request.setAttribute("colonySize", " > " + nColonySize);
        }

        if (dFrequency > -1) {
            request.setAttribute("frequency", " > " + dFrequency);
        }

        request.setAttribute("strainTypes",
                WIUtils.strainTypeKeysToLabel(listStrainTypes));

        request.setAttribute("sortBy", strSortBy);
        request.setAttribute("maxItems", strMaxItems);

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("TumorSearchResultsAction: TOTAL TIME: " +
                        timer.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    private String getAccessionId(long lReferenceKey) {
        String strAccId = null;

        if (lReferenceKey != -1) {
            try {
                // create a Reference DAO
                MTBReferenceUtilDAO daoRefUtil =
                        MTBReferenceUtilDAO.getInstance();
                // get the accession id
                strAccId = daoRefUtil.getJNumByReference(lReferenceKey);
            } catch (Exception e) {
                log.error("Error retrieving accession id by reference", e);
            }
        }

        return strAccId;
    }
    // this is for a proof of concept YUI paginated search result
    private void asJason(List<MTBStrainTumorSummaryDTO> list, HttpServletResponse response) throws IOException{
      
       response.setContentType("text/plain");
       StringBuffer tumors = new StringBuffer();
       tumors.append("{ \"tumors\":[");
       for(MTBStrainTumorSummaryDTO dto : list){
         
         tumors.append("{\"tumorName\":\"").append(dto.getTumorName()).append("\",");
         tumors.append("\"organAffectedName\":\"").append(dto.getOrganAffectedName()).append("\",");
         tumors.append("\"agent\":\"").append(dto.getTreatmentType()).append("\",");
         if(dto.getAgentsCollection().size()>0){
          tumors.append("\"agentInfo\":["); 
          for(String agent :  dto.getAgentsCollection()){
            tumors.append("\"").append(agent).append("\",");
          }
          tumors.deleteCharAt(tumors.length()-1);
          tumors.append("],");
         }
         tumors.append("\"strainKey\":\"").append(dto.getStrainKey()).append("\",");
         tumors.append("\"strainName\":\"").append(dto.getStrainName()).append("\",");
        
         if(dto.getStrainTypesCollection().size()>0){
          tumors.append("\"strainType\":["); 
          for(String strainType :  dto.getStrainTypesCollection()){
            tumors.append("\"").append(strainType).append("\",");
          }
          tumors.deleteCharAt(tumors.length()-1);
          tumors.append("],");
         }
         tumors.append("\"f\":\"").append(dto.getFreqFemaleString()).append("\",");
         tumors.append("\"m\":\"").append(dto.getFreqMaleString()).append("\",");
         tumors.append("\"mixed\":\"").append(dto.getFreqMixedString()).append("\",");
         tumors.append("\"unknown\":\"").append(dto.getFreqUnknownString()).append("\",");
         tumors.append("\"mets\":[");
         if(dto.getMetastasizesToDisplay().size()>0){
          for(String mets : dto.getMetastasizesToDisplay()){
            tumors.append("\"").append(mets).append("\",");
          }
          tumors.deleteCharAt(tumors.length()-1);
          
         }else{
           tumors.append("");
         }
         tumors.append("],\"image\":");
         if(dto.getImages()){
           tumors.append("\"image\"");
         }else{
           tumors.append("\"\"");
         }
         tumors.append(",\"summary\":\"tumorSummary.do?strainKey=").append(dto.getStrainKey()).append("&amp;organOfOriginKey=").append(dto.getOrganOfOriginKey());
         tumors.append("&amp;tumorFrequencyKeys=").append(dto.getAllTFKeysAsParams());
         tumors.append("\"");
         
       /*  
                              organ:"<c:out value="${tumor.organAffectedName}" escapeXml="false"/>",
                              agent:["<c:out value="${tumor.treatmentType}" escapeXml="false"/>"
                                  <c:if test="${(not empty tumor.agentsCollection) && (fn:length(tumor.agentsCollection) > 0)}">
                                  <c:forEach var="agentInfo" items="${tumor.agentsCollection}" varStatus="status">
                                  <c:if test="${(not empty agentInfo) && (fn:length(agentInfo) > 0)}">,"<c:out value="${agentInfo}" escapeXml="false"/>"
                                  </c:if>
                                  </c:forEach>
                                  </c:if>],strain:["<c:out value="${tumor.strainKey}"/>"
                                ,"<c:out value="${tumor.strainName}" escapeXml="false"/>"<c:if test="${not empty tumor.strainTypesCollection}"><c:forEach var="strainType" items="${tumor.strainTypesCollection}" varStatus="status">,"${strainType}"
                                  </c:forEach>
                                  </c:if>],
                              f:"<c:out value="${tumor.freqFemaleString}" escapeXml="false" default="&nbsp;"/>",
                              m:"<c:out value="${tumor.freqMaleString}" escapeXml="false" default="&nbsp;"/>",
                              mixed:"<c:out value="${tumor.freqMixedString}" escapeXml="false" default="&nbsp;"/>",
                              unk:"<c:out value="${tumor.freqUnknownString}" escapeXml="false" default="&nbsp;"/>",
                              mets:<c:choose>
                                <c:when test="${not empty tumor.metastasizesToDisplay}">"<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">${organ}<c:if test="${status.last != true}"><br></c:if>
                                </c:forEach>",
                                </c:when>
                                <c:otherwise>"",</c:otherwise>
                                </c:choose>
                                image:<c:choose><c:when test="${tumor.images==true}">"image",</c:when>
                                <c:otherwise>"",</c:otherwise>
                                </c:choose>
                                summary:"tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}",},
                                </c:forEach>
         
         */
         
         tumors.append("},\n");
       }
       // drop the last comma
       tumors.deleteCharAt(tumors.length()-2);
       
       
       tumors.append("]}");
     
      
       
       
      response.getWriter().write(tumors.toString());
      response.flushBuffer();
      
      
    }
}
