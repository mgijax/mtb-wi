/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import org.apache.log4j.Logger;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXComment;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDAO;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDocument;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXGraphic;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXLink;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.dao.utils.DAOUtils;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Manages PDX data Initialized on startup; loads mice, reports and vocabularies
 * Gets data from web services, and through DAOs from both caTissue and MTB
 * databases
 *
 * @author sbn
 */
public class PDXMouseStore {

    private static final Logger log
            = Logger.getLogger(PDXMouseStore.class.getName());
    private static ArrayList<PDXMouse> allMice;
    // use the numeric part of the model id as an index to the mouse object
    //  private static HashMap<Integer,PDXMouse> mouseMap = new HashMap<Integer,PDXMouse>();
    private static ArrayList<String> diagnosesList;
    private static ArrayList<String> primarySitesList;
    private static ArrayList<String> tagsList;
    private static ArrayList<String> tumorMarkersList;
    private static ArrayList<String> allGenesList;
    private static ArrayList<String> ctpGeneList;
    private static ArrayList<LabelValueBean<String, String>> diagnosesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> primarySitesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> tagsLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> tumorMarkersLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> fusionGenesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> recistDrugsLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> recistResponsesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static String allGenesWebFormat;
    private static String ctpGenesWebFormat;
    private static String idList;
    private static HashMap<String, ArrayList<String>> assocData = new HashMap<String, ArrayList<String>>();
    private static ArrayList<ArrayList<String>> status = new ArrayList<ArrayList<String>>();
    private static String pdxEngraftmentStatusSummary = "The PDX Customer report could not be loaded;";
    private static String pdxPatientHistory = "The PDX Patient History report could not be loaded";
    private static String pdxPTClinical = "The PDX Patient Clinical report could not be loaded";
    private static String pdxStatusReport = "The PDX Status report could not be loaded";
    private static String pdxConsortiumReport = "The PDX Consortium report could not be loaded";
    private static Date reportFreshnessDate = null;
    private static String JSON_PDX_STATUS = "Unable to load data from eLIMS";
    private static String JSON_PDX_INFO = "Unable to load data from eLIMS";

    private static String baseURL = WIConstants.getInstance().getPDXWebservice();

    private static final String MODEL_EXPRESSION = baseURL + "expression?all_ctp_genes=yes&keepnulls=yes&model=";

    private static final String GENE_EXPRESSION = baseURL + "expression?&keepnulls=yesgene_symbol=";

    private static final String MODEL_CNV = baseURL + "cnv_gene?all_ctp_genes=yes&keepnulls=yes&model=";

    private static final String CNV_AMP = baseURL + "cnv_gene?min_lr_ploidy=0.5&gene_symbol=";
    private static final String CNV_DEL = baseURL + "cnv_gene?max_lr_ploidy=-0.5&gene_symbol=";

    private static final String VARIANTS = baseURL + "variants";

    private static final String FUSION_MODELS_BY_GENE = baseURL + "fusions?ckb_class=B&gene_symbol=";

    private static final String FUSION_GENES = baseURL + "fusion_genes?ckb_class=B";

    private static final String VARIANTS_FOR_GENE = baseURL + "gene_variants?gene_symbol=";

    private static final String ALL_GENES = baseURL + "all_genes";

    private static HashMap<String, String> fusionModelsMap = new HashMap();

    private static final String[] BUILD_38_AFFECTED_GENES = {"AKT3", "APOBEC3A", "B2M", "DAXX", "EHMT2", "EPHB6", "HLA-A", "HRAS", "ID3", "KCNQ2", "MUC4", "NOTCH4", "PIWIL1", "PTEN", "PTPRD", "RASA3", "SMARCB1"};
    private static final String RNA_SEQ = "RNA_Seq";
    private static final HashMap<String, String> AFFECTED_GENES = new HashMap<>();

    private static final String CKB_MOLPRO_PUBLIC = "https://ckb.jax.org/molecularProfile/show/";
    private static final String CKB_GENE_PUBLIC = "https://ckb.jax.org/gene/show?geneId=";

    private static final String CKB_MOLPRO_INTERNAL = "https://myckb.jax.org/molecularProfile/show/";
    private static final String CKB_GENE_INTERNAL = "https://myckb.jax.org/gene/show?geneId=";

    public static final String BAYLOR = "Baylor College of Medicine";
    public static final String DANA_FARBER = "Dana-Farber Cancer Institute";

    public static double AMP = 0.5;
    public static double DEL = -0.5;

    private static final HashMap<String, ArrayList<String>> cnvPlots = new HashMap<>();

    public PDXMouseStore() {

        try {
            if (allMice == null || allMice.isEmpty()) {
                synchronized (PDXMouseStore.class) {
                    loadData();
                }
            }
            if (AFFECTED_GENES.size() == 0) {
                for (String g : BUILD_38_AFFECTED_GENES) {
                    AFFECTED_GENES.put(g, g);
                }
            }
        } catch (Exception e) {
            log.error("Unable to initalize pdx mouse store", e);
            allMice = new ArrayList<>();

        }
    }

