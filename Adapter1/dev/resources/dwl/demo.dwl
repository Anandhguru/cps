%dw 2.0
output application/json
var function = attributes.headers.fun
var data = attributes.headers.data
var value = [{"Name":"Anandh","Age":22},{"Name":"guru","Age":22}]
fun dynamic(function,data,payload) = if(function == "add") (if(data == "field") value map ($ ++ payload) else value + payload)
else (if(data == "field") value map ($ -- payload) else (value - payload))
---
dynamic(function,data,payload)