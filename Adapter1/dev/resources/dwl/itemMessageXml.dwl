%dw 2.0
import * from dw::Runtime
output application/xml
fun getOperationType(item) =
    if(item.documentActionCode == "ADD") "Record"
   else if(item.documentActionCode == "DELETE") "DeleteRecord"
    else ""
---
"Products":{(payload.itemMessage.*item map(item,index) -> (getOperationType(item)) : ({
    ("PRODUCTID": if((item.itemIdentification.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode) != null)  (item.itemIdentification.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode) else fail("ProductId Not Found")) ,
    ("NAME":
     (item.itemIdentification.itemName)) if((item.itemIdentification.itemName) != null),
    ("DESCRIPTION":
     (item.*description)) if((item.*description) != null),
    ("UNITID":
    item.tradeItemBaseUnitOfMeasure) if((item.tradeItemBaseUnitOfMeasure) != null) ,
    ("PRODUCTGROUPID":
     item.classifications.itemFamilyGroup) if((item.classifications.itemFamilyGroup) != null),
    ("ACTIVEFROM": 
     item.status.effectiveDateTime) if((item.status.effectiveDateTime) != null),
    ("ACTIVEUPTO":
     item.status.discontinueDateTime) if((item.status.discontinueDateTime) != null) 
    }))}
