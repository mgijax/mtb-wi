/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorUtilDAO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.forms.DynamicGridForm;

/**
 * Action for the Dynamic Tumor Frequency Grid
 * Generates a new grid from selected rows and columns
 * or keeps track of which rows and columns have been expanded or collapsed
 * @author sbn
 */
public class DynamicGridAction extends Action {

  private final static Logger log = Logger.getLogger(DynamicGridAction.class.getName());

  public ActionForward execute(ActionMapping mapping,
          ActionForm form,
          HttpServletRequest request,
          HttpServletResponse response)
          throws Exception {
    
    String message = null;
    String strStrainFamilyKey = request.getParameter("strainFamilyKey");
    String strCurrentStrainFamilyKey = request.getParameter("currentStrainFamilyKey");
    String strOrganParentKey = request.getParameter("organKey");
    String strCurrentOrganParentKey = request.getParameter("currentOrganKey");
   
    String strTarget = "select";
    String[] selectedOrganGrps = request.getParameterValues("organGrpChk");
    String[] selectedOrgans = request.getParameterValues("organChk");
    String[] selectedStrainFamilies = request.getParameterValues("strainFamilyChk");
    String[] selectedStrains = request.getParameterValues("strainChk");

    String expandColapse = request.getParameter("expandColapse");
   
    // if true user was only able to select strain families
    // so all strains should be shown. For further refinements of
    // grid only show selected strains or summaries
    String showAllStrains = request.getParameter("showAllStrains");
    
    // a column or row has been expanded or colapsed
    if(!"false".equals(expandColapse)) {

      Map mapGridData = WIConstants.getInstance().getTFGrid();

      List arrOrgans = WIConstants.getInstance().getTFGridOrgans();

      List arrStrains = WIConstants.getInstance().getTFGridStrains();

      request.setAttribute("anatomicalSystems", arrOrgans);
      request.setAttribute("strains", arrStrains);
      request.setAttribute("gridData", mapGridData);

      


      // for exapand and collapse of strain families and organs

      // a value in strCurrentStrainFamilyKey means a strain family has
      // been collapsed or expanded so the key delimited by '|' is either
      // added or removed from the list of strainFamilyKeys to expand.
      if (StringUtils.equals(strStrainFamilyKey, strCurrentStrainFamilyKey)) {
        strStrainFamilyKey = "";
        strCurrentStrainFamilyKey = "";
      } else {
        if (strCurrentStrainFamilyKey != null && strCurrentStrainFamilyKey.length() > 0) {
          String token = "|" + strCurrentStrainFamilyKey + "|";
          int start = strStrainFamilyKey.indexOf(token);
          if (start != -1) {
            strStrainFamilyKey = strStrainFamilyKey.replace(token, "");

          } else {
            strStrainFamilyKey += token;
          }
          strCurrentStrainFamilyKey = "";
        }

      }

      // do the same for organParentKeys  
      if (StringUtils.equals(strOrganParentKey, strCurrentOrganParentKey)) {
        strOrganParentKey = "";
        strCurrentOrganParentKey = "";
      } else {
        if (strCurrentOrganParentKey != null && strCurrentOrganParentKey.length() > 0) {
          String token = "|" + strCurrentOrganParentKey + "|";
          int start = strOrganParentKey.indexOf(token);
          if (start != -1) {
            strOrganParentKey = strOrganParentKey.replace(token, "");

          } else {
            strOrganParentKey += token;
          }
          strCurrentOrganParentKey = "";
        }

      }
      // used by grid to dertermine the number of columns to print
      // when the are no values for a row.
      int expOrganCount = 0;
      for(int i =0; i < strOrganParentKey.length(); i++){
        if(strOrganParentKey.charAt(i) == '|'){
          expOrganCount++;
        }
      }
      expOrganCount = expOrganCount/2;

      request.setAttribute("strainFamilyKey", strStrainFamilyKey);
      request.setAttribute("currentStrainFamilyKey", strCurrentStrainFamilyKey);
      request.setAttribute("organKey", strOrganParentKey);
      request.setAttribute("currentOrganKey", strCurrentOrganParentKey);
      request.setAttribute("expOrganCount", expOrganCount);


    } else {
      // generating a new grid
      // get the selected rows and columns 
      
      strTarget = "grid";

      String organGrpStr = arrayToCSV(selectedOrganGrps);

      String organStr = arrayToCSV(selectedOrgans);

      String strainFamiliesStr = arrayToCSV(selectedStrainFamilies);

      String strainsStr = arrayToCSV(selectedStrains);

      // check that both rows and columns have been selected
      if((organGrpStr != null && strainFamiliesStr != null) ||
          (organStr != null && strainsStr != null) ||
          (organStr != null && strainFamiliesStr != null)){
      
        
        try {
          MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
          Map mapTFGrid = WIConstants.getInstance().getTFGrid();

          List arrOrgans = daoTumorUtil.getTFGridOrgans(organGrpStr, organStr);

          List arrStrains = daoTumorUtil.getTFGridStrains(strainFamiliesStr, strainsStr);

          request.setAttribute("anatomicalSystems", arrOrgans);
          request.setAttribute("strains", arrStrains);
          request.setAttribute("gridData", mapTFGrid);
          request.setAttribute("strainFamilyChk", selectedStrainFamilies);
          request.setAttribute("strainChk", selectedStrains);
          request.setAttribute("showAllStrains",showAllStrains);

          // clears the selected checkboxes
          ((DynamicGridForm) form).reset();

        } catch (Exception e) {
          log.error("Error getting grid data.", e);
          message = "There was an error retrieving the data for the dynamic grid.";

        }
      }else{
        // return a message about what needs to be checked to generate a grid
        // depending on which grid was submitted

        message = "Please select values for both columns and rows to generate a grid";
        }

    
    }
    request.setAttribute("message", message);
    return mapping.findForward(strTarget);
  }

  // convert the array of values from a group of checkboxes
  // into a comma seperated string or null to send to the DAOs
  private String arrayToCSV(String[] vals) {
    String csv = null;
    if (vals != null) {
      StringBuffer buff = new StringBuffer();
      for (int i = 0; i < vals.length; i++) {
          try{
              if(buff.length()==0){
                buff.append(new Integer(vals[i]));
              }else{
                buff.append(", " + new Integer(vals[i]));
              }
          }catch(Exception e){
             
          }
      }
      csv = buff.toString();
    }
    return csv;
  }
}