    private void loadData() throws Exception {

        log.info("Loading eLIMS-PDX Data");

        if (!WIConstants.getInstance().getPublicDeployment()) {
            if (status == null || status.isEmpty()) {
                loadReports();
            }
        }

        primarySitesLVB.clear();
        diagnosesLVB.clear();
        tagsLVB.clear();
        fusionGenesLVB.clear();
        recistDrugsLVB.clear();
        recistResponsesLVB.clear();

        log.info("loading mice from eLIMS");
        ElimsUtil eu = new ElimsUtil();
        PDXMouseSearchData searchData = eu.getPDXMouseSearchData();
        allMice = searchData.getMice();
        log.info("loaded " + allMice.size() + " mice.");

        diagnosesList = searchData.getDiagnosis();
        primarySitesList = searchData.getPrimarySites();
        tagsList = searchData.getTags();

        for (String tissue : primarySitesList) {
            LabelValueBean<String, String> lvb = new LabelValueBean(tissue, tissue);
            primarySitesLVB.add(lvb);
        }

        for (String diagnosis : diagnosesList) {
            LabelValueBean lvb = new LabelValueBean(diagnosis, diagnosis);
            diagnosesLVB.add(lvb);
        }

        for (String tag : tagsList) {
            LabelValueBean lvb = new LabelValueBean(tag, tag);
            tagsLVB.add(lvb);
        }

        String[] idArray = searchData.getIds().keySet().toArray(new String[searchData.getIds().size()]);
        // unfortunately this sorts by actual id not displayed id.... hrmph
        Arrays.sort(idArray);

        StringBuilder sb = new StringBuilder("[");
        for (String id : idArray) {
            sb.append("['").append(searchData.getIds().get(id)).append("','").append(id.replaceAll("'", "")).append("'],");
        }
        sb.replace(sb.length() - 1, sb.length(), "]");
        this.idList = sb.toString();

        loadFusionGenes();

        if (allMice != null && allMice.size() > 0) {

            HashMap<String, Integer> socGraphs = SOCLoader.loadSOCModels();

            ArrayList<String> recistResponses = SOCLoader.loadRECISTResponses();
            ArrayList<String> recistDrugs = SOCLoader.loadRECISTDrugs();

            for (String drug : recistDrugs) {
                recistDrugsLVB.add(new LabelValueBean(drug, drug));
            }

            for (String response : recistResponses) {
                recistResponsesLVB.add(new LabelValueBean(response, response));
            }

            assocData = PDXDAO.getInstance().getPDXAdditionalContent();
            for (PDXMouse mouse : allMice) {

                if (socGraphs.containsKey(mouse.getModelID())) {
                    mouse.setSocGraph(socGraphs.get(mouse.getModelID()));
                }
                mouse.setAssocData(assocData.get(mouse.getModelID()));
                String id = mouse.getModelID();

                if (fusionModelsMap.get(id) != null) {
                    mouse.setFusionGenes(fusionModelsMap.get(id));

                }

            }
            log.info("Loading genes from webservice.");
            loadAllGenes();

            StringBuffer genesBuffer = new StringBuffer();
            genesBuffer.append("[");

            for (String gene : allGenesList) {
                genesBuffer.append("[\"").append(gene).append("\",\"").append(gene).append("\"],");

            }
            genesBuffer.replace(genesBuffer.length() - 1, genesBuffer.length(), "]");

            allGenesWebFormat = genesBuffer.toString();

            log.info("Loaded " + allGenesList.size() + " genes.");

            loadCTPGenes();
            genesBuffer = new StringBuffer();
            genesBuffer.append("[");
            for (String gene : ctpGeneList) {
                if (genesBuffer.length() > 1) {
                    genesBuffer.append(",");
                }
                genesBuffer.append("['" + gene + "']");

            }
            genesBuffer.append("]");
            ctpGenesWebFormat = genesBuffer.toString();

            loadCNVPlots();
            log.info("Loaded cnv plots for " + cnvPlots.size() + " models.");
        }
    }

    /**
     * Pre load reports for dashboard, small but may take a few minutes to load
     * Can be reloaded by refresh button on dashboard
     */
    private void loadReports() {
        Date d = new Date();

        log.info(d + " Loading reports from eLIMS");
        ElimsUtil eu = new ElimsUtil();

        String temp = "";

        d = new Date();
        log.info(d + " Loading Engraftment Status Summary");
        temp = eu.getPDXEngraftmentStatusSummary();
        if (temp.length() > 0) {
            pdxEngraftmentStatusSummary = temp;
        } else {
            log.error("PDX Engraftment Status Summary was not loaded!");
        }

        d = new Date();
        log.info(d + " Loading Patient History");
        temp = eu.getPDXPatientHistory();
        if (temp.length() > 0) {
            pdxPatientHistory = temp;
        } else {
            log.error("PDX Patient History not loaded!");
        }

        d = new Date();
        log.info(d + " Loading Patient Clinical Report");
        temp = eu.getPDXPatientClinicalReport();
        if (temp.length() > 0) {
            pdxPTClinical = temp;
        } else {
            log.error("PDX PT Clinical Report not loaded!");
        }

        d = new Date();
        log.info(d + " Loading Status Report");
        temp = eu.getPDXStatusReport();
        if (temp.length() > 0) {
            pdxStatusReport = temp;
        } else {
            log.error("PDX Status Report not loaded!");
        }

        d = new Date();
        log.info(d + " Loading Consortium Report");
        temp = eu.getPDXConsortiumReport();
        if (temp.length() > 0) {
            pdxConsortiumReport = temp;
        } else {
            log.error("PDX Consortium Report not loaded!");
        }

        ArrayList<ArrayList<String>> tempList = eu.getPDXModelStatus();
        if (tempList.size() > 0) {
            status = tempList;
        } else {
            log.error("PDX Model Status not loaded!");
        }

        d = new Date();
        log.info(d + " Done loading reports");
        reportFreshnessDate = d;
    }

    // keep a cached copy of the PDXStatus JSON but use a new one if available
    // used by pdx dashboard (external to MTB)
    public String getJSONPDXStatus() {
        ElimsUtil eu = new ElimsUtil();
        String newData = eu.getJSONPDXStatusReport();
        if (newData != null && newData.trim().length() != 80) {
            this.JSON_PDX_STATUS = newData;
        } else {
            log.error("Unable to load JSON for PDX status.");
        }
        return this.JSON_PDX_STATUS;
    }

    /**
     * Return the mouse model with ID using cached mouse list Result will be a
     * single mouse or empty. ArrayList for consistency with other find methods
     *
     * @param ID String TM#####
     * @return ArrayList<PDXMouse>
     */
    public ArrayList<PDXMouse> findStaticMouseByID(String ID) {
        ArrayList<PDXMouse> mice = new ArrayList<PDXMouse>();
        loop:
        for (PDXMouse mouse : this.allMice) {
            if (mouse.getModelID().equalsIgnoreCase(ID)) {
                mice.add(mouse);
                break loop;
            }
        }

        return mice;
    }

    /**
     * Return a list of PDXMice that match the search parameters
     *
     * @param modelID String
     * @param tissues ArrayList<String>
     * @param diagnoses ArrayList<String>
     * @param tumorTypes ArrayList<String>
     * @param tumorMarkers ArrayList<String>
     * @param genes ArrayList<String>
     * @param variants ArrayList<String>
     * @param drugResponse boolean drugResponse data required
     * @param tumorGrowth boolean tumorGrowth data required
     * @return ArrayList<PDXMouse> mice matching search parameters
     */
    public ArrayList<PDXMouse> findMice(String modelID, ArrayList<String> tissues,
            ArrayList<String> diagnoses, ArrayList<String> tumorTypes, ArrayList<String> tumorMarkers,
            String gene, ArrayList<String> variants, boolean dosingStudy,
            boolean tumorGrowth, ArrayList<String> tags, String fusionGenes,
            boolean treatmentNaive, String recistDrug, String recistResponse) {

        // may need to do 3 searches
        // findStaticMice
        // find by fusion gene
        // find by gene variant --> populate variants and consequence if variant is used
        ArrayList<PDXMouse> mice = new ArrayList<PDXMouse>();

        // get a list of mice based on search criteria that are in ELIMS
        mice = findStaticMice(modelID, tissues, diagnoses, tumorTypes, tumorMarkers,
                tags, dosingStudy, tumorGrowth, treatmentNaive, recistDrug, recistResponse);

        ArrayList<String> ids = new ArrayList<>();

        if (fusionGenes != null && fusionGenes.trim().length() > 0) {

            if (fusionGenes.equalsIgnoreCase("any")) {
                for (String id : fusionModelsMap.keySet()) {
                    ids.add(id);
                }
            } else {

                ids.addAll(getFusionModels(fusionGenes));
            }

        }

        Collections.sort(ids);

        ArrayList<PDXMouse> mice2 = new ArrayList<PDXMouse>();

        if (ids.isEmpty()) {
            mice2.addAll(mice);
        } else {
            for (PDXMouse sMouse : mice) {
                // because search specific values will be set clone the static mouse
                PDXMouse mouse = sMouse.clone();
                for (String id : ids) {
                    if (compareIDs(mouse.getModelID(), id)) {
                        mice2.add(mouse);

                    }
                }
            }
        }

        if (gene != null && gene.length() > 0) {
            mice2 = getMiceByGeneVariant(mice2, gene, variants);
        }

        return mice2;
    }

