### First exercise
```json
Create(p:Fighter {name: "Khabib Nurmagomedov",weight:"155"});
Create(p:Fighter {name: "Rafael Dos Anjos", weight:"155"});
Create(p:Fighter {name: "Neil Magny", weight:"170"});
Create(p:Fighter {name: "Jon Jones", weight:"205"});
Create(p:Fighter {name: "Daniel Cormier", weight:"205"});
Create(p:Fighter {name: "Michael Bisping",weight:"185"});
Create(p:Fighter {name: "Matt Hamill", weight:"185"});
Create(p:Fighter {name: "Brandon Vera", weight:"205"});
Create(p:Fighter {name: "Frank Mir", weight:"230"});
Create(p:Fighter {name: "Brock Lesnar", weight:"230"});
Create(p:Fighter {name: "Kelvin Gastelum", weight:"185"});


MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Khabib Nurmagomedov" AND b.name = "Rafael Dos Anjos" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Rafael Dos Anjos" AND b.name = "Neil Magny" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Jon Jones" AND b.name = "Daniel Cormier" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Michael Bisping" AND b.name = "Matt Hamill" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Jon Jones" AND b.name = "Brandon Vera" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Brandon Vera" AND b.name = "Frank Mir" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Frank Mir" AND b.name = "Brock Lesnar" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Neil Magny" AND b.name = "Kelvin Gastelum" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Kelvin Gastelum" AND b.name = "Michael Bisping" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Michael Bisping" AND b.name = "Matt Hamill" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Michael Bisping" AND b.name = "Kelvin Gastelum" CREATE (a)-[:beats]->(b);
MATCH (a:Fighter), (b:Fighter) WHERE a.name = "Matt Hamill" AND b.name = "Jon Jones" CREATE (a)-[:beats]->(b);
```
![1](https://i.ibb.co/JQggKBc/graph.jpg)
