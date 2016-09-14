 /**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.SearchResults;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceSearchDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.param.ReferenceSearchParams;
import org.jax.mgi.mtb.dao.gen.mtb.ReferenceDAO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.forms.ReferenceSearchForm;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * The ReferenceSearchResultsAction class performs the search for references.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class ReferenceSearchResultsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(ReferenceSearchResultsAction.class.getName());
    public final String COMPARE_REF_PRIMARYAUTH = ReferenceDAO.NAME_PRIMARYAUTHOR;
    public final String COMPARE_REF_PRIMARYAUTH_NICE = "First Author";

    // ----------------------------------------------------- Instance Variables
    // none

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
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

        ReferenceSearchForm formSearch = (ReferenceSearchForm) form;
        String strRefAccId = formSearch.getReferenceAccessionId();
        String strFirstAuthor = formSearch.getFirstAuthor();
        String strFirstAuthorComparison = formSearch.getFirstAuthorComparison();
        String strAuthors = formSearch.getAuthors();
        String strAuthorsComparison = formSearch.getAuthorsComparison();
        String strJournal = formSearch.getJournal();
        String strJournalComparison = formSearch.getJournalComparison();
        String strYear = formSearch.getYear();
        String strYearComparison = formSearch.getYearComparison();
        String strVolume = formSearch.getVolume();
        String strVolumeComparison = formSearch.getVolumeComparison();
        String strPages = formSearch.getPages();
        String strPagesComparison = formSearch.getPagesComparison();
        String strTitle = formSearch.getTitle();
        String strTitleComparison = formSearch.getTitleComparison();
        String strOrderBy = formSearch.getSortBy();
        String strMaxItems = formSearch.getMaxItems();
        
        String[] organs = formSearch.getOrganTissue();
        String[] tClassifications = formSearch.getTumorClassification();

        int nMaxRows = -1;
        try {
            nMaxRows = Integer.parseInt(strMaxItems);
        } catch (NumberFormatException nfe) {
            nMaxRows = -1;
        }

        Timer timerDao = new Timer();
        timerDao.start();
        
        // create a ReferenceUtilDAO
        MTBReferenceUtilDAO daoRefUtil = MTBReferenceUtilDAO.getInstance();
        SearchResults<MTBReferenceSearchDTO> resRef = null;
        
          ReferenceSearchParams params = new ReferenceSearchParams();
        
          
          // for now we only get one selection... this could be expanded to multiple selections?
         
        if(organs.length > 0){
            params.setOrgan(new Long(organs[0]));
        }
        if(tClassifications.length > 0){
            params.setTumorClassification(new Long(tClassifications[0]));
        }

        try {
            // search for references
          
            params.setReferenceKey(0);
            params.setReferenceAccessionId(strRefAccId);
            params.setFirstAuthor(strFirstAuthor);
            params.setFirstAuthorComparison(strFirstAuthorComparison);
            params.setAuthors(strAuthors);
            params.setAuthorsComparison(strAuthorsComparison);
            params.setJournal(strJournal);
            params.setJournalComparison(strJournalComparison);
            params.setYear(strYear);
            params.setYearComparison(strYearComparison);
            params.setVolume(strVolume);
            params.setVolumeComparison(strVolumeComparison);
            params.setPages(strPages);
            params.setPagesComparison(strPagesComparison);
            params.setTitle(strTitle);
            params.setTitleComparison(strTitleComparison);
            params.setOrderBy(strOrderBy);
            params.setMaxItems(nMaxRows);
            params.setIncludeRejected(false);
            resRef = daoRefUtil.searchReference(params);
        } catch (Exception e) {
            log.error("Error searching for references", e);
            StringBuffer sb = new StringBuffer();
            sb.append("referenceAccessionId = ").append(strRefAccId).append(WIConstants.EOL);
            sb.append("firstAuthor = ").append(strFirstAuthor).append(WIConstants.EOL);
            sb.append("firstAuthorComparison = ").append(strFirstAuthorComparison).append(WIConstants.EOL);
            sb.append("authors = ").append(strAuthors).append(WIConstants.EOL);
            sb.append("authorsComparison = ").append(strAuthorsComparison).append(WIConstants.EOL);
            sb.append("journal = ").append(strJournal).append(WIConstants.EOL);
            sb.append("journalComparison = ").append(strJournalComparison).append(WIConstants.EOL);
            sb.append("year = ").append(strYear).append(WIConstants.EOL);
            sb.append("yearComparison = ").append(strYearComparison).append(WIConstants.EOL);
            sb.append("volume = ").append(strVolume).append(WIConstants.EOL);
            sb.append("volumeComparison = ").append(strVolumeComparison).append(WIConstants.EOL);
            sb.append("pages = ").append(strPages).append(WIConstants.EOL);
            sb.append("pagesComparison = ").append(strPagesComparison).append(WIConstants.EOL);
            sb.append("title = ").append(strTitle).append(WIConstants.EOL);
            sb.append("titleComparison = ").append(strTitleComparison).append(WIConstants.EOL);
            sb.append("orderBy = ").append(strOrderBy).append(WIConstants.EOL);
            sb.append("maxItems = ").append(strMaxItems).append(WIConstants.EOL);
            log.error(sb.toString());
        }

        timerDao.stop();

        if (log.isDebugEnabled()) {
            log.debug("MTBReferenceUtilDAO.searchReference() - " +
                        timerDao.toString());
        }

        if (resRef != null) {
            // put all the matching references in the request
            request.setAttribute("references", resRef.getList());
            // need to send back (string, object) NOT (sting, int)
            request.setAttribute("numberOfResults", resRef.getSize() + "");
            request.setAttribute("totalResults", resRef.getTotal() + "");
        }

        request.setAttribute("accId", strRefAccId);
        request.setAttribute("firstAuthor", strFirstAuthor);
        request.setAttribute("firstAuthorComparison",
                StringUtils.initCap(
                        WIUtils.convertComparison(strFirstAuthorComparison)));
        request.setAttribute("authors", strAuthors);
        request.setAttribute("authorsComparison",
                             StringUtils.initCap(strAuthorsComparison));
        request.setAttribute("journal", strJournal);
        request.setAttribute("journalComparison",
                             StringUtils.initCap(strJournalComparison));
        request.setAttribute("year", strYear);
        request.setAttribute("yearComparison",
               StringUtils.initCap(
                        WIUtils.convertComparison(strYearComparison)));
        request.setAttribute("volume", strVolume);
        request.setAttribute("volumeComparison",
                             StringUtils.initCap(strVolumeComparison));
        request.setAttribute("pages", strPages);
        request.setAttribute("pagesComparison",
                             StringUtils.initCap(strPagesComparison));
        request.setAttribute("title", strTitle);
        request.setAttribute("titleComparison",
                             WIUtils.convertComparison(strTitleComparison));
        request.setAttribute("abstractText", null);
        request.setAttribute("abstractTextComparison", null);
        request.setAttribute("sortBy",
                StringUtils.initCap(convertOrderBy(strOrderBy)));
        request.setAttribute("maxItems", strMaxItems);

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("ReferenceSearchResultsAction: " + timer.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Convert orderby.
     *
     * @param strComp the string to convert
     * @return the converted string
     */
    public String convertOrderBy(String strComp) {
        String strRet = strComp;

        if (strComp.equalsIgnoreCase(COMPARE_REF_PRIMARYAUTH)) {
            strRet = COMPARE_REF_PRIMARYAUTH_NICE;
        } else if (strComp.equalsIgnoreCase(COMPARE_REF_PRIMARYAUTH_NICE)) {
            strRet = COMPARE_REF_PRIMARYAUTH;
        }

        return strRet;
    }
    
}
