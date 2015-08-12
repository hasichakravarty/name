public with sharing Class Controller {
List<WrappedRecord> myRecords=new List<WrappedRecord>();
public Controller(){
    List<Account> acclist=[select id,name from Account where id='001g000000W57Hs'];
    if (acclist.size()>0){
        for(integer i=0;i<acclist.size(); i++){
            WrappedRecord wr=new WrappedRecord(acclist[i]);
            myRecords.add(wr);
        }
    }
}
public Class WrappedRecord {
    public Account detail {get;set;}
    public List<WrappedRecord> children { get; set; }
    public WrappedRecord(Account acc) {
        this.detail=acc;
        this.children=new List<WrappedRecord>();
    }
}//Wrapper class

public Component.Apex.OutputPanel getThePanel(){
    Component.Apex.OutputPanel outPanel = new Component.Apex.OutputPanel();
    for(Integer i=0; i<myRecords.size(); i++) {
        outPanel.childComponents.add( addChildComponents(myRecords, 0, 'myRecords') );
    }
    return outPanel;
}
private Component.Apex.OutputPanel addChildComponents(List<WrappedRecord> wrappers, Integer level, String accessString) {
    accessString = accessString + '[' + level + ']';
    Component.Apex.OutputPanel outPanel = new Component.Apex.OutputPanel();
    {
        Component.Apex.InputText inTxt = new Component.Apex.InputText();
        inTxt.value = wrappers[level].detail.Name ;
        inTxt.expressions.value = '{!' + accessString + '}';
        outPanel.childComponents.add( inTxt );
    }
   // outPanel.childComponents.add( addChildComponents( wrappers[level].children, level+1, accessString + 'children') );
    return outPanel;
}

}