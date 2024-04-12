# TCFetchRequest
A better and simpler way to fetch request using core data


## Examples
The examples explain better how the things works.

```swift
let allUsersSortedByAge = TCFetchRequest.requestAll(from: User.self,
                                                    orderBy: .asc(\.age), // Youngers first
                                                    into: databaseMainContext)
        
let oldestUser = TCFetchRequest.requestFirst(from: User.self,
                                             orderBy: .desc(\.age),
                                             into: databaseMainContext)
        
let userWithSpecificEmail = TCFetchRequest.requestFirst(from: User.self,
                                                        where: \.email == "tiago@xyz.com",
                                                        into: databaseMainContext)
        
        
let usersUnder20 = TCFetchRequest.request(from: User.self,
                                          where: \.age < 20,
                                          orderBy: .asc(\.age),
                                          into: databaseMainContext)
        
let usersWithSpecificNameUnder30 = TCFetchRequest.request(from: User.self,
                                                          where: \.name == "Tiago" && \.age < 30,
                                                          orderBy: .asc(\.age), into: databaseMainContext)
        
        
let usersWithSpecificNameUnder30LimitedBy3 = TCFetchRequest.request(from: User.self,
                                                                    where: \.name == "Tiago" && \.age < 30,
                                                                    orderBy: .asc(\.age),
                                                                    limitedBy: 3,
                                                                    into: databaseMainContext)
```

I would like to point out that this framework still does not replace NSFetchRequest entirely, there are still some types of queries not supported in this framework, but I believe it is useful for 95% of cases

# Installation
 Via Swift Package Manager.
