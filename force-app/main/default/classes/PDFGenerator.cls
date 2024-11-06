/**
 * @description       : Permite generar un pdf en base a un template y a parametros (Opcionales). El pdf puede generarse como Attachment, ContenDocument o retornar su base 64
 * @author            : Victor M. Degano
 * @last modified on  : 31-10-2024
 * @last modified by  : Victor M. Degano
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   31-10-2024   Victor M. Degano   Initial Version
**/
public with sharing class PDFGenerator {
    private String HtmlTemplate { get; set; }
    private Map<String,String> HtmlParameters { get; set; }
    private String Filename { get; set; }
    private String ParentId { get; set; }
    private String Description { get; set; }
    private Boolean hasParams { get; set; }

    private PDFGenerator(){
        this.HtmlTemplate = '';
        this.HtmlParameters = new Map<String,String>();
        this.Filename = '';
        this.ParentId = '';
        this.Description = '';
        this.hasParams = false;
    }

    public String generateBase64() {
        return EncodingUtil.base64Encode(this.generatePDFBlob());
    }

    public Blob generatePDFBlob(){
        PageReference pdfPage = Page.PDFGenerator;
        pdfPage.setRedirect(false);
        pdfPage.getParameters().put('htmlContent', HtmlTemplate);
        if(this.hasParams){
            pdfPage.getParameters().put('htmlParameters', JSON.serialize(HtmlParameters));
        }
        pdfPage.getParameters().put('loadParams',JSON.serialize(this.hasParams));

        return generatePDF(pdfPage);
    }

    private Blob generatePDF(PageReference pdfPage){
        Blob blobFile;

        if(Test.isRunningTest()){ //We use this to mock the "GetContentAsPDF" method cause cannot use it in test
            Test.setCurrentPage(pdfPage);
            PDFController controllerForTest = new PDFController();
            blobFile = Blob.valueOf(controllerForTest.htmlContent);
        } else {
            blobFile = pdfPage.getContentAsPDF();
        }
        return blobFile;
    }

    public Attachment generateAttachment(){
        Attachment attachment = new Attachment(
            ParentId = this.ParentId,
            Name = this.Filename+'.pdf',
            Body = this.generatePDFBlob(),
            ContentType = 'application/pdf',
            Description = this.Description
        );
        return attachment;
    }

    public ContentVersion generateContentVersion(){
        ContentVersion contentVersion = new ContentVersion(
            Title = this.Filename,
            PathOnClient = this.Filename+'.pdf',
            VersionData = this.generatePDFBlob(),
            Description = this.Description
        );
        return contentVersion;
    }
    
    public PDFGenerator withHtmlTemplate(String value){
        this.HtmlTemplate = value;
        return this;
    }

    public PDFGenerator withHtmlParameters(Map<String,String> mapValues){
        this.HtmlParameters = mapValues;
        this.hasParams = true;
        return this;
    }

    public PDFGenerator withFilename(String value){
        this.Filename = value;
        return this;
    }

    public PDFGenerator withParentId(String value){
        this.ParentId = value;
        return this;
    }

    public PDFGenerator withDescription(String value){
        this.Description = value;
        return this;
    }

    public static PDFGenerator init(){
        return new PDFGenerator();
    }
}