/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import com.starlims.www.webservices.Engraftment_status;

import com.starlims.www.webservices.GetPDXEngraftmentMouseReport_sessionless;
import com.starlims.www.webservices.GetPDXPatientClinicalReports_sessionless;
import com.starlims.www.webservices.PDXPatientClinicalReport;
import com.starlims.www.webservices.GetPDXStatusReport_sessionless;
import com.starlims.www.webservices.MTB_wsStub;
import com.starlims.www.webservices.Pdx_model_status;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
//import org.apache.axiom.soap.SOAP11Constants;
import org.apache.log4j.Logger;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Access to data from ELIMS web services
 *
 * @author sbn
 */
public class ElimsUtil {

    private static final Logger log
            = Logger.getLogger(ElimsUtil.class.getName());
    private static String userName;
    private static String password;
    
    private static final String BCM = "BCM"; // to identify Bayolor MRN IDs for search by ID and show as previous ID
    
    private static final String NSG_OFFICIAL_NAME = "NOD.Cg-Prkdcscid Il2rgtm1Wjl/SzJ  (aka NSG or NOD Scid gamma)";
    private static final String NSG_HTML_NAME = "NOD.Cg-Prkdc<sup>scid</sup> Il2rg<sup>tm1Wjl</sup>/SzJ<br>(aka NSG or NOD Scid gamma)";
    
    // strains starting with this get turned into one of the above.
    private static final String NSG = "NSG";
    
    // all TM models and all J models before J000111056 are considered legacy and should be shown on MTB if they are P1 available
    // non legacy models are shown at P2 available
    private static final int legacyCutOff=111056;

    public ElimsUtil() {
    }

    public void setAuthentication(String uname, String pwd) {
        userName = uname;
        password = pwd;
    }

    // The names of the web services and the reports are switched so this is right
    public String getPDXEngraftmentStatusSummary() {
        StringBuffer report = new StringBuffer();
        try {
            MTB_wsStub stub = getStub();

            GetPDXEngraftmentMouseReport_sessionless soapRequest
                    = GetPDXEngraftmentMouseReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            Engraftment_status[] result = stub.getPDXEngraftmentMouseReport_sessionless(soapRequest).getGetPDXEngraftmentMouseReport_sessionlessResult().getEngraftment_status();

            if (result.length > 0) {
                report.append("Model ID,Model,Passage,Number of Mice Engrafted, Model Status\n");

                for (int i = 0; i < result.length; i++) {

                    if (filterOnID(result[i].getIdentifier())) {

                        report.append(result[i].getIdentifier()).append(",");
                        report.append(result[i].getModel()).append(",");
                        report.append(result[i].getPassage()).append(",");
                        report.append(result[i].getNumber_Of_Mice_Engrafted()).append(",");
                        report.append(result[i].getModel_Status()).append("\n");
                    }
                }
            }
        } catch (Exception e) {
            log.error("Error getting PDX Engraftment Summary", e);
            report.append("There was an error creating the report.");
        }
        return report.toString();
    }

    
    
     

 

