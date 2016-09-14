/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.SearchResults;
import org.jax.mgi.mtb.dao.custom.mtb.MTBAdvancedSearchDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBStrainTumorSummaryDTO;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.forms.AdvancedSearchForm;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * The AdvancedSearchResults class performs the advanced search.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class AdvancedSearchResultsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(AdvancedSearchResultsAction.class.getName());

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
        Timer timerTotal = new Timer();
        timerTotal.start();

        final AdvancedSearchForm formSearch = (AdvancedSearchForm)form;
        String strSortBy = formSearch.getSortBy();
        int nMaxItems = -1;
        final String strMaxItems = formSearch.getMaxItems();
        int nAgentType = -1;
        final String strAgentType = formSearch.getAgentType();
        final boolean bMetastasisLimit = formSearch.getMetastasisLimit();
        final boolean bMustHaveImages = formSearch.getMustHaveImages();
        final String strStrainNameComparison = formSearch.getStrainNameComparison();
        final String strStrainName = formSearch.getStrainName();
        final String[] arrStrStrainTypes = formSearch.getStrainTypes();
        List<String> arrStrainTypes = new ArrayList<String>();
        final String[] arrStrOrganTissueOrigin = formSearch.getOrganTissueOrigin();
        List<String> arrOrganTissueOrigin = new ArrayList<String>();
        final String[] arrStrTumorClassification = formSearch.getTumorClassification();
        List<String> arrTumorClassification = new ArrayList<String>();
        final String strGeneticName = formSearch.getGeneticName();
        
        // temp we think
        int colonySize = -1;
        int freqNum = -1;
        
        try {
            freqNum = Integer.parseInt(formSearch.getFreqNum());
        } catch (NumberFormatException ignore) {
        }
        try {
           colonySize = Integer.parseInt(formSearch.getColonySize());
        } catch (NumberFormatException ignore) {
        }

        if (arrStrStrainTypes != null) {
            arrStrainTypes = new ArrayList<String>(Arrays.asList(arrStrStrainTypes));
            // we added an "ANY" to the strain type list box and others so
            // now we need to remove it if it exists
            arrStrainTypes.remove("");
        }

        if (arrStrOrganTissueOrigin != null) {
            arrOrganTissueOrigin = new ArrayList<String>(Arrays.asList(arrStrOrganTissueOrigin));
            arrOrganTissueOrigin.remove("");
        }

        if (arrStrTumorClassification != null) {
            arrTumorClassification = new ArrayList<String>(Arrays.asList(arrStrTumorClassification));
            arrTumorClassification.remove("");
        }


        try {
            nMaxItems = Integer.parseInt(strMaxItems);
        } catch (NumberFormatException ignore) {
            log.debug("Unable to convert max items to a numeric.", ignore);
        }

        try {
            if(strAgentType != null && strAgentType.trim().length() > 0){
              nAgentType = Integer.parseInt(strAgentType);
            }
        } catch (NumberFormatException ignore) {
            log.debug("Unable to convert agent type to a numeric.", ignore);
        }

        // perform the search
        SearchResults<MTBStrainTumorSummaryDTO> result = 
                search(arrOrganTissueOrigin,
                       arrTumorClassification,
                       nAgentType, 
                       bMetastasisLimit, 
                       bMustHaveImages,
                       strStrainNameComparison, 
                       strStrainName, 
                       arrStrainTypes,
                       strGeneticName,
                       strSortBy, 
                       nMaxItems,colonySize,freqNum);

        List listTumors = null;

        if (result != null) {
            listTumors = result.getList();

            // put all the matching tumors in the request
            request.setAttribute("tumors", listTumors);

            // need to send back (string, object) NOT (sting, int)
            request.setAttribute("numberOfResults", listTumors.size() + "");
            request.setAttribute("totalResults", result.getTotal() + "");
            request.setAttribute("tumorFrequencyRecords", 
                    result.getAncillaryTotal() + "");
        }

        request.setAttribute("geneticName", strGeneticName);
        request.setAttribute("strainNameComparison", strStrainNameComparison);
        request.setAttribute("strainName", strStrainName);
        request.setAttribute("strainTypes", 
                WIUtils.strainTypeKeysToLabel(arrStrainTypes));
        request.setAttribute("organTissueOrigins", 
                WIUtils.organKeysToLabel(arrOrganTissueOrigin));
        request.setAttribute("tumorClassifications", 
                WIUtils.tumorclassificationKeysToLabel(arrTumorClassification));
        request.setAttribute("agentType", 
                WIUtils.agenttypeKeyToLabel(nAgentType));

        if (bMetastasisLimit) {
            request.setAttribute("metastasisLimit", "Yes");
        }

        if (bMustHaveImages) {
            request.setAttribute("mustHaveImages", "Yes");
        }
        
        if ("strain".equalsIgnoreCase(strSortBy)) {
            strSortBy = "Strain Name";
        } else if ("organ".equalsIgnoreCase(strSortBy)) {
            strSortBy = "Organ of tumor origin";
        } else if ("tumorclassification".equalsIgnoreCase(strSortBy)) {
            strSortBy = "Tumor Classification";
        } else if ("straintype".equalsIgnoreCase(strSortBy)) {
            strSortBy = "Strain Type";
        } else if ("treatmenttype".equalsIgnoreCase(strSortBy)) {
            strSortBy = "Treatment Type";
        }

        request.setAttribute("sortBy", strSortBy);
        request.setAttribute("maxItems", strMaxItems);

        timerTotal.stop();

        if (log.isDebugEnabled()) {
            log.debug("TOTAL TIME: " + timerTotal.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Search for the tumors based upon the search criteria.
     * 
     * @param orderBy The field to order the results by.
     * @param maxItems The maximum number of results to return.
     * @return A SearchResults that contains the matching
     *         tumors.
     */
    public SearchResults<MTBStrainTumorSummaryDTO>
            search(Collection colOrgansOrigin,
                   Collection colTumorClassifications,
                   int nAgentType,
                   boolean bRestrictToMetastasis,
                   boolean bMustHaveImages,
                   String strStrainNameComparison,
                   String strStrainName,
                   Collection colStrainTypes,
                   String strGeneticName, 
                   String strOrderBy, 
                   int nMaxItems, int colonySize, int freqNum) {

        Timer timerDao = new Timer();
        timerDao.start();

        MTBAdvancedSearchDAO daoAdvanced = MTBAdvancedSearchDAO.getInstance();

        // create the collection of matching tumor to return
        SearchResults res = null;

        try {
            res = daoAdvanced.search(colOrgansOrigin,
                                colTumorClassifications,
                                nAgentType,
                                bRestrictToMetastasis,
                                bMustHaveImages,
                                strStrainNameComparison,
                                strStrainName,
                                colStrainTypes,
                                strGeneticName, 
                                strOrderBy, 
                                nMaxItems,colonySize,freqNum);
        } catch (Exception e) {
            log.error("Error performing advanced search", e);
        }

        timerDao.stop();

        if (log.isDebugEnabled()) {
            log.debug("DAO time: " + timerDao.toString());
        }

        return res;
    }
}
