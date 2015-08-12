public class TestController 
{

public TestController()
{
system.debug('constructor');
generatePDF();


} 

public pageReference generatePDF()
{
system.debug('method//');
pageReference nextPage = page.TestPage2;
nextPage.setRedirect(false);
return nextPage;
}

}