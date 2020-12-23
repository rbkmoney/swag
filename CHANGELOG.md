# swag-v2

## Version 2.0.0 to 2.0.1
---
### What's New
---

### What's Deprecated
---

### What's Changed
---
`GET` /analytics/shops/{shopID}/invoices
    Parameters

        Modify bankCardTokenProvider
            - yandexpay
            
        Modify paymentTerminalProvider 
            - uzcard
        
`GET` /analytics/shops/{shopID}/payments
    Parameters

        Modify bankCardTokenProvider
            - yandexpay
            
        Modify paymentTerminalProvider
            - uzcard
        
`GET` /processing/invoices/{invoiceID}/payments
    Return Type
    
        Insert transactionInfo
        
`GET` /processing/invoices/{invoiceID}/payments/{paymentID}
    Return Type

        Insert transactionInfo
        
`GET` /processing/payments
    Return Type
    
        Insert transactionInfo

