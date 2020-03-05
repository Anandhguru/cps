%dw 2.0
output application/json
---
"Ans is " ++ (payload.one + payload.two) as String