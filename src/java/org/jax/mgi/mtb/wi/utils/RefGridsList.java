/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.utils;

import java.util.HashMap;

/**
 *
 * @author sbn
 */
public class RefGridsList {
 
    public static HashMap<String,String> map =  new HashMap<>();
    static{
        map.put("532","J1879.jpg");
        map.put("788","J2578.jpg");
        map.put("530","J15101.jpg");
        map.put("1012","J24434.jpg");
        map.put("81","J25446.jpg");
        map.put("163","J29486.jpg");
        map.put("551","J35020.jpg");
        map.put("180","J41126.jpg");
        map.put("360","J42441.jpg");
        map.put("29","J46464.jpg");
        map.put("460","J47108.jpg");
        map.put("176","J47282.jpg");
        map.put("323","J49839.jpg");
        map.put("91465","J51144.jpg");
        map.put("87354","J52560.jpg");
        map.put("473","J55416.jpg");
        map.put("437","J57631.jpg");
        map.put("506","J58876.jpg");
        map.put("595","J59366.jpg");
        map.put("540","J64364.jpg");
        map.put("720","J64968.jpg");
        map.put("656","J68915.jpg");
        map.put("623","J68981.jpg");
        map.put("688","J70622.jpg");
        map.put("712","J71315.jpg");
        map.put("88751","J71406.jpg");
        map.put("755","J72086.jpg");
        map.put("92092","J75243.jpg");
        map.put("836","J77034.jpg");
        map.put("1224","J77740.jpg");
        map.put("89296","J80272.jpg");
        map.put("89529","J83780.jpg");
        map.put("89668","J85513.jpg");
        map.put("89815","J87536.jpg");
        map.put("92990","J88315.jpg");
        map.put("89929","J89239.jpg");
        map.put("92591","J90512.jpg");
        map.put("90203","J92444.jpg");
        map.put("92774","J94629.jpg");
        map.put("92861","J96884.jpg");
        map.put("93094","J98835.jpg");
        map.put("93537","J108788.jpg");
        map.put("93536","J110567.jpg");
        map.put("93886","J112292.jpg");
        map.put("93995","J117494.jpg");
        map.put("94140","J123168.jpg");
        map.put("94156","J123935.jpg");
        map.put("94310","J130924.jpg");
        map.put("94567","J141658.jpg");
        map.put("94831","J143449.jpg");
        map.put("94696","J144977.jpg");
        map.put("94884","J146481.jpg");
        map.put("94763","J147432.jpg");
        map.put("94940","J149148.jpg");
        map.put("94966","J150362.jpg");
        map.put("94708","J151494.jpg");
        map.put("94715","J153341.jpg");
        map.put("94754","J153668.jpg");
        map.put("95133","J158059.jpg");
        map.put("95144","J158687.jpg");
        map.put("95334","J166684.jpg");
        map.put("95473","J171821.jpg");
        map.put("95469","J172605.jpg");
        map.put("98821","J177420.jpg");
        map.put("98889","J178573.jpg");
        map.put("99392","J186116.jpg");
        map.put("99876","J192917.jpg");
        map.put("99963","J193361.jpg");
        map.put("100161","J195539.jpg");
        map.put("100561","J200102.jpg");
        map.put("101251","J208539.jpg");
        map.put("102107","J218227.jpg");
        map.put("102806","J225947.jpg");
        map.put("103522","J233444.jpg");
        map.put("104350","J241552.jpg");
        map.put("104367","J241797.jpg");
        map.put("105705","J264300.jpg");
        map.put("107046","J292136.jpg");
        map.put("108545","J303442.jpg");
        map.put("108687","J305009.jpg");
    }
    
    public static String getGrid(String refKey){
       return map.get(refKey);
    }
    
   
}
