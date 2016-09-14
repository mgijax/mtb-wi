/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.SearchResults;
import org.jax.mgi.mtb.dao.custom.mtb.MTBCytoResults;
import org.jax.mgi.mtb.dao.custom.mtb.MTBGeneticsSearchDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBGeneticsUtilDAO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.utils.Timer;
import org.jax.mgi.mtb.wi.forms.GeneticsSearchForm;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * The GeneticsSearchResultsAction class performs the search for genetics.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class GeneticsSearchResultsAction extends Action {

  // -------------------------------------------------------------- Constants
  // none

  // ----------------------------------------------------- Instance Variables
  private final static Logger log =
          Logger.getLogger(GeneticsSearchResultsAction.class.getName());

  // ----------------------------------------------------------- Constructors
  // none

  // --------------------------------------------------------- Public Methods
  /**
   * Performs the seacrh.
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
    String target = "success";

    Timer timerTotal = new Timer();
    timerTotal.start();

    MTBGeneticsUtilDAO dao = MTBGeneticsUtilDAO.getInstance();
    SearchResults<MTBGeneticsSearchDTO> resStrains = null;
    SearchResults<MTBGeneticsSearchDTO> resTumors = null;
    SearchResults<MTBCytoResults> resCyto = null;
    Collection colStrain = null;
    Collection colTumor = null;

    // search form variables
    GeneticsSearchForm formSearch = (GeneticsSearchForm) form;
    String strAllele = formSearch.getAlleleName();
    String strAlleleComparison =
            formSearch.getAlleleNameComparison();
    String strMarker = formSearch.getMarkerName();
    String strMarkerComparison =
            formSearch.getMarkerNameComparison();

    String[] arrStrChromosomes = formSearch.getChromosome();
    List<String> colChromosomes = new ArrayList<String>();


    String[] arrStrMutations = formSearch.getAlleleGroupType();
    List<String> colMutations = new ArrayList<String>();

    String strSortBy = formSearch.getSortBy();
    String strMaxItems = formSearch.getMaxItems();

    boolean assayImages = formSearch.getAssayImages();



    long lMaxItems = -1;

    // convert the arrays to collections
    colChromosomes = WIUtils.arrayToCleanList(arrStrChromosomes);
    colMutations = WIUtils.arrayToCleanList(arrStrMutations);


    lMaxItems = WIUtils.stringToLong(strMaxItems, -1l);

    // search for the strain genetics
    Timer timerDao = new Timer();


    if (!assayImages) {
      timerDao = new Timer();
      timerDao.start();
      try {
       
        resStrains = dao.searchStrainGenetics(strAllele,
                strAlleleComparison,
                strMarker,
                strMarkerComparison,
                colChromosomes,
                colMutations,
                strSortBy,
                (int) lMaxItems);

        if (resStrains != null) {
          colStrain = resStrains.getList();
        }
      } catch (Exception e) {
        
        log.error("Error searching for strain genetics", e);
        log.error("allele = " + strAllele);
        log.error("alleleComparison = " + strAlleleComparison);
        log.error("marker = " + strMarker);
        log.error("markerComparison = " + strMarkerComparison);
        log.error("chromosomesColl = " + colChromosomes);
        log.error("mutationsCollection = " + colMutations);
        log.error("sortBy = " + strSortBy);
        log.error("maxItems = " + lMaxItems);
      }

      timerDao.stop();

      if (log.isDebugEnabled()) {
        log.debug("MTBGeneticsUtilDAO.searchStrainGenetics(): " +
                timerDao.toString());
      }


      // search for the tumor genetics

      timerDao.restart();

      try {
        
        resTumors = dao.searchTumorGenetics(strAllele,
                strAlleleComparison,
                strMarker,
                strMarkerComparison,
                colChromosomes,
                colMutations,
                strSortBy, (int) lMaxItems);

        if (resTumors != null) {
          colTumor = resTumors.getList();
        }
      } catch (Exception e) {

        log.error("Error searching for tumor genetics", e);
        log.error("allele = " + strAllele);
        log.error("alleleComparison = " + strAlleleComparison);
        log.error("marker = " + strMarker);
        log.error("markerComparison = " + strMarkerComparison);
        log.error("chromosomesColl = " + colChromosomes);
        log.error("mutationsCollection = " + colMutations);
        log.error("sortBy = " + strSortBy);
        log.error("maxItems = " + lMaxItems);
      }

      timerDao.stop();

      if (log.isDebugEnabled()) {
        log.debug("MTBGeneticsUtilDAO.searchTumorGenetics(): " +
                timerDao.toString());
      }

    }
    
    
    try {
    
      if ((strAllele.length() < 1) && (strMarker.length() < 1)) {
        resCyto =dao.searchTumorCytoGeneticsSummary(colChromosomes,
                                                    colMutations,
                                                    (int) lMaxItems,
                                                    strSortBy, assayImages);
      }

    } catch (Exception e) {
      log.debug(e);
    }
    
    Collection<String> colSelectedChromosomes = WIUtils.chromosomeKeysToLabel(colChromosomes);
    Collection<String> colSelectedMutations = WIUtils.mutationKeysToLabel(colMutations);

    String strChromosomesForDisplay = StringUtils.collectionToString(colSelectedChromosomes, ", ", "");
    String strMutationsForDisplay = StringUtils.collectionToString(colSelectedMutations, ", ", "");

    // put all the items in the request
    if (resStrains != null) {
      request.setAttribute("strainGenetics", colStrain);
      request.setAttribute("numberOfResultsStrains",
              colStrain.size() + "");
      request.setAttribute("totalResultsStrains",
              resStrains.getTotal() + "");
    }

    if (resTumors != null) {
      request.setAttribute("tumorGenetics", colTumor);
      request.setAttribute("numberOfResultsTumors",
              colTumor.size() + "");
      request.setAttribute("totalResultsTumors",
              resTumors.getTotal() + "");
    }

    if (resCyto != null) {
      request.setAttribute("cytoGenetics", resCyto.getList());
      request.setAttribute("numberOfCytoTumors", resCyto.getList().size() + "");
      request.setAttribute("totalCytoTumors", resCyto.getTotal());

    }

    request.setAttribute("alleleName", strAllele);
    request.setAttribute("alleleNameComparison", strAlleleComparison);
    request.setAttribute("markerName", strMarker);
    request.setAttribute("markerNameComparison", strMarkerComparison);
    request.setAttribute("chromosomes", strChromosomesForDisplay);
    request.setAttribute("mutations", strMutationsForDisplay);
    request.setAttribute("sortBy", StringUtils.initCap(strSortBy));
    request.setAttribute("maxItems", strMaxItems);
    if(assayImages){
       request.setAttribute("assayImages","true");
    }
   
    timerTotal.stop();

    if (log.isDebugEnabled()) {
      log.debug("TOTAL TIME: " + timerTotal.toString());
    }

    // forward to the appropriate View
    return mapping.findForward(target);
  }  // ------------------------------------------------------ Protected Methods
  // none

  // -------------------------------------------------------- Private Methods
  // none
}
