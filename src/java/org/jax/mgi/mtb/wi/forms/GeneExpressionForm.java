package org.jax.mgi.mtb.wi.forms;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Collection;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.utils.StringUtils;

/**
 * GeneExpressionForm
 *
 * This class is extends ActionFrom and is used to encapsulate
 * the request parameters submitted by an HTTP request for the
 * Gene Expression Array Search.
 *
 * @author $Author: sbn $
 * @date $Date: 2010/07/08 19:50:51 $
 * @version $Revision: 1.1 $
 * @cvsheader $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/forms/GeneExpressionForm.java,v 1.1 2010/07/08 19:50:51 sbn Exp $
 * @see org.apache.struts.action.ActionForm
 */
public class GeneExpressionForm extends ActionForm {

  
  private String[] organ = new String[0];
  private Collection organValues = new ArrayList();
  private String[] tumorClassification = new String[0];
  private Collection tumorClassificationValues = new ArrayList();
  private String[] platform = new String[0];
  private Collection platformValues = new ArrayList();
  private String strainName = new String();
  private String likeClause = new String();
  private long tfKey = 0;
  private String seriesId;

  public String[] getOrgan() {
    return organ;
  }

  public void setOrgan(String[] organ) {
    this.organ = organ;
  }

  public Collection getOrganValues() {
    return organValues;
  }

  public void setOrganValues(Collection organValues) {
    this.organValues = organValues;
  }

  public String[] getTumorClassification() {
    return tumorClassification;
  }

  public void setTumorClassification(String[] tumorClassification) {
    this.tumorClassification = tumorClassification;
  }

  public Collection getTumorClassificationValues() {
    return tumorClassificationValues;
  }

  public void setTumorClassificationValues(Collection tumorClassificationValues) {
    this.tumorClassificationValues = tumorClassificationValues;
  }

  public String getStrainName() {
    return strainName;
  }

  public void setStrainName(String strainName) {
    this.strainName = strainName;
  }

  public String getLikeClause() {
    return likeClause;
  }

  public void setLikeClause(String likeClause) {
    this.likeClause = likeClause;
  }

  public String[] getPlatform() {
    return platform;
  }

  public void setPlatform(String[] platform) {
    this.platform = platform;
  }

  public Collection getPlatformValues() {
    return platformValues;
  }

  public void setPlatformValues(Collection platformValues) {
    this.platformValues = platformValues;
  }  

  public long getTfKey() {
    return tfKey;
  }

  public void setTfKey(long tfKey) {
    this.tfKey = tfKey;
  }

  public String getSeriesId() {
    return seriesId;
  }

  public void setSeriesId(String seriesId) {
    this.seriesId = seriesId;
  }
 
}
