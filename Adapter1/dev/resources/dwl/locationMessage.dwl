%dw 2.0
output application/xml
var location = payload.locationMessage.*location
fun checkLocationType(lType : String) =
    if(["MANUFACTURING_PLANT","STORE","WAREHOUSE_AND_OR_DEPOT"] contains(lType))
    lType
    else
    ""
fun getOperationType(location) =
   if(location.documentActionCode == "ADD") "Record"
   else if(location.documentActionCode == "DELETE") "DeleteRecord"
    else ""
---
{
    Locations: {
        (location map (value)  ->  {
            (getOperationType(value)) : {
                LocationID: value.locationIdentification.entityIdentification default "",
                Name: value.basicLocation.locationName default "",
                Description:value.basicLocation.description default "",
                Type: checkLocationType(value.basicLocation.locationTypeCode) default "",
                Country: value.basicLocation.address.countryCode default "",
                PostalCode: value.basicLocation.address.postalCode default "",
                City: value.basicLocation.address.city default "",
                Street: ([1 to (sizeOf(value.basicLocation.address.streetAddressOne splitBy(" ")) -1)] map (value.basicLocation.address.streetAddressOne splitBy(" "))[$])[0] joinBy " " default "",
                HouseNumber: (value.basicLocation.address.streetAddressOne splitBy(" "))[0] default "",
                TimeZone : "",
                Region : "",
                SubRegion : "",
                Latitude: value.basicLocation.address.geographicalCoordinates.latitude default "",
                Longitude: value.basicLocation.address.geographicalCoordinates.longitude default "",
                Altitude : "",
                StorageArea : "",
                SalesArea : "",
                // OpenDate : "",
                // FinalDate : "",
                ActiveFrom : (value.basicLocation.status.effectiveDate replace  "Z" with "") default "",
                ActiveUpTo :  (value.basicLocation.status.discontinueDate replace  "Z" with "") default ""
            }
        }
    )
    }
}