/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.forms;

import org.apache.struts.action.ActionForm;

/**
 *
 * @author sbn
 */
public class OrthologyForm extends ActionForm {

  private String humanGS = "";
  private String sortBy = "HumanGS";
  private String compare = "Equals";

  public void setHumanGS(String in) {
    humanGS = in;
  }

  public String getHumanGS() {
    return humanGS;
  }

  public final String getSortBy() {
    return this.sortBy;
  }

  
  public final void setSortBy(String sort) {
    this.sortBy = sort;
  }

  public String getCompare() {
    return compare;
  }

  public void setCompare(String compare) {
    this.compare = compare;
  }
}
