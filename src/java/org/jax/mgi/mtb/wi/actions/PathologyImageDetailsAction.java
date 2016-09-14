/**
 * Header: $Header$
 * Author: $Author$
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
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageDetailDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainSynonymsDTO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.utils.WIUtils;


/**
 * Retrieve the detail information about a pathology image record.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class PathologyImageDetailsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            Logger.getLogger(PathologyImageDetailsAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Retrieve the detail information about a pathology image record.
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
        MTBPathologyImageDetailDTO dtoPathologyDetail = null;
        Timer timerDao = new Timer();
        timerDao.start();

        if (StringUtils.hasValue(strKey)) {
            try {
                dtoPathologyDetail = getPathology(Long.parseLong(strKey));
            } catch (Exception e) {
                log.error("Error in pathology detail, key =" + strKey, e);
            }
        }

        timerDao.stop();

        if (log.isDebugEnabled()) {
            log.debug("PathologyImageDetailsAction: DAO TIME: " +
                        timerDao.toString());
        }

        // set the target to error if we could not retrieve the detail record
        if (dtoPathologyDetail == null) {
            strTarget = "error";
        } else {
            
            //some images have a caption with a url. convert that to a link.
            String caption = dtoPathologyDetail.getCaption();
            if(caption != null){
                int start = caption.indexOf("http");
                if(start > -1){
                    String url = caption.substring(start);
                    String prefix = caption.substring(0,start);
                    if(".".equals(url.charAt(url.length()-1)+"")){
                         url = url.substring(0, url.length()-1);
                         caption = prefix + "<a href=\""+url+"\">"+url+".</a>";
                    }else{
                         caption = prefix + "<a href=\""+url+"\">"+url+"</a>";
                    
                    }
                   
                    dtoPathologyDetail.setCaption(caption);
                }
            }
            
            // put the detail record in the request
            List<StrainSynonymsDTO> arrSynonyms =
                    new ArrayList<StrainSynonymsDTO>(dtoPathologyDetail.getStrainSynonyms());

            List<StrainSynonymsDTO> filteredSynonyms =
                    WIUtils.filterStrainSynonyms(arrSynonyms,
                                           dtoPathologyDetail.getStrainName());

            dtoPathologyDetail.setStrainSynonyms(filteredSynonyms);

            request.setAttribute("pathology", dtoPathologyDetail);
        }

        if (log.isDebugEnabled()) {
            log.debug("PathologyImageDetailsAction: " + timer.toString());
        }

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none

    // -------------------------------------------------------- Private Methods

    /**
     * Retrieve a MTBPathologyImageDetailDTO object based upon the
     * unique key.
     *
     * @param lKey The unique key
     * @return A MTBPathologyImageDetailDTO object
     */
    private MTBPathologyImageDetailDTO getPathology(long lKey) {
        // create a MTBPathologyImageUtilDAO
        MTBPathologyImageUtilDAO daoPath = MTBPathologyImageUtilDAO.getInstance();
        MTBPathologyImageDetailDTO dtoPath = null;

        try {
            dtoPath = daoPath.getPathology(lKey);
        } catch (Exception e) {
            log.error("Error retrieving pathology detail, key =" + lKey, e);
        }

        return dtoPath;
    }
}
