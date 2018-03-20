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
    private static ArrayList<LabelValueBean<String, String>> diagnosesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> primarySitesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> tagsLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> tumorMarkersLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> exomePanelGenesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> fusionGenesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> recistDrugsLVB = new ArrayList<LabelValueBean<String, String>>();
    private static ArrayList<LabelValueBean<String, String>> recistResponsesLVB = new ArrayList<LabelValueBean<String, String>>();
    private static String allGenesWebFormat;
    private static String exomePanelGenesWebFormat;
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
    public static final String[] exomePanelGeneList = {"A1CF", "ABL1", "ACVR1B", "ADAR", "ADARB1", "AFF2", "AICDA", "AKT1", "AKT2", "AKT3", "ALK", "APC", "APOBEC1", "APOBEC2", "APOBEC3A",
        "APOBEC3C", "APOBEC3D", "APOBEC3F", "APOBEC3G", "APOBEC4", "AR", "ARID1A", "ARID1B", "ARID2", "ASH1L", "ASXL1", "ATM", "ATN1", "ATP10B", "ATR", "ATRX", "AURKA", "AURKB",
        "AURKC", "AXIN1", "B2M", "BAP1", "BCL2", "BCOR", "BCR", "BID", "BRAF", "BRCA1", "BRCA2", "BRIP1", "BTK", "CARD11", "CARM1", "CASP8", "CBFB", "CBL", "CCND1", "CCNE1", "CCR2",
        "CDC73", "CDH1", "CDK12", "CDK4", "CDK6", "CDKN1B", "CDKN2A", "CDKN2C", "CEBPA", "CHEK2", "CIC", "CIRBP", "COL18A1", "CREBBP", "CRLF2 (chrX)", "CRLF2 (chrY)", "CSF1R", "CSMD3",
        "CTCF", "CTNNB1", "CXCR4", "CYLD", "DALRD3", "DAXX", "DDIT4", "DDR2", "DICER1", "DNMT1", "DNMT3A", "DNMT3B", "DOT1L", "DROSHA", "DSPP", "EGFR", "EHMT2", "EIF2C1", "EIF2C2",
        "EIF2C3", "EIF2C4", "EP300", "EPHA10", "EPHA3", "EPHA5", "EPHB6", "ERBB2", "ERBB3", "ERBB4", "ESR1", "ETV6", "EZH1", "EZH2", "FAM123B", "FAM166A", "FAT4", "FBXO4", "FBXW7",
        "FER1L5", "FES", "FGFR1", "FGFR2", "FGFR3", "FGFR4", "FLT3", "FOXA1", "FOXL2", "FUBP1", "GATA1", "GATA2", "GATA3", "GLI1", "GLI2", "GLI3", "GLI4", "GNA11", "GNAQ", "GNAS",
        "GPR32", "GPRIN2", "GPS2", "GRIN2A", "H2AFX", "H3F3A", "HAUS5", "HCFC1R1", "HES1", "HES5", "HEY1", "HEY2", "HGF", "HIST1H1C", "HIST1H2BC", "HIST1H3B", "HLA-A", "HMCN1",
        "HNF1A", "HRAS", "HSBP1", "HSF1", "HSF2", "HSF4", "HSP90AA1", "ID1", "ID2", "ID3", "ID4", "IDH1", "IDH2", "IGF1R", "IKZF1", "INHBA", "INO80C", "ITPKB", "JAK1", "JAK2", "JAK3",
        "JMJD1C", "JMJD6", "KCNQ2", "KDM1A", "KDM1B", "KDM2A", "KDM2B", "KDM3A", "KDM3B", "KDM4A", "KDM4B", "KDM4C", "KDM4D", "KDM5A", "KDM5B", "KDM5C", "KDM5D", "KDM6A", "KDM6B",
        "KDR", "KEAP1", "KIT", "KLF4", "KLHL6", "KLRG2", "KRAS", "LATS1", "LATS2", "LLGL2", "LMO1", "LRFN4", "LRP1B", "LTK", "LYSMD3", "MAP2K1", "MAP2K2", "MAP2K4", "MAP2K7", "MAP3K1",
        "MAPK8", "MAPK9", "MDM2", "MDM4", "MED12", "MED23", "MEN1", "MET", "MLH1", "MLL2", "MLL3", "MLLT4", "MPL", "MSH2", "MSH6", "MST1", "MTOR", "MUC16", "MUC17", "MUC4", "MUC5B", "MYB",
        "MYC", "MYCL1", "MYCN", "MYD88", "MYT1L", "NCOA3", "NCOR1", "NEK10", "NF1", "NF2", "NFE2L2", "NKAIN4", "NKX2-1", "NOTCH1", "NOTCH2", "NOTCH3", "NOTCH4", "NPM1", "NRAS", "NSD1",
        "NTRK1", "NTRK2", "NTRK3", "PAK3", "PALB2", "PAX5", "PBRM1", "PD", "PDGFA", "PDGFB", "PDGFRA", "PDGFRB", "PDL1", "PGR", "PHF6", "PIK3CA", "PIK3R1", "PIP4K2C", "PIWIL1", "PLK1",
        "PMS1", "PMS2", "POLB", "POLI", "PPEF1", "PPP2R1A", "PQLC2", "PRDM1", "PRDM14", "PRDM2", "PRDM9", "PRKAA1", "PRKAA2", "PRMT1", "PRMT2", "PRMT3", "PRMT5", "PRMT6", "PRRX1", "PTCH1",
        "PTEN", "PTK2B", "PTPN11", "PTPRD", "PYCRL", "RAD50", "RAD51", "RAD51B", "RAD51C", "RAD51D", "RAD52", "RAD54B", "RAD54L", "RAD54L2", "RAF1", "RASA3", "RASGRF2", "RB1", "RET",
        "RNF43", "ROR2", "ROS1", "RPGR", "RUNX1", "SAAL1", "SCGB1C1", "SETBP1", "SETD2", "SETD7", "SF3B1", "SKP2", "SLC38A3", "SMAD2", "SMAD4", "SMARCA4", "SMARCB1", "SMO", "SMYD3",
        "SOCS1", "SOS1", "SOX9", "SPOP", "SRC", "SRSF2", "STAG2", "STK11", "STK3", "SUV39H1", "TARBP2", "TBL1XR1", "TBP", "TBX3", "TCF7L2", "TEAD1", "TEAD2", "TEAD4", "TET2", "TGFBR2",
        "TLE6", "TMEM82", "TNFAIP3", "TP53", "TP63", "TP73", "TRAF7", "TSC1", "TSHR", "TTC5", "TTN", "U2AF1", "UBC", "USH2A", "VHL", "WHSC1", "WHSC1L1", "WNT7A", "WT1", "WWTR1", "XRCC2",
        "XRCC3", "YAP1", "YES1", "ZFP36L1", "ZMYND19"};

    private static String baseURL = WIConstants.getInstance().getPDXWebservice();

    private static String variationURL = baseURL + "/pdx-variation/";
    private static final String fusionURL = baseURL + "/pdx-fusion/";

    private static final String fusionModels = fusionURL + "models-for-fusion-gene-?.json"; // replace ? with gene
    private static final String fusionGenes = fusionURL + "all-fusion-genes.json";
    private static final String allFusionModels = fusionURL + "all-fusion-models.json";
    private static HashMap<String, String> fusionModelsMap = new HashMap<String, String>();

    private static final String allGenes = "all-genes.json";
    private static final String variantsForGene = "variants-for-gene-?.json";  // replace ? with gene symbol
    private static final String allVariants = "all-variants.json";

    public PDXMouseStore() {

        try {
            if (allMice == null ) {
                synchronized (PDXMouseStore.class) {
                    loadData();
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
        exomePanelGenesLVB.clear();
        fusionGenesLVB.clear();
        recistDrugsLVB.clear();
        recistResponsesLVB.clear();
        

        log.info("NOT loading mice from eLIMS");
    //    ElimsUtil eu = new ElimsUtil();
    //    PDXMouseSearchData searchData = eu.getPDXMouseSearchData();
        PDXMouseSearchData searchData = new PDXMouseSearchData();
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

        for (String gene : exomePanelGeneList) {
            LabelValueBean lvb = new LabelValueBean(gene, gene);
            exomePanelGenesLVB.add(lvb);
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
        loadFusionModels();

        if (allMice != null && allMice.size() > 0) {

            HashMap<String, Integer> socGraphs = SOCLoader.loadSOCModels();
            
            ArrayList<String> recistResponses = SOCLoader.loadRECISTResponses();
            ArrayList<String> recistDrugs = SOCLoader.loadRECISTDrugs();
            
            for(String drug: recistDrugs){
                recistDrugsLVB.add(new LabelValueBean(drug,drug));
            }
            
            for(String response : recistResponses){    
                recistResponsesLVB.add(new LabelValueBean(response,response));
            }

            assocData = PDXDAO.getInstance().getPDXAdditionalContent();
            for (PDXMouse mouse : allMice) {

                if (socGraphs.containsKey(mouse.getModelID())) {
                    mouse.setSocGraph(socGraphs.get(mouse.getModelID()));
                }
                mouse.setAssocData(assocData.get(mouse.getModelID()));
                String id = mouse.getModelID();
                Integer num = null;
                if (id.startsWith("TM")) {
                    id = id.substring(2);
                    num = new Integer(id).intValue();
                }
                if (id.startsWith("J")) {
                    id = id.substring(1);
                    num = new Integer(id).intValue();
                }
                if (num == null) {
                    log.error("model id " + id + " cant be parsed into an integer");
                }

                if (fusionModelsMap.get(num.toString()) != null) {
                    mouse.setFusionGenes(fusionModelsMap.get(num.toString()));

                }

                //   mouseMap.put(num,mouse);
            }
            log.info("Loading genes from webservice.");
            getAllGenes();

            StringBuffer genesBuffer = new StringBuffer();
            genesBuffer.append("[");

            for (String gene : allGenesList) {
                genesBuffer.append("[\"").append(gene).append("\",\"").append(gene).append("\"],");

            }
            genesBuffer.replace(genesBuffer.length() - 1, genesBuffer.length(), "]");

            allGenesWebFormat = genesBuffer.toString();

            log.info("Loaded " + allGenesList.size() + " genes.");
            genesBuffer = new StringBuffer();

            genesBuffer.append("[");

            for (String gene : exomePanelGeneList) {
                if (genesBuffer.length() > 1) {
                    genesBuffer.append(",");
                }
                genesBuffer.append("['" + gene + "']");

            }
            genesBuffer.append("]");
            exomePanelGenesWebFormat = genesBuffer.toString();
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
            ArrayList<String> genes, ArrayList<String> variants, boolean dosingStudy, 
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

        if (genes != null && genes.size() > 0 && genes.get(0).trim().length() > 0) {
            mice2 = getMiceByGeneVariant(mice2, genes, variants);
        }

        return mice2;
    }

    private boolean compareIDs(String display, String numeric) {
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
            ArrayList<String> diagnoses,ArrayList<String> tumorTypes, ArrayList<String> tumorMarkers, 
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
        
        if(StringUtils.hasValue(recistDrug) || StringUtils.hasValue(recistResponse)){
            ArrayList<String> recistIDs = SOCLoader.getRECISTModels(recistDrug,recistResponse);
            for(PDXMouse mouse : mice){
                if(recistIDs.contains(mouse.getModelID())){
                    mice2.add(mouse);
                }
            }
        }else{
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
    
    public String getPDXReportWithNoName(){
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

    public ArrayList<String> getExomePanelGenes() {
        ArrayList<String> genes = new ArrayList<String>(Arrays.asList(exomePanelGeneList));
        return genes;
    }

    public String getExomePanelGenesWebFormat() {
        return exomePanelGenesWebFormat;
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

    public ArrayList<LabelValueBean<String, String>> getExomePanelGenesLVB() {
        return (ArrayList<LabelValueBean<String, String>>) exomePanelGenesLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getFusionGenesLVB() {
        return (ArrayList<LabelValueBean<String, String>>) fusionGenesLVB;
    }
    
    public ArrayList<LabelValueBean<String, String>> getRECISTDrugsLVB() {
        return  recistDrugsLVB;
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

    public String getModelExpression(String modelID) {
        String data = PDXDAO.getInstance().getModelExpression(modelID);
        return data;

    }
    public String getModelTPM(String modelID) {
        String data = PDXDAO.getInstance().getModelTPM(modelID);
        return data;

    }

    public String getModelCNV(String modelID) {
        String data = PDXDAO.getInstance().getModelCNV(modelID);
        return data;

    }

    public String getExpression(String gene, ArrayList<PDXMouse> mice) {
        return PDXDAO.getInstance().getExpression(gene, mice);
    }

    public String getIds() {
        return this.idList;
    }

    public HashMap<String, HashMap<String, ArrayList<String>>> getComparisonData(ArrayList<String> models, ArrayList<String> genes) {
        return PDXDAO.getInstance().getComparisonData(models, genes);
    }
    
    
   
    private ArrayList<PDXMouse> getMiceByGeneVariant(ArrayList<PDXMouse> mice, ArrayList<String> genes, ArrayList<String> variants) {

        // turn model ids into an array of ints
        // use the all-variants.json service to return all matching models
        // populate matching models with gene, 
        // if variants then populate consequence
        ArrayList<PDXMouse> matchingMice = new ArrayList<>();
        JSONArray jsonIds = new JSONArray();
        for (PDXMouse m : mice) {
            String id = m.getModelID().substring(2);
            Integer idInt = new Integer(id);
            jsonIds.put(idInt.toString());

        }
        JSONArray jsonGenes = new JSONArray(genes);
        JSONArray jsonVariants = new JSONArray(variants);
        StringBuilder params = new StringBuilder();

        params.append("{\"model\":").append(jsonIds.toString()).append(",\"gene_symbol\":").append(jsonGenes.toString());
        if (variants != null && variants.size() > 0) {
            params.append(",\"amino_acid_change\":").append(jsonVariants.toString());
        }

        String filter = "FALSE";
        if (WIConstants.getInstance().getPublicDeployment()) {
            filter = "TRUE";
        }
        params.append(",\"skip\": \"0\", \"limit\": \"-1\", \"sort_by\": \"consequence\", \"sort_dir\": \"DESC\", \"filter\": \"");
        params.append(filter).append("\"}");

        // need to turn the json in to a map key of model id
        // values variants, consequences
        HashMap<String, ArrayList<StringBuilder>> data = new HashMap<>();
        try {
            JSONObject job = new JSONObject("{\"data\":" + getJSON(variationURL + allVariants, params.toString()) + "}");

            JSONArray jarray = ((JSONObject) job.get("data")).getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {

                String id = getField(jarray.getJSONObject(i), "model_id");
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
                    if (compareIDs(mouse.getModelID(),id)) {
                        mouse.setConsequence(data.get(id).get(0).toString());
                        mouse.setVariant(data.get(id).get(1).toString());
                        mouse.setGene(genes.get(0));
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

        String query = variantsForGene.replace("?", gene);
        ArrayList<String> variants = new ArrayList<String>();
        try {
            JSONObject job = new JSONObject("{\"data\":" + getJSON(variationURL + query) + "}");

            JSONArray array = (JSONArray) job.get("data");

            for (int i = 0; i < array.length(); i++) {
                variants.add(array.getString(i));
            }
            Collections.sort(variants);

        } catch (Exception e) {
            log.error("Error getting variants for gene " + gene, e);
        }

        return variants;

    }

    public String getVariationData(String model, String limit, String start, String sort, String dir, String filter) {

        String params = "{\"model\":[\"" + model + "\"],\"skip\": \"" + start + "\", \"limit\": \"" + limit + "\", \"sort_by\": \"" + sort + "\", \"sort_dir\": \"" + dir + "\", \"filter\": \"" + filter + "\"}";

        StringBuffer result = new StringBuffer("{'total':");
        try {

            JSONObject job = new JSONObject("{\"data\":" + getJSON(variationURL + allVariants, params) + "}");

            job = (JSONObject) job.get("data");

            String total = ((Integer) job.get("total_rows")).toString();
            result.append(total);

            JSONArray array = (JSONArray) job.get("data");

            result.append(",'variation':[ ");

            result.append(getVariantFields(array));

            result.replace(result.length() - 1, result.length(), "]}");

        } catch (Exception e) {
            log.error("Error getting variants for " + model, e);

        }

        String resultStr = result.toString().replaceAll("null", " ");

        return resultStr;
    }

    
    // need to paginate results in lots of 150000 so we dont crush the server.
    // only applies to a few models
    public String getCSVVariants(String model) {

        String filter = "FALSE";

        if (WIConstants.getInstance().getPublicDeployment()) {
            filter = "TRUE";
        }

        StringBuilder result = new StringBuilder("Model,Sample,Gene,Platform,Chromosome,Seq Position,Ref Allele,Alt Allele,");
        result.append("Consequence,Amino Acid Change,RS Variants,Read Depth,Allele Frequency,Transcript ID,Filtered Rationale,");
        result.append("Passage Num,Gene ID,CKB Evidence,Actionable Cancer Types,Drug Class,Count Human Reads,PCT Human Reads,");
        result.append("Variant Num Trials,Variant NCT IDs\n");

        int start = 0;
        int limit = 150000;
        JSONArray array;
        boolean done = false;

        try {

            do {

                String params = "{\"model\":[\"" + model + "\"],\"skip\": \"" + start + "\", \"limit\": \"" + limit + "\", \"sort_by\": \"gene_symbol\", \"sort_dir\": \"ASC\", \"filter\": \"" + filter + "\"}";

                JSONObject job = new JSONObject("{\"data\":" + getJSON(variationURL + allVariants, params) + "}");

                job = (JSONObject) job.get("data");

                int total = (Integer) job.get("total_rows");

                done = (total < start);

                array = (JSONArray) job.get("data");

                result.append("\n ");

                result.append(getVariantFields(array).replaceAll("'", "").replaceAll("null", " ").replaceAll("\\[", "").replaceAll("\\],", "\n"));

                start += limit;

            } while (array.length() > 0 || !done);

        } catch (Exception e) {
            log.error("Error getting variants for " + model, e);

        }

        return result.toString();

    }

    private String getVariantFields(JSONArray array) throws JSONException {
        StringBuilder result = new StringBuilder();

        for (int i = 0; i < array.length(); i++) {

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
            result.append("'").append(getField(array.getJSONObject(i), "passage_num")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "gene_id")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ckb_evidence_types")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "cancer_types_actionable")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "drug_class")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "count_human_reads")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "pct_human_reads")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "variant_num_trials")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "variant_nct_ids")).append("'],");

        }
        return result.toString();
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

    // example response
    //{"genes":[{"gene":"ALK","models":[{"model":"206","samples":[{"sample":"LG0812PE1330P0_206","fusions":["EML4 - ALK"]},{"sample":"LG0812PE1332P0_206","fusions":["EML4 - ALK"]}]}]}]}
    private ArrayList<String> getFusionModels(String fusionGenes) {
        ArrayList<String> models = new ArrayList<String>();
        try {
            String url = this.fusionModels.replace("?", fusionGenes);
            JSONObject job = new JSONObject(getJSON(url));
            JSONArray jarray = (JSONArray) job.get("genes");
            job = jarray.getJSONObject(0);
            jarray = job.getJSONArray("models");
            for (int i = 0; i < jarray.length(); i++) {
                models.add(jarray.getJSONObject(i).getString("model"));
            }

        } catch (Exception e) {
            log.error("Unable to load fusion modles for " + fusionGenes, e);
        }

        return models;
    }

    private void loadFusionModels() {

        try {

            JSONObject job = new JSONObject(getJSON(allFusionModels));
            JSONArray jarray = (JSONArray) job.get("models");
            for (int i = 0; i < jarray.length(); i++) {
                String model = jarray.getJSONObject(i).getString("model");
                StringBuilder value = new StringBuilder();
                JSONArray samples = jarray.getJSONObject(i).getJSONArray("samples");
                for (int j = 0; j < samples.length(); j++) {
                    value.append("Sample ").append(samples.getJSONObject(j).getString("sample"));
                    value.append(" has fusion gene");
                    JSONArray fusions = samples.getJSONObject(j).getJSONArray("fusions");
                    if (fusions.length() > 1) {
                        value.append("s ");
                    } else {
                        value.append(" ");
                    }
                    for (int k = 0; k < fusions.length(); k++) {
                        if (k > 0) {
                            value.append(", ");
                        }
                        value.append(fusions.get(k));
                    }
                    // oh the horror HTML
                    value.append("<br>");
                }
                
                fusionModelsMap.put(model, value.toString());
            }
        } catch (Exception e) {
            log.error("Unable to load fusion models", e);
        }
    }

    private void loadFusionGenes() {
        try {
            JSONObject job = new JSONObject(getJSON(this.fusionGenes));
            JSONArray jarray = (JSONArray) job.get("fusion_genes");
            for (int i = 0; i < jarray.length(); i++) {
                LabelValueBean bean = new LabelValueBean<String, String>();
                bean.setLabel(jarray.getString(i).trim());
                bean.setValue(jarray.getString(i).trim());

                fusionGenesLVB.add(bean);
            }

        } catch (Exception e) {
            log.error("Unable to load fusion genes", e);
        }
    }

    // this is slow and should be done once on load.
    private void getAllGenes() {

        ArrayList<String> genes = new ArrayList<String>();

        try {
            JSONObject job = new JSONObject("{\"data\":" + getJSON(variationURL + allGenes) + "}");

            JSONArray array = (JSONArray) job.get("data");

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

    public String getCNVExpression(ArrayList<PDXMouse> mice, String gene) {
        return PDXDAO.getInstance().getCNVExpression(gene, mice);
    }

    private String getJSON(String uri) {
        return getJSON(uri, null);
    }

    private String getJSON(String uri, String json) {

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
