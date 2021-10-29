# Serenity

* Types
    * Axiety
    * Stress
    * Other
## Endpoints
* **/randomize?time={time}&avg={averageTimePerLetter}**
    * GET: get a random meditation from db fiting the given time
    ```json
    {
        "step00": [
                {
                    "_id":"6169c53d201ebe4f6a58c76a", 
                    "content":"bienvenido a gradua..."
                }
            ],
        ...
        "step7": [
                {
                    "_id":"6169ba2036651c7498ee7d5c",
                    "content":"gracias por meditar con nosotros...",
                }
            ],
    }
    ```

* **/feedback**
    * POST: saves the user feedback form
        * Body: 
    ```Json
    {
        "score": 5,
        "stateBefore": 9,
        "stateAfter": 6,
        "objectiveType": "stress",
        "routine": {
                "step00": ["6169c53d201ebe4f6a58c76a"],
                ...
                "step5": ["6169ba2036651c7498ee7d5c","6169ba2036651c7498ee7d5d"],
                ...
                "step7": ["6169ba2036651c7498ee7d5c"],
        }
    }
    ```