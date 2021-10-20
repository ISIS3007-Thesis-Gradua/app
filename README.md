# Serenity

* Types
    * Axiety
    * Stress
    * Other
## Endpoints
* **/randomize?time={time}**
    * GET: get a random meditation from db fiting the given time

* **/user-feedback**
    * POST: saves the user feedback form
        * Body: 
            ```Json
            {
            "score": 5,
            "stateBefore": 9,
            "stateAfter": 6,
            "objectiveType": "stress",
            "routine":{
                    "step00": ["6169c53d201ebe4f6a58c76a"],
                    ...
                    "step5": ["6169ba2036651c7498ee7d5c","6169ba2036651c7498ee7d5d"],
                    ...
                    "step7": ["6169ba2036651c7498ee7d5c"],
                }
            }
            ```