/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.SearchResults;
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageHelperDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageSearchDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.forms.PathologyImageSearchForm;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * The PathologyImageSearchResultsAction class performs the search for
 * pathology images.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class PathologyImageSearchResultsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none
    // ----------------------------------------------------- Instance Variables
    private final static Logger log =
            Logger.getLogger(PathologyImageSearchResultsAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none
    // --------------------------------------------------------- Public Methods
    /**
     * The PathologyImageSearchResultsAction class performs the search for
     * pathology images.
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

        SearchResults<MTBPathologyImageSearchDTO> resPathImages = null;
        MTBPathologyImageUtilDAO dao = MTBPathologyImageUtilDAO.getInstance();

        String tfKeys = parseKeys(request.getParameter("tfKeys"));

        if (tfKeys == null || tfKeys.length()==0) {

            PathologyImageSearchForm formSearch = (PathologyImageSearchForm) form;
            String strSortBy = formSearch.getSortBy();
            String strMaxItems = formSearch.getMaxItems();
            String[] arrStrOrganTissuesOrigin = formSearch.getOrganTissueOrigin();
            List<String> arrOrganOrigin = new ArrayList<String>();
            String[] arrStrTumorClassifications =
                    formSearch.getTumorClassification();
            List<String> arrTumorClass = new ArrayList<String>();
            String strReferenceKey = formSearch.getReferenceKey();
            String strAccId = null;
            String strMethod = formSearch.getMethod();
            String strMethodSelected = formSearch.getMethod();
            String[] arrStrAntibodies = formSearch.getAntibody();
            List<String> arrAntibodies = new ArrayList<String>();
            String strOrganAffected = formSearch.getOrganTissueAffected();

            long lMaxItems = WIUtils.stringToLong(strMaxItems, -1l);

            long lOrganAffectedKey = -1;

            try {
                lOrganAffectedKey = Integer.parseInt(strOrganAffected);
                strOrganAffected = WIConstants.getInstance().getOrgans().get(lOrganAffectedKey).getLabel();
            } catch (Exception e) {
                lOrganAffectedKey = -1;
            }

            long lReferenceKey = WIUtils.stringToLong(strReferenceKey, -1l);

            try {
                if (StringUtils.hasValue(strReferenceKey)) {
                    // create a Reference DAO
                    MTBReferenceUtilDAO refDAO = MTBReferenceUtilDAO.getInstance();

                    // get the accession id
                    strAccId = refDAO.getJNumByReference(lReferenceKey);

                }
            } catch (Exception e) {
                log.error("Error retrieving accession id by reference", e);
            }

            arrOrganOrigin = WIUtils.arrayToCleanKeyList(arrStrOrganTissuesOrigin);
            arrTumorClass = WIUtils.arrayToCleanKeyList(arrStrTumorClassifications);
            arrAntibodies = WIUtils.arrayToCleanKeyList(arrStrAntibodies);
            
            Map<String,LabelValueBean<String,String>> mapMethods =
                WIConstants.getInstance().getMethods();
            if(mapMethods.get(strMethod)!=null){
                //method is valid
            }else{
                strMethod = null;
            }

            Timer daoTimer = new Timer();
            daoTimer.start();

            try {
                // search for the pathology images
                resPathImages = dao.searchPathology(arrOrganOrigin,
                        arrTumorClass,
                        (int) lOrganAffectedKey,
                        null,
                        strMethod, arrAntibodies,
                        null,
                        (int) lReferenceKey,
                        strSortBy,
                        (int) lMaxItems);
            } catch (Exception e) {
                log.error("Error searching for pathology images", e);
            }

            daoTimer.stop();

            if (log.isDebugEnabled()) {
                log.debug("PathologySearchResultsAction : DAO TIME: "
                        + daoTimer.toString());
            }

            request.setAttribute("organsAffectedSelected",
                    strOrganAffected);
            request.setAttribute("organOriginSelected",
                    WIUtils.organKeysToLabel(arrOrganOrigin));
            request.setAttribute("tumorClassificationsSelected",
                    WIUtils.tumorclassificationKeysToLabel(arrTumorClass));
            request.setAttribute("antibodiesSelected",
                    WIUtils.probeKeysToLabel(arrAntibodies));
            request.setAttribute("methodSelected", strMethodSelected);
            request.setAttribute("accId", strAccId);
            request.setAttribute("sortBy", StringUtils.initCap(strSortBy));
            request.setAttribute("maxItems", strMaxItems);

            timer.stop();

            if (log.isDebugEnabled()) {
                log.debug("PathologySearchResultsAction: " + timer.toString());
            }

        } else {


            try {
                // search for the pathology images
                resPathImages = dao. searchPathologyByTF(tfKeys);
                
            } catch (Exception e) {
                log.error("Error searching for pathology images", e);
            }
            
            request.setAttribute("sortBy", StringUtils.initCap("strain"));

        }


        if (resPathImages != null) {

            urlsToLinks(resPathImages);
            // put all the matching pathology images in the request
            request.setAttribute("pathologyImages",
                    resPathImages.getList());
            request.setAttribute("numberOfResults",
                    resPathImages.getSize() + "");
            request.setAttribute("totalNumOfPathImages",
                    resPathImages.getAncillaryTotal() + "");
            request.setAttribute("totalResults",
                    resPathImages.getTotal() + "");
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none
    // -------------------------------------------------------- Private Methods
    private void urlsToLinks(SearchResults<MTBPathologyImageSearchDTO> results) {

        List<MTBPathologyImageSearchDTO> dtos = results.getList();

        for (MTBPathologyImageSearchDTO dto : dtos) {

            for (MTBPathologyImageHelperDTO helper : dto.getImages()) {



                //some images have a caption with a url. convert that to a link.
                String caption = helper.getImageCaption();
                if (caption != null) {
                    int start = caption.indexOf("http");
                    if (start > -1) {
                        String url = caption.substring(start);
                        String prefix = caption.substring(0, start);
                        if (".".equals(url.charAt(url.length() - 1) + "")) {
                            url = url.substring(0, url.length() - 1);
                            caption = prefix + "<a href=\"" + url + "\">" + url + ".</a>";
                        } else {
                            caption = prefix + "<a href=\"" + url + "\">" + url + "</a>";

                        }
                        helper.setImageCaption(caption);
                    }
                }
            }
        }



    }

    private String parseKeys(String strTFKeys) {
        StringBuffer tfKeys = new StringBuffer();

        try {
            if (StringUtils.hasValue(strTFKeys)) {
                // split the comma seperated string into an array
                String[] arrStrings = StringUtils.separateString(strTFKeys, ",");

                if (arrStrings.length > 0) {


                    // loop through the strings and convert them to long
                    for (int i = 0; i < arrStrings.length; i++) {
                        if (i > 0) {
                            tfKeys.append(",");
                        }
                        tfKeys.append(Long.parseLong(arrStrings[i]));
                    }
                }
            }

        } catch (Exception e) {
            // bad value in URL do nothing
        }
        return tfKeys.toString();
    }
}
