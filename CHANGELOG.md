# Swag-v2 changelog

## Version 0.0.0 to 0.0.1 - 11.12.2020
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

