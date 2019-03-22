/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
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
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorSummaryDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainSynonymsDTO;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * For a given tumor frequency key get summaries for tumor frequencies
 * with the same strain, classification and agents
 * @author sbn
 */
public class TumorSummaryByExampleAction extends Action {

  private final static Logger log =
          Logger.getLogger(TumorSummaryByExampleAction.class.getName());

  public ActionForward execute(ActionMapping mapping,
          ActionForm form,
          HttpServletRequest request,
          HttpServletResponse response)
          throws Exception {


    String target = "success";
    String strTFKey = request.getParameter("tumorFrequencyKeys");

    // dto to hold the tumor summary data
    MTBTumorSummaryDTO dtoTumorSummary = null;


    try {


      MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();

      dtoTumorSummary = daoTumorUtil.getTumorSumaryByExample(strTFKey);


      List<StrainSynonymsDTO> arrSynonyms =
              new ArrayList<>(dtoTumorSummary.getStrainSynonyms());

      List<StrainSynonymsDTO> filteredSynonyms =
              WIUtils.filterStrainSynonyms(arrSynonyms,dtoTumorSummary.getStrainName());

      dtoTumorSummary.setStrainSynonyms(filteredSynonyms);

      request.setAttribute("tumor", dtoTumorSummary);
      request.setAttribute("byExample","true");


    } catch (Exception e) {
      log.error("Error in tumor summary", e);
      target = "failure";

    }


    // forward to the appropriate View
    return mapping.findForward(target);
  }


}
