package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBGeneticsUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBOrthologyComparator;
import org.jax.mgi.mtb.dao.custom.mtb.MTBOrthologyDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSynchronizationUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.MarkerDTO;
import org.jax.mgi.mtb.dao.gen.mtb.ReferenceDTO;
import org.jax.mgi.mtb.utils.LabelValueDataBean;
import org.jax.mgi.mtb.wi.forms.OrthologyForm;

/**
 *
 */
public class OrthologyAction extends Action {
  // --------------------------------------------------------- Public Methods
  /**
   * Queries MGI for Human Gene Symbol to Mouse Orthologies then uses the
   * Mouse gene symbols to query MTB for strain and tumor genetics records
   * 
   * Handles collections of human markers associated with specific references
   * these can be used for searching orthologies or viewed as a list
   * they are displayed on the orthology search page
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

    OrthologyForm oForm = (OrthologyForm) form;
    String strTarget = null;
    String humanGeneSymbols = oForm.getHumanGS().toUpperCase();
    
    String sortOrder = oForm.getSortBy();

    // equals, begins, contains, ends
    String comparison = oForm.getCompare();
    String ref = request.getParameter("reference");
    if ((ref != null ) && (ref.length()>=1)) {
      
      if("true".equals(request.getParameter("asList"))){
        ArrayList<LabelValueDataBean<String,String,String>> symbols = getSymbolDetailsForRef(ref);
        request.setAttribute("symbols", symbols);
        request.setAttribute("reference", ref);
        
        return mapping.findForward("list");
     
      }else{
        
        humanGeneSymbols = getSymbolListForRef(ref);
      }
      
  }

    if((humanGeneSymbols != null) && (humanGeneSymbols.length()>0)){

      Collection <MTBOrthologyDTO> orthos = MTBSynchronizationUtilDAO.getInstance().getHMOrthologies(humanGeneSymbols,comparison);

      orthos = MTBGeneticsUtilDAO.getInstance().getOrthologGenetics(orthos);
      String sortBy ="";
      
      MTBOrthologyComparator compy = null;
      if ((sortOrder != null) && sortOrder.equals("HumanGS")) {
        compy = new MTBOrthologyComparator(MTBOrthologyComparator.HUMAN_GS);
        sortBy = "Human Gene Symbol";
      } else {
        compy = new MTBOrthologyComparator(MTBOrthologyComparator.MOUSE_GS);
        sortBy = "Mouse Gene Symbol";
      }

      MTBOrthologyDTO sortArray[] = (MTBOrthologyDTO[]) orthos.toArray(new MTBOrthologyDTO[orthos.size()]);
      Arrays.sort(sortArray, compy);

      orthos = new ArrayList<MTBOrthologyDTO>(Arrays.asList(sortArray));
      
      humanGeneSymbols = pretty(humanGeneSymbols,", ");

      request.setAttribute("orthos", orthos);
      request.setAttribute("humanGS", humanGeneSymbols);
      request.setAttribute("comparison", comparison);
      request.setAttribute("sortBy", sortBy);

      strTarget = "success";
    } else {
      
      ArrayList<ReferenceDTO> references = MTBReferenceUtilDAO.getInstance().getHumanMarkerReferences();
      
      // this is done so the pubmed link won't be shown if there is no pubmed id
      for(ReferenceDTO dto : references){
         String accID = MTBReferenceUtilDAO.getInstance().getJNumByReference(dto.getReferenceKey());
         // don't try getting it from MTB since "old" (before mid 2015) references don't have pubMedID's
         String pubmedID = MTBSynchronizationUtilDAO.getInstance().getPubmedIDFromJNum(accID);
        // use the url field to store the pubmed link
        if((pubmedID != null) && (!pubmedID.equalsIgnoreCase("null")) && (pubmedID.length() > 0)){
          dto.setUrl("http://www.ncbi.nlm.nih.gov/pubmed/"+pubmedID);
        }
      }
      request.setAttribute("references", references);
      // get references for human gene lists
      strTarget = "orthologySearch";
    }
    return mapping.findForward(strTarget);
  }
  
  
  /**
   * Converts string of arbitrarily delimited symbols into delim delimited string
   * @param humanGeneSymbols a string of symbols with some type of delimiter
   * @param delim string new delimiter
   * @return a string of gene symbols delimited by the delim param
   */
  private String pretty(String humanGeneSymbols,String delim){
    
    StringBuffer buf = new StringBuffer();
    String[] mrks = humanGeneSymbols.split("[\t\n .,|:;]+");
    for(int i = 0; i < mrks.length; i++){
      if(i ==0){
        buf.append(mrks[i].trim());
      }else{
        buf.append(delim+mrks[i].trim());
      }
    }
    return buf.toString();
  }
  
  // get the details to display the associated marker symbols as a list (symbol entregene id, name)
  private ArrayList<LabelValueDataBean<String,String,String>> getSymbolDetailsForRef(String ref){
    ArrayList<LabelValueDataBean<String,String,String>> list = new ArrayList<LabelValueDataBean<String,String,String>>();
    try{
        ArrayList<MarkerDTO> dtos = MTBReferenceUtilDAO.getInstance().getHumanMarkers(new Long(ref).longValue());
        for(MarkerDTO dto : dtos){
          list.add(new LabelValueDataBean(dto.getSymbol(),(String)dto.getDataBean().get(MTBReferenceUtilDAO.EGID),dto.getName()));
        }
    }catch(Exception e){}
    return list;
  }
  
  // get a comma seperated list of symbols for the reference
  // if there is an entrez gene id use that rather than the symbol
  private String getSymbolListForRef(String ref){
    StringBuffer str = new StringBuffer();
    String id = null;
    try{
        ArrayList<MarkerDTO> dtos = MTBReferenceUtilDAO.getInstance().getHumanMarkers(new Long(ref).longValue());

        for(MarkerDTO dto : dtos){
          id = (String)dto.getDataBean().get(MTBReferenceUtilDAO.EGID);
          if(id != null && id.length() >0){
           str.append(id).append(",");
          }else{

            str.append(dto.getSymbol()).append(",");
          }
        }
    }catch(Exception e){
        
    }
        
    
    return str.toString();
  }
    
    
}

 