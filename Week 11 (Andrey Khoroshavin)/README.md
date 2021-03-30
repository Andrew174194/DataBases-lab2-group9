1. Find all the documents in the collection restaurants
    ```
    db.restaurants.find({})
    ```
    Output: query1.json

2. Find the fields restaurant_id , name, borough and cuisine for all the documents in the collection restaurant.
    ```
    db.restaurants.find(
        {},
        {restaurant_id: 1,name: 1,borough: 1,cuisine: 1}
    )
    ```
    Output: query2.json

3. Find the first 5 restaurant which is in the borough Bronx.
    ```
    db.restaurants.find(
        {borough: 'Bronx'}
    ).limit(5)
    ```
    Output: query3.json

4. Find the restaurant Id, name, borough and cuisine for those restaurants which prepared dish except 'American' and 'Chinees' or restaurant's name begins with letter 'Wil’.
    ```
    db.restaurants.find(
        {$or:[{name:{$regex: RegExp('^Wil')}}, { $and:[{ cuisine:{$not:{$eq:'American '}}}, {cuisine:{$not:{$eq:'Chinese'}}}]}]},
        {restaurant_id: 1,name: 1,borough: 1,cuisine: 1}
    )
    ```
    Output: query4.json