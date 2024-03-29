/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/forms/PDXForm.java,v 1.6 2016/07/18 17:09:44 sbn Exp $
 * Author: $Author: sbn $
 */
package org.jax.mgi.mtb.wi.forms;

import java.util.ArrayList;
import java.util.Collection;

import org.apache.struts.action.ActionForm;

public class PDXForm extends ActionForm {

    private String maxItems = "100";
    private String[] diagnoses = new String[0];
    private Collection diagnosesValues = new ArrayList();
    private String[] primarySites = new String[0];
    private Collection primarySitesValues = new ArrayList();
    private String[] tags = new String[0];
    private Collection tagsValues = new ArrayList();
    private String[] tumorTypes = new String[0];
    private Collection tumorTypesValues = new ArrayList();
    private String[] tumorMarkers = new String[0];
    private Collection tumorMarkersValues = new ArrayList();
    private String fusionGenes = null;
    private String recistDrugs = null;
    private String recistResponses = null;
    private String gene = null;
    private String genes2 = null;
    private String genesCNV = null;
    private String variantGene = null;
    private String[] genes = new String[0];
    private String[] chrCNV = new String[0];
    private Collection chrValuesCNV = new ArrayList();
    private String[] variants = new String[0];
    private Collection variantsValues = new ArrayList();
    private String modelID = null;
    private String arm = null;
    private String cnvChange = null;
    private boolean chartCNV = false;
    private boolean amplification = false;
    private boolean deletion = false;
    private boolean loh = false;
    private boolean dosingStudy = false;
    private boolean treatmentNaive = false;
    private boolean pediatric = false;
    private boolean currentlyAvailable = false;
    private String TMBLT = null;
    private String TMBGT = null;
    private String pTMBLT = null;
    private String pTMBGT = null;

    // ----------------------------------------------------------- Constructors
    // none
    // --------------------------------------------------------- Public Methods
    /**
     * @return the maxItems
     */
    public String getMaxItems() {
        return maxItems;
    }

    /**
     * @param maxItems the maxItems to set
     */
    public void setMaxItems(String maxItems) {
        this.maxItems = maxItems;
    }

    /**
     * @return the diagnoses
     */
    public String[] getDiagnoses() {
        return diagnoses;
    }

    /**
     * @param diagnoses the diagnoses to set
     */
    public void setDiagnoses(String[] diagnoses) {
        this.diagnoses = diagnoses;
    }

    /**
     * @return the diagnosesValues
     */
    public Collection getDiagnosesValues() {
        return diagnosesValues;
    }