    private boolean compareIDs(String display, String numeric) {

        log.error("Comparing " + display + " to " + numeric);
        if (true) {
            return display.equals(numeric);
        }

        boolean match = false;
        int numNum = -1;
        int displayNum = 0;
        try {
            numNum = new Integer(numeric).intValue();

        } catch (Exception e) {
            log.error("Cant parse " + numeric + " to compare to " + display);
        }
        try {

            if (display.startsWith("TM")) {
                display = display.substring(2);
                displayNum = new Integer(display).intValue();
            }
            if (display.startsWith("J")) {
                display = display.substring(1);
                displayNum = new Integer(display).intValue();
            }
        } catch (Exception e) {
            log.error("Cant parse " + display + " to compare to " + numeric);
        }
        if (displayNum == numNum) {
            match = true;
        }

        return match;
    }

    public ArrayList<PDXMouse> findStaticMiceByTissueOfOrigin(String toa) {
        ArrayList<PDXMouse> mice = new ArrayList<PDXMouse>();

        for (PDXMouse mouse : allMice) {
            if (mouse.getTissue().equals(toa)) {
                mice.add(mouse);
            }
        }
        return mice;
    }

    /**
     * Use the cached list of mice to get models matching the search criteria
     * This getting pretty lame
     *
     * @param modelID String TM#####
     * @param tissues ArrayList<String>
     * @param diagnoses ArrayList<String>
     * @param tumorTypes ArrayList<String>
     * @param tumorMarkers ArrayList<String>
     * @return ArrayList<PDXMouse> matching mice
     */
    private ArrayList<PDXMouse> findStaticMice(String modelID, ArrayList<String> tissues,
            ArrayList<String> diagnoses, ArrayList<String> tumorTypes, ArrayList<String> tumorMarkers,
            ArrayList<String> tags, boolean dosingStudy, boolean tumorGrowth, boolean treatmentNaive,
            String recistDrug, String recistResponse) {

        ArrayList<PDXMouse> mice = new ArrayList<PDXMouse>();
        ArrayList<PDXMouse> mice2 = new ArrayList<PDXMouse>();

        if (modelID != null && modelID.length() > 0) {
            mice = findStaticMouseByID(modelID);
        } else {
            mice.addAll(allMice);
        }

        if (tissues != null && tissues.size() > 0) {
            for (PDXMouse mouse : mice) {
                for (String tissue : tissues) {
                    if (mouse.getPrimarySite().equals(tissue)) {
                        mice2.add(mouse);
                    }
                }
            }
        } else {
            mice2.addAll(mice);
        }

        mice.clear();

        if (dosingStudy) {
            for (PDXMouse mouse : mice2) {
                if (mouse.getSocGraph() != 0) {
                    mice.add(mouse);
                }
            }
        } else {
            mice.addAll(mice2);
        }

        mice2.clear();

        if (tumorGrowth) {
            for (PDXMouse mouse : mice) {
                if (mouse.getAssocData() != null && mouse.getAssocData().contains("Tumor")) {
                    mice2.add(mouse);
                }
            }
        } else {
            mice2.addAll(mice);
        }
        mice.clear();

        if (diagnoses != null && diagnoses.size() > 0) {
            for (PDXMouse mouse : mice2) {
                for (String diagnosis : diagnoses) {
                    if ((mouse.getInitialDiagnosis().toLowerCase().indexOf(diagnosis.toLowerCase()) != -1)
                            || (mouse.getClinicalDiagnosis().toLowerCase().indexOf(diagnosis.toLowerCase())) != -1) {
                        mice.add(mouse);
                    }
                }
            }
        } else {
            mice.addAll(mice2);
        }

        mice2.clear();

        if (tumorTypes != null && tumorTypes.size() > 0) {
            for (PDXMouse mouse : mice) {
                for (String tumorType : tumorTypes) {
                    if (mouse.getTumorType().equals(tumorType)) {
                        mice2.add(mouse);
                    }
                }
            }
        } else {
            mice2.addAll(mice);
        }

        mice.clear();

        if (tumorMarkers != null && tumorMarkers.size() > 0) {
            for (PDXMouse mouse : mice2) {
                for (String tumorMarker : tumorMarkers) {
                    if (mouse.getTumorMarkers().indexOf(tumorMarker) != -1) {
                        mice.add(mouse);
                    }
                }
            }
        } else {
            mice.addAll(mice2);
        }
        mice2.clear();

        if (tags != null && tags.size() > 0) {
            for (PDXMouse mouse : mice) {
                for (String tag : tags) {
                    // prevents tags that are substrings of other tags from matching
                    // assumes possibility of multiple tags seperated by a comma (and no space)
                    String paddedTag = "," + mouse.getTag() + ",";
                    if (paddedTag.indexOf("," + tag + ",") != -1) {
                        mice2.add(mouse);
                    }
                }
            }
        } else {
            mice2.addAll(mice);
        }
        mice.clear();

        if (treatmentNaive) {
            for (PDXMouse mouse : mice2) {
                if (mouse.getTreatmentNaive() != null && "Yes".equalsIgnoreCase(mouse.getTreatmentNaive().trim())) {
                    mice.add(mouse);
                }
            }
        } else {
            mice.addAll(mice2);
        }

        mice2.clear();

        if (StringUtils.hasValue(recistDrug) || StringUtils.hasValue(recistResponse)) {
            ArrayList<String> recistIDs = SOCLoader.getRECISTModels(recistDrug, recistResponse);
            for (PDXMouse mouse : mice) {
                if (recistIDs.contains(mouse.getModelID())) {
                    mice2.add(mouse);
                }
            }
        } else {
            mice2.addAll(mice);
        }

        mice.clear();

        // deduplicate
        HashMap<String, PDXMouse> mouseMap = new HashMap();
        for (PDXMouse mouse : mice2) {
            mouseMap.put(mouse.getModelID(), mouse);
        }

        mice.addAll(mouseMap.values());

        return mice;

    }

    // slight misnomer also refreshes models for public search
    public void refreshReports() {
        loadReports();
        try {
            loadData();
        } catch (Exception e) {
            log.error("Unable to load elims PDX search data", e);
        }
    }

    public String getReportFreshnessDate() {
        return reportFreshnessDate.toString().substring(0, reportFreshnessDate.toString().lastIndexOf(":"));
    }

