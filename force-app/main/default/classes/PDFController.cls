/**
 * @description       : Controladora Visualforce que permite armar y formatear el template de PDF
 * @author            : Victor M. Degano
 * @last modified on  : 31-10-2024
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   31-10-2024   Victor M. Degano   Initial Version
**/
public with sharing class PDFController {
    public String htmlContent { get; set; } // Propiedad para almacenar el HTML que se va a usar de template
    public Map<String,String> htmlParameters { get; set; } // Propiedad que guarda los parametros que van cargarse en el template
    public Boolean loadTemplate { get; set; }

    public PDFController() {
        this.htmlContent = ApexPages.currentPage().getParameters().get('htmlContent');

        String pageParameters = ApexPages.currentPage().getParameters().get('htmlParameters');
        this.htmlParameters = String.isNotBlank(pageParameters) ? (Map<String,String>) JSON.deserialize(pageParameters, Map<String,String>.class) : new Map<String,String>();
        
        String loadTemplatePageParam = ApexPages.currentPage().getParameters().get('loadParams');
        this.loadTemplate = 'true'.equalsIgnoreCase(loadTemplatePageParam) ?? false;

        if(loadTemplate){
            this.loadTemplate();
        }
    }

    @TestVisible
    public void loadTemplate(){
        String item;
        String mergeFieldSintax;
        String mergeFieldSintaxRegex;
        for(String key : this.htmlParameters.keySet()) {
                mergeFieldSintax = '{!key}';
                mergeFieldSintaxRegex = '\\{\\!(?i)'+key+'\\}';

            if(this.htmlContent.containsIgnoreCase(key)){
                item = this.htmlParameters.get(key);
                this.htmlContent = this.htmlContent.replaceAll(mergeFieldSintaxRegex, item);
            } else {
                System.debug(LoggingLevel.WARN, 'No existe parametro para el valor: '+key);
            }
        }
    }
}