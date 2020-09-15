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

    private static HashMap<String, String> relations = new HashMap<>();
    private static HashMap<String, String> proxeIds = new HashMap<>();

    private static void load() {
        relations.put("TM00233", "PDX models TM00233 and <a href='pdxDetails.do?modelID=TM01357' target='_blank'>TM01357</a> originated from the same patient.");

        relations.put("TM01357", "PDX models <a href='pdxDetails.do?modelID=TM00233' target='_blank'>TM00233</a> and TM01357 originated from the same patient.");

        relations.put("TM01617", "PDX models TM01617, <a href='pdxDetails.do?modelID=TM01618' target='_blank'>TM01618</a> and <a href='pdxDetails.do?modelID=TM01619' target='_blank'>TM01619</a> originated from the same patient.");

        relations.put("TM01618", "PDX models <a href='pdxDetails.do?modelID=TM01617' target='_blank'>TM01617</a>, TM01618 and <a href='pdxDetails.do?modelID=TM01619' target='_blank'>TM01619</a> originated from the same patient.");

        relations.put("TM01619", "PDX models <a href='pdxDetails.do?modelID=TM01617' target='_blank'>TM01617</a>, <a href='pdxDetails.do?modelID=TM01618' target='_blank'>TM01618</a> and TM01619 originated from the same patient.");

        relations.put("J000077591", "PDX models J000077591, <a href='pdxDetails.do?modelID=J000077608' target='_blank'>J000077608</a> and <a href='pdxDetails.do?modelID=J000077636' target='_blank'>J000077636</a> originated from the same patient.");

        relations.put("J000077608", "PDX models <a href='pdxDetails.do?modelID=J000077591' target='_blank'>J000077591</a>, J000077608 and <a href='pdxDetails.do?modelID=J000077636' target='_blank'>J000077636</a> originated from the same patient.");

        relations.put("J000077636", "PDX models <a href='pdxDetails.do?modelID=J000077591' target='_blank'>J000077591</a>, <a href='pdxDetails.do?modelID=J000077608' target='_blank'>J000077608</a> and J000077636 originated from the same patient.");

        relations.put("J000077960", "PDX models J000077960 and <a href='pdxDetails.do?modelID=J000077973' target='_blank'>J000077973</a> originated from the same patient.");

        relations.put("J000077973", "PDX models <a href='pdxDetails.do?modelID=J000077960' target='_blank'>J000077960</a> and J000077973 originated from the same patient.");

        relations.put("J000101005", "PDX models J000101005 and <a href='pdxDetails.do?modelID=J000101006' target='_blank'>J000101006</a> originated from the same patient.");

        relations.put("J000101006", "PDX models <a href='pdxDetails.do?modelID=J000101005' target='_blank'>J000101005</a> and J000101006 originated from the same patient.");

        relations.put("J000101173", "PDX models J000101173 and <a href='pdxDetails.do?modelID=J000103634' target='_blank'>J000103634</a> originated from the same patient.");

        relations.put("J000103634", "PDX models <a href='pdxDetails.do?modelID=J000101173' target='_blank'>J000101173</a> and J000103634 originated from the same patient.");

        relations.put("J000101328", "PDX models J000101328 and <a href='pdxDetails.do?modelID=J000101329' target='_blank'>J000101329</a> originated from the same patient.");

        relations.put("J000101329", "PDX models <a href='pdxDetails.do?modelID=J000101328' target='_blank'>J000101328</a> and J000101329 originated from the same patient.");
        
        relations.put("TM01044", "PDX models TM01044 and <a href='pdxDetails.do?modelID=TM01045' target='_blank'>TM01045</a> originated from the same patient.");
        
        relations.put("TM01045", "PDX models <a href='pdxDetails.do?modelID=TM01044' target='_blank'>TM01044</a> and TM01045 originated from the same patient.");
        
        relations.put("TM00914", "PDX models TM00914 and <a href='pdxDetails.do?modelID=TM00916' target='_blank'>TM00916</a> originated from the same patient.");
        
        relations.put("TM00916", "PDX models <a href='pdxDetails.do?modelID=TM00914' target='_blank'>TM00914</a> and TM00916 originated from the same patient.");
        
        relations.put("TM01168", "PDX models TM01168 and <a href='pdxDetails.do?modelID=TM01171' target='_blank'>TM01171</a> originated from the same patient.");
        
        relations.put("TM01171", "PDX models <a href='pdxDetails.do?modelID=TM01168' target='_blank'>TM01168</a> and TM01171 originated from the same patient.");
        
        relations.put("TM00222", "PDX models TM00222 and <a href='pdxDetails.do?modelID=TM00302' target='_blank'>TM00302</a> originated from the same patient.");
        
        relations.put("TM00302", "PDX models <a href='pdxDetails.do?modelID=TM00222' target='_blank'>TM00222</a> and TM00302 originated from the same patient.");
        
        relations.put("TM01075", "PDX models TM01075 and <a href='pdxDetails.do?modelID=TM01076' target='_blank'>TM01076</a> originated from the same patient.");
        
        relations.put("TM01076", "PDX models <a href='pdxDetails.do?modelID=TM01075' target='_blank'>TM01075</a> and TM01076 originated from the same patient.");
        
        relations.put("TM00913", "PDX models TM00913, <a href='pdxDetails.do?modelID=TM00914' target='_blank'>TM00914</a> and <a href='pdxDetails.do?modelID=TM00916' target='_blank'>TM00916</a> originated from the same patient.");
        
        relations.put("TM00914", "PDX models TM00914, <a href='pdxDetails.do?modelID=TM00913' target='_blank'>TM00913</a> and <a href='pdxDetails.do?modelID=TM00916' target='_blank'>TM00916</a> originated from the same patient.");
        
        relations.put("TM00916", "PDX models TM00916, <a href='pdxDetails.do?modelID=TM00913' target='_blank'>TM00913</a> and <a href='pdxDetails.do?modelID=TM00914' target='_blank'>TM00914</a> originated from the same patient.");
        
        relations.put("TM01096", "PDX models TM01096 and <a href='pdxDetails.do?modelID=TM01098' target='_blank'>TM01098</a> originated from the same patient.");
        
        relations.put("TM01098", "PDX models <a href='pdxDetails.do?modelID=TM01096' target='_blank'>TM01096</a> and TM01098 originated from the same patient.");
        
        

        proxeIds.put("J000106568", "DFBL-75549-R2");
        proxeIds.put("J000106569", "DFAM-61345-V1");
        proxeIds.put("J000106566", "DFAM-32000-V1");
        proxeIds.put("J000106564", "DFAB-90079-V0");
        proxeIds.put("J000106565", "DFAM-16835-V1");
        proxeIds.put("J000106562", "DFAB-56509-V0");
        proxeIds.put("J000106563", "DFAB-82788-V0");
        proxeIds.put("J000106571", "DFBL-44685-V1");
        proxeIds.put("J000106572", "DFTL-69579-V3-mCLP");
        proxeIds.put("J000106573", "DFTL-94393-V4");
        proxeIds.put("J000106542", "DFAB-10746-V1");
        proxeIds.put("J000106543", "DFAB-13653-V1");
        proxeIds.put("J000106541", "DFAL-34953-V1");
        proxeIds.put("J000106561", "DFAB-39722-V1");
        proxeIds.put("J000106146", "DFMD-76960-V2");
        proxeIds.put("J000106144", "DFAT-72032-V1");
        proxeIds.put("J000106145", "DFBL-20954-V2");
        proxeIds.put("J000106124", "DFAM-15354-V2");
        proxeIds.put("J000106125", "DFAM-22318-V1");
        proxeIds.put("J000106132", "DFAM-22359-V1");
        proxeIds.put("J000106133", "DFAM-55517-V1");
        proxeIds.put("J000106134", "DFAM-61786-V2");
        proxeIds.put("J000106142", "DFAM-80115-V1");
        proxeIds.put("J000106143", "DFAM-84910-V1");
        proxeIds.put("J000106141", "DFAM-72078-V2");
        
        proxeIds.put("J000106574", "DFAL-48392-V1");
        proxeIds.put("J000106567", "DFAL-49600-V2");
        proxeIds.put("J000106570", "DFAM-62736-V1");
        


        
    }

    public static String getReleationLabel(String modelID) {
        if (relations.size() == 0) {
            //  System.out.println("loading PDX relations");
            load();
        }
        return relations.get(modelID);
    }

    public static String getProxeId(String modelID) {
        if (proxeIds.size() == 0) {
            load();
        }
        return proxeIds.get(modelID);
    }
}
