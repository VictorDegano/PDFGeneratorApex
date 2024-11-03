/**
 * @description       : 
 * @author            : Victor M. Degano
 * @last modified on  : 31-10-2024
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   31-10-2024   Victor M. Degano   Initial Version
**/
public with sharing class PDFController {
    public String htmlContent { get; set; } // Propiedad para almacenar el HTML
    public Map<String,String> htmlParameters { get; set; }

    public PDFController() {
        this.htmlContent = ApexPages.currentPage().getParameters().get('htmlContent');
        this.htmlParameters = (Map<String,String>) JSON.deserialize(ApexPages.currentPage().getParameters().get('htmlParameters'), Map<String,String>.class);
        String loadTemplatePageParam = ApexPages.currentPage().getParameters().get('loadParams');
        Boolean loadTemplate = String.isNotBlank(loadTemplatePageParam) && 'true'.equalsIgnoreCase(loadTemplatePageParam);

        if(loadTemplate){
            this.loadTemplate();
        }
    }

    private void loadTemplate(){
        String item;
        String mergeFieldSintax;
        String mergeFieldSintaxRegex;
        for(String key : this.htmlParameters.keySet()) {
                mergeFieldSintax = '{!key}';
                mergeFieldSintaxRegex = '\\{\\!(?i)'+key+'\\}';

            if(this.htmlContent.containsIgnoreCase(key)){
                item = this.htmlParameters.get(key);
                this.htmlContent.replaceAll(mergeFieldSintaxRegex, item);
            } else {
                System.debug(LoggingLevel.WARN, 'No existe parametro para el valor: '+key);
            }
            
        }
    }
}