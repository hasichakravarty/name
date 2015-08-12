@isTest
public class testterritoryclass{
public static testmethod void createterr(){ 
Territory2 tt = TestDataFactory.createTerritory();
insert tt;
system.assert(tt.id!=null,'Territory is created');


//Territory2 terr= new Territory2(Name='TestClassTerritory');
//insert terr;
//system.debug(terr.id+';'+terr.name);
}
}