    /**
     * @param diagnosesValues the diagnosesValues to set
     */
    public void setDiagnosesValues(Collection diagnosesValues) {
        this.diagnosesValues = diagnosesValues;
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
     * @return the primarySites
     */
    public String[] getPrimarySites() {
        return primarySites;
    }

    /**
     * @param primarySites the primarySites to set
     */
    public void setPrimarySites(String[] primarySites) {
        this.primarySites = primarySites;
    }

    /**
     * @return the primarySitesValues
     */
    public Collection getPrimarySitesValues() {
        return primarySitesValues;
    }

    /**
     * @param primarySitesValues the primarySitesValues to set
     */
    public void setPrimarySitesValues(Collection primarySitesValues) {
        this.primarySitesValues = primarySitesValues;
    }

    /**
     * @return the tumorTypes
     */
    public String[] getTumorTypes() {
        return tumorTypes;
    }

    /**
     * @param tumorTypes the tumorTypes to set
     */
    public void setTumorTypes(String[] tumorTypes) {
        this.tumorTypes = tumorTypes;
    }

    /**
     * @return the tumorTypesValues
     */
    public Collection getTumorTypesValues() {
        return tumorTypesValues;
    }

    /**
     * @param tumorTypesValues the tumorTypesValues to set
     */
    public void setTumorTypesValues(Collection tumorTypesValues) {
        this.tumorTypesValues = tumorTypesValues;
    }

    /**
     * @return the tumorMarkers
     */
    public String[] getTumorMarkers() {
        return tumorMarkers;
    }

    /**
     * @param tumorMarkers the tumorMarkers to set
     */
    public void setTumorMarkers(String[] tumorMarkers) {
        this.tumorMarkers = tumorMarkers;
    }

    /**
     * @return the tumorMarkersValues
     */
    public Collection getTumorMarkersValues() {
        return tumorMarkersValues;
    }

    /**
     * @param tumorMarkersValues the tumorMarkersValues to set
     */
    public void setTumorMarkersValues(Collection tumorMarkersValues) {
        this.tumorMarkersValues = tumorMarkersValues;
    }

    /**
     * @return the variants
     */
    public String[] getVariants() {
        return variants;
    }

    /**
     * @param variants the variants to set
     */
    public void setVariants(String[] variants) {
        this.variants = variants;
    }

    /**
     * @return the variantsValues
     */
    public Collection getVariantsValues() {
        return variantsValues;
    }

    /**
     * @param variantsValues the variantsValues to set
     */
    public void setVariantsValues(Collection variantsValues) {
        this.variantsValues = variantsValues;
    }

  

   

    /**
     * @return the arm
     */
    public String getArm() {
        return arm;
    }

    /**
     * @param arm the arm to set
     */
    public void setArm(String arm) {
        this.arm = arm;
    }

    /**
     * @return the amplification
     */
    public boolean getAmplification() {
        return amplification;
    }

    /**
     * @param amplification the amplification to set
     */
    public void setAmplification(boolean amplification) {
        this.amplification = amplification;
    }

    /**
     * @return the deletion
     */
    public boolean getDeletion() {
        return deletion;
    }

    /**
     * @param deletion the deletion to set
     */
    public void setDeletion(boolean deletion) {
        this.deletion = deletion;
    }

    /**
     * @return the loh
     */
    public boolean getLoh() {
        return loh;
    }

    /**
     * @param loh the loh to set
     */
    public void setLoh(boolean loh) {
        this.loh = loh;
    }

    /**
     * @return the chrCNV
     */
    public String[] getChrCNV() {
        return chrCNV;
    }

    /**
     * @return the chrValuesCNV
     */
    public Collection getChrValuesCNV() {
        return chrValuesCNV;
    }

    /**
     * @param chrValuesCNV the chrValuesCNV to set
     */
    public void setChrValuesCNV(Collection chrValuesCNV) {
        this.chrValuesCNV = chrValuesCNV;
    }

    /**
     * @return the chartCNV
     */
    public boolean getChartCNV() {
        return chartCNV;
    }

    /**
     * @param chartCNV the chartCNV to set
     */
    public void setChartCNV(boolean chartCNV) {
        this.chartCNV = chartCNV;
    }

    /**
     * @return the cnvChange
     */
    public String getCnvChange() {
        return cnvChange;
    }

    /**
     * @param cnvChange the cnvChange to set
     */
    public void setCnvChange(String cnvChange) {
        this.cnvChange = cnvChange;
    }

   

    /**
     * @return the dosingStudy
     */
    public boolean getDosingStudy() {
        return dosingStudy;
    }

    /**
     * @param dosingStudy the dosingStudy to set
     */
    public void setDosingStudy(boolean dosingStudy) {
        this.dosingStudy = dosingStudy;
    }

    public String getGene() {
        return gene;
    }

    public void setGene(String gene) {
        this.gene = gene;
    }

    /**
     * @return the tags
     */
    public String[] getTags() {
        return tags;
    }

    /**
     * @param tags the tags to set
     */
    public void setTags(String[] tags) {
        this.tags = tags;
    }

    /**
     * @return the tagsValues
     */
    public Collection getTagsValues() {
        return tagsValues;
    }

    /**
     * @param tagsValues the tagsValues to set
     */
    public void setTagsValues(Collection tagsValues) {
        this.tagsValues = tagsValues;
    }

    public String getGenes2() {
        return genes2;
    }

    
    public void setGenes2(String genes2) {
        this.genes2 = genes2;
    }

    /**
     * @return the genesCNV
     */
    public String getGenesCNV() {
        return genesCNV;
    }

    /**
     * @param genesCNV the genesCNV to set
     */
    public void setGenesCNV(String genesCNV) {
        this.genesCNV = genesCNV;
    }

    /**
     * @return the genes
     */
    public String[] getGenes() {
        return genes;
    }

    /**
     * @param genes the genes to set
     */
    public void setGenes(String[] genes) {
        this.genes = genes;
    }

    /**
     * @return the fusionGenes
     */
    public String getFusionGenes() {
        return fusionGenes;
    }

    /**
     * @param fusionGenes the fusionGenes to set
     */
    public void setFusionGenes(String fusionGenes) {
        this.fusionGenes = fusionGenes;
    }

    /**
     * @return the treatmentNaive
     */
    public boolean getTreatmentNaive() {
        return treatmentNaive;
    }

    /**
     * @param treatmentNaive the treatmentNaive to set
     */
    public void setTreatmentNaive(boolean treatmentNaive) {
        this.treatmentNaive = treatmentNaive;
    }

    /**
     * @return the recistDrugs
     */
    public String getRecistDrugs() {
        return recistDrugs;
    }

    /**
     * @param recistDrugs the recistDrugs to set
     */
    public void setRecistDrugs(String recistDrugs) {
        this.recistDrugs = recistDrugs;
    }

    /**
     * @return the recistResponse
     */
    public String getRecistResponses() {
        return recistResponses;
    }

    /**
     * @param recistResponse the recistResponse to set
     */
    public void setRecistResponses(String recistResponses) {
        this.recistResponses = recistResponses;
    }

    /**
     * @return the variantGene
     */
    public String getVariantGene() {
        return variantGene;
    }

    /**
     * @param variantGene the variantGene to set
     */
    public void setVariantGene(String variantGene) {
        this.variantGene = variantGene;
    }

    /**
     * @return the TMBLT
     */
    public String getTMBLT() {
        return TMBLT;
    }

    /**
     * @param TMBLT the TMBLT to set
     */
    public void setTMBLT(String TMBLT) {
        this.TMBLT = TMBLT;
    }

    /**
     * @return the TMBGT
     */
    public String getTMBGT() {
        return TMBGT;
    }

    /**
     * @param TMBGT the TMBGT to set
     */
    public void setTMBGT(String TMBGT) {
        this.TMBGT = TMBGT;
    }

    /**
     * @return the pTMBLT
     */
    public String getpTMBLT() {
        return pTMBLT;
    }

    /**
     * @param pTMBLT the pTMBLT to set
     */
    public void setpTMBLT(String pTMBLT) {
        this.pTMBLT = pTMBLT;
    }

    /**
     * @return the pTMBGT
     */
    public String getpTMBGT() {
        return pTMBGT;
    }

    /**
     * @param pTMBGT the pTMBGT to set
     */
    public void setpTMBGT(String pTMBGT) {
        this.pTMBGT = pTMBGT;
    }

    /**
     * @return the pediatric
     */
    public boolean getPediatric() {
        return pediatric;
    }

    /**
     * @param pediatric the pediatric to set
     */
    public void setPediatric(boolean pediatric) {
        this.pediatric = pediatric;
    }

    /**
     * @return the currentlyAvailable
     */
    public boolean getCurrentlyAvailable() {
        return currentlyAvailable;
    }

    /**
     * @param currentlyAvailable the currentlyAvailable to set
     */
    public void setCurrentlyAvailable(boolean currentlyAvailable) {
        this.currentlyAvailable = currentlyAvailable;
    }
}