    public String getPDXStatusReport(String delim) {
        return pdxStatusReport;
    }

    public String getPDXEngraftmentStatusSummary(String delimiter) {
        return pdxEngraftmentStatusSummary;
    }

    public String getPDXPatientHistory(String delimiter) {
        return pdxPatientHistory;
    }

    public String getPDXPTClinical(String delimiter) {
        return pdxPTClinical;
    }

    public String getPDXConsortiumReport(String delimiter) {
        return pdxConsortiumReport;
    }

    public String getPDXReportWithNoName() {
        return new ElimsUtil().getPDXReportWithNoName(allMice);
    }

    public ArrayList<ArrayList<String>> getPDXModelStatus() {
        return status;
    }

    public ArrayList<String> getDiagnosesList() {
        return (ArrayList<String>) diagnosesList.clone();
    }

    public ArrayList<String> getPrimarySitesList() {
        return (ArrayList<String>) primarySitesList.clone();
    }

    public ArrayList<String> getTumorMarkersList() {
        return (ArrayList<String>) tumorMarkersList.clone();
    }

    public static ArrayList<String> getTagsList() {
        return tagsList;
    }

    public ArrayList<String> getCTPGenes() {
        return ctpGeneList;
    }

    public String getCTPGenesWebFormat() {
        return ctpGenesWebFormat;
    }

    // why the redundant casting??????
    public ArrayList<LabelValueBean<String, String>> getDiagnosesLVB() {
        return (ArrayList<LabelValueBean<String, String>>) diagnosesLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getPrimarySitesLVB() {
        return (ArrayList<LabelValueBean<String, String>>) primarySitesLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getTumorMarkersLVB() {
        return (ArrayList<LabelValueBean<String, String>>) tumorMarkersLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getTagsLVB() {
        return (ArrayList<LabelValueBean<String, String>>) tagsLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getFusionGenesLVB() {
        return (ArrayList<LabelValueBean<String, String>>) fusionGenesLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getRECISTDrugsLVB() {
        return recistDrugsLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getRECISTResponsesLVB() {
        return recistResponsesLVB;
    }

    public String getAllGenesWebFormat() {
        return allGenesWebFormat;
    }

    // get, add, update and delete methods for additional content types
    // pdx curator methods
    public boolean addLink(PDXLink link) {
        boolean success = true;
        PDXDAO dao = PDXDAO.getInstance();
        try {
            dao.addLink(link);
        } catch (SQLException e) {
            log.error("Could not add link", e);
            success = false;
        }
        return success;
    }

    public boolean updateLink(PDXLink link) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.updateLink(link);
        } catch (SQLException e) {
            log.error("Could not update link", e);
            success = false;
        }
        return success;
    }

    public ArrayList<PDXLink> getLinks(String tumorID) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getLinks(tumorID);
    }

    public PDXLink getLink(int key) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getLink(key);
    }

    public void deleteLink(int contentKey) {
        PDXDAO dao = PDXDAO.getInstance();
        dao.deleteLink(contentKey);

    }

    public boolean addComment(PDXComment comment) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.addComment(comment);
        } catch (SQLException e) {
            log.error("Could not add comment", e);
            success = false;
        }
        return success;

    }

