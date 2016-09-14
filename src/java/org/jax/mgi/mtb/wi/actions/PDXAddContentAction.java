/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXComment;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXContent;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDocument;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXGraphic;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXImage;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXLink;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.forms.PDXAddContentForm;

import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 *
 * @author sbn
 */
public class PDXAddContentAction extends Action {
    
    private String filePrefix = WIConstants.getInstance().getPDXFilePath();

  
    private SimpleDateFormat df = new SimpleDateFormat("yyMMddHHmmss");

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        PDXAddContentForm contentForm = (PDXAddContentForm) form;

        //default not logged in
        String result = "failure";
    
        String modelID = request.getParameter("modelID");

        request.setAttribute("modelID", modelID);

        // verify user is logged in.
        String userName = (String) request.getSession().getAttribute("pdxUser");
        if (userName != null) {
           
            
            result = "add";
        
            String contentType = request.getParameter("submitContent");
            if(contentType == null){
               
                // set up the add content page
                int characterizationKey = 0;
                String characterization ="";
                request.setAttribute("hidePImage", "true");
                request.setAttribute("hideDocument","true");
                request.setAttribute("hideComment", "true");
                request.setAttribute("hideLink","true");
                request.setAttribute("hideGraphic","true");


                if(request.getParameter("histology") != null){
                    characterizationKey = PDXContent.HISTOLOGY;
                    characterization = "Histology";
                    request.setAttribute("hideGraphic", "false");
                }
                  if(request.getParameter("histologySummary") != null){
                    characterizationKey = PDXContent.HISTOLOGY_SUMMARY;
                    characterization = "Histology Summary";
                    request.setAttribute("hideComment", "false");
                }
                  
                  if(request.getParameter("pathologist")!=  null){
                      characterizationKey = PDXContent.PATHOLOGIST;
                      characterization = "Pathologist";
                      request.setAttribute("hideComment","false");
                  }
                
                if(request.getParameter("tumorMarkers") != null){
                    characterizationKey = PDXContent.TUMOR_MARKER;
                    characterization = "Tumor Markers";
                    request.setAttribute("hideComment","false");
                }
                if(request.getParameter("geneExpression") != null){
                    characterizationKey = PDXContent.GENE_EXPRESSION;
                    characterization = "Gene Expression";
                    request.setAttribute("hideGraphic","false");
                    request.setAttribute("hideLink","false");
                }
                if(request.getParameter("CNV") != null){
                    characterizationKey = PDXContent.CNV;
                    characterization = "CNV";
                   request.setAttribute("hideGraphic","false");
                    request.setAttribute("hideLink","false");
                }
                if(request.getParameter("mutation") != null){
                    characterizationKey = PDXContent.MUTATION;
                     characterization = "Mutation";       
                     request.setAttribute("hideComment","false");
                      request.setAttribute("hideLink","false");
                }
                if(request.getParameter("drugSensitivity") != null){
                    characterizationKey = PDXContent.DRUG_SENSITIVITY;
                    characterization = "Drug Sensitivity";
                    request.setAttribute("hideGraphic", "false");
                    request.setAttribute("hideDocument", "false");

                }
                
                if(request.getParameter("additionalGraphic") != null){
                    characterizationKey = PDXContent.ADDITIONAL_GRAPHIC;
                    characterization = "Additional Graphic";
                    request.setAttribute("hideGraphic", "false");

                }
                
                   if(request.getParameter("tumorGrowthRate") != null){
                    characterizationKey = PDXContent.TUMOR_GROWTH_RATE;
                    characterization = "Tumor Growth Rate";
                    request.setAttribute("hideGraphic", "false");

                }

                request.setAttribute("characterization", characterization);
                request.setAttribute("characterizationKey", characterizationKey);
            
            }else{
         
                boolean success = false;


                if ("pathImage".equals(contentType)) {
                    success = addPathImage(contentForm, userName);
                } else if ("url".equals(contentType)) {
                    success = addLink(contentForm, userName);
                } else if ("document".equals(contentType)) {
                    success = addDocument(contentForm, userName);
                } else if ("graphic".equals(contentType)) {
                    success = addGraphic(contentForm, userName);
                } else if ("comment".equals(contentType)) {
                    success = addComment(contentForm, userName);
                }

                response.setContentType("text/html");
                if (success) {
                    response.getWriter().write("{success:true}");
                } else {
                    response.getWriter().write("{success:false}");
                }
                
                   response.flushBuffer();
                
                response.getWriter().close();

                return null;

            }
        }
        
        
     