    public String getPDXPatientHistory() {
        StringBuffer report = new StringBuffer();

        try {

            HashMap<String, HashMap<String,String>> statusMap = this.getModelStatusMap();

            HashMap<String,String> emptyList = statusMap.get("emptyMap");

            MTB_wsStub stub = getStub();

            GetPDXPatientClinicalReports_sessionless soapRequest
                    = GetPDXPatientClinicalReports_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            PDXPatientClinicalReport[] result = stub.getPDXPatientClinicalReports_sessionless(soapRequest).getGetPDXPatientClinicalReports_sessionlessResult().getPDXPatientClinicalReport();

            if (result.length > 0) {

                /*  Add these fields from the statusMap
                    list.put("status",result[i].getModel_Status());
                    list.put("modelAKA",result[i].getModel_Aka());
                    list.put("gender",result[i].getGender());
                    list.put("age",result[i].getPatient_Age());
                    list.put("race",result[i].getRace());
                    list.put("comments",result[i].getComments());
                    list.put("specimenSite",result[i].getSpecimen_Site());
                    list.put("primarySite",result[i].getPrimary_Site());
                    list.put("clinicalDiagnosis",result[i].getClinical_Diagnosis());
                    list.put("hospital",result[i].getCollecting_Site()); // instituion/hospital
                 */
                report.append("Participant ID,Model,Model AKA,Model Status,Specimen Site, Primary Site,Gender,Age,Race,Clinical Diagnosis,Prior Cancer Diagnosis,");
                report.append("Current Smoker,Former Smoker,Extimated Pack Years, Treatment Naive, Radiation Therapy,");
                report.append("Radiation Therapy Details, Chemotherapy, Chemotherapy Details, Hormone Therapy, Hormone Therapy Details, Other Therapy, Other Therapy Details,");
                report.append("Donating Hospital,Treatment Outcome,Patient History Notes,Comments\n");
                for (int i = 0; i < result.length; i++) {

                    String id = result[i].getModel();
                    try {
                        int intID = new Integer(id);
                        id = ("TM" + String.format("%05d", intID));
                    } catch (NumberFormatException e) {}
                    
                    if (filterOnID(id)) {
                        report.append(clean(result[i].getParticipant_ID())).append(",");
                        report.append(clean(id)).append(",");
                        HashMap<String,String> statusList = statusMap.get(result[i].getModel());

                        if (statusList == null) {
                            statusList = emptyList;
                        }
                        report.append(clean(statusList.get("modelAKA"))).append(",");
                        report.append(clean(statusList.get("status"))).append(",");
                        report.append(clean(statusList.get("specimenSite"))).append(",");
                        report.append(clean(statusList.get("primarySite"))).append(",");
                        report.append(clean(statusList.get("gender"))).append(",");
                        report.append(clean(statusList.get("age"))).append(",");
                        report.append(clean(statusList.get("race"))).append(",");
                        report.append(clean(statusList.get("clinicalDiagnosis"))).append(",");
                        
                        report.append(clean(result[i].getPrior_Cancer_Diagnoses())).append(",");
                        report.append(clean(result[i].getCurrent_Smoker())).append(",");
                        report.append(clean(result[i].getFormer_Smoker())).append(",");
                        report.append(clean(result[i].getEstimated_Pack_Years())).append(",");
                        report.append(clean(result[i].getTreatment_Naive())).append(",");
                        report.append(clean(result[i].getRadiation_Therapy())).append(",");
                        report.append(clean(result[i].getRadiation_Therapy_Details())).append(",");
                        report.append(clean(result[i].getChemotherapy())).append(",");
                        report.append(clean(result[i].getChemotherapy_Details())).append(",");
                        report.append(clean(result[i].getHormone_Therapy())).append(",");
                        report.append(clean(result[i].getHormone_Therapy_Details())).append(",");
                        report.append(clean(result[i].getOther_Therapy())).append(",");
                        report.append(clean(result[i].getOther_Therapy_Details())).append(",");
                        report.append(clean(statusList.get("hospital"))).append(",");
                        report.append(clean(result[i].getTreatment_Outcome())).append(",");
                        report.append(clean(result[i].getPatient_History_Notes())).append(",");
                        report.append(clean(statusList.get("comments"))).append("\n");

                    }

                }
            }
        } catch (Exception e) {
            log.error("Error getting PDX Family History", e);
        }

        return report.toString();

    }

    public String getPDXPatientClinicalReport() {
        StringBuffer report = new StringBuffer();

        try {

            MTB_wsStub stub = getStub();

            GetPDXPatientClinicalReports_sessionless soapRequest = GetPDXPatientClinicalReports_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            PDXPatientClinicalReport[] result
                    = stub.getPDXPatientClinicalReports_sessionless(soapRequest).getGetPDXPatientClinicalReports_sessionlessResult().getPDXPatientClinicalReport();

            if (result.length > 0) {
                
                
                

                report.append("Model,Name,Primary Site,Laterality,Stage,Grade,Path Report Available,Path Report Link,Cisplatin Resistant, Other Resistance, Histology,");
                report.append("Tumor Markers,Other Markers,Chromosome Analysis,Genetic Mutation Analysis, Tumor Notes\n");

                for (int i = 0; i < result.length; i++) {

                    if (filterOnID(result[i].getModel())) {

                        report.append(clean(result[i].getModel())).append(",");
                        report.append(clean(result[i].getName())).append(",");
                        report.append(clean(result[i].getPrimary_Site())).append(",");
                        report.append(clean(result[i].getLaterality())).append(",");
                        report.append(clean(result[i].getStage())).append(",");
                        report.append(clean(result[i].getGrade())).append(",");
                        report.append(clean(result[i].getPath_Report_Available())).append(",");
                        report.append(clean(result[i].getPath_Report_Link())).append(",");
                        report.append(clean(result[i].getCisplatin_Resistant())).append(",");
                        report.append(clean(result[i].getOther_Resistance())).append(",");
                        report.append(clean(result[i].getHistology())).append(",");
                        report.append(clean(result[i].getTumorMarkers())).append(",");
                        report.append(clean(result[i].getOther_Markers())).append(",");
                        report.append(clean(result[i].getChromosome_Analysis())).append(",");
                        report.append(clean(result[i].getGenetic_Mutation_Analysis())).append(",");
                        report.append(clean(result[i].getTumor_Notes())).append("\n");


                        /*


                        result[i].getTreatment_Outcome();
                        result[i].getTreatment_Naive();
                        result[i].getRisk_Factors();
                        result[i].getRadiation_Therapy();
                        result[i].getPrior_Cancer_Diagnoses();
                        result[i].getPatient_History_Notes();
                        result[i].getParticipant_ID();
                        result[i].getOther_Therapy();
                        result[i].getOccupation_Information();
                        result[i].getHormone_Therapy();
                        result[i].getFormer_Smoker();
                        result[i].getFamily_History();
                        result[i].getExposures();
                        result[i].getEstimated_Pack_Years();
                        result[i].getCurrent_Smoker();
                        result[i].getComorbidity_Conditions();
                        result[i].getChromosome_Analysis();
                        result[i].getChemotherapy();
                        result[i].getAlcohol_Use();
                         */
                    }
                }
            }
        } catch (Exception e) {
            log.error("Error getting PDX Tumor Details", e);
        }
        return report.toString();

    }

