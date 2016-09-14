<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>

    <head>

    <c:import  url="../../../meta.jsp">
        <c:param name="pageTitle" value="PDX Request Form"/>
    </c:import>

    <script language="javascript">
    
        function validate(){
            
            var email = document.requestForm.email.value;
            var name = document.requestForm.name.value;
            var title = document.requestForm.title.value;
            var org = document.requestForm.org.value;
            var comments = document.requestForm.comments.value;
            
            if((email.length > 0 ) && (name.length >0) &&(title.length>0) &&(org.length>0) &&(comments.length > 0)
            && (email.indexOf("@")>=1) &&(email == document.requestForm.vemail.value)){
                document.requestForm.submit();
            }else{
                document.getElementById("msgtxt").style.display="inline";
            }
        }
    
    </script>

</head>

<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="PDX Information Request Form"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td width="200" valign="top">
    <c:import url="../../../pdxToolBar.jsp" />
</td>
<td class="separator">
    &nbsp;
</td>
<td valign="top">
    <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
        <tr>
            <td>
                <!--======================= Start Main Section =============================-->

                <!--======================= Start Form Header ==============================-->
                <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                    <tr class="pageTitle">
                        <td colspan="2">
                            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#pdxRequest"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        PDX Information Request Form
                                    </td>
                                    <td width="20%" valign="middle" align="center">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <!--======================= End Form Header ================================-->
                    <tr class="buttons">
                        <td align="center" colspan="2">
                            <form action="pdxRequest.do" method="GET" name="requestForm">
                                <table align="center" border=0 cellspacing=5 width="100%">

                                    <tr>
                                        <td colspan="2" style="display:hidden"><div id="msgtxt" style="display:none">
                                                <b>Please verify that both emails match and all fields are completed</b>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                             <c:choose>
                                                <c:when test="${not empty mice}">
                                                     You are requesting details on PDX Mouse ID <b> ${mice} </b>.
                                                </c:when>
                                                <c:otherwise>
                                                    You are requesting general information on the PDX program.
                                                </c:otherwise>
                                             </c:choose>
                                            
                                            
                                        </td>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            Fill out our brief web form and we will contact you in 1-2 business days.
                                        </td>
                                    </tr>
                                    <tr><td colspan="2">
                                            * Designates required information
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>*Email</td><td><input type="text" name="email" size="30"></td>
                                    </tr>
                                    <tr>
                                        <td>*Verify Email</td><td><input type="text" name="vemail" size="30"></td>
                                    </tr>
                                    <tr>
                                        <td>*</td>
                                        <td>
                                            <label>Dr.</label><input type="radio" value="Dr" name="Mr">
                                            &nbsp;<label>Ms.</label><input type="radio" value="Ms"  name="Mr">
                                            &nbsp;<label>Mr.</label><input type="radio" value="Mr"  name="Mr">
                                            &nbsp;<label>Prof.</label><input type="radio" value="Prof"  name="Mr">
                                        </td>
                                    </tr>
                                    <tr>  
                                        <td>*Name</td><td><input type="text" name="name" size="30"></td>
                                    </tr>
                                    <tr>
                                        <td>*Title</td><td><input type="text" name="title" size="30"></td>
                                    </tr>
                                    <tr>

                                        <td>*Organization</td><td><input type="select" name="org" size="30"></td>
                                    </tr>
                                    <tr>
                                        <td>*Country</td><td><select>
                                                <option value="">Please select...</option>
                                                <option value="UnitedStates" class="switch-a">United States</option>
                                                <option value="AF" >Afghanistan</option>
                                                <option value="Albania" >Albania</option>
                                                <option value="Algeria" >Algeria</option>
                                                <option value="AmericanSamoa1" >American Samoa</option>

                                                <option value="Andorra" >Andorra</option>
                                                <option value="Angola" >Angola</option>
                                                <option value="Anguilla" >Anguilla</option>
                                                <option value="Antarctica" >Antarctica</option>
                                                <option value="AntiguaandBarbud" >Antigua and Barbuda</option>
                                                <option value="Argentina" >Argentina</option>
                                                <option value="Armenia" >Armenia</option>
                                                <option value="Aruba" >Aruba</option>
                                                <option value="Australia" >Australia</option>

                                                <option value="Austria" >Austria</option>
                                                <option value="Azerbaijan" >Azerbaijan</option>
                                                <option value="Bahamas" >Bahamas</option>
                                                <option value="Bahrain" >Bahrain</option>
                                                <option value="Bangladesh" >Bangladesh</option>
                                                <option value="Barbados" >Barbados</option>
                                                <option value="Belarus" >Belarus</option>
                                                <option value="Belgium" >Belgium</option>
                                                <option value="Belize" >Belize</option>

                                                <option value="Benin" >Benin</option>
                                                <option value="Bermuda" >Bermuda</option>
                                                <option value="Bhutan" >Bhutan</option>
                                                <option value="Bolivia" >Bolivia</option>
                                                <option value="BosniaandHerzego" >Bosnia and Herzegovina</option>
                                                <option value="Botswana" >Botswana</option>
                                                <option value="BouvetIsland" >Bouvet Island</option>
                                                <option value="Brazil" >Brazil</option>
                                                <option value="BritishIndianOce" >British Indian Ocean Territory</option>

                                                <option value="Brunei" >Brunei</option>
                                                <option value="Bulgaria" >Bulgaria</option>
                                                <option value="BurkinaFaso" >Burkina Faso</option>
                                                <option value="Burundi" >Burundi</option>
                                                <option value="Cambodia" >Cambodia</option>
                                                <option value="Cameroon" >Cameroon</option>
                                                <option value="Canada" class="switch-b">Canada</option>
                                                <option value="CapeVerde" >Cape Verde</option>
                                                <option value="CaymanIslands" >Cayman Islands</option>

                                                <option value="CentralAfricanRe" >Central African Republic</option>
                                                <option value="Chad" >Chad</option>
                                                <option value="Chile" >Chile</option>
                                                <option value="China" >China</option>
                                                <option value="ChristmasIsland" >Christmas Island</option>
                                                <option value="CocosKeelingIsla" >Cocos ( Keeling ) Islands</option>
                                                <option value="Colombia" >Colombia</option>
                                                <option value="Comoros" >Comoros</option>
                                                <option value="Congo" >Congo</option>

                                                <option value="CookIslands" >Cook Islands</option>
                                                <option value="CostaRica" >Costa Rica</option>
                                                <option value="CtedIvoire" >Côte d ' Ivoire</option>
                                                <option value="CroatiaHrvatska" >Croatia ( Hrvatska )</option>
                                                <option value="Cuba" >Cuba</option>
                                                <option value="Cyprus" >Cyprus</option>
                                                <option value="CzechRepublic" >Czech Republic</option>
                                                <option value="CongoDRC" >Congo ( DRC )</option>
                                                <option value="Denmark" >Denmark</option>

                                                <option value="Djibouti" >Djibouti</option>
                                                <option value="Dominica" >Dominica</option>
                                                <option value="DominicanRepubli" >Dominican Republic</option>
                                                <option value="EastTimor" >East Timor</option>
                                                <option value="Ecuador" >Ecuador</option>
                                                <option value="Egypt" >Egypt</option>
                                                <option value="ElSalvador" >El Salvador</option>
                                                <option value="EquatorialGuinea" >Equatorial Guinea</option>
                                                <option value="Eritrea" >Eritrea</option>

                                                <option value="Estonia" >Estonia</option>
                                                <option value="Ethiopia" >Ethiopia</option>
                                                <option value="FalklandIslandsI" >Falkland Islands ( Islas Malvinas )</option>
                                                <option value="FaroeIslands" >Faroe Islands</option>
                                                <option value="FijiIslands" >Fiji Islands</option>
                                                <option value="Finland" >Finland</option>
                                                <option value="France" >France</option>
                                                <option value="FrenchGuiana" >French Guiana</option>
                                                <option value="FrenchPolynesia" >French Polynesia</option>

                                                <option value="FrenchSouthernan" >French Southern and Antarctic Lands</option>
                                                <option value="Gabon" >Gabon</option>
                                                <option value="Gambia" >Gambia</option>
                                                <option value="Georgia1" >Georgia</option>
                                                <option value="Germany" >Germany</option>
                                                <option value="Ghana" >Ghana</option>
                                                <option value="Gibraltar" >Gibraltar</option>
                                                <option value="Greece" >Greece</option>
                                                <option value="Greenland" >Greenland</option>

                                                <option value="Grenada" >Grenada</option>
                                                <option value="Guadeloupe" >Guadeloupe</option>
                                                <option value="Guam1" >Guam</option>
                                                <option value="Guatemala" >Guatemala</option>
                                                <option value="Guinea" >Guinea</option>
                                                <option value="GuineaBissau" >Guinea-Bissau</option>
                                                <option value="Guyana" >Guyana</option>
                                                <option value="Haiti" >Haiti</option>
                                                <option value="HeardIslandandMc" >Heard Island and McDonald Islands</option>

                                                <option value="Honduras" >Honduras</option>
                                                <option value="HongKongSAR" >Hong Kong SAR</option>
                                                <option value="Hungary" >Hungary</option>
                                                <option value="Iceland" >Iceland</option>
                                                <option value="India" >India</option>
                                                <option value="Indonesia" >Indonesia</option>
                                                <option value="Iran" >Iran</option>
                                                <option value="Iraq" >Iraq</option>
                                                <option value="Ireland" >Ireland</option>

                                                <option value="Israel" >Israel</option>
                                                <option value="Italy" >Italy</option>
                                                <option value="Jamaica" >Jamaica</option>
                                                <option value="Japan" >Japan</option>
                                                <option value="Jordan" >Jordan</option>
                                                <option value="Kazakhstan" >Kazakhstan</option>
                                                <option value="Kenya" >Kenya</option>
                                                <option value="Kiribati" >Kiribati</option>
                                                <option value="Korea" >Korea</option>

                                                <option value="Kuwait" >Kuwait</option>
                                                <option value="Kyrgyzstan" >Kyrgyzstan</option>
                                                <option value="Laos" >Laos</option>
                                                <option value="Latvia" >Latvia</option>
                                                <option value="Lebanon" >Lebanon</option>
                                                <option value="Lesotho" >Lesotho</option>
                                                <option value="Liberia" >Liberia</option>
                                                <option value="Libya" >Libya</option>
                                                <option value="Liechtenstein" >Liechtenstein</option>

                                                <option value="Lithuania" >Lithuania</option>
                                                <option value="Luxembourg" >Luxembourg</option>
                                                <option value="MacaoSAR" >Macao SAR</option>
                                                <option value="MacedoniaFormerY" >Macedonia, Former Yugoslav Republic of</option>
                                                <option value="Madagascar" >Madagascar</option>
                                                <option value="Malawi" >Malawi</option>
                                                <option value="Malaysia" >Malaysia</option>
                                                <option value="Maldives" >Maldives</option>
                                                <option value="Mali" >Mali</option>

                                                <option value="Malta" >Malta</option>
                                                <option value="MarshallIslands" >Marshall Islands</option>
                                                <option value="Martinique" >Martinique</option>
                                                <option value="Mauritania" >Mauritania</option>
                                                <option value="Mauritius" >Mauritius</option>
                                                <option value="Mayotte" >Mayotte</option>
                                                <option value="Mexico" >Mexico</option>
                                                <option value="Micronesia" >Micronesia</option>
                                                <option value="Moldova" >Moldova</option>

                                                <option value="Monaco" >Monaco</option>
                                                <option value="Mongolia" >Mongolia</option>
                                                <option value="Montserrat" >Montserrat</option>
                                                <option value="Morocco" >Morocco</option>
                                                <option value="Mozambique" >Mozambique</option>
                                                <option value="Myanmar" >Myanmar</option>
                                                <option value="Namibia" >Namibia</option>
                                                <option value="Nauru" >Nauru</option>
                                                <option value="Nepal" >Nepal</option>

                                                <option value="Netherlands" >Netherlands</option>
                                                <option value="NetherlandsAntil" >Netherlands Antilles</option>
                                                <option value="NewCaledonia" >New Caledonia</option>
                                                <option value="NewZealand" >New Zealand</option>
                                                <option value="Nicaragua" >Nicaragua</option>
                                                <option value="Niger" >Niger</option>
                                                <option value="Nigeria" >Nigeria</option>
                                                <option value="Niue" >Niue</option>
                                                <option value="NorfolkIsland" >Norfolk Island</option>

                                                <option value="NorthKorea" >North Korea</option>
                                                <option value="NorthernMarianaI1" >Northern Mariana Islands</option>
                                                <option value="Norway" >Norway</option>
                                                <option value="Oman" >Oman</option>
                                                <option value="Pakistan" >Pakistan</option>
                                                <option value="Palau1" >Palau</option>
                                                <option value="Panama" >Panama</option>
                                                <option value="PapuaNewGuinea" >Papua New Guinea</option>
                                                <option value="Paraguay" >Paraguay</option>

                                                <option value="Peru" >Peru</option>
                                                <option value="Philippines" >Philippines</option>
                                                <option value="PitcairnIslands" >Pitcairn Islands</option>
                                                <option value="Poland" >Poland</option>
                                                <option value="Portugal" >Portugal</option>
                                                <option value="PuertoRico1" >Puerto Rico</option>
                                                <option value="Qatar" >Qatar</option>
                                                <option value="Reunion" >Reunion</option>
                                                <option value="Romania" >Romania</option>

                                                <option value="Russia" >Russia</option>
                                                <option value="Rwanda" >Rwanda</option>
                                                <option value="Samoa" >Samoa</option>
                                                <option value="SanMarino" >San Marino</option>
                                                <option value="SoTomandPrncipe" >São Tomé and Prìncipe</option>
                                                <option value="SaudiArabia" >Saudi Arabia</option>
                                                <option value="Senegal" >Senegal</option>
                                                <option value="SerbiaandMontene" >Serbia and Montenegro</option>
                                                <option value="Seychelles" >Seychelles</option>

                                                <option value="SierraLeone" >Sierra Leone</option>
                                                <option value="Singapore" >Singapore</option>
                                                <option value="Slovakia" >Slovakia</option>
                                                <option value="Slovenia" >Slovenia</option>
                                                <option value="SolomonIslands" >Solomon Islands</option>
                                                <option value="Somalia" >Somalia</option>
                                                <option value="SouthAfrica" >South Africa</option>
                                                <option value="SouthGeorgiaandt" >South Georgia and the South Sandwich Islands</option>
                                                <option value="Spain" >Spain</option>

                                                <option value="SriLanka" >Sri Lanka</option>
                                                <option value="StHelena" >St. Helena</option>
                                                <option value="StKittsandNevis" >St. Kitts and Nevis</option>
                                                <option value="StLucia" >St. Lucia</option>
                                                <option value="StPierreandMique" >St. Pierre and Miquelon</option>
                                                <option value="StVincentandtheG" >St. Vincent and the Grenadines</option>
                                                <option value="Sudan" >Sudan</option>
                                                <option value="Suriname" >Suriname</option>
                                                <option value="SvalbardandJanMa" >Svalbard and Jan Mayen</option>

                                                <option value="Swaziland" >Swaziland</option>
                                                <option value="Sweden" >Sweden</option>
                                                <option value="Switzerland" >Switzerland</option>
                                                <option value="Syria" >Syria</option>
                                                <option value="Taiwan" >Taiwan</option>
                                                <option value="Tajikistan" >Tajikistan</option>
                                                <option value="Tanzania" >Tanzania</option>
                                                <option value="Thailand" >Thailand</option>
                                                <option value="Togo" >Togo</option>

                                                <option value="Tokelau" >Tokelau</option>
                                                <option value="Tonga" >Tonga</option>
                                                <option value="TrinidadandTobag" >Trinidad and Tobago</option>
                                                <option value="Tunisia" >Tunisia</option>
                                                <option value="Turkey" >Turkey</option>
                                                <option value="Turkmenistan" >Turkmenistan</option>
                                                <option value="TurksandCaicosIs" >Turks and Caicos Islands</option>
                                                <option value="Tuvalu" >Tuvalu</option>
                                                <option value="Uganda" >Uganda</option>

                                                <option value="Ukraine" >Ukraine</option>
                                                <option value="UnitedArabEmirat" >United Arab Emirates</option>
                                                <option value="UnitedKingdom" >United Kingdom</option>
                                                <option value="UnitedStatesMino" >United States Minor Outlying Islands</option>
                                                <option value="Uruguay" >Uruguay</option>
                                                <option value="Uzbekistan" >Uzbekistan</option>
                                                <option value="Vanuatu" >Vanuatu</option>
                                                <option value="VaticanCity" >Vatican City</option>
                                                <option value="Venezuela" >Venezuela</option>

                                                <option value="VietNam" >Viet Nam</option>
                                                <option value="VirginIslandsBri" >Virgin Islands ( British )</option>
                                                <option value="VirginIslands" >Virgin Islands</option>
                                                <option value="WallisandFutuna" >Wallis and Futuna</option>
                                                <option value="Yemen" >Yemen</option>
                                                <option value="Zambia" >Zambia</option>
                                                <option value="Zimbabwe" >Zimbabwe</option></select> <br></td>
                                    </tr>
                                    <tr>

                                        <td>Comments</td><td><textarea rows="5" cols="30" name="comments"></textarea> </td>
                                        
                                        </tr>
                                    <tr>
                                        <td>
                                            <input type="hidden" value="${mice}" name="mice">
                                            <input type="button" value="Submit Request" onClick="validate();">
                                        </td>
                                    </tr>
                                </table>

                            </form>


                        </td>


                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>

            </td></tr>
        <!--======================= End Results ====================================-->
    </table>
    <!--======================== End Main Section ==============================-->
</td>
</tr>
</table>

</body>
</html>
