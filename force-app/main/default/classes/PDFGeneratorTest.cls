@IsTest
public with sharing class PDFGeneratorTest {
    private final static String NAME_ROW = '<p>Hola {!name},</p>';
    private final static String HTML_SAMPLE = 
        '<!DOCTYPE html>'+
        '<html>'+
        '<head>'+
        '  <meta charset="UTF-8">'+
        '  <meta name="viewport" content="width=device-width, initial-scale=1.0">'+
        '  <title>Test de Template Generator</title>'+
        '</head>'+
        '<body style="font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #2574A9;">'+
        '  <div style="max-width: 600px; margin: 0 auto; background-color: #2574A9; padding: 20px; border-radius: 5px;">'+
        '    <div style="background-color: #0073e6; color: #ffffff; padding: 10px 20px; text-align: center; font-size: 24px; font-weight: bold; border-radius: 5px 5px 0 0;">'+
        '      <b>Título del Template</b>'+
        '    </div>'+
        '    <div style="padding: 20px; font-size: 16px; color: #333333; line-height: 1.6;">'+
        '      '+NAME_ROW+
        '    </div>'+
        '  </div>'+
        '</body>'+
        '</html>';

    @IsTest
    private static void generatePDFTest(){
        // Setup (Given)
        String filename = 'TestPDF';
        String description = 'Only a test PDF';
        
        Contact pepe = new Contact(firstname = 'Pepe', LastName = 'Prueba');
        insert pepe;
        
        Map<String, String> parameters = new Map<String, String> { 'name' => pepe.FirstName };
        final String EXPECTED_BODY = HTML_SAMPLE.replace('{!name}', pepe.FirstName);

        // Exercise (When)
        Test.startTest();
        PDFGenerator generator = PDFGenerator.init().withFilename(filename).withDescription(description).withParentId(pepe.Id).withHtmlTemplate(HTML_SAMPLE).withHtmlParameters(parameters);
        String templateAsBase64 = generator.generateBase64();
        Attachment templateAsAttach = generator.generateAttachment();
        ContentVersion templateAsContent = generator.generateContentVersion();
        Test.stopTest();

        // Test (Then)
        String rawBody = EncodingUtil.base64Decode(templateAsBase64).toString();
        System.assertEquals(EXPECTED_BODY, rawBody, 'El template no esta formateado como se espera.');
        System.assertEquals(EXPECTED_BODY, templateAsAttach.Body.toString(), 'El template no esta formateado como se espera.');
        System.assertEquals(EXPECTED_BODY, templateAsContent.VersionData.toString(), 'El template no esta formateado como se espera.');
    }
}