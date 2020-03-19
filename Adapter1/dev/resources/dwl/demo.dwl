%dw 2.0
output application/json
var function = attributes.headers.function
var data = attributes.headers.data
var value = if(attributes.headers.value != null) (read(attributes.headers.value,"application/json")) else {} 
var mapped = 
(payload.itemMessage.*item map(item,index) -> ( {
    "ProductId": 
    if((item.itemIdentification.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode) != null) (item.itemIdentification.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode) else '',
    "Name":
    if((item.itemIdentification.itemName) != null) (item.itemIdentification.itemName) else '',
    "Description":
    if((item.*description) != null) (item.*description) else '',
    "UnitID":
    if((item.tradeItemBaseUnitOfMeasure) != null)item.tradeItemBaseUnitOfMeasure else '',
    "ProductGroupID":
    if((item.classifications.itemFamilyGroup) != null) item.classifications.itemFamilyGroup else '',
    "ActiveFrom": 
    if((item.status.effectiveDateTime) != null) item.status.effectiveDateTime else '',
    "ActiveUpTo":
    if((item.status.discontinueDateTime) != null) item.status.discontinueDateTime else ''
    }))
fun dynamic(function,data,value) = if(function == "add") (if(data == "field") mapped map ($ ++ value) else (mapped + value))
else (if(data == "field") mapped map ($ -- value) else (mapped - value))
---
if(function == null) (mapped) else dynamic(function,data,value)