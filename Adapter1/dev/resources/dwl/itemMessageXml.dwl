%dw 2.0
import * from dw::Runtime
output application/xml
fun getOperationType(item) =
    if(item.documentActionCode == "ADD") "Record"
   else if(item.documentActionCode == "DELETE") "DeleteRecord"
    else ""
---
"Products":{(payload.itemMessage.*item map(item,index) -> (getOperationType(item)) : ({
    ("ProductID": if((item.itemIdentification.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode) != null)  (item.itemIdentification.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode) else fail("ProductId Not Found")) ,
    ("Name":
     (item.itemIdentification.itemName)) if((item.itemIdentification.itemName) != null),
    ("Description":
     (item.description)) if((item.description) != null),
    ("UnitID":
    item.tradeItemBaseUnitOfMeasure) if((item.tradeItemBaseUnitOfMeasure) != null) ,
    ("ProductGroupID":
     item.classifications.itemFamilyGroup) if((item.classifications.itemFamilyGroup) != null),
    ("ActiveFrom": 
     item.status.effectiveDateTime) if((item.status.effectiveDateTime) != null),
    ("ActiveUpto":
     item.status.discontinueDateTime) if((item.status.discontinueDateTime) != null)
    }) ++ {((item.avpList.*eComStringAttributeValuePairList) map (($.@attributeName) : $))})}