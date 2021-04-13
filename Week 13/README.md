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
![1](https://i.ibb.co/VDWnpH0/graph.jpg)


### Second exercise
##### First query
```json
MATCH (p:Fighter), (pp:Fighter) WHERE (p.weight = "155" or p.weight = "170" or p.weight = "185") and (p)-[:beats]->(pp) RETURN p;
```
![2](https://i.ibb.co/c1CD6Nn/graph.jpg)

##### Second query
```json
MATCH 
    (p:Fighter)-[p_c:beats]->(pp:Fighter), (pp)-[pp_c:beats]->(p)

WITH 
    p, pp,
    count(p_c) AS p_w, 
    count(pp_c) AS pp_w
    
WHERE
    p_w = 1 AND 
    pp_w = 1

RETURN p, pp
```
![3](https://i.ibb.co/ckz537v/graph.jpg)

##### Third query
```json
MATCH (p: Fighter {name: "Khabib Nurmagomedov"}), 
	(pp: Fighter) 
WHERE 
	(p)-[:beats*2..]->(pp) 
    and NOT (pp.name = p.name) 
RETURN pp;
```
![4](https://i.ibb.co/dkhK041/graph.jpg)

##### Fourth query
```json
MATCH (p:Fighter) WHERE NOT (()-[:beats]->(p) AND (p)-[:beats]->()) RETURN p;
```
![5](https://i.ibb.co/rmbYM98/graph.jpg)


##### Fifth query
```json
MATCH (p:Fighter) OPTIONAL MATCH (p)-[nice:beats]->()
    
WITH p, count(nice) AS w

OPTIONAL MATCH ()-[nice:beats]->(p)
    
WITH p, w, count(nice) AS l
    
SET p.w = w, p.l = l
    
RETURN p, w, l
```
![6](https://i.ibb.co/hL3n2z9/graph.jpg)

```json
╒══════════════════════════════════════════════════════════════════════╕
│"n"                                                                   │
╞══════════════════════════════════════════════════════════════════════╡
│{"wins":1,"w":1,"loses":0,"name":"Khabib Nurmagomedov","weight":"155",│
│"l":0}                                                                │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":1,"w":1,"loses":1,"name":"Rafael Dos Anjos","weight":"155","l"│
│:1}                                                                   │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":1,"w":1,"loses":1,"name":"Neil Magny","weight":"170","l":1}   │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":2,"w":2,"loses":1,"name":"Jon Jones","weight":"205","l":1}    │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":0,"w":0,"loses":1,"name":"Daniel Cormier","weight":"205","l":1│
│}                                                                     │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":3,"w":3,"loses":1,"name":"Michael Bisping","weight":"185","l":│
│1}                                                                    │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":1,"w":1,"loses":2,"name":"Matt Hamill","weight":"185","l":2}  │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":1,"w":1,"loses":1,"name":"Brandon Vera","weight":"205","l":1} │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":1,"w":1,"loses":1,"name":"Frank Mir","weight":"230","l":1}    │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":0,"w":0,"loses":1,"name":"Brock Lesnar","weight":"230","l":1} │
├──────────────────────────────────────────────────────────────────────┤
│{"wins":1,"w":1,"loses":2,"name":"Kelvin Gastelum","weight":"185","l":│
│2}                                                                    │
└──────────────────────────────────────────────────────────────────────┘
```

```json
﻿[
  {
    "n": {
"identity": 0,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 1,
"w": 1,
"loses": 0,
"name": "Khabib Nurmagomedov",
"weight": "155",
"l": 0
      }
    }
  },
  {
    "n": {
"identity": 1,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 1,
"w": 1,
"loses": 1,
"name": "Rafael Dos Anjos",
"weight": "155",
"l": 1
      }
    }
  },
  {
    "n": {
"identity": 2,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 1,
"w": 1,
"loses": 1,
"name": "Neil Magny",
"weight": "170",
"l": 1
      }
    }
  },
  {
    "n": {
"identity": 3,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 2,
"w": 2,
"loses": 1,
"name": "Jon Jones",
"weight": "205",
"l": 1
      }
    }
  },
  {
    "n": {
"identity": 4,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 0,
"w": 0,
"loses": 1,
"name": "Daniel Cormier",
"weight": "205",
"l": 1
      }
    }
  },
  {
    "n": {
"identity": 5,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 3,
"w": 3,
"loses": 1,
"name": "Michael Bisping",
"weight": "185",
"l": 1
      }
    }
  },
  {
    "n": {
"identity": 6,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 1,
"w": 1,
"loses": 2,
"name": "Matt Hamill",
"weight": "185",
"l": 2
      }
    }
  },
  {
    "n": {
"identity": 7,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 1,
"w": 1,
"loses": 1,
"name": "Brandon Vera",
"weight": "205",
"l": 1
      }
    }
  },
  {
    "n": {
"identity": 8,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 1,
"w": 1,
"loses": 1,
"name": "Frank Mir",
"weight": "230",
"l": 1
      }
    }
  },
  {
    "n": {
"identity": 9,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 0,
"w": 0,
"loses": 1,
"name": "Brock Lesnar",
"weight": "230",
"l": 1
      }
    }
  },
  {
    "n": {
"identity": 10,
"labels": [
        "Fighter"
      ],
"properties": {
"wins": 1,
"w": 1,
"loses": 2,
"name": "Kelvin Gastelum",
"weight": "185",
"l": 2
      }
    }
  }
]
```
