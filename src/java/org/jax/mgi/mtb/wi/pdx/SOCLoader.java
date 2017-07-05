/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import org.apache.log4j.Logger;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 *
 * @author sbn
 * Query the SOC sqllite database for a list of PDX models that have SOC graphs.
 */
public class SOCLoader {
    
      private static final Logger log
            = Logger.getLogger(SOCLoader.class.getName());

  

    public static HashMap<String,Integer> loadSOCModels() {

        String path = WIConstants.getInstance().getSOCDB();
        HashMap<String,Integer> models = new HashMap<>();

        try {
            Connection liteCon = null;
            Class.forName("org.sqlite.JDBC");
            liteCon = DriverManager.getConnection("jdbc:sqlite:/" + path);

            Statement stmt = liteCon.createStatement();
            ResultSet rs = stmt.executeQuery("select model_TM, count(*) from studies group by model_TM");
            while (rs.next()) {
                models.put(rs.getString(1),rs.getInt(2));
                
            }
        } catch (Exception e) {
            log.error("Unable to load SOC model data",e);
        }

        return models;
    }
}
