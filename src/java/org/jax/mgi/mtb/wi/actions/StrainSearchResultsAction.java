/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
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
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBStrainSearchDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBStrainUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.param.StrainSearchParams;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.forms.StrainSearchForm;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * The StrainSearchResults class performs the search for strains.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class StrainSearchResultsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(StrainSearchResultsAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Search for the strains.
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
        Timer timer = new Timer();
        timer.start();

        ///////////////////////////////////////////////////////////////////////
        // get all the variables that are needed from the form
        ///////////////////////////////////////////////////////////////////////
        StrainSearchForm formStrainSearch = (StrainSearchForm) form;
        String strStrainNameLikeClause = formStrainSearch.getLikeClause();
        String strStrainName = formStrainSearch.getStrainName();
        String strGeneticName = formStrainSearch.getGeneticName();
        String[] arrStrStrainTypes = formStrainSearch.getStrainTypes();
        List<String> arrStrainTypes = new ArrayList<String>();
        String strJAXStockNumber = formStrainSearch.getJaxStockNumber();
        String strReferenceKey = formStrainSearch.getReferenceKey();
        String strAllelePairKey = formStrainSearch.getAllelePairKey();
        String strSortBy = formStrainSearch.getSortBy();
        String strMaxItems = formStrainSearch.getMaxItems();
        String strAccId = null;

        // make sure that the format is ###### with leading zeros
        if (StringUtils.hasValue(strJAXStockNumber)) {
            strJAXStockNumber = StringUtils.padLeft(strJAXStockNumber, 6, '0');
        }

        long lReferenceKey = WIUtils.stringToLong(strReferenceKey, 0);

        // this is only used from the genetics search results screen
        long lAllelePairKey = WIUtils.stringToLong(strAllelePairKey, -1l);

        List<String> arrSites = new ArrayList<String>();
        List<String> arrSiteNames = new ArrayList<String>();

        if (formStrainSearch.getSiteJaxMice()) {
            int i = WIConstants.getInstance().getSiteIdJaxMice();
            arrSites.add(i + "");
            arrSiteNames.add(WIConstants.getInstance().getLongSiteName(i));
        }

        if (formStrainSearch.getSiteNCIMR()) {
            int i = WIConstants.getInstance().getSiteIdNCIMR();
            arrSites.add(i + "");
            arrSiteNames.add(WIConstants.getInstance().getLongSiteName(i));
        }

        arrStrainTypes = WIUtils.arrayToCleanKeyList(arrStrStrainTypes);
        long lMaxItems = WIUtils.stringToLong(strMaxItems, -1l);

        StrainSearchParams strainParams = new StrainSearchParams();
        strainParams.setStrainName(strStrainName);
        strainParams.setStrainNameComparison(strStrainNameLikeClause);
        strainParams.setStrainTypes(arrStrainTypes);
        strainParams.setReferenceKey(lReferenceKey);
        strainParams.setAllelePairKey(lAllelePairKey);
        strainParams.setGeneticName(strGeneticName);
        strainParams.setJAXMiceStockNumber(strJAXStockNumber);
        strainParams.setSites(arrSites);

        Timer timerDao = new Timer();
        timerDao.start();

        MTBStrainUtilDAO dao = MTBStrainUtilDAO.getInstance();

        // create the collection of matching strains to return
        SearchResults<MTBStrainSearchDTO> resultStrains = null;

        try {
            // search for the strains
            resultStrains = dao.searchStrain(strainParams,
                                             strSortBy,
                                             lMaxItems);
        } catch (Exception e) {
            log.error("Error searching for strains", e);
        }

        timerDao.stop();

        if (log.isDebugEnabled()) {
            log.debug("StrainSearchResultsAction: DAO TIME: " +
                      timerDao.toString());
        }

        try {
            if (StringUtils.hasValue(strReferenceKey)) {
                // create a Reference DAO
                MTBReferenceUtilDAO daoRefUtil =
                        MTBReferenceUtilDAO.getInstance();
                // get the accession id
                strAccId = daoRefUtil.getJNumByReference(lReferenceKey);
            }
        } catch (Exception e) {
            log.error("Converting " + strReferenceKey, e);
        }

        Collection<String> colStrainTypesForDisplay =
                WIUtils.strainTypeKeysToLabel(arrStrainTypes);
        String strSitesForDisplay =
                StringUtils.collectionToString(arrSiteNames, ", ", "");
        int nStrainTypesSize = 0;

        if (colStrainTypesForDisplay != null) {
            nStrainTypesSize = colStrainTypesForDisplay.size();
        }

        // put all the matching strains in the request
        if (resultStrains != null) {
            request.setAttribute("strains", resultStrains.getList());
            request.setAttribute("numberOfResults",
                                 resultStrains.getList().size() + "");
            request.setAttribute("totalResults",
                                 resultStrains.getTotal() + "");
        }

        request.setAttribute("strainComparison",
                StringUtils.initCap(
                        WIUtils.convertComparison(strStrainNameLikeClause)));
        request.setAttribute("strainName", strStrainName);
        request.setAttribute("strainTypes", colStrainTypesForDisplay);
        request.setAttribute("strainTypesSize", nStrainTypesSize + "");
        request.setAttribute("geneticName", strGeneticName);
        request.setAttribute("sites", strSitesForDisplay);
        request.setAttribute("sortBy", StringUtils.initCap(strSortBy));
        request.setAttribute("maxItems", strMaxItems);
        request.setAttribute("jaxMiceStockNumber", strJAXStockNumber);
        request.setAttribute("accId", strAccId);

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("StrainSearchResultsAction: " + timer.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods
    // none
}
