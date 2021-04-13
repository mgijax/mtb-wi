/**
 * Header: $Header$
 * Author: $Autho$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBStrainDetailDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBStrainUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainNotesDTO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainSynonymsDTO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * Retrieve the detail information about a strain record.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class StrainDetailsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log = 
            Logger.getLogger(StrainDetailsAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Retrieve the detail information about a strain record.
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

        String strKey = request.getParameter("key");
        String strPage = StringUtils.nvl(request.getParameter("page"),
                                         "collapsed");
        strTarget = strPage.toLowerCase();
        MTBStrainDetailDTO dtoStrainDetail = null;
        Timer daoTimer = new Timer();
        daoTimer.start();

        if (StringUtils.hasValue(strKey)) {
            try {
                dtoStrainDetail = getStrain(Long.parseLong(strKey),
                                   strTarget.equals("collapsed"));

            } catch (Exception e) {
                log.error("Error retrieving strain detail, key =" + strKey, e);
            }
        }

        daoTimer.stop();

        if (log.isDebugEnabled()) {
            log.debug("StrainDetailsAction: DAO TIME: " +
                        daoTimer.toString());
        }

        // set the target to failure if we could not retrieve the strain types
        if (dtoStrainDetail == null) {
            strTarget = "error";
        } else {
            ///////////////////////////////////////////////////////////////////
            // Filter the duplicate strain synonyms
            ///////////////////////////////////////////////////////////////////
            List<StrainSynonymsDTO> arrSynonyms =
                    new ArrayList<StrainSynonymsDTO>(dtoStrainDetail.getSynonyms());

            List<StrainSynonymsDTO> arrFilteredSynonyms =
                    WIUtils.filterStrainSynonyms(arrSynonyms,
                                                 dtoStrainDetail.getName());

            dtoStrainDetail.setSynonyms(arrFilteredSynonyms);
            
            if(dtoStrainDetail.getNotes()== null || dtoStrainDetail.getNotes().size() == 0){
                dtoStrainDetail.setNotes(null);
            }
            
            // put the strain in the request
            request.setAttribute("strain", dtoStrainDetail);
        }

        timer.stop();

        if (log.isDebugEnabled()) {
            log.debug("StrainDetailsAction: " + timer.toString());
            log.debug("StrainDetailsAction: " + strTarget);
        }

        timer = null;

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Get a MTBStrainDetail object based upon the key.
     *
     * @param lKey The unique key value.
     * @param bSimple True for simple detail info, false otherwise.
     * @return MTBStrainDetailDTO object
     */
    private MTBStrainDetailDTO getStrain(long lKey, boolean bSimple) {
        MTBStrainUtilDAO daoStrainUtil = MTBStrainUtilDAO.getInstance();

        MTBStrainDetailDTO dtoStrainDetail = null;

        try {
            dtoStrainDetail = daoStrainUtil.getStrain(lKey, bSimple);
        } catch (Exception e) {
            log.error("Error retrieving MTBStrainDetailDTO, key: " + lKey, e);
        }

        return dtoStrainDetail;
    }
}