        return mapping.findForward(result);
    }

    private boolean addPathImage(PDXAddContentForm contentForm, String userName) {
        boolean success = false;

        
        PDXImage image = new PDXImage();
     
        image.setCaption(contentForm.getCaption());
        image.setDescription(contentForm.getPiDescription());
        image.setMouseID(contentForm.getModelID());
        image.setCharacterization(contentForm.getCharacterizationKey());
        image.setPathologist(contentForm.getPathologist());
        image.setSource(contentForm.getSource());
        image.setUser(userName);
        
        String fileName = getFileName(contentForm.getPiFilePath(),contentForm.getModelID());

        if(saveFile( contentForm.getPiFilePath(),fileName)){
            
            success = true;
            image.setFileName(fileName);
            
        }

        return success;

    }

    private boolean addLink(PDXAddContentForm contentForm, String userName) {
        boolean success = false;

      PDXLink link = new PDXLink();
  
      link.setDescription(contentForm.getLinkDescription());
      link.setLinkText(contentForm.getLinkText());
      link.setUrl(contentForm.getLinkURL());
      link.setModelID(contentForm.getModelID());
      link.setCharacterization(contentForm.getCharacterizationKey());
      link.setUser(userName);
      PDXMouseStore store  = new PDXMouseStore();
      
       success = store.addLink(link);

        return success;

    }

    private boolean addDocument(PDXAddContentForm contentForm, String userName) {
        boolean success = false;

        PDXDocument doc = new PDXDocument();
       
        doc.setModelID(contentForm.getModelID());
        doc.setCharacterization(contentForm.getCharacterizationKey());
        doc.setDescription(contentForm.getDocumentDescription());
        doc.setLinkText(contentForm.getDocumentLinkText());
        doc.setUser(userName);
        String fileName = getFileName(contentForm.getDocumentFilePath(),contentForm.getModelID());
        if (saveFile(contentForm.getDocumentFilePath(), fileName)) {
            success = true;
            doc.setFileName(fileName);
            PDXMouseStore store = new PDXMouseStore();
            success = store.addDocument(doc);

        }


        return success;


    }

    private boolean addGraphic(PDXAddContentForm contentForm, String userName) {
        boolean success = false;

        success = false;

        PDXGraphic gr = new PDXGraphic();
        
        gr.setDescription(contentForm.getGraphicDescription());
        gr.setModelID(contentForm.getModelID());
        gr.setCharacterization(contentForm.getCharacterizationKey());
        gr.setUser(userName);
        String fileName = getFileName(contentForm.getGraphicFilePath(),contentForm.getModelID());
        if (saveFile(contentForm.getGraphicFilePath(), fileName)) {
            success = true;
            gr.setFileName(fileName);
            PDXMouseStore store = new PDXMouseStore();
            success = store.addGraphic(gr);
        }

        return success;


    }

    private boolean addComment(PDXAddContentForm contentForm, String userName) {
        boolean success = false;

        PDXComment comment = new PDXComment();
       
        comment.setModelID(contentForm.getModelID());
        comment.setCharacterization(contentForm.getCharacterizationKey());
        comment.setComment(contentForm.getComment());
        comment.setUser(userName);
        PDXMouseStore store = new PDXMouseStore();
        

        success = store.addComment(comment);


        return success;


    }

    private String getFileName(FormFile file, String modelID) {
        
        String fileName = file.getFileName();
        String fileType = fileName.substring(fileName.lastIndexOf("."));
        
        return  modelID + df.format(Calendar.getInstance().getTime())+fileType;

    }

    private boolean saveFile(FormFile file, String fileName) {
   
        fileName = this.filePrefix+fileName;
        
        boolean success = false;

        try {
            // retrieve the file data
            InputStream stream = file.getInputStream();

            // write the file to the file specified
            OutputStream fos = new FileOutputStream(fileName);
            int bytesRead = 0;
            byte[] buffer = new byte[4096];
            while ((bytesRead = stream.read(buffer, 0, 4096)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
            
           
            fos.close();
        
            stream.close();
             File f = new File(fileName);
             f.setReadOnly();
             
            success = true;

      
        } catch (IOException ioe) {
            ioe.printStackTrace();
        } finally {
            //destroy the temporary file created
            try{
              file.destroy();
            }catch (Exception e){e.printStackTrace();}
        }
        
        return success;
    }
}
