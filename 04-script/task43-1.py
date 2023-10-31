#!/usr/bin/python3

json_dict = { "info" : "Sample JSON output from our service",
             "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : "7.1.7.5"
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
print(json_dict)