    // Any changes here need to get relayed to Al Simons as he comsumes this as JSON and these are field keys
    private static final String STATUS_COLUMNS = "Model ID,Project Type,Model Status,Location,Model,Model AKA,MRN,Gender,Age,Race,Ethnicity,"
            + "Specimen Site,Primary Site,Initial Diagnosis,Clinical Diagnosis,Other Diagnosis Info,"
            + "Tumor Type,Grades,Markers,Model Tags,Stages,M-Stage,N-Stage,T-Stage,Sample Type,Stock Num,Strain,Mouse Sex,"
            + "Engraftment Site,Collecting Site,Collection Date,Received Date,Accession Date,P0 Engraftment Date,P0 Success Date,"
            + "P1 Engraftment Date,P1 Success Date,P2 Engraftment Date,P2 Success Date,Comments";

    private static final String STATUS_COLUMNS_2 = "Model ID,Project Type,Model Status,Location,Model,Model AKA,MRN,Gender,Age,Race,Ethnicity,"
            + "Specimen Site,Primary Site,Clinical Diagnosis,"
            + "Tumor Type,Grades,Markers,Model Tags,Stages,M-Stage,N-Stage,T-Stage,Sample Type,Stock Num,Strain,Mouse Sex,"
            + "Engraftment Site,Collecting Site,Collection Date,Received Date,Accession Date,P0 Engraftment Date,P0 Success Date,"
            + "P1 Engraftment Date,P1 Success Date,P2 Engraftment Date,P2 Success Date,Comments";

    
    public String getPDXStatusReport() {
        StringBuffer report = new StringBuffer();
        try {

            MTB_wsStub stub = getStub();

            GetPDXStatusReport_sessionless soapRequest
                    = GetPDXStatusReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            Pdx_model_status[] result = stub.getPDXStatusReport_sessionless(soapRequest).getGetPDXStatusReport_sessionlessResult().getPdx_model_status();

            if (result.length > 0) {

                report.append(STATUS_COLUMNS_2).append("\n");
                for (int i = 0; i < result.length; i++) {

                    String id = result[i].getIdentifier();
                    try {
                        int intID = new Integer(id).intValue();
                        id = ("TM" + String.format("%05d", intID));
                    } catch (NumberFormatException e) {
                        // this will happen for J##### ids which is ok
                    }

                    if (filterOnID(id)) {
                        report.append(id).append(",");
                        report.append(clean(result[i].getProjectType())).append(",");
                        report.append(clean(result[i].getModel_Status())).append(",");
                        report.append(clean(result[i].getLocation())).append(",");
                        report.append(clean(result[i].getModel())).append(",");
                        report.append(clean(result[i].getModel_Aka())).append(",");
                        report.append(clean(result[i].getMedical_Record_Number())).append(",");
                        report.append(clean(result[i].getGender())).append(",");
                        report.append(clean(result[i].getPatient_Age())).append(",");
                        report.append(clean(result[i].getRace())).append(",");
                        report.append(clean(result[i].getEthnicity())).append(",");
                        report.append(clean(result[i].getSpecimen_Site())).append(",");
                        report.append(clean(result[i].getPrimary_Site())).append(",");
                      //  report.append(clean(result[i].getInitial_Diagnosis())).append(",");
                        report.append(clean(result[i].getClinical_Diagnosis())).append(",");
                     //   report.append(clean(result[i].getOther_Diagnosis_Info())).append(",");    // we can remove this (per margaret)
                        report.append(clean(result[i].getTumor_Type())).append(",");
                        report.append(clean(result[i].getGrades())).append(",");
                        report.append(clean(result[i].getMarkers())).append(",");
                        report.append(clean(result[i].getModelTags())).append(",");
                        report.append(clean(result[i].getTumor_Stage())).append(",");
                        report.append(clean(result[i].getTumor_M_Stage())).append(",");
                        report.append(clean(result[i].getTumor_N_Stage())).append(",");
                        report.append(clean(result[i].getTumor_T_Stage())).append(",");
                        report.append(clean(result[i].getSample_Type())).append(",");
                        report.append(clean(result[i].getStockNumber())).append(",");
                        report.append(fixStrain(result[i].getStrain())).append(",");
                        report.append(clean(result[i].getMouseSex())).append(",");
                        report.append(clean(fixEngraftment(result[i].getEngraftmentSite()))).append(",");
                        report.append(clean(result[i].getCollecting_Site())).append(",");  // organization
                        report.append(cleanDate(result[i].getCollection_Date())).append(",");
                        report.append(cleanDate(result[i].getReceived_Date())).append(",");
                        report.append(cleanDate(result[i].getAccession_Date())).append(",");
                        report.append(cleanDate(result[i].getP0_Engraftment_Date())).append(",");
                        report.append(cleanDate(result[i].getP0_Success_Date())).append(",");
                        report.append(cleanDate(result[i].getP1_Engraftment_Date())).append(",");
                        report.append(cleanDate(result[i].getP1_Success_Date())).append(",");
                        report.append(cleanDate(result[i].getP2_Engraftment_Date())).append(",");
                        report.append(cleanDate(result[i].getP2_Success_Date())).append(",");
                        report.append(clean(result[i].getComments())).append("\n");
                    }
                }

            }

        } catch (Exception e) {
            log.error("Error gettting PDX Status Report", e);
        }

        return report.toString();
    }

