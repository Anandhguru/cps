%dw 2.0
output application/xml

type inFormat = Date { format: "yyyy-MM-dd" }

fun getOperationType(itemLocation) =
    if(itemLocation.documentActionCode == "ADD") "Record"
   else if(itemLocation.documentActionCode == "DELETE") "DeleteRecord"
    else ""
    
---

StockParameters:({(payload.itemLocationMessage.*itemLocation map () -> (getOperationType($)): {
    "ProductId":if($.itemLocationIdentification.item.additionalTradeItemIdentification.@additionalTradeItemIdentificationTypeCode == "BUYER_ASSIGNED") $.itemLocationIdentification.item.additionalTradeItemIdentification else "",
    "LocationId":if($.itemLocationIdentification.location.additionalPartyIdentification.@additionalPartyIdentificationTypeCode == "UNKNOWN") $.itemLocationIdentification.location.additionalPartyIdentification else "",
    "UnitID":$.effectiveInventoryParameters.maximumOnHandQuantity.@measurementUnitCode,
    "MinQuantity":$.effectiveInventoryParameters.minimumSafetyStockQuantity,
    "MaxQuantity":$.planningParameters.maximumOnHandQuantity,
    "MinNumberExpirationDays":$.perishableParameters.minimumShelfLifeDuration,
    "ActiveFrom":$.effectiveDate as inFormat,
    "ActiveUpTo":$.discontinueDate as inFormat
})})
