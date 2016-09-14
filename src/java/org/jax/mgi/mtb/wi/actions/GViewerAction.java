/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Iterator;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSynchronizationUtilDAO;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.wi.forms.QTLForm;
import org.jax.mgi.mtb.wi.utils.GViewerFeature;
import org.jax.mgi.mtb.wi.utils.QTLParser;

/**
 * This class is only used by 'hidden' qtl flash viewer and should be removed.
 * 
 * Generates annotation XML for the GViewer based on selected Types
 * Parses GViewer request for parameters to display on details page
 *
 * @author $Author: sbn $
 * @date $Date: 2012/06/04 15:32:33 $
 * @version $Revision: 1.12 $
 * @cvsheader $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/GViewerAction.java,v 1.12 2012/06/04 15:32:33 sbn Exp $
 * @see org.apache.struts.action.Action
 */
public class GViewerAction extends Action {
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

    QTLForm qtlForm = (QTLForm) form;
    String strTarget = "success";

    QTLParser qtlParser = new QTLParser();
    
    String[] selectedTypes = qtlForm.getSelectedQTLTypes();

    String location = request.getParameter("location");    
    if (location != null) { 
      // A feature was clicked on the GViewer
      setAttributes(request, location, qtlForm);
      // goto the details screen
      strTarget = "details";

    } else if (request.getParameter("reset") != null) {
      // reset selected types
      selectedTypes = null;
      qtlForm.setSelectedQTLTypes(null);

    } else if ("HTML".equals(request.getParameter("qtlList"))) {
      // display a list of the QTL data for the selected types
      strTarget = "qtlList";

      if (selectedTypes != null && selectedTypes.length > 0) {
        request.setAttribute("features", qtlParser.getFeaturesForTypes(selectedTypes,QTLParser.SORT_FOR_LIST));
      }
    } else if ("tabbed".equals(request.getParameter("qtlList"))) {
      // display a list of the QTL data for the selected types
      response.setContentType("text/plain");
    
      strTarget = "tabbedQTLList";
      String text ="";
      if (selectedTypes != null && selectedTypes.length > 0) {
        ArrayList<GViewerFeature> features = qtlParser.getFeaturesForTypes(selectedTypes,QTLParser.SORT_FOR_LIST);
        text = buildTabbedList(features);
       
      }
      response.getWriter().write(text);
      response.flushBuffer();
      return null;

    } else if (selectedTypes != null && selectedTypes.length > 0) {
      // generate the annotation XML for the selected QTL types
      StringBuffer xml = new StringBuffer();
      xml.append("<genome>");
      
        if (selectedTypes[0].equals("ALL")) {
          xml.append(qtlParser.getXMLForAll());
        } else {
          xml.append(qtlParser.getXMLForTypes(selectedTypes));
        }
      
      xml.append("</genome>");
      String xmlStr = xml.toString();
    xmlStr =    xmlStr.replaceAll("&", "and");
      
       if(request.getParameter("asXML")!= null){
         response.setContentType("text/xml");
        response.getWriter().write(xmlStr);
        response.flushBuffer();
        return null;
        
      }
      
      request.setAttribute("data", xml.toString());

      // show the color coding of the selected QTLs
     // request.setAttribute("legend", qtlParser.getLegend(selectedTypes));

    }
    
    String mgiURL = request.getParameter("mgiURL");
    if(mgiURL != null){
      mgiURL = java.net.URLDecoder.decode(mgiURL, "UTF-8");
      mgiURL = mgiURL.replaceAll(" ", "+");

              
        StringBuffer xml = new StringBuffer();
        xml.append("<genome>");
        GViewerDetailsAction gda = new GViewerDetailsAction();
        ArrayList<GViewerFeature> featuresList = gda.parseMGIURL(mgiURL);
        Iterator it = featuresList.iterator();
        while (it.hasNext()) {
          GViewerFeature feat = (GViewerFeature) it.next();
          xml.append(feat.toXML("")).append("\n");
        }

        xml.append("</genome>");
          String xmlStr = xml.toString();
       xmlStr =   xmlStr.replaceAll("&", "and");
       
        response.setContentType("text/xml");
        response.getWriter().write(xmlStr);
        response.flushBuffer();
        return null;
    }
      
      
            
            
//    ArrayList<LabelValueBean<String, String>> typesList = qtlParser.getTypesLVBs();

//    request.setAttribute("qtlTypes", typesList);
    
    //unique id for GViewer flash movie
    request.setAttribute("uid",System.currentTimeMillis());

    return mapping.findForward(strTarget);
  }

  // ------------------------------------------------------ Protected Methods
  // none

  // -------------------------------------------------------- Private Methods
  private String buildTabbedList(ArrayList<GViewerFeature> features) {
    StringBuffer text = new StringBuffer();

    for (GViewerFeature feature : features) {
      text.append(feature.getMgiId());
      text.append("\t");
      text.append(feature.getDescription());
      text.append("\t");
      text.append(feature.getName());
      text.append("\t");
      text.append(feature.getOrgan());
      text.append("\t");
      text.append(feature.getChromosome());
      text.append(":");
      text.append(feature.getStart());
      text.append("..");
      text.append(feature.getEnd());
      text.append("\t");
      text.append(feature.getPrimeRef());
      text.append("\n");
    }
   
    return text.toString();

  }
 
  private void setAttributes(HttpServletRequest request, String location, QTLForm qtlForm) {

    // location is in the format <chromosome>:<start>..<end>
    String start = location.substring(location.indexOf(":") + 1, location.indexOf("."));
    String end = location.substring(location.indexOf(".") + 2);
    String chrom = location.substring(0, location.indexOf(":"));

    String mgiId = request.getParameter("id");
    String label = request.getParameter("label");
    String types = request.getParameter("types");
    String primeRef = request.getParameter("primeRef");
    String qtlName = request.getParameter("qtlName");
    
    if(qtlName != null){
      qtlName = qtlName.replace('+', ' ');
    }
    MTBSynchronizationUtilDAO syncDAO = MTBSynchronizationUtilDAO.getInstance();
    
    qtlForm.setLabel(label);
    qtlForm.setMgiId(mgiId);
    qtlForm.setQtlStart(start);
    qtlForm.setQtlEnd(end);
    qtlForm.setChrom(chrom);
    qtlForm.setPrimeRef(primeRef);
    qtlForm.setTypes(types);
    qtlForm.setQtlName(qtlName);
    qtlForm.setSearchStart(start);
    qtlForm.setSearchEnd(end);
    qtlForm.setPrimeRefId(syncDAO.getIDForRef(primeRef));

    if(mgiId != null){
      // get the strains from MGI based on the QTLs MGI id
      
      request.setAttribute("strains", syncDAO.getStrainsForQTL(mgiId));
    }    
  }
}
