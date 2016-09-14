/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageUtilDAO;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Used to set the values for the Pathology Image Search Form.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class PathologyImageSearchAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(PathologyImageSearchAction.class.getName());

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

        // retrieve the information to populate the form
        final Map<Long,LabelValueBean<String,Long>> mapAntibodies =
                WIConstants.getInstance().getProbes();
        final Map<Long,LabelValueBean<String,Long>> mapTumorClass =
                getImageTumorClassifications();
        final Map<Long,LabelValueBean<String,Long>> mapOrgansOfOrigin =
                getImageOrgansOrigin();
        final Map<String,LabelValueBean<String,String>> mapMethods =
                WIConstants.getInstance().getMethods();

        // set the target to error if we could not retrieve the strain types
        if ((mapTumorClass == null) || (mapAntibodies == null) ||
            (mapMethods == null) || (mapOrgansOfOrigin == null)) {
            strTarget = "error";
        } else {
            request.setAttribute("antibodies", mapAntibodies.values());
            request.setAttribute("methods", mapMethods.values());
            request.setAttribute("organsOfOrigin", mapOrgansOfOrigin.values());
            request.setAttribute("organsAffected", mapOrgansOfOrigin.values());
            request.setAttribute("tumorClassifications",
                                 mapTumorClass.values());
        }

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("PathologyImageSearchAction: " + timer.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Retrive the tumor classifications that have images associated with them.
     *
     * @return A Map of LabelValueBeans
     */
    private Map<Long,LabelValueBean<String,Long>>
            getImageTumorClassifications() {
        Map<Long,LabelValueBean<String,Long>> mapImageTumorClassifications =
                new LinkedHashMap<Long,LabelValueBean<String,Long>>();

        try {
            // get the probes (antibodies)
            MTBPathologyImageUtilDAO daoPathUtil =
                    MTBPathologyImageUtilDAO.getInstance();

            List<LabelValueBean<String,Long>> listTCIMages =
                    daoPathUtil.getTumorClassificationsWithImages();

            for (LabelValueBean<String,Long> bean : listTCIMages) {
                mapImageTumorClassifications.put(bean.getValue(),
                        new LabelValueBean<String,Long>(bean.getLabel(),
                                                        bean.getValue()));
            }
        } catch (Exception e) {
            log.error("Error retrieving tumor class list", e);
        }

        return mapImageTumorClassifications;
    }

    /**
     * Retrive the organs of origin that have images associated with them.
     *
     * @return A Map of LabelValueBeans
     */
    private Map<Long,LabelValueBean<String,Long>> getImageOrgansOrigin() {
        Map<Long,LabelValueBean<String,Long>> mapImageOrgansOrigin =
                new LinkedHashMap<Long,LabelValueBean<String,Long>>();

        try {
            // get the probes (antibodies)
            MTBPathologyImageUtilDAO daoPathUtil =
                    MTBPathologyImageUtilDAO.getInstance();

            List<LabelValueBean<String,Long>> listOriginImages =
                    daoPathUtil.getOrgansOfOriginWithImages();

            for (LabelValueBean<String,Long> bean : listOriginImages) {
                mapImageOrgansOrigin.put(bean.getValue(),
                        new LabelValueBean<String,Long>(bean.getLabel(),
                                                        bean.getValue()));
            }
        } catch (Exception e) {
            log.error("Error retrieving organs of origin list", e);
        }

        return mapImageOrgansOrigin;
    }
}