    public boolean updateComment(PDXComment comment) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.updateComment(comment);
        } catch (SQLException e) {
            log.error("Could not update comment", e);
            success = false;
        }
        return success;

    }

    public ArrayList<PDXComment> getComments(String tumorID) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getComments(tumorID);
    }

    public PDXComment getComment(int key) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getComment(key);
    }

    public void deleteComment(int contentKey) {
        PDXDAO dao = PDXDAO.getInstance();
        dao.deleteComment(contentKey);
    }

    public boolean addGraphic(PDXGraphic graphic) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.addGraphic(graphic);
        } catch (SQLException e) {
            log.error("Could not add graphic", e);
            success = false;
        }
        return success;

    }

    public boolean updateGraphic(PDXGraphic graphic) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.updateGraphic(graphic);
        } catch (SQLException e) {
            log.error("Could not update graphic", e);
            success = false;
        }
        return success;

    }

    public ArrayList<PDXGraphic> getGraphics(String tumorID) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getGraphics(tumorID);
    }

    public PDXGraphic getGraphic(int key) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getGraphic(key);
    }

    public void deleteGraphic(int contentKey) {
        PDXDAO dao = PDXDAO.getInstance();
        PDXGraphic g = getGraphic(contentKey);
        deleteFile(g.getFileName());
        dao.deleteGraphic(contentKey);

    }

    public boolean addDocument(PDXDocument doc) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.addDocument(doc);
        } catch (SQLException e) {
            log.error("Could not add document", e);
            success = false;
        }
        return success;

    }

    public boolean updateDocument(PDXDocument doc) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.updateDocument(doc);
        } catch (SQLException e) {
            log.error("Could not update document", e);
            success = false;
        }
        return success;

    }

    public ArrayList<PDXDocument> getDocuments(String tumorID) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getDocuments(tumorID);
    }

    public PDXDocument getDocument(int key) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getDocument(key);
    }

    public void deleteDocument(int contentKey) {
        PDXDAO dao = PDXDAO.getInstance();
        PDXDocument d = getDocument(contentKey);
        deleteFile(d.getFileName());
        dao.deleteDocument(contentKey);

    }

    private void deleteFile(String fileName) {
        File f = new File(WIConstants.getInstance().getPDXFilePath() + fileName);
        f.delete();

    }

    public String getModelExpression(String modelID, boolean useTPM) {

        String valueToGet = "z_score_percentile_rank";
        if (useTPM) {
            valueToGet = "tpm";
        }

        DecimalFormat df = new DecimalFormat("#.##");

        StringBuffer result = new StringBuffer();
        HashMap<String, String> sampleMap = new HashMap();
        HashMap<String, HashMap<String, String>> genes = new HashMap();
        HashMap<String, String> platformMap = new HashMap();
        HashMap<String, String> samplePlatformMap = new HashMap();

        String url = MODEL_EXPRESSION + modelID;

        try {
            JSONObject job = new JSONObject(getJSON(url));
            JSONArray array = (JSONArray) job.get("data");
            for (int i = 0; i < array.length(); i++) {
                JSONObject data = array.getJSONObject(i);

                String sample = data.getString("sample_name") + " " + getField(data,"passage_num");

                String gene = data.getString("gene_symbol");
                String platform = data.getString("platform");
                Double value = data.getDouble(valueToGet);

                if (useTPM) {
                    value = (Math.log(value + 1) / Math.log(2));
                }

                String valueStr = df.format(value);

                platformMap.put(platform, platform);
                sampleMap.put(sample, sample);
                samplePlatformMap.put(sample, platform);
                if (genes.containsKey(gene)) {
                    genes.get(gene).put(sample, valueStr);
                } else {
                    HashMap<String, String> map = new HashMap();
                    map.put(sample, valueStr);
                    genes.put(gene, map);
                }

            }
            ArrayList<String> samples = new ArrayList<String>();
            samples.addAll(sampleMap.keySet());

            Collections.sort(samples);

            ArrayList<String> platforms = new ArrayList<String>();
            platforms.addAll(platformMap.keySet());

            Collections.sort(platforms);
            for (String pform : platforms) {
                if (result.length() > 0) {
                    result.append(", ");
                }
                result.append(pform);
            }
            // build the column definitions gene then one or more samples
            result.append("['Gene'");
            for (String sam : samples) {
                result.append(",'").append(sam).append("',{role:'certainty'}");
            }
            result.append("]");

            // group the expression values by gene across one or more samples
            ArrayList<String> geneList = new ArrayList<String>();
            geneList.addAll(genes.keySet());
            Collections.sort(geneList);
            for (String g : geneList) {
                result.append(",['").append(g).append("'");
                HashMap<String, String> map = genes.get(g);
                for (String sam : samples) {
                    if (map.get(sam) != null) {
                        // affected genes are only for samples from platform RNA_Seq
                        if (AFFECTED_GENES.containsKey(g) && RNA_SEQ.equals(samplePlatformMap.get(sam))) {
                            result.append(",").append(map.get(sam)).append(",false");
                        } else {
                            result.append(",").append(map.get(sam)).append(",true");
                        }
                    } else {
                        result.append(",null,true");
                    }

                }

                result.append("]");

            }

            if (genes.size() == 0) {
                result.delete(0, result.length());
            }

        } catch (Exception e) {
            log.error(e);
        }

        return result.toString();

    }

    public String getModelCNV(String modelID) {

        DecimalFormat df = new DecimalFormat("##.####");

        StringBuffer result = new StringBuffer();

        HashMap<String, String> ploidyMap = new HashMap();
        HashMap<String, HashMap<String, String>> genes = new HashMap();
        try {

            String url = MODEL_CNV + modelID;

            JSONObject job = new JSONObject(getJSON(url));
            JSONArray array = (JSONArray) job.get("data");
            for (int i = 0; i < array.length(); i++) {
                JSONObject data = array.getJSONObject(i);

                String gene = data.getString("gene_symbol");
                String sample = data.getString("sample_name") + " " + getField(data,"passage_num");
                String cn = df.format(data.getDouble("logratio_ploidy"));
                String ploidy = df.format(data.getDouble("ploidy"));

                if (genes.containsKey(gene)) {
                    genes.get(gene).put(sample, cn);
                } else {
                    HashMap map = new HashMap();
                    map.put(sample, cn);
                    genes.put(gene, map);
                }

                ploidyMap.put(sample, ploidy + "");

            }

            ArrayList<String> samples = new ArrayList<String>();
            samples.addAll(ploidyMap.keySet());

            Collections.sort(samples);

            for (String key : ploidyMap.keySet()) {
                result.append(key + ":" + ploidyMap.get(key) + ",");
            }

            result.append("|");

            // build the column definitions gene then one or more samples
            result.append("['Gene'");
            for (String sam : samples) {
                result.append(",'").append(sam).append(" Sample Ploidy:").append(ploidyMap.get(sam)).append("'");
            }
            result.append("]");

            // group the expression values by gene across one or more samples
            ArrayList<String> geneList = new ArrayList();
            geneList.addAll(genes.keySet());
            Collections.sort(geneList);
            for (String g : geneList) {
                result.append(",['").append(g).append("'");
                HashMap<String, String> map = genes.get(g);
                for (String sam : samples) {
                    if (map.get(sam) != null) {
                        result.append(",").append(map.get(sam));
                    } else {
                        result.append(",null");
                    }
                }
                result.append("]");
            }

            if (genes.size() == 0) {
                result.delete(0, result.length());
            }

        } catch (Exception e) {
            log.error(e);
        }
        return result.toString();

    }

    public String getIds() {
        return this.idList;
    }

    public HashMap<String, HashMap<String, ArrayList<String>>> getComparisonData(ArrayList<String> models, ArrayList<String> genes) {

        HashMap<String, HashMap<String, ArrayList<String>>> results = new HashMap<String, HashMap<String, ArrayList<String>>>();

        StringBuffer query = new StringBuffer(GENE_EXPRESSION);

        query.append(DAOUtils.collectionToString(genes, ",", ""));

        // maybe do it for all models then only pick the selected ones
        if (!models.isEmpty() && models.size() < 100) {
            query.append("&model=").append(DAOUtils.collectionToString(models, ",", ""));
        }
        DecimalFormat df = new DecimalFormat("###.##");
        try {

            /* build ampDel map
            for each gene in list query for amp gene -> amp samples
                                  query for del gene -> del samples
            combine
            get(gene).get(model)->amp or del
             */
            HashMap<String, HashMap<String, String>> ampDelMap = new HashMap<>();
            JSONObject job;
            for (String gene : genes) {
                job = new JSONObject(getJSON(CNV_AMP + gene));
                JSONArray array = (JSONArray) job.get("data");
                HashMap<String, String> ad = new HashMap<>();
                for (int i = 0; i < array.length(); i++) {
                    JSONObject data = array.getJSONObject(i);
                    ad.put(data.getString("sample_name"), "Ampilfication");
                }
                job = new JSONObject(getJSON(CNV_DEL + gene));
                array = (JSONArray) job.get("data");
                HashMap<String, String> del = new HashMap<>();
                for (int i = 0; i < array.length(); i++) {
                    JSONObject data = array.getJSONObject(i);
                    ad.put(data.getString("sample_name"), "Deletion");
                }
                ampDelMap.put(gene,ad);
            }
            
            job = new JSONObject(getJSON(query.toString()));
            JSONArray array = (JSONArray) job.get("data");
            for (int i = 0; i < array.length(); i++) {
                JSONObject data = array.getJSONObject(i);
                String model = data.getString("model_name");
                String gene = data.getString("gene_symbol");
                String sample = data.getString("sample_name") + " " + getField(data,"passage_num");

                // this will fail for baylor and dfci models wich should be used
                // to exclude them from the results.
                String rankZ = df.format(data.getDouble("z_score_percentile_rank"));
                String ampDel = "Normal";
                try {
                    ampDel = ampDelMap.get(gene).get(sample);
                } catch (NullPointerException npe) {
                    // its normal
                }
                //1         2           3    4                   5                6
                //"select modelID, sampleName, gene, rankZ as expression, ampDel as cnv, mutation ");
                if (results.containsKey(gene)) {
                    HashMap samples = results.get(gene);
                    ArrayList<String> list = new ArrayList<>();
                    list.add(rankZ);
                    list.add(ampDel);
                    list.add("mutation");
                    samples.put(model + "-" + sample, list);
                } else {
                    HashMap<String, ArrayList<String>> samples = new HashMap<>();
                    ArrayList<String> list = new ArrayList<>();
                    list.add(rankZ);
                    list.add(ampDel);
                    list.add("mutation");
                    samples.put(model + "-" + sample, list);
                    results.put(gene, samples);
                }

            }
        } catch (JSONException e) {
            log.error(e);
        } finally {

        }

        return results;

    }

    public ArrayList<PDXMouse> getMiceByGeneVariant(ArrayList<PDXMouse> mice, String gene, ArrayList<String> variants) {

        ArrayList<PDXMouse> matchingMice = new ArrayList<>();
        StringBuilder ids = new StringBuilder();
        StringBuilder variantList = new StringBuilder();

        for (String variant : variants) {
            variantList.append(variant).append(",");
        }
        StringBuilder params = new StringBuilder();

        params.append("?gene_symbol=").append(gene);
        if (variants != null && variants.size() > 0) {
            params.append("&amino_acid_change=").append(variantList.toString());
        }

        HashMap<String, ArrayList<StringBuilder>> data = new HashMap<>();
        try {
            JSONObject job = new JSONObject(getJSON(VARIANTS + params.toString()));

            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {

                String id = getField(jarray.getJSONObject(i), "model_name");
                String consequence = getField(jarray.getJSONObject(i), "consequence").replace("\"", "");
                String aaChange = getField(jarray.getJSONObject(i), "amino_acid_change");

                ArrayList<StringBuilder> list = data.get(id);
                if (list != null) {
                    // skip duplicates
                    if (list.get(0).indexOf(consequence) == -1) {
                        if (list.get(0).length() > 0) {
                            list.get(0).append(", ");
                        }

                        list.get(0).append(consequence);
                    }

                    // skip duplicates
                    if (list.get(1).indexOf(aaChange) == -1) {
                        if (list.get(1).length() > 0) {
                            list.get(1).append(", ");
                        }

                        list.get(1).append(aaChange);
                    }
                } else {
                    list = new ArrayList<>();
                    list.add(new StringBuilder(consequence));
                    list.add(new StringBuilder(aaChange));
                    data.put(id, list);
                }
            }

            // now for each id in the map get the mouse from mice
            // then add the appropriate conseqeunce and variant
            for (String id : data.keySet()) {
                for (PDXMouse mouse : mice) {
                    if (compareIDs(mouse.getModelID(), id)) {
                        mouse.setConsequence(data.get(id).get(0).toString());
                        mouse.setVariant(data.get(id).get(1).toString());
                        mouse.setGene(gene);
                        matchingMice.add(mouse);
                    }
                }
            }

        } catch (JSONException e) {
            log.error("Error getting mice by gene variants", e);

        }

        return matchingMice;
    }

    public ArrayList<String> getVariants(String gene) {

        String query = VARIANTS_FOR_GENE + gene;
        ArrayList<String> variants = new ArrayList<String>();
        try {
            JSONObject job = new JSONObject(getJSON(query));

            JSONArray array = (JSONArray) job.get("data");

            for (int i = 0; i < array.length(); i++) {
                variants.add(array.getJSONObject(i).getString("amino_acid_change"));
            }
            Collections.sort(variants);

        } catch (Exception e) {
            log.error("Error getting variants for gene " + gene, e);
        }

        return variants;

    }

    public String getVariationData(String model, String limit, String start, String sort, String dir) {

        StringBuffer result = new StringBuffer("{'total':");
        boolean ckbSort = sort.startsWith("ckb_");

        String params = "?keepnulls=yes&model=" + model + "&skip=" + start + "&limit=" + limit + "&sort_by=" + sort + "&sort_dir=" + dir;

        try {

            JSONObject job = new JSONObject(getJSON(VARIANTS + params));

            String total = ((Integer) job.get("total_rows")).toString();
            result.append(total);

            JSONArray array = (JSONArray) job.get("data");

            result.append(",'variation':[ ");

            result.append(getVariantFields(array, ckbSort));

            result.replace(result.length() - 1, result.length(), "]}");

        } catch (Exception e) {
            log.error("Error getting variants for " + model + " from " + VARIANTS + params, e);

            result.append("0,'variation':[ ]}");

        }

        String resultStr = result.toString().replaceAll("null", " ");

        return resultStr;
    }

    // need to paginate results in lots of 150000 so we dont crush the server.
    // only applies to a few models
    public String getCSVVariants(String model) {

        StringBuilder result = new StringBuilder("Model,Sample,Gene,Platform,Chromosome,Seq Position,Ref Allele,Alt Allele,");
        result.append("Consequence,Amino Acid Change,RS Variants,Read Depth,Allele Frequency,Transcript ID,Filtered Rationale,Filter,");
        result.append("Passage Num,CKB Molecular Profile Link, CKB Molecular Profile Name, CKB Gene Link,CKB Potential Treatment Appr,CKB Protein Effect,No. clinical annotations predicting sensitivity,");
        result.append("No. preclinical annotations predicting sensitivity,No. clinical annotations predicting resistance,No. preclinical annotations predicting resistance,");
        result.append("Count Human Reads,PCT Human Reads");

        int start = 0;
        int limit = 15000;
        JSONArray array;
        boolean done = false;

        try {

            do {

                String params = "?keepnulls=yes&model=" + model + "&skip=" + start + "&limit=" + limit;
                JSONObject job = new JSONObject(getJSON(VARIANTS + params));

                int total = (Integer) job.get("total_rows");

                done = (total < start);

                array = (JSONArray) job.get("data");

                result.append("\n ");

                result.append(getVariantFields(array, false).replaceAll("'", "").replaceAll("null", " ").replaceAll("\\[", "").replaceAll("\\],", "\n"));

                start += limit;

            } while (array.length() > 0 || !done);

        } catch (Exception e) {
            log.error("Error getting variants for " + model, e);

        }

        return result.toString();

    }

    private String getVariantFields(JSONArray array, boolean ckbSort) throws JSONException {

        // some ckb annotations are private if a ckb field is used to sort we want the private ones at the end
        // otherwise the sort has gaps where private values are hidden.
        // so stash the private results and append them at the end.
        // will have odd effect over pagination but better than nothing...
        StringBuilder finalResult = new StringBuilder();
        StringBuilder result = new StringBuilder();
        StringBuilder stashedResult = new StringBuilder();

        for (int i = 0; i < array.length(); i++) {
            boolean stash = false;
            result.append("['").append(getField(array.getJSONObject(i), "model_id")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "sample_name")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "gene_symbol")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "platform")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "chromosome")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "seq_position")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ref_allele")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "alt_allele")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "consequence")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "amino_acid_change")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "rs_variants")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "read_depth")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "allele_frequency")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "transcript_id")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "filtered_rationale")).append("',");

            if (!WIConstants.getInstance().getPublicDeployment()) {
                result.append("'").append(getField(array.getJSONObject(i), "filter")).append("',");
            } else {
                result.append("'',");
            }

            result.append("'").append(getField(array.getJSONObject(i), "passage_num")).append("',");
            String ckbGeneID = getField(array.getJSONObject(i), "ckb_gene_id");
            String ckbMolProID = getField(array.getJSONObject(i), "ckb_molpro_id");
            String ckbMolProName = getField(array.getJSONObject(i), "ckb_molpro_name");
            boolean ckbPublic = "public".equals(getField(array.getJSONObject(i), "ckb_public_status"));

            if (WIConstants.getInstance().getPublicDeployment()) {
                if (ckbPublic) {
                    result.append("'").append(CKB_MOLPRO_PUBLIC).append(ckbMolProID).append("',");
                } else {
                    result.append("'',");
                }

                result.append("'").append(ckbMolProName).append("',");

                if (ckbPublic && ckbGeneID.length() > 0 && !ckbGeneID.equals("null")) {
                    result.append("'").append(CKB_GENE_PUBLIC).append(ckbGeneID).append("',");
                } else {
                    result.append("'',");
                }
                result.append("'").append(getField(array.getJSONObject(i), "ckb_potential_treat_approach")).append("',");
                result.append("'").append(getField(array.getJSONObject(i), "ckb_protein_effect")).append("',");

            } else {
                //link to internal site
                if (ckbMolProName.length() > 0 && !ckbMolProName.equals("null")) {
                    result.append("'").append(CKB_MOLPRO_INTERNAL).append(ckbMolProID).append("',");
                    result.append("'").append(ckbMolProName).append("',");
                } else {
                    result.append("'',");
                    result.append("'',");

                }
                if (ckbGeneID.length() > 0 && !ckbGeneID.equals("null")) {
                    result.append("'").append(CKB_GENE_INTERNAL).append(ckbGeneID).append("',");
                } else {
                    result.append("'',");
                }

                result.append("'").append(getField(array.getJSONObject(i), "ckb_potential_treat_approach")).append("',");
                result.append("'").append(getField(array.getJSONObject(i), "ckb_protein_effect")).append("',");

            }

            result.append("'").append(getField(array.getJSONObject(i), "ckb_nclinical_resist")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ckb_nclinical_sens")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ckb_npreclinical_resist")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ckb_npreclinical_sens")).append("',");

            result.append("'").append(getField(array.getJSONObject(i), "count_human_reads")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "pct_human_reads")).append("'],");

            if (stash) {
                stashedResult.append(result);

            } else {
                finalResult.append(result);
            }
            result.delete(0, result.length());
        }

        finalResult.append(stashedResult);
        return finalResult.toString();
    }

    private String getField(JSONObject job, String field) {
        String val = "";
        try {

            val = job.get(field).toString();
            val = val.replaceAll(",", ";");
            val = val.replaceAll("'", "");

        } catch (Exception e) {
            // if the field value is null it may not be included as a field in the json so skip it
            //  log.error("Unable to get value for " + field + " from json object");
        }

        return val;
    }

    private ArrayList<String> getFusionModels(String fusionGenes) {
        ArrayList<String> models = new ArrayList<String>();
        HashMap<String, String> modelsMap = new HashMap();
        try {
            String url = FUSION_MODELS_BY_GENE + fusionGenes;
            JSONObject job = new JSONObject(getJSON(url));
            JSONArray jarray = (JSONArray) job.get("data");
            for (int i = 0; i < jarray.length(); i++) {
                modelsMap.put(jarray.getJSONObject(i).getString("model_name"), jarray.getJSONObject(i).getString("model_name"));
            }

        } catch (Exception e) {
            log.error("Unable to load fusion modles for " + fusionGenes, e);
        }
        models.addAll(modelsMap.keySet());
        return models;
    }

    private void loadFusionGenes() {
        StringBuilder fusionGeneList = new StringBuilder();
        try {
            JSONObject job = new JSONObject(getJSON(FUSION_GENES));
            JSONArray jarray = (JSONArray) job.get("data");
            for (int i = 0; i < jarray.length(); i++) {
                LabelValueBean bean = new LabelValueBean<String, String>();
                bean.setLabel(jarray.getString(i).trim());
                bean.setValue(jarray.getString(i).trim());

                fusionGenesLVB.add(bean);
                fusionGeneList.append(jarray.getString(i).trim()).append(",");
            }

        } catch (Exception e) {
            log.error("Unable to load fusion genes", e);
        }
        loadFusionModels(fusionGeneList.toString());
    }

    private void loadFusionModels(String allFusionGenes) {

        // models have samples, samples have variants 
        HashMap<String, HashMap<String, HashMap<String, String>>> map = new HashMap();

        try {

            JSONObject job = new JSONObject(getJSON(FUSION_MODELS_BY_GENE + allFusionGenes));
            JSONArray jarray = (JSONArray) job.get("data");
            for (int i = 0; i < jarray.length(); i++) {
                try {
                    String model = jarray.getJSONObject(i).getString("model_name");
                    log.error("Fusion model " + model);
                    String sample = jarray.getJSONObject(i).getString("sample_name");
                    String variant = jarray.getJSONObject(i).getString("up_gene") + " - " + jarray.getJSONObject(i).getString("dw_gene");

                    if (map.containsKey(model)) {
                        if (map.get(model).containsKey(sample)) {
                            map.get(model).get(sample).put(variant, variant);
                        } else {
                            HashMap<String, String> variants = new HashMap();
                            variants.put(variant, variant);
                            map.get(model).put(sample, variants);
                        }
                    } else {
                        HashMap<String, HashMap<String, String>> sampleMap = new HashMap();
                        HashMap<String, String> variants = new HashMap();
                        variants.put(variant, variant);
                        sampleMap.put(sample, variants);
                        map.put(model, sampleMap);
                    }
                } catch (Exception e) {
                    // some data objects don't have ckb_varaint
                }
            }
            for (String model : map.keySet()) {
                StringBuilder display = new StringBuilder();
                for (String sample : map.get(model).keySet()) {
                    display.append("Sample ").append(sample).append(" has fusion gene");

                    if (map.get(model).get(sample).keySet().size() > 1) {
                        display.append("s");
                    }
                    for (String variant : map.get(model).get(sample).keySet()) {

                        display.append(" ").append(variant).append(",");
                    }
                    // remove trailing comma
                    display.replace(display.length() - 1, display.length(), "");
                    if (map.get(model).size() > 1) {
                        display.append("<br>");
                    }
                }
                log.error(model + " " + display.toString());

                fusionModelsMap.put(model, display.toString());
            }
        } catch (Exception e) {
            log.error("Unable to load fusion models from" + FUSION_MODELS_BY_GENE + allFusionGenes, e);
        }
    }

    private void loadAllGenes() {

        ArrayList<String> genes = new ArrayList<String>();

        try {
            JSONObject job = new JSONObject(getJSON(ALL_GENES));

            JSONArray array = job.getJSONArray("data");

            for (int i = 0; i < array.length(); i++) {
                if (array.getString(i).trim().length() > 0) {
                    genes.add(array.getString(i));
                }
            }
            Collections.sort(genes);

        } catch (Exception e) {
            log.error("Error getting all genes", e);
        }
        allGenesList = genes;

    }

    private void loadCTPGenes() {

        ArrayList<String> genes = new ArrayList<String>();

        try {
            JSONObject job = new JSONObject(getJSON(ALL_GENES + "?all_ctp_genes=yes"));

            JSONArray array = job.getJSONArray("data");

            for (int i = 0; i < array.length(); i++) {
                if (array.getString(i).trim().length() > 0) {
                    genes.add(array.getString(i));
                }
            }
            Collections.sort(genes);

        } catch (Exception e) {
            log.error("Error getting all genes", e);
        }
        ctpGeneList = genes;

    }

    private void loadCNVPlots() {

        cnvPlots.clear();

        String path = WIConstants.getInstance().getCNVPlotsPath();
        File cnvFile = new File(path);
        for (File file : cnvFile.listFiles()) {
            String name = file.getName();
            String model = file.getName().split("_")[0];
            if (cnvPlots.containsKey(model)) {
                cnvPlots.get(model).add(name);
            } else {
                ArrayList<String> fileNames = new ArrayList<>();
                fileNames.add(name);
                cnvPlots.put(model, fileNames);

            }
        }
        for (ArrayList<String> list : cnvPlots.values()) {
            Collections.sort(list);
        }
    }

    // returns an array list of plot URLs
    public ArrayList<String> getCNVPlotsForModel(String modelID) {
        return cnvPlots.get(modelID);
    }

    /*
    public String getCNVExpression(ArrayList<PDXMouse> mice, String gene) {
        return PDXDAO.getInstance().getCNVExpression(gene, mice);
    }
    
    public String getExpression(ArrayList<PDXMouse> mice, String gene){
        return PDXDAO.getInstance().getExpression(mice, gene);
    }
     */
    /**
     *
     * @param gene String gene name
     * @param mice ArrayList<PDXMouse> all mice from query results
     * @return String to graph expression of gene across all mice
     */
    public String getExpressionGraph(ArrayList<PDXMouse> mice, String gene, boolean cnv) {

        HashMap<String, String> ampDel = new HashMap<>();
        if (cnv) {
            ampDel = getAmpDel(gene);
        }

        DecimalFormat df = new DecimalFormat("#.##");

        StringBuffer result = new StringBuffer();

        StringBuffer mouseIDs = new StringBuffer();
        //batch query at 100 mice
        int i = 0;
        String model, sample, passage, ampDelStr;
        Double rankZ;
        while (i < mice.size()) {

            for (int j = 0; (j < 100) && (i < mice.size()); j++) {
                if (!DANA_FARBER.equals(mice.get(i).getInstitution()) && !BAYLOR.equals(mice.get(i).getInstitution())) {
                    mouseIDs.append(mice.get(i).getModelID()).append(",");
                }
                i++;
            }

            mouseIDs.deleteCharAt(mouseIDs.length() - 1);

            StringBuffer query = new StringBuffer(GENE_EXPRESSION).append(gene);
            query.append("&model=").append(mouseIDs);
            try {

                JSONObject job = new JSONObject(getJSON(query.toString()));

                JSONArray jarray = job.getJSONArray("data");

                for (int k = 0; k < jarray.length(); k++) {
                    model = jarray.getJSONObject(k).getString("model_name");
                    sample = jarray.getJSONObject(k).getString("sample_name");
                    passage = getField(jarray.getJSONObject(k),"passage_num");
                    rankZ = jarray.getJSONObject(k).getDouble("z_score_percentile_rank");

                    if (cnv) {
                        ampDelStr = "Normal";
                        if (ampDel.containsKey(model)) {
                            ampDelStr = ampDel.get(model);
                        }
                        result.append("['" + model + " : " + sample + "'," + df.format(rankZ) + ",'" + model + "','" + ampDelStr + "'],");
                    } else {
                        result.append("['").append(model).append(" : ").append(sample);
                        result.append(" ").append(passage);
                        result.append("',").append(df.format(rankZ)).append(",'").append(model).append("'],");
                    }
                }

            } catch (JSONException e) {
                log.error(e);
            }
        }
        if (result.length() > 0) {
            result.deleteCharAt(result.length() - 1);
        }

        return result.toString();

    }

    private HashMap<String, String> getAmpDel(String gene) {
        //Amplification, Deletion, Normal

        HashMap<String, String> ampDel = new HashMap<>();

        try {

            JSONObject job = new JSONObject(getJSON(CNV_AMP + gene));

            JSONArray jarray = job.getJSONArray("data");

            for (int i = 0; i < jarray.length(); i++) {

                ampDel.put(jarray.getJSONObject(i).getString("model_name"), "Amplification");
            }

            job = new JSONObject(getJSON(CNV_DEL + gene));

            jarray = job.getJSONArray("data");

            for (int i = 0; i < jarray.length(); i++) {

                ampDel.put(jarray.getJSONObject(i).getString("model_name"), "Deletion");
            }

        } catch (JSONException e) {
            log.error(e);
        }
        return ampDel;
    }

    private String getFilterStr() {
        String filterStr = "filter=no";
        if (WIConstants.getInstance().getPublicDeployment()) {
            filterStr = "filter=yes";
        }
        return filterStr;
    }

    private String getJSON(String uri) {
        return getJSON(uri, null);
    }

    private String getJSON(String uri, String json) {

        if (uri.contains("?")) {
            uri = uri + "&" + getFilterStr();
        } else {
            uri = uri + "?" + getFilterStr();
        }

        boolean post = true;
        if (json == null || json.length() == 0) {
            post = false;
        }

        String responseSingle = "";
        StringBuffer response = new StringBuffer();

        HttpURLConnection connection = null;
        try {
            URL url = new URL(uri);
            connection
                    = (HttpURLConnection) url.openConnection();
            if (post) {
                connection.setRequestMethod("POST");
                connection.setDoOutput(true); // sending stuff
            } else {
                connection.setRequestMethod("GET");
            }

            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");

            connection.setDoInput(true); //we want a response
            connection.setUseCaches(false);

            if (post) {
                OutputStream out = connection.getOutputStream();
                try {

                    OutputStreamWriter wr = new OutputStreamWriter(out);
                    wr.write(json.toString());
                    wr.flush();
                    wr.close();
                } catch (IOException e) {

                    log.error("Error writing to webservice " + uri, e);

                } finally {
                    if (out != null) {
                        out.close();
                    }
                }
            }

            // Open a stream which can read the server response
            InputStream in = connection.getInputStream();
            try {
                BufferedReader rd = new BufferedReader(new InputStreamReader(in));
                while ((responseSingle = rd.readLine()) != null) {
                    response.append(responseSingle);
                }
                rd.close(); //close the reader

            } catch (IOException e) {

                log.error("Error reading from webservice " + uri, e);

            } finally {
                if (in != null) {
                    in.close();
                }
            }
        } catch (IOException e) {
            log.error("Error connecting to webservice " + uri, e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return response.toString();

    }
}
