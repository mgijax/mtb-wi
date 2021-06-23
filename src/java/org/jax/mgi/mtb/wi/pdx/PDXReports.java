/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.util.ArrayList;
import java.util.Date;
import org.apache.log4j.Logger;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 *
 * @author sbn
 */
public class PDXReports {

    private static String pdxEngraftmentStatusSummary = "The PDX Customer report could not be loaded;";
    private static String pdxPatientHistory = "The PDX Patient History report could not be loaded";
    private static String pdxPTClinical = "The PDX Patient Clinical report could not be loaded";
    private static String pdxStatusReport = "The PDX Status report could not be loaded";
    private static String pdxActiveModelSummary = "The PDX Active Model Summary could not be loaded";
    private static String pdxConsortiumReport = "The PDX Consortium report could not be loaded";
    private static Date reportFreshnessDate = null;
    private static ArrayList<ArrayList<String>> status = new ArrayList<>();

    private static final Logger log
            = Logger.getLogger(PDXReports.class.getName());

    
    private static PDXReports singleton;
    
    private PDXReports(){
            loadReports();
    }
    
     public static PDXReports getInstance() {
        if (singleton == null) {
            singleton = new PDXReports();
        }
        return singleton;
    }
    
    public void refresh(){
        status = null;
        singleton = new PDXReports();
    }

    public String getReportFreshnessDate() {
        return reportFreshnessDate.toString().substring(0, reportFreshnessDate.toString().lastIndexOf(":"));
    }

    public String getPDXStatusReport(String delim) {
        return pdxStatusReport;
    }
    
    public String getPDXActiveModelSummary(String delim) {
        return pdxActiveModelSummary;
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

    

    public ArrayList<ArrayList<String>> getPDXModelStatus() {
        return status;
    }
    
    
    /**
     * Pre load reports for dashboard, small but may take a few minutes to load
     * Can be reloaded by refresh button on dashboard
     */
    
    
    
    private void loadReports() {

        if (!WIConstants.getInstance().getPublicDeployment()) {
            if (status == null || status.isEmpty()) {

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
                log.info(d + " Loading Active Model Summary");
                temp = eu.getPDXActiveModelSummary();
                if (temp.length() > 0) {
                    pdxActiveModelSummary = temp;
                } else {
                    log.error("PDX Active Model Summary not loaded!");
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
        }
    }

}
