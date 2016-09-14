/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.jax.mgi.mtb.dao.utils.DAOUtils;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.beans.QuickSearchDataBean;
import org.jax.mgi.mtb.wi.forms.QuickSearchForm;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * Perform the "Toolbar Quick Search" from the MTB Toolbar.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class QuickSearchResultsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(QuickSearchResultsAction.class);

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods
    /**
     * Perform the "Toolbar Quick Search" from the MTB Toolbar.
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

        QuickSearchForm searchForm = (QuickSearchForm) form;

        String[] arrStrSections = searchForm.getQuickSearchSections();
        List<String> arrVals = new ArrayList<String>();
        String strSearchTerm =
                URLEncoder.encode(searchForm.getQuickSearchTerm(), "UTF-8");

        if (arrStrSections != null) {
            arrVals = new ArrayList<String>(Arrays.asList(arrStrSections));
        }

        // set the target to failure if no match
        if (StringUtils.hasValue(strSearchTerm)) {
            // special processing if 'all' was selected
            if (arrVals.size() == 1) {
                String strSection = arrVals.get(0);

                if (strSection.equals(
                        WIConstants.getInstance().SEARCH_LABEL_ALL)) {
                    arrVals = new ArrayList<String>();
                    arrVals.add(WIConstants.getInstance().SEARCH_NAME_TUMOR);
                    arrVals.add(WIConstants.getInstance().SEARCH_NAME_ORGAN);
                    arrVals.add(WIConstants.getInstance().SEARCH_NAME_STRAIN);
                    arrVals.add(
                            WIConstants.getInstance().SEARCH_NAME_GENETICS);
                }
            } else {
                arrVals.remove(WIConstants.getInstance().SEARCH_LABEL_ALL);
            }

            StringBuffer sbRequestURL = request.getRequestURL();
            StringBuffer sbUrl = new StringBuffer();

            sbUrl.append(
                    sbRequestURL.substring(0, sbRequestURL.lastIndexOf("/")));

            sbUrl.append('/');
            List<QuickSearchDataBean> arrUrls = new ArrayList<QuickSearchDataBean>();

            for (int i = 0; i < arrVals.size(); i++) {
                QuickSearchDataBean bean = new QuickSearchDataBean();

                bean.setId(arrVals.get(i));

                bean.setSearchName(
                        WIConstants.getInstance().getLabelForSection(
                                bean.getId()));

                bean.setMainSearchName(
                        WIConstants.getInstance().getMainLabelForSection(
                                bean.getId()));

                bean.setMainSearchUrl(sbUrl.toString() +
                        WIConstants.getInstance().getSearchUrlForSection(
                                bean.getId()));

                bean.setSearchUrl(sbUrl.toString() +
                       WIConstants.getInstance().getSearchResultsUrlForSection(
                                bean.getId()) + strSearchTerm);

                bean.setViewAllUrl(sbUrl.toString() +
                    WIConstants.getInstance().getSearchResultsUrlAllForSection(
                                bean.getId()) + strSearchTerm);

                arrUrls.add(bean);
            }

            timer.start();
            List<QuickSearchDataBean> arrData = WIUtils.quickUrlSearch(arrUrls);

            if (log.isDebugEnabled()) {
                log.debug("QuickSearchResultsAction: downloading took " +
                            timer.toString());
            }

            List<QuickSearchDataBean> arrFilteredData = new ArrayList<QuickSearchDataBean>();
            List<String> arrSearchSections = new ArrayList<String>();

            timer.restart();

            for (int i = 0; i < arrData.size(); i++) {
                QuickSearchDataBean oldBean = arrData.get(i);
                QuickSearchDataBean newBean = new QuickSearchDataBean();

                newBean.copy(oldBean);

                try {
                    newBean.setSearchCriteriaText(
                            StringUtils.getBetween(oldBean.getSearchText(),
                                WIConstants.getInstance().SEARCH_LIMIT_START,
                                WIConstants.getInstance().SEARCH_LIMIT_END));
                } catch (Exception ignore) {
                    newBean.setSearchCriteriaText("");
                }

                try {
                    newBean.setSearchResultsText(
                            StringUtils.getBetween(oldBean.getSearchText(),
                                WIConstants.getInstance().SEARCH_SECTION_START,
                                WIConstants.getInstance().SEARCH_SECTION_END));
                } catch (Exception ignore) {
                    newBean.setSearchResultsText("No results found.");
                }

                arrFilteredData.add(newBean);
                arrSearchSections.add(oldBean.getSearchName());
            }

            if (log.isDebugEnabled()) {
                log.debug("QuickSearchResultsAction: altering urls took " +
                            timer.toString());
            }

            // put all the matching data in the request
            request.setAttribute("quickSearchTerm", strSearchTerm);
            request.setAttribute("searchSections",
                     DAOUtils.collectionToString(arrSearchSections, ", ", ""));
            request.setAttribute("data", arrFilteredData);
        } else {
            strTarget = "failure";

            ActionMessages actionMessages = new ActionMessages();
            ActionMessage actionMessage =
                  new ActionMessage("errors.searchForms.quickSearch.notfound");

            actionMessages.add(ActionMessages.GLOBAL_MESSAGE, actionMessage);
            saveMessages(request, actionMessages);
        }

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("QuickSearchResultsAction: " + timer.toString());
        }

        timer = null;

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods
    // none
}
