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
import org.apache.axiom.soap.SOAP11Constants;
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

            HashMap<String, ArrayList<String>> statusMap = this.getModelStatusMap();

            ArrayList<String> emptyList = new ArrayList();
            for (int k = 0; k < 6; k++) {
                emptyList.add("");
            }

            MTB_wsStub stub = getStub();

            GetPDXPatientClinicalReports_sessionless soapRequest
                    = GetPDXPatientClinicalReports_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            PDXPatientClinicalReport[] result = stub.getPDXPatientClinicalReports_sessionless(soapRequest).getGetPDXPatientClinicalReports_sessionlessResult().getPDXPatientClinicalReport();

            if (result.length > 0) {

                /*  Add these fields from the statusMap
                    list.add(result[i].getModel_Aka());
                    list.add(result[i].getGender());
                    list.add(result[i].getPatient_Age());
                    list.add(result[i].getRace());
                    list.add(result[i].getComments());
                 */
                report.append("Participant ID,Model,Model AKA,Model Status,Gender,Age,Race,Occupation Information,Prior Cancer Diagnosis,Risk Factors,Family History, Comorbidity Conditions,Exposures,");
                report.append("Current Smoker,Former Smoker,Extimated Pack Years,Alcohol Use, Treatment Naive, Radiation Therapy, Radiation Therapy Details, Chemotherapy, Chemotherapy Details, Hormone Therapy, Hormone Therapy Details, Other Therapy, Other Therapy Details,");
                report.append("Treatment Outcome,Patient History Notes,Comments\n");
                for (int i = 0; i < result.length; i++) {

                    String id = result[i].getModel();
                    try {
                        int intID = new Integer(id).intValue();
                        id = ("TM" + String.format("%05d", intID));
                    } catch (NumberFormatException e) {
                        // this will happen for J##### ids which is ok
                    }

                    if (filterOnID(id)) {
                        report.append(clean(result[i].getParticipant_ID())).append(",");
                        report.append(clean(id)).append(",");
                        ArrayList<String> statusList = statusMap.get(result[i].getModel());

                        if (statusList == null) {
                            statusList = emptyList;
                        }
                        report.append(clean(statusList.get(1))).append(",");
                        report.append(clean(statusList.get(0))).append(",");
                        report.append(clean(statusList.get(2))).append(",");
                        report.append(clean(statusList.get(3))).append(",");
                        report.append(clean(statusList.get(4))).append(",");

                        report.append(clean(result[i].getOccupation_Information())).append(",");
                        report.append(clean(result[i].getPrior_Cancer_Diagnoses())).append(",");
                        report.append(clean(result[i].getRisk_Factors())).append(",");
                        report.append(clean(result[i].getFamily_History())).append(",");
                        report.append(clean(result[i].getComorbidity_Conditions())).append(",");
                        report.append(clean(result[i].getExposures())).append(",");
                        report.append(clean(result[i].getCurrent_Smoker())).append(",");
                        report.append(clean(result[i].getFormer_Smoker())).append(",");
                        report.append(clean(result[i].getEstimated_Pack_Years())).append(",");
                        report.append(clean(result[i].getAlcohol_Use())).append(",");
                        report.append(clean(result[i].getTreatment_Naive())).append(",");
                        report.append(clean(result[i].getRadiation_Therapy())).append(",");
                        report.append(clean(result[i].getRadiation_Therapy_Details())).append(",");
                        report.append(clean(result[i].getChemotherapy())).append(",");
                        report.append(clean(result[i].getChemotherapy_Details())).append(",");
                        report.append(clean(result[i].getHormone_Therapy())).append(",");
                        report.append(clean(result[i].getHormone_Therapy_Details())).append(",");
                        report.append(clean(result[i].getOther_Therapy())).append(",");
                        report.append(clean(result[i].getOther_Therapy_Details())).append(",");
                        report.append(clean(result[i].getTreatment_Outcome())).append(",");
                        report.append(clean(result[i].getPatient_History_Notes())).append(",");
                        report.append(clean(statusList.get(5))).append("\n");

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
    private static final String STATUS_COLUMNS = "Model ID,Project Type,Model Status,Model,Model AKA,MRN,Gender,Age,Race,Ethnicity,Specimen Site,Primary Site,Initial Diagnosis,Clinical Diagnosis,Other Diagnosis Info,"
            + "Tumor Type,Grades,Markers,Model Tags,Stages,M-Stage,N-Stage,T-Stage,Sample Type,Stock Num,Strain,Mouse Sex,Engraftment Site,Collecting Site,Shipped Date,Received Date,Accession Date,Implantation Date,"
            + "P1 Creation Date,Engraftment Success Date,Engraftment Termination Date,Comments";

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

                report.append(STATUS_COLUMNS).append("\n");
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
                        report.append(clean(result[i].getModel())).append(",");
                        report.append(clean(result[i].getModel_Aka())).append(",");
                        report.append(clean(result[i].getMedical_Record_Number())).append(",");
                        report.append(clean(result[i].getGender())).append(",");
                        report.append(clean(result[i].getPatient_Age())).append(",");
                        report.append(clean(result[i].getRace())).append(",");
                        report.append(clean(result[i].getEthnicity())).append(",");
                        report.append(clean(result[i].getSpecimen_Site())).append(",");
                        report.append(clean(result[i].getPrimary_Site())).append(",");
                        report.append(clean(result[i].getInitial_Diagnosis())).append(",");
                        report.append(clean(result[i].getClinical_Diagnosis())).append(",");
                        report.append(clean(result[i].getOther_Diagnosis_Info())).append(",");
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
                        report.append(clean(result[i].getStrain())).append(",");
                        report.append(clean(result[i].getMouseSex())).append(",");
                        report.append(clean(fixEngraftment(result[i].getEngraftmentSite()))).append(",");
                        report.append(clean(result[i].getCollecting_Site())).append(",");  // organization
                        report.append(cleanDate(result[i].getShipped_Date())).append(",");
                        report.append(cleanDate(result[i].getReceived_Date())).append(",");
                        report.append(cleanDate(result[i].getAccession_Date())).append(",");
                        report.append(cleanDate(result[i].getImplantation_Date())).append(",");
                        report.append(cleanDate(result[i].getP1_Creation_Date())).append(",");
                        report.append(cleanDate(result[i].getEngraftment_Success_Date())).append(",");
                        report.append(cleanDate(result[i].getEngraftment_Termination_Date())).append(",");
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
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getStrain())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getMouseSex())).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(fixEngraftment(result[i].getEngraftmentSite()))).append(",\n");
                        report.append("\"").append(columns[j++]).append("\":").append(clean(result[i].getCollecting_Site())).append(",\n");  // organization
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getShipped_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getReceived_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getAccession_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getImplantation_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getP1_Creation_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getEngraftment_Success_Date())).append("\",\n");
                        report.append("\"").append(columns[j++]).append("\":\"").append(cleanDate(result[i].getEngraftment_Termination_Date())).append("\",\n");
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
                report.append("Stage,Grade,Molecular Markers,Histological Markers,JAX Model ID,Implantation Date, Model Status\n");
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
                        report.append(cleanDate(result[i].getImplantation_Date())).append(",");
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

            if (results.length > 0) {

                for (int i = 0; i < results.length; i++) {

                    ArrayList<String> details;

                    // should also test for filterOnID()
                    if ((results[i].getModel_Status().indexOf("Available") != -1)
                            || (results[i].getModel_Status().indexOf("Inventory") != -1)
                            || (results[i].getModel_Status().indexOf("Blood") != -1)
                            || (results[i].getModel_Status().indexOf("Data") != -1)) {

                        PDXMouse mouse = new PDXMouse();

                        details = detailsMap.get(clean(results[i].getIdentifier()));
                        if (details != null) {
                            mouse.setCurrentSmoker(details.get(0));
                            mouse.setFormerSmoker(details.get(1));
                            mouse.setTreatmentNaive(details.get(2));

                        } else {
                            log.error("no clinical details for " + results[i].getIdentifier());
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
                        mouse.setStrain(results[i].getStrain());

                        mouse.setTumorType(results[i].getTumor_Type());
                        mouse.setTumorMarkers(clean(results[i].getMarkers()));
                        mouse.setStage(results[i].getTumor_Stage());
                        mouse.setGrade(results[i].getGrades());
                        mouse.setStrain(results[i].getStrain());

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
                            if(pid != null && pid.trim().length()>0){
                                // oh the humanity, the ExtJS widget won't work if IDs are duplicated so we need to pad these id with a space right here ---V
                                idMap.put( pid+ " ("+mouse.getModelID()+") "+mouse.getPrimarySite() + " " + mouse.getInitialDiagnosis(),mouse.getModelID()+" ");
                            }
                        } else {
                            log.debug("skipping suspended model " + mouse.getModelID());
                        }

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

            PDXPatientClinicalReport[] result
                    = stub.getPDXPatientClinicalReports_sessionless(soapRequest).getGetPDXPatientClinicalReports_sessionlessResult().getPDXPatientClinicalReport();

            if (result.length > 0) {

                for (int i = 0; i < result.length; i++) {

                    ArrayList<String> details = new ArrayList<String>();

                    details.add(result[i].getCurrent_Smoker());
                    details.add(result[i].getFormer_Smoker());
                    details.add(result[i].getTreatment_Naive());

                    modelDetails.put(clean(result[i].getModel()), details);

                }
            }
        } catch (Exception e) {
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
                        report.append(noQuotesNoCommasClean(result[i].getStrain())).append(",");
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

    /*
    Return a map of modelid -> 
                model status,                
                Model_AKA,
                Gender,
                Age,
                Race,
                Comments,

     */
    private HashMap<String, ArrayList<String>> getModelStatusMap() {

        HashMap<String, ArrayList<String>> map = new HashMap<>();

        try {
            MTB_wsStub stub = getStub();

            GetPDXStatusReport_sessionless soapRequest
                    = GetPDXStatusReport_sessionless.class.newInstance();

            soapRequest.setPwd(password);
            soapRequest.setUser(userName);

            Pdx_model_status[] result = stub.getPDXStatusReport_sessionless(soapRequest).getGetPDXStatusReport_sessionlessResult().getPdx_model_status();

            if (result.length > 0) {
                for (int i = 0; i < result.length; i++) {
                    ArrayList<String> list = new ArrayList<>();
                    list.add(result[i].getModel_Status());
                    list.add(result[i].getModel_Aka());
                    list.add(result[i].getGender());
                    list.add(result[i].getPatient_Age());
                    list.add(result[i].getRace());
                    list.add(result[i].getComments());
                    map.put(result[i].getIdentifier(), list);
                }
            }

        } catch (Exception e) {
            log.error("Error getting Model Status Map", e);

        }
        return map;
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

            stub._getServiceClient().getOptions().setSoapVersionURI(
                    SOAP11Constants.SOAP_ENVELOPE_NAMESPACE_URI);

            stub._getServiceClient().getOptions().setTimeOutInMilliSeconds(300000);
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

    // if engraftment site is not provided it is Sub Q 
    private String fixEngraftment(String in) {
        if (in == null || in.trim().length() == 0) {
            return "Subcutaneous";
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
