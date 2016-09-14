/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Used to set the values for the Reference Search Form.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class ReferenceSearchAction extends Action {

    // -------------------------------------------------------------- Constants
    // none
    // ----------------------------------------------------- Instance Variables
    private final static Logger log =
            Logger.getLogger(ReferenceSearchAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none
    // --------------------------------------------------------- Public Methods
    /**
     * Set the values for the Reference Search Form.
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

        Timer timer = new Timer();
        timer.start();

        // default target to success
        String strTarget = "success";

        ArrayList<LabelValueBean<String,Long>> organs = null;

      
         organs = WIConstants.getInstance().getReferenceOrgans();
       

        Map mapTumorClass =
                WIConstants.getInstance().getTumorClassifications();


        request.setAttribute("organTissueValues", organs);

        request.setAttribute("tumorClassificationValues",
                mapTumorClass.values());

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("ReferenceSearchAction: " + timer.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }
    // ------------------------------------------------------ Protected Methods
    // none
    // -------------------------------------------------------- Private Methods
    // none
}