    public String getJSONPDXStatusReport() {
        StringBuilder report = new StringBuilder();
        try {

            MTB_wsStub stub = getStub();

            GetPDXStatusReport_sessionless soapRequest
                    = GetPDXStatusReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            Pdx_model_status[] result = stub.getPDXStatusReport_sessionless(soapRequest).getGetPDXStatusReport_sessionlessResult().getPdx_model_status();

            String[] columns = STATUS_COLUMNS.split(",");

            if (result.length > 0) {
                report.append("{\"pdxStatus\":[");
                for (int i = 0; i < result.length; i++) {
                    int j = 0;
                    String id = result[i].getIdentifier();
                    if (filterOnID(id)) {
                        report.append("{");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(id)).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getProjectType())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getModel_Status())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getLocation())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getModel())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getModel_Aka())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getMedical_Record_Number())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getGender())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getPatient_Age())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getRace())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getEthnicity())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getSpecimen_Site())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getPrimary_Site())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getInitial_Diagnosis())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getClinical_Diagnosis())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getOther_Diagnosis_Info())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getTumor_Type())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getGrades())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getMarkers())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getModelTags())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getTumor_Stage())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getTumor_M_Stage())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getTumor_N_Stage())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getTumor_T_Stage())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getSample_Type())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getStockNumber())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(fixStrain(result[i].getStrain()))).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getMouseSex())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(fixEngraftment(result[i].getEngraftmentSite()))).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getCollecting_Site())).append(",\n");  // organization
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getCollection_Date())).append("\",\n");  
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getReceived_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getAccession_Date())).append("\",\n");  
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getP0_Engraftment_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getP0_Success_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getP1_Engraftment_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getP1_Success_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getP2_Engraftment_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getP2_Success_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getComments())).append("},\n");
                    }
                }
            }
            report.replace(report.length() - 2, report.capacity(), "]}");
        } catch (Exception e) {
            log.error("Error gettting PDX Status Report as JSON", e);
        }

        return report.toString();
    }

    public String getPDXConsortiumReport() {
        StringBuffer report = new StringBuffer();
        try {

            MTB_wsStub stub = getStub();

            GetPDXStatusReport_sessionless soapRequest
                    = GetPDXStatusReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            Pdx_model_status[] result = stub.getPDXStatusReport_sessionless(soapRequest).getGetPDXStatusReport_sessionlessResult().getPdx_model_status();

            if (result.length > 0) {

                report.append("Model AKA,Collection Date,Donating Site,MRN,Patient Age,Sex,Race,Specimen Site,Primary Tumor Site,Clinical Diagnosis,Pathologic Diagnosis,");
                report.append("Stage,Grade,Molecular Markers,Histological Markers,JAX Model ID,P0 Engraftment Date, Model Status\n");
                for (int i = 0; i < result.length; i++) {

                    String id = result[i].getIdentifier();

                    if (filterOnID(id)) {
                        report.append(clean(result[i].getModel_Aka())).append(",");
                        report.append(cleanDate(result[i].getReceived_Date())).append(",");
                        report.append(clean(result[i].getCollecting_Site())).append(",");  // organization
                        report.append(clean(result[i].getMedical_Record_Number())).append(",");
                        report.append(clean(result[i].getPatient_Age())).append(",");
                        report.append(clean(result[i].getGender())).append(",");
                        report.append(clean(result[i].getRace())).append(",");
                        report.append(clean(result[i].getSpecimen_Site())).append(",");
                        report.append(clean(result[i].getPrimary_Site())).append(",");
                        report.append(clean(result[i].getInitial_Diagnosis())).append(",");  // in this report initial diag is called clinical
                        report.append(clean(result[i].getClinical_Diagnosis())).append(","); // clinical is called pathologic
                        report.append(clean(result[i].getTumor_Stage())).append(",");
                        report.append(clean(result[i].getGrades())).append(",");
                        report.append(clean(result[i].getMarkers())).append(",");
                        report.append(",");  // don't have histological markers yet

                        try {
                            int intID = new Integer(id).intValue();
                            id = ("TM" + String.format("%05d", intID));
                        } catch (NumberFormatException e) {
                            // this will happen for J##### ids which is ok
                        }
                        report.append(clean(id)).append(",");  // will need to add a TM to some of these
                        report.append(cleanDate(result[i].getP0_Engraftment_Date())).append(",");
                        report.append(clean(result[i].getModel_Status())).append("\n");
                    }
                }

            }
        } catch (Exception e) {
            log.error("Error gettting PDX Status Report", e);
        }

        return report.toString();
    }

    /*
     * Returns all the PDX mice plus lists of initial diagnosis and primary sites
     */
    public PDXMouseSearchData getPDXMouseSearchData() throws Exception {

        System.out.println("getting pdx search data");

        HashMap<String, ArrayList<String>> detailsMap = getPDXClinicalDetails();

        PDXMouseSearchData searchData = new PDXMouseSearchData();

        ArrayList<String> diagnosis = new ArrayList<String>();
        ArrayList<String> primarySites = new ArrayList<String>();
        ArrayList<String> tags = new ArrayList<String>();
        ArrayList<PDXMouse> mice = new ArrayList<PDXMouse>();

        // to get unique values for these fields
        HashMap<String, String> diagnosisMap = new HashMap<String, String>();
        HashMap<String, String> primarySitesMap = new HashMap<String, String>();
        HashMap<String, String> tagsMap = new HashMap<String, String>();
        HashMap<String, String> idMap = new HashMap<>();

        try {

            MTB_wsStub stub = getStub();

            GetPDXStatusReport_sessionless soapRequest
                    = GetPDXStatusReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            Pdx_model_status[] results = stub.getPDXStatusReport_sessionless(soapRequest).getGetPDXStatusReport_sessionlessResult().getPdx_model_status();

            String status ="";
            int numericID =111111;
            
            if (results.length > 0) {

                for (int i = 0; i < results.length; i++) {

                    ArrayList<String> details;

                    // should also test for filterOnID()
                    
//                    New MTB PDX Filter criteria
//                    Active: Available
//                    Or Active: Available - QC Complete
//                    Or (Active: P1 Available + all TM models + all J models less than J000111056)
//                    No change to Blood or Data filter

                    
                    status = results[i].getModel_Status();
                 
                    try{
                        numericID = new Integer(results[i].getIdentifier().replaceAll("J",""));
                    }catch(Exception e){
                        numericID = 111111;
                    }
                    
                    if (status.contains("Active Available") 
                        || status.contains("Active: Available")    
                        || status.contains("Blood")
                        || status.contains("Data")
                        || (status.contains("Active: P1 Available") && numericID < 111056 )) {
                        
                //        System.out.println(status+"\t"+numericID+"\tACCEPTED");
                                

                        PDXMouse mouse = new PDXMouse();

                        details = detailsMap.get(clean(results[i].getIdentifier()));
                        if (details != null) {
                            mouse.setCurrentSmoker(details.get(0));
                            mouse.setFormerSmoker(details.get(1));
                            mouse.setTreatmentNaive(details.get(2));

                        } 
                        
                        try {

                            mouse.setModelID("TM" + String.format("%05d", new Integer(results[i].getIdentifier())));

                        } catch (Exception e) {
                            // this will be the new J#### models
                            //         log.debug("cant parse model id:" + results[i].getIdentifier());

                            mouse.setModelID(results[i].getIdentifier());
                        }

                        mouse.setModelStatus(results[i].getModel_Status());
                        mouse.setPreviousID(results[i].getModel_Aka());
                        mouse.setInstitution(results[i].getCollecting_Site());
                        mouse.setTissue(results[i].getSpecimen_Site());
                        mouse.setSex(results[i].getGender());  // patient sex, not mouse
                        mouse.setAge(results[i].getPatient_Age());
                        mouse.setInitialDiagnosis(results[i].getInitial_Diagnosis());
                        mouse.setClinicalDiagnosis(results[i].getClinical_Diagnosis()); // displayed as Final Diaganosis
                        mouse.setSampleType(results[i].getSample_Type());
                        mouse.setLocation(fixEngraftment(results[i].getEngraftmentSite()));
                        mouse.setRace(results[i].getRace());
                        mouse.setEthnicity(results[i].getEthnicity());
                        mouse.setPrimarySite(results[i].getPrimary_Site());
                        mouse.setStrain(fixWebStrain(results[i].getStrain()));

                        mouse.setTumorType(results[i].getTumor_Type());
                        mouse.setTumorMarkers(clean(results[i].getMarkers()));
                        mouse.setStage(results[i].getTumor_Stage());
                        mouse.setGrade(results[i].getGrades());

                        mouse.setTag(results[i].getModelTags());

                        // don't display models taged as Suspended on the public install
                        String tag = results[i].getModelTags();
                        if (tag == null) {
                            tag = "";
                        }
                        if ((!WIConstants.getInstance().getPublicDeployment() || !"Suspended".equalsIgnoreCase(tag))) {

                            mice.add(mouse);
                            if (mouse.getInitialDiagnosis().trim().length() > 0) {
                                diagnosisMap.put(mouse.getInitialDiagnosis(), mouse.getInitialDiagnosis());
                            }
                            if (mouse.getClinicalDiagnosis().trim().length() > 0) {
                                diagnosisMap.put(mouse.getClinicalDiagnosis(), mouse.getClinicalDiagnosis());
                            }

                            if (mouse.getPrimarySite().trim().length() > 0) {
                                primarySitesMap.put(mouse.getPrimarySite(), mouse.getPrimarySite());
                            }

                            if (tag.trim().length() > 0) {
                                tagsMap.put(results[i].getModelTags(), "tag");
                            }

                            idMap.put( mouse.getModelID()+" "+mouse.getPrimarySite() + " " + mouse.getInitialDiagnosis(),mouse.getModelID());
                            // we want to be able to search on previous IDs as well
                            String pid = mouse.getPreviousID();
                            
                            
                            // for Baylor models we want to use MRN as previous ID
                            String mrn = results[i].getMedical_Record_Number();
                            if(mrn != null && mrn.startsWith(BCM)){
                                pid = mrn;
                                mouse.setPreviousID(pid);
                            }
                            
                            if(pid != null && pid.trim().length()>0){
                                // oh the humanity, the ExtJS combobox widget won't work if IDs are duplicated so we need to pad these id with a space right here ---V
                                idMap.put( pid+ " ("+mouse.getModelID()+") "+mouse.getPrimarySite() + " " + mouse.getInitialDiagnosis(),mouse.getModelID()+" ");
                            }
                        } else {
                            log.debug("skipping suspended model " + mouse.getModelID());
                        }

                    }else{
               //              System.out.println(status+"\t"+numericID+"\tREJECTED");
                    }
                }

                diagnosis.addAll(diagnosisMap.keySet());
                Collections.sort(diagnosis);
                primarySites.addAll(primarySitesMap.keySet());
                Collections.sort(primarySites);

                tags.addAll(tagsMap.keySet());
                Collections.sort(tags);

                searchData.setDiagnosis(diagnosis);
                searchData.setPrimarySites(primarySites);
                searchData.setTags(tags);
                searchData.setMice(mice);
                searchData.setIds(idMap);

                // what about using linkedHashMaps so vocabs are sorted
                // but use the values as sets of matching modelID's for search?
            }
        } catch (Exception e) {
            log.error("Error getting PDX Mice", e);
            // log.error("using PWD " + password + ", and user " + userName);
            throw (e);
        }

        return searchData;
    }

    public ArrayList<ArrayList<String>> getPDXModelStatus() {

        ArrayList<ArrayList<String>> modelStats = new ArrayList<ArrayList<String>>();
        try {

            MTB_wsStub stub = getStub();
            HashMap<String, Integer> map = new HashMap<String, Integer>();

            GetPDXStatusReport_sessionless soapRequest
                    = GetPDXStatusReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            Pdx_model_status[] result = stub.getPDXStatusReport_sessionless(soapRequest).getGetPDXStatusReport_sessionlessResult().getPdx_model_status();

            if (result.length > 0) {

                for (int i = 0; i < result.length; i++) {

                    StringBuffer key = new StringBuffer();
                    String keyStr = "";

                    key.append(result[i].getModel_Status()).append(",");
                    key.append(result[i].getCollecting_Site()).append(",");  //// organization
                    if (result[i].getPrimary_Site().trim().length() == 0) {
                        key.append("Not Specified,");
                    } else {
                        key.append(result[i].getPrimary_Site() + ",");
                    }

                    keyStr = key.toString().replaceAll("\"", "");

                    if (map.containsKey(keyStr)) {
                        int count = map.get(keyStr).intValue();
                        count++;
                        map.put(keyStr, new Integer(count));
                    } else {
                        map.put(keyStr, new Integer(1));
                    }

                }

                for (String key : map.keySet()) {
                    ArrayList<String> vals = new ArrayList<String>();
                    String[] keyVals = key.split(",");
                    vals.add(keyVals[2]); // primary site
                    vals.add(keyVals[1]); // org
                    vals.add(keyVals[0]); //status
                    vals.add(map.get(key).toString()); // count
                    modelStats.add(vals);

                }

            }
        } catch (Exception e) {
            log.error("Error gettting PDX Status Report", e);
        }
        return modelStats;
    }

    // Return a map of patient details to model ID's this is used for the model comparision page
    private HashMap<String, ArrayList<String>> getPDXClinicalDetails() {
        HashMap<String, ArrayList<String>> modelDetails = new HashMap<String, ArrayList<String>>();

     
        try {

            MTB_wsStub stub = getStub();

            GetPDXPatientClinicalReports_sessionless soapRequest
                    = GetPDXPatientClinicalReports_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            PDXPatientClinicalReport[] result  = stub.getPDXPatientClinicalReports_sessionless(soapRequest).getGetPDXPatientClinicalReports_sessionlessResult().getPDXPatientClinicalReport();

                    
                    
            
            if (result.length > 0) {

                for (int i = 0; i < result.length; i++) {

                    ArrayList<String> details = new ArrayList<String>();

                    details.add(result[i].getCurrent_Smoker());
                    details.add(result[i].getFormer_Smoker());
                    details.add(result[i].getTreatment_Naive());

                    modelDetails.put(clean(result[i].getModel()), details);

                }
            }
        } catch (Error e) {
            log.error("Error getting PDX Clinical Details", e);
        } catch (Exception e){
            log.error("Error getting PDX Clinical Details", e);
        }

        return modelDetails;

    }

   

    // an extended version of the search results report including models with any status.
    //contacts for this are Tony Marchetti and Julius Henderson
    public String getPDXReportWithNoName(ArrayList<PDXMouse> allMice) {

        // this should only happen once a week so we will just eat the overhead
        HashMap<String, PDXMouse> mouseMap = new HashMap();
        for (PDXMouse mouse : allMice) {
            mouseMap.put(mouse.getModelID(), mouse);
        }
        StringBuffer report = new StringBuffer();
        try {

            MTB_wsStub stub = getStub();

            GetPDXStatusReport_sessionless soapRequest
                    = GetPDXStatusReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            report.append("Model Status,");
            report.append("Model ID,");
            report.append("Previous ID,");
            report.append("Tissue,");
            report.append("Initial Diagnosis,");
            report.append("Final Diagnosis,");
            report.append("Location,");
            report.append("Sample Type,");
            report.append("Tumor Type,");
            report.append("Primary Site,");
            report.append("Tumor Markers,");
            report.append("Sex,");
            report.append("Age,");
            report.append("Strain,");
            report.append("Associated Data\n");

            Pdx_model_status[] result = stub.getPDXStatusReport_sessionless(soapRequest).getGetPDXStatusReport_sessionlessResult().getPdx_model_status();

            if (result.length > 0) {
                for (int i = 0; i < result.length; i++) {
                    String id = result[i].getIdentifier();
                    try {
                        int intID = new Integer(id).intValue();
                        id = ("TM" + String.format("%05d", intID));
                    } catch (NumberFormatException e) {
                    }

                    if (filterOnID(id)) {
                        report.append(noQuotesNoCommasClean(result[i].getModel_Status())).append(",");
                        report.append(id).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getModel_Aka())).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getSpecimen_Site())).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getInitial_Diagnosis())).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getClinical_Diagnosis())).append(",");
                        report.append(noQuotesNoCommasClean(fixEngraftment(result[i].getEngraftmentSite()))).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getSample_Type())).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getTumor_Type())).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getPrimary_Site())).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getMarkers()).replaceAll(",", ";")).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getGender())).append(",");
                        report.append(noQuotesNoCommasClean(result[i].getPatient_Age())).append(",");
                        report.append(noQuotesNoCommasClean(fixStrain(result[i].getStrain()))).append(",");
                        if (mouseMap.containsKey(id) && mouseMap.get(id).getAssocData() != null) {
                            report.append(noQuotesNoCommasClean(mouseMap.get(id).getAssocData().replaceAll(",", ";"))).append("\n");
                        } else {
                            report.append(",\n");
                        }

                    }
                }

            }

        } catch (Exception e) {
            log.error("Error gettting PDX Report with no name", e);
        }

        return report.toString();
    }

   
    private HashMap<String, HashMap<String,String>> getModelStatusMap() {

        HashMap<String, HashMap<String,String>> map = new HashMap<>();

        HashMap<String,String> list = new HashMap();
                    list.put("status","");
                    list.put("modelAKA","");
                    list.put("gender","");
                    list.put("age","");
                    list.put("race","");
                    list.put("comments","");
                    list.put("specimenSite","");
                    list.put("primarySite","");
                    list.put("clinicalDiagnosis","");
                    list.put("hospital","");
                    map.put("emptyMap", list);
        
        try {
            MTB_wsStub stub = getStub();

            GetPDXStatusReport_sessionless soapRequest
                    = GetPDXStatusReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            Pdx_model_status[] result = stub.getPDXStatusReport_sessionless(soapRequest).getGetPDXStatusReport_sessionlessResult().getPdx_model_status();

            if (result.length > 0) {
                for (int i = 0; i < result.length; i++) {
                    list = new HashMap();
                    list.put("status",result[i].getModel_Status());
                    list.put("modelAKA",result[i].getModel_Aka());
                    list.put("gender",result[i].getGender());
                    list.put("age",result[i].getPatient_Age());
                    list.put("race",result[i].getRace());
                    list.put("comments",result[i].getComments());
                    list.put("specimenSite",result[i].getSpecimen_Site());
                    list.put("primarySite",result[i].getPrimary_Site());
                    list.put("clinicalDiagnosis",result[i].getClinical_Diagnosis());
                    list.put("hospital",result[i].getCollecting_Site()); // instituion/hospital
                    map.put(result[i].getIdentifier(), list);
                }
            }

        } catch (Exception e) {
            log.error("Error getting Model Status Map", e);

        }
        return map;
    }
    
    private String fixStrain(String strain){
      
        if(strain != null && strain.startsWith(NSG)){
            strain =NSG_OFFICIAL_NAME;
        }
        return strain;
    }
    
    private String fixWebStrain(String strain){
      
        if(strain != null && strain.startsWith(NSG)){
            strain =NSG_HTML_NAME;
        }
        return strain;
    }
    

    // right now there is a practice model that needs to be excluded
    // but in theory it could be anyting else at some point.
    private boolean filterOnID(String id) {
        boolean include = true;

        if (id != null && id.contains("Practice")) {
            include = false;
        }

        return include;
    }

    // private utility methods
    private static MTB_wsStub getStub() throws Exception {

        MTB_wsStub stub = null;
        try {
            stub = new MTB_wsStub();
            
            //stub._getServiceClient().getOptions().setSoapVersionURI(
            //        SOAP11Constants.SOAP_ENVELOPE_NAMESPACE_URI);

            //stub._getServiceClient().getOptions().setTimeOutInMilliSeconds(300000);
        } catch (Error e) {
            e.printStackTrace();
            throw new Exception(e.fillInStackTrace());
        }
        return stub;

    }
    
    // for fields that are parsed rather than loaded into Excel
    private String noQuotesNoCommasClean(String in){
        if(in != null){
             in = in.replaceAll("\"", "").replaceAll("'", "").replaceAll("\\p{C}", "").replaceAll("&#x.{1,4};", " ").trim().replaceAll(",",";");
        }
        return in;
    }

    private String clean(String in) {
        if (in != null) {
            return "\"" + in.replaceAll("\"", "").replaceAll("'", "").replaceAll("\\p{C}", "").replaceAll("&#x.{1,4};", " ").trim() + "\"";
        }
        return in;
    }

    
    // if engraftment site is not provided it is (Not any more) Sub Q 
    private String fixEngraftment(String in) {
        if (in == null || in.trim().length() == 0) {
            return "";
        } else {
            return in;
        }
    }

    // dates look like this 2015-09-12T20:00:33.3100000-04:00 (yay)
    private String cleanDate(String in) {
        if (in != null) {
            int dateLen = in.length();
            if (dateLen > 10) {
                dateLen = 10;
            }
            in = in.substring(0, dateLen);
        }
        return in;
    }

    
}
