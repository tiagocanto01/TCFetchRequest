# TCFetchRequest
A better and simpler way to fetch request using core data


## Examples
The examples explain better how the things works. I think it's important just explain the sorting operators I chose. I created the operator <> (less than ... greater than) for ascending order and the operator >< (greater than ... less than) for descending order.

```swift
let allUsersSortedByAge = TCFetchRequest.requestAll(from: User.self,
                                                    orderBy: <>\.age, // Youngers first
                                                    into: databaseMainContext)
        
let oldestUser = TCFetchRequest.requestFirst(from: User.self,
                                             orderBy: ><\.age,
                                             into: databaseMainContext)
        
let userWithSpecificEmail = TCFetchRequest.requestFirst(from: User.self,
                                                        where: \.email == "tiago@xyz.com",
                                                        into: databaseMainContext)
        
        
let usersUnder20 = TCFetchRequest.request(from: User.self,
                                          where: \.age < 20,
                                          orderBy: <>\.age,
                                          into: databaseMainContext)
        
let usersWithSpecificNameUnder30 = TCFetchRequest.request(from: User.self,
                                                          where: \.name == "Tiago" && \.age < 30,
                                                          orderBy: <>\.age, into: databaseMainContext)
        
        
let usersWithSpecificNameUnder30LimitedBy3 = TCFetchRequest.request(from: User.self,
                                                                    where: \.name == "Tiago" && \.age < 30,
                                                                    orderBy: <>\.age,
                                                                    limitedBy: 3,
                                                                    into: databaseMainContext)
```

I would like to point out that this framework still does not replace NSFetchRequest entirely, there are still some types of queries not supported in this framework, but I believe it is useful for 95% of cases
