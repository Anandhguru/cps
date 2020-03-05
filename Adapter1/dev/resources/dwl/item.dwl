%dw 2.0
output application/json
fun getOperationType(item) =
    if(item.documentActionCode == "ADD") "Record"
   else if(item.documentActionCode == "DELETE") "DeleteRecord"
    else ""
---
Products:
({(payload.itemMessage.*item map(item,index) -> (getOperationType(item)) : {
    "ProductId":
    if((item.itemIdentification.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode) != null) (item.itemIdentification.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode) else '',
    "Name":
    if((item.itemIdentification.itemName) != null) (item.itemIdentification.itemName) else '',
   
	"UnitID":
    if((item.tradeItemBaseUnitOfMeasure) != null)item.tradeItemBaseUnitOfMeasure else '',
    "ProductGroupID":
    if((item.classifications.itemFamilyGroup) != null) item.classifications.itemFamilyGroup else ''
    })})
