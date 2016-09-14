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
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.utils.StringUtils;

/**
 * Retrieve the required information needed on the home page.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class RedirectAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log = Logger.getLogger(RedirectAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Retrieve the required information needed on the home page.
     *
     * @param mapping the action mapping that determines where we need to go
     * @param form the form bean
     * @param request standard servlet request
     * @param response standard servlet response
     * @return the ActionForward object that indicates where to go
     * @throws Exception if the application business logic throws an exception
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

        String strUrl = request.getParameter("url");

        // set the target to failure if we could not retrieve the organ list
        if (StringUtils.hasValue(strUrl)) {
            // put all the servers in the request
            request.setAttribute("url", strUrl);
        } else {
            strTarget = "error";
        }

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("RedirectAction: " + timer.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods
    // none

}
