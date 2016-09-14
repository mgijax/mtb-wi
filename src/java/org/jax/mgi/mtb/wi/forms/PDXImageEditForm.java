/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/forms/PDXImageEditForm.java,v 1.1 2013/10/30 19:58:46 sbn Exp $
 * Author: $Author: sbn $
 */
package org.jax.mgi.mtb.wi.forms;


import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;




public class PDXImageEditForm extends ActionForm {
    
  
    
    
    private String tumorID;
    private String caption;
    private String description;
    private String pathologist;
    private String source;
    private String passage;
    private String diagnosis;
    private String fileName;
    private String okToDelete;
    
   
   
    public void reset() {
        // no-op'd
    }

  
  
     public ActionErrors validate(ActionMapping mapping, 
            HttpServletRequest request) {

        final ActionErrors errors = new ActionErrors();
        
        // no validation as of now
        
        return errors;
    }

    /**
     * @return the tumorID
     */
    public String getTumorID() {
        return tumorID;
    }

    /**
     * @param tumorID the tumorID to set
     */
    public void setTumorID(String tumorID) {
        this.tumorID = tumorID;
    }

 

    /**
     * @return the caption
     */
    public String getCaption() {
        return caption;
    }

    /**
     * @param set the caption
     */
    public void setCaption(String caption) {
        this.caption = caption;
    }

    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @return the pathologist
     */
    public String getPathologist() {
        return pathologist;
    }

    /**
     * @param pathologist the pathologist to set
     */
    public void setPathologist(String pathologist) {
        this.pathologist = pathologist;
    }

    /**
     * @return the source
     */
    public String getSource() {
        return source;
    }

    /**
     * @param source the source to set
     */
    public void setSource(String source) {
        this.source = source;
    }

    /**
     * @return the passage
     */
    public String getPassage() {
        return passage;
    }

    /**
     * @param passage the passage to set
     */
    public void setPassage(String passage) {
        this.passage = passage;
    }

    /**
     * @return the fileName
     */
    public String getFileName() {
        return fileName;
    }

    /**
     * @param fileName the fileName to set
     */
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    /**
     * @return the diagnosis
     */
    public String getDiagnosis() {
        return diagnosis;
    }

    /**
     * @param diagnosis the diagnosis to set
     */
    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    /**
     * @return the okToDelete
     */
    public String getOkToDelete() {
        return okToDelete;
    }

    /**
     * @param okToDelete the okToDelete to set
     */
    public void setOkToDelete(String okToDelete) {
        this.okToDelete = okToDelete;
    }
    

  
}
