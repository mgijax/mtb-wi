/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.forms;

import java.util.ArrayList;
import org.apache.struts.action.ActionForm;
import org.apache.struts.upload.FormFile;

/**
 *
 * @author sbn
 */
public class PDXAddContentForm  extends ActionForm {
    
    //tumorID
    private String modelID;
    private int characterizationKey; 
    private String characterization;
    
    // for pathology images
    private String caption;
    private String piDescription;
    private String pathologist;
    private String source;
    private FormFile piFilePath;
    private double piSort;
   
    // for links
    private String linkDescription;
   private String linkURL;
   private String linkText;
   private String pubMedID;
   
   // for documents
   private String documentDescription;
   private String documentLinkText;
   private FormFile documentFilePath;
    
   // for graphics
   private String graphicDescription;
   private FormFile graphicFilePath;
   private double graphicSort;
   
   
   // for comments
   private String comment;
   
    public void setPiFilePath(FormFile file){
        this.piFilePath =file;
        
    }
    
    public FormFile getPiFilePath(){
        return this.piFilePath;
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
     * @return the stain
     */
    public String getPiDescription() {
        return piDescription;
    }

    /**
     * @param stain the stain to set
     */
    public void setPiDescription(String desc) {
        this.piDescription = desc;
    }

    /**
     * @return the caption
     */
    public String getCaption() {
        return caption;
    }

    /**
     * @param caption the caption to set
     */
    public void setCaption(String caption) {
        this.caption = caption;
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
     * @return the linkDescription
     */
    public String getLinkDescription() {
        return linkDescription;
    }

    /**
     * @param linkDescription the linkDescription to set
     */
    public void setLinkDescription(String linkDescription) {
        this.linkDescription = linkDescription;
    }

    /**
     * @return the linkURL
     */
    public String getLinkURL() {
        return linkURL;
    }

    /**
     * @param linkURL the linkURL to set
     */
    public void setLinkURL(String linkURL) {
        this.linkURL = linkURL;
    }

    /**
     * @return the linkText
     */
    public String getLinkText() {
        return linkText;
    }

    /**
     * @param linkText the linkText to set
     */
    public void setLinkText(String linkText) {
        this.linkText = linkText;
    }

    /**
     * @return the documentDescription
     */
    public String getDocumentDescription() {
        return documentDescription;
    }

    /**
     * @param documentDescription the documentDescription to set
     */
    public void setDocumentDescription(String documentDescription) {
        this.documentDescription = documentDescription;
    }

    /**
     * @return the documentLinkText
     */
    public String getDocumentLinkText() {
        return documentLinkText;
    }

    /**
     * @param documentLinkText the documentLinkText to set
     */
    public void setDocumentLinkText(String documentLinkText) {
        this.documentLinkText = documentLinkText;
    }

    /**
     * @return the documentFilePath
     */
    public FormFile getDocumentFilePath() {
        return documentFilePath;
    }

    /**
     * @param documentFilePath the documentFilePath to set
     */
    public void setDocumentFilePath(FormFile documentFilePath) {
        this.documentFilePath = documentFilePath;
    }

    /**
     * @return the graphicDescription
     */
    public String getGraphicDescription() {
        return graphicDescription;
    }

    /**
     * @param graphicDescription the graphicDescription to set
     */
    public void setGraphicDescription(String graphicDescription) {
        this.graphicDescription = graphicDescription;
    }

    /**
     * @return the graphicFilePath
     */
    public FormFile getGraphicFilePath() {
        return graphicFilePath;
    }

    /**
     * @param graphicFilePath the graphicFilePath to set
     */
    public void setGraphicFilePath(FormFile graphicFilePath) {
        this.graphicFilePath = graphicFilePath;
    }

    /**
     * @return the comment
     */
    public String getComment() {
        return comment;
    }

    /**
     * @param comment the comment to set
     */
    public void setComment(String comment) {
        this.comment = comment;
    }

    /**
     * @return the modelID
     */
    public String getModelID() {
        return modelID;
    }

    /**
     * @param modelID the modelID to set
     */
    public void setModelID(String modelID) {
        this.modelID = modelID;
    }

    /**
     * @return the characterizationKey
     */
    public int getCharacterizationKey() {
        return characterizationKey;
    }

    /**
     * @param characterizationKey the characterizationKey to set
     */
    public void setCharacterizationKey(int characterizationKey) {
        this.characterizationKey = characterizationKey;
    }
    
     /**
     * @return the characterization
     */
    public String  getCharacterization() {
        return characterization;
    }

    /**
     * @param characterization the characterization to set
     */
    public void setCharacterization(String characterization) {
        this.characterization = characterization;
    }

    /**
     * @return the piSort
     */
    public double getPiSort() {
        return piSort;
    }

    /**
     * @param piSort the piSort to set
     */
    public void setPiSort(double piSort) {
        this.piSort = piSort;
    }

    /**
     * @return the graphicSort
     */
    public double getGraphicSort() {
        return graphicSort;
    }

    /**
     * @param graphicSort the graphicSort to set
     */
    public void setGraphicSort(double graphicSort) {
        this.graphicSort = graphicSort;
    }

    /**
     * @return the pubMedID
     */
    public String getPubMedID() {
        return pubMedID;
    }

    /**
     * @param pubMedID the pubMedID to set
     */
    public void setPubMedID(String pubMedID) {
        this.pubMedID = pubMedID;
    }

  
}
    