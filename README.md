# Curious-Edinburgh

### Launch URL

Launch URL takes the form:
    
`curious-edinburgh://DOMAIN?tour=TOUR_NAME&protocol=PROTOCOL_TYPE`
    
i.e.
    
`curious-edinburgh://curiousedinburgh.org?tour=Science&protocol=secure`
    
The `protocol` query string item is optional and can be either `secure` or 
`insecure`. However, any value other than `secure` results in the API endpoint 
url being prefixed with `http://`. If `protocol` is specified as`secure` then 
the API endpoint url is prefixed with `https://`.
