/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/AssayImageDetailsAction.java,v 1.3 2008/11/11 21:27:20 sbn Exp $
 * Author: $Author: sbn $
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBAssayImageUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBPathologyImageDetailDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorGeneticChangesDTO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainSynonymsDTO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.utils.WIUtils;


/**
 * Retrieve the detail information about a assay image record.
 *
 * @author $Author: sbn $
 * @date $Date: 2008/11/11 21:27:20 $
 * @version $Revision: 1.3 $
 * @cvsheader $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/AssayImageDetailsAction.java,v 1.3 2008/11/11 21:27:20 sbn Exp $
 * @see org.apache.struts.action.Action
 */
public class AssayImageDetailsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables

    private final static Logger log =
            org.apache.logging.log4j.LogManager.getLogger(AssayImageDetailsAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none

    // --------------------------------------------------------- Public Methods

    /**
     * Retrieve the detail information about a assay image record.
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

       

        String strKey = request.getParameter("key");
        MTBPathologyImageDetailDTO dtoPathologyDetail = null;
        ArrayList<MTBTumorGeneticChangesDTO> dtoTGCs = null;
      

        if (StringUtils.hasValue(strKey)) {
            try {
              Long assayImageKey = Long.parseLong(strKey);
               // a pathologyDetail dto can contain all the needed details 
                dtoPathologyDetail = getAssayImage(assayImageKey);
                Long tfKey = new Long(dtoPathologyDetail.getTumorFrequencyKey());
                
                dtoTGCs = getTumorGeneticChanges(assayImageKey, tfKey);
            } catch (Exception e) {
                log.error("Error in assay image detail, key =" + strKey, e);
            }
        }

    

       

        // set the target to error if we could not retrieve the detail record
        if ((dtoPathologyDetail == null) || (dtoTGCs == null)) {
            strTarget = "error";
        } else {
            // put the detail record in the request
            List<StrainSynonymsDTO> arrSynonyms =
                    new ArrayList<StrainSynonymsDTO>(dtoPathologyDetail.getStrainSynonyms());

            List<StrainSynonymsDTO> filteredSynonyms =
                    WIUtils.filterStrainSynonyms(arrSynonyms,
                                           dtoPathologyDetail.getStrainName());

            dtoPathologyDetail.setStrainSynonyms(filteredSynonyms);

            request.setAttribute("assayImage", dtoPathologyDetail);
            request.setAttribute("dtoTGCs", dtoTGCs);
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
    private MTBPathologyImageDetailDTO getAssayImage(long lKey) {
        // create a MTBPathologyImageUtilDAO
       MTBPathologyImageDetailDTO dto = null;
       try {
        MTBAssayImageUtilDAO dao = new MTBAssayImageUtilDAO();
        

       
            dto = dao.getAssayImage(lKey);
        } catch (Exception e) {
            log.error("Error retrieving assay image detail, key =" + lKey, e);
        }

        return dto;
    }
    
     private ArrayList<MTBTumorGeneticChangesDTO> getTumorGeneticChanges(long lKey, Long tgcKey) {
      
       ArrayList<MTBTumorGeneticChangesDTO> dtos = null;
       try {
        Long aiKey = new Long(lKey);
        MTBAssayImageUtilDAO dao = new MTBAssayImageUtilDAO();
       
            dtos = dao.getTGCsFromAssayImageKey(aiKey, tgcKey);
        } catch (Exception e) {
            log.error("Error retrieving assay image detail, key =" + lKey, e);
        }

        return dtos;
    }
}
