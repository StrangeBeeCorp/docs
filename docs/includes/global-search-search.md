3. Enter the keywords you want to search for in the search box displayed by default.

    !!! tip "Wildcard character"
        You can use the wildcard character *\** to broaden your searches and capture multiple variations since version 5.4.7.
        
        Examples of use cases:  
        - Email domains: Entering *\*@gmail.com* will return entities containing the gmail.com domain.  
        - IP subnets: Entering *192.168.\*.\** will return entities with IP addresses in the 192.168.x.x subnet.  
        - URLs: Entering *https://malwaredomain.com/\** will return entities hosted under the malwaredomain.com directory.

        Other advanced search options, such as Boolean and phrase searches, are not supported.

4. If you need additional filters, apply one or more filters by selecting **Add new filter**. These filters refine your search results and act as an equivalent to the AND operator in Boolean search.

    !!! warning "Warning"
        Filters are required for the following fields to ensure the search engine accurately interprets values:  
        - Fields with specific date formats  
        - [Custom fields](../../../../administration/custom-fields/about-custom-fields.md)