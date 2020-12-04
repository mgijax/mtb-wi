/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import org.apache.log4j.Logger;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 *
 * @author sbn Query the SOC sqllite database for a list of PDX models that have
 * SOC graphs.
 */
public class SOCLoader {

    private static final Logger log
            = Logger.getLogger(SOCLoader.class.getName());

    public static HashMap<String, Integer> loadSOCModels() {

        String path = WIConstants.getInstance().getSOCDB();
        HashMap<String, Integer> models = new HashMap<>();

        try {
            Connection liteCon = null;
            Class.forName("org.sqlite.JDBC");
            liteCon = DriverManager.getConnection("jdbc:sqlite:/" + path);

            Statement stmt = liteCon.createStatement();
            ResultSet rs = stmt.executeQuery("select model_TM, count(*) from studies group by model_TM");
            while (rs.next()) {
                models.put(rs.getString(1), rs.getInt(2));

            }
            log.error("Loaded " + models.size() + " pdx model with SOC data.");
        } catch (Exception e) {
            log.error("Unable to load SOC model data", e);
        }

        

        return models;
    }

    /**
     * Drug -> Response -> list of models
     *
     * @return
     */
    public static ArrayList<String> getRECISTModels(String drug, String response) {

        String path = WIConstants.getInstance().getSOCDB();
        ArrayList<String> models = new ArrayList<>();

        try {

            Connection liteCon = null;
            Class.forName("org.sqlite.JDBC");
            liteCon = DriverManager.getConnection("jdbc:sqlite:/" + path);

            StringBuilder sql = new StringBuilder("SELECT distinct s.model_TM from groups g, studies s where g.study_number = s.study_number ");
            if (drug != null && drug.trim().length() > 0) {
                sql.append("and g.drug = ?");
            }
            if (response != null && response.trim().length() > 0) {
                sql.append("and g.recist= ?");
            }

            PreparedStatement stmt = liteCon.prepareStatement(sql.toString());
            int index = 1;

            if (drug != null && drug.trim().length() > 0) {
                stmt.setString(index++, drug);
            }
            if (response != null && response.trim().length() > 0) {
                stmt.setString(index++, response);
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                models.add(rs.getString(1));
            }

        } catch (Exception e) {
            log.error("Unable to load SOC recist model data", e);
        }

        return models;
    }

    public static ArrayList<String> loadRECISTResponses() {

        String path = WIConstants.getInstance().getSOCDB();
        ArrayList<String> response = new ArrayList<>();

        try {
            Connection liteCon = null;
            Class.forName("org.sqlite.JDBC");
            liteCon = DriverManager.getConnection("jdbc:sqlite:/" + path);

            Statement stmt = liteCon.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT distinct recist from groups order by recist");
            while (rs.next()) {
                response.add(rs.getString(1));

            }
        } catch (Exception e) {
            log.error("Unable to load SOC recist response data", e);
        }

        return response;
    }

    public static ArrayList<String> loadRECISTDrugs() {

        String path = WIConstants.getInstance().getSOCDB();
        ArrayList<String> response = new ArrayList<>();

        try {
            Connection liteCon = null;
            Class.forName("org.sqlite.JDBC");
            liteCon = DriverManager.getConnection("jdbc:sqlite:/" + path);

            Statement stmt = liteCon.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT distinct drug from groups where drug != \"None\" order by drug ");
            while (rs.next()) {
                response.add(rs.getString(1));

            }
        } catch (Exception e) {
            log.error("Unable to load SOC recist drug data", e);
        }

        return response;
    }

    /**
     * For all models with RECIST data return a mapping modelId -> list of pairs
     * of drug, response
     *
     * @ return HashMap<String,ArrayList<ArrayList<String>>>
     */
    public static HashMap<String, ArrayList<ArrayList<String>>> getRECISTMap() {

        String path = WIConstants.getInstance().getSOCDB();
        HashMap<String, ArrayList<ArrayList<String>>> modelsMap = new HashMap<>();
        try {

            Connection liteCon = null;
            Class.forName("org.sqlite.JDBC");
            liteCon = DriverManager.getConnection("jdbc:sqlite:/" + path);

            String sql = "SELECT distinct s.model_TM, g.drug, g.recist from groups g, studies s where g.study_number = s.study_number ";
            PreparedStatement stmt = liteCon.prepareStatement(sql);

            ResultSet rs = stmt.executeQuery();
            String id;
            while (rs.next()) {
                id = rs.getString(1);
                ArrayList<String> pair = new ArrayList<>();
                pair.add(rs.getString(2));
                pair.add(rs.getString(3));
                if (modelsMap.containsKey(id)) {
                    modelsMap.get(id).add(pair);
                } else {
                    ArrayList<ArrayList<String>> list = new ArrayList<>();
                    list.add(pair);
                    modelsMap.put(id, list);
                }

            }

        } catch (Exception e) {
            log.error("Unable to load SOC recist model data", e);
        }

        return modelsMap;
    }
}
