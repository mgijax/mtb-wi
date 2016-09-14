/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.jax.mgi.mtb.wi.forms;


import org.apache.struts.action.ActionForm;



public class DynamicGridForm extends ActionForm {

    
   

    // note for a multiselect box to work and retain values on an error
    // you need to have both collectionSelect and strainType
    // see the jsp for attributes
    
    
    private String[] organGrpChk = {};  
    private String[] strainFamilyChk = {};
    
    

  public String[] getOrganGrpChk() {
    return organGrpChk;
  }

  public void setOrganGrpChk(String[] organGrpChk) {
    this.organGrpChk = organGrpChk;
  }

 

  public String[] getStrainFamilyChk() {
    return strainFamilyChk;
  }

  public void setStrainFamilyChk(String[] strainFamilyChk) {
    this.strainFamilyChk = strainFamilyChk;
  }

  

  public void reset(){
    organGrpChk = new String[0];
    strainFamilyChk = new String[0];
  }

  
   


   
}