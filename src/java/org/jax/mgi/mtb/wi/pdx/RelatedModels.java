/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.util.HashMap;

/**
 *
 * @author sbn
 */
public class RelatedModels {
    
    private static HashMap<String,String> relations = new HashMap<>();
    
    private static void load(){
        relations.put("TM00233","PDX models TM00233 and <a href='pdxDetails.do?modelID=TM01357' target='_blank'>TM01357</a> originated from the same patient.");

        relations.put("TM01357","PDX models <a href='pdxDetails.do?modelID=TM00233' target='_blank'>TM00233</a> and TM01357 originated from the same patient.");

        relations.put("TM01617","PDX models TM01617, <a href='pdxDetails.do?modelID=TM01618' target='_blank'>TM01618</a> and <a href='pdxDetails.do?modelID=TM01619' target='_blank'>TM01619</a> originated from the same patient.");

        relations.put("TM01618","PDX models <a href='pdxDetails.do?modelID=TM01617' target='_blank'>TM01617</a>, TM01618 and <a href='pdxDetails.do?modelID=TM01619' target='_blank'>TM01619</a> originated from the same patient.");

        relations.put("TM01619","PDX models <a href='pdxDetails.do?modelID=TM01617' target='_blank'>TM01617</a>, <a href='pdxDetails.do?modelID=TM01618' target='_blank'>TM01618</a> and TM01619 originated from the same patient.");

        relations.put("J000077591","PDX models J000077591, <a href='pdxDetails.do?modelID=J000077608' target='_blank'>J000077608</a> and <a href='pdxDetails.do?modelID=J000077636' target='_blank'>J000077636</a> originated from the same patient.");

        relations.put("J000077608","PDX models <a href='pdxDetails.do?modelID=J000077591' target='_blank'>J000077591</a>, J000077608 and <a href='pdxDetails.do?modelID=J000077636' target='_blank'>J000077636</a> originated from the same patient.");

        relations.put("J000077636","PDX models <a href='pdxDetails.do?modelID=J000077591' target='_blank'>J000077591</a>, <a href='pdxDetails.do?modelID=J000077608' target='_blank'>J000077608</a> and J000077636 originated from the same patient.");

        relations.put("J000077960","PDX models J000077960 and <a href='pdxDetails.do?modelID=J000077973' target='_blank'>J000077973</a> originated from the same patient.");

        relations.put("J000077973","PDX models <a href='pdxDetails.do?modelID=J000077960' target='_blank'>J000077960</a> and J000077973 originated from the same patient.");

        relations.put("J000101005","PDX models J000101005 and <a href='pdxDetails.do?modelID=J000101006' target='_blank'>J000101006</a> originated from the same patient.");

        relations.put("J000101006","PDX models <a href='pdxDetails.do?modelID=J000101005' target='_blank'>J000101005</a> and J000101006 originated from the same patient.");

        relations.put("J000101173","PDX models J000101173 and <a href='pdxDetails.do?modelID=J000103634' target='_blank'>J000103634</a> originated from the same patient.");

        relations.put("J000103634","PDX models <a href='pdxDetails.do?modelID=J000101173' target='_blank'>J000101173</a> and J000103634 originated from the same patient.");

        relations.put("J000101328","PDX models J000101328 and <a href='pdxDetails.do?modelID=J000101329' target='_blank'>J000101329</a> originated from the same patient.");

        relations.put("J000101329","PDX models <a href='pdxDetails.do?modelID=J000101328' target='_blank'>J000101328</a> and J000101329 originated from the same patient.");
    }
    
    
    public static String getReleationLabel(String modelID){
        if(relations.size()==0){
            System.out.println("loading PDX relations");
            load();
        }
        return relations.get(modelID);
    }
}
