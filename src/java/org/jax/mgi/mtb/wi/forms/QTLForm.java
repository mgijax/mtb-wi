/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/forms/QTLForm.java,v 1.4 2012/06/04 15:32:33 sbn Exp $
 * Author: $Author: sbn $
 */
package org.jax.mgi.mtb.wi.forms;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Collection;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

/**
 * 
 * 
 * @author $Author: sbn $
 * @version $Revision: 1.4 $
 * @see org.apache.struts.action.ActionForm
 * @cvsheader $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/forms/QTLForm.java,v 1.4 2012/06/04 15:32:33 sbn Exp $
 * @date $Date: 2012/06/04 15:32:33 $
 */
public class QTLForm extends ActionForm {

  private static final long serialVersionUID = 7771625112122310025L;
  private String[] selectedQTLTypes = new String[0];
  private Collection qtlTypes = new ArrayList();
  private String[] ontology_key = {"Molecular+Function","Biological+Process","Cellular+Component"};
  private String go_op = new String("");
  private String go_term = new String();
  private String phenotype = new String();
  private String sortBy = "nomen";
  
  private String gsmname_op = new String("");
  private String gsmname_term = new String();
  
  private String featureTypes = new String();
  
  
  private String qtlStart = new String();
  private String qtlEnd = new String();
  private String searchStart = new String();
  private String searchEnd = new String();
  private String chrom = new String();
  private String types = new String();
  private String label = new String();
  private String mgiId = new String();
  private String primeRef = new String();
  private String primeRefId = new String();
  private String qtlName = new String();
  private  FormFile filePath = null;
  
  
  public QTLForm(){
    super();
    
  }

  public ActionErrors validate(ActionMapping mapping,
          HttpServletRequest request) {

    final ActionErrors errors = new ActionErrors();
      
    // no validation as of now

    return errors;
  }

  /**
   * Becuase this ActionForm should be request-scoped, do 
   * nothing here.  The fields will be reset when a new instance is created.
   */
  public void reset() {
    ontology_key[0] = "Molecular+Function";
    ontology_key[1] = "Biological+Process";
    ontology_key[2] = "Cellular+Component";
  }

  public String[] getSelectedQTLTypes() {
    return selectedQTLTypes;
  }

  public void setSelectedQTLTypes(String[] selectedQTLTypes) {
    this.selectedQTLTypes = selectedQTLTypes;
  }

  public Collection getQtlTypes() {
    return qtlTypes;
  }

  public void setQtlTypes(Collection qtlTypes) {
    this.qtlTypes = qtlTypes;
  }

  public String[] getOntology_key() {
    return ontology_key;
  }

  public void setOntology_key(String[] ontology_key) {
    this.ontology_key = ontology_key;
  }

  public String getGo_op() {
    return go_op;
  }

  public void setGo_op(String go_op) {
    this.go_op = go_op;
  }

  public String getGo_term() {
    return go_term;
  }

  public void setGo_term(String go_term) {
    this.go_term = go_term;
  }

  public String getPhenotype() {
    return phenotype;
  }

  public void setPhenotype(String phenotype) {
    this.phenotype = phenotype;
  }

  public String getSortBy() {
    return sortBy;
  }

  public void setSortBy(String sortBy) {
    this.sortBy = sortBy;
  }

  public String getQtlStart() {
    return qtlStart;
  }

  public void setQtlStart(String qtlStart) {
    this.qtlStart = qtlStart;
  }

  public String getQtlEnd() {
    return qtlEnd;
  }

  public void setQtlEnd(String qtlEnd) {
    this.qtlEnd = qtlEnd;
  }

  public String getSearchStart() {
    return searchStart;
  }

  public void setSearchStart(String searchStart) {
    this.searchStart = searchStart;
  }

  public String getSearchEnd() {
    return searchEnd;
  }

  public void setSearchEnd(String searchEnd) {
    this.searchEnd = searchEnd;
  }

  public String getChrom() {
    return chrom;
  }

  public void setChrom(String chrom) {
    this.chrom = chrom;
  }

  public String getTypes() {
    return types;
  }

  public void setTypes(String types) {
    this.types = types;
  }

  public String getLabel() {
    return label;
  }

  public void setLabel(String label) {
    this.label = label;
  }

  public String getMgiId() {
    return mgiId;
  }

  public void setMgiId(String mgiId) {
    this.mgiId = mgiId;
  }

  public String getPrimeRef() {
    return primeRef;
  }

  public void setPrimeRef(String primeRef) {
    this.primeRef = primeRef;
  }
  
  public void setPrimeRefId(String id){
    this. primeRefId = id;
  }
  
  public String  getPrimeRefId(){
    return this.primeRefId;
  }

  public String getQtlName() {
    return qtlName;
  }

  public void setQtlName(String qtlName) {
    this.qtlName = qtlName;
  }

  public FormFile getFilePath() {
    return filePath;
  }

  public void setFilePath(FormFile filePath) {
    this.filePath = filePath;
  }

  public String getFeatureTypes() {
    return featureTypes;
  }

  public void setFeatureTypes(String featureTypes) {
    this.featureTypes = featureTypes;
  }

    /**
     * @return the gsmname_op
     */
    public String getGsmname_op() {
        return gsmname_op;
    }

    /**
     * @param gsmname_op the gsmname_op to set
     */
    public void setGsmname_op(String gsmname_op) {
        this.gsmname_op = gsmname_op;
    }

    /**
     * @return the gsmname_term
     */
    public String getGsmname_term() {
        return gsmname_term;
    }

    /**
     * @param gsmname_term the gsmname_term to set
     */
    public void setGsmname_term(String gsmname_term) {
        this.gsmname_term = gsmname_term;
    }

 
}

    
   