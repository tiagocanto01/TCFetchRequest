import CoreData

struct TCFetchRequest {
    
    private static func createRequest<T: NSManagedObject>(predicate: TCPredicate<T>? = nil, orderBy: [TCSorting<T>]? = nil) -> NSFetchRequest<NSManagedObject> {
        
        let request = T.makeFetchRequest()
        request.predicate = predicate?.toNSPredicate()
        request.sortDescriptors = orderBy?.compactMap { $0.sortDescriptor }
        
        return request
    }
    
    static func requestFirst<T: NSManagedObject>(from type: T.Type, where predicate: TCPredicate<T>? = nil, orderBy: TCSorting<T>..., into context: NSManagedObjectContext) -> T? {
        
        let request = self.createRequest(predicate: predicate, orderBy: orderBy)
        request.fetchLimit = 1
        
        if let result = try? context.fetch(request) {
            return result.first as? T
        } else {
            return nil
        }
    }
    
    static func requestAll<T: NSManagedObject>(from type: T.Type, orderBy: TCSorting<T>..., into context: NSManagedObjectContext) -> [T] {
        
        let request = self.createRequest(orderBy: orderBy)
        
        if let result = try? context.fetch(request) {
            return (result as? [T]) ?? []
        } else {
            return []
        }
    }
    
    static func request<T: NSManagedObject>(from type: T.Type, where predicate: TCPredicate<T>, orderBy: TCSorting<T>..., limitedBy limit: Int? = nil, into context: NSManagedObjectContext) -> [T] {
        
        let request = self.createRequest(predicate: predicate, orderBy: orderBy)
        
        if let limit {
            request.fetchLimit = limit
        }
        
        if let result = try? context.fetch(request) {
            return (result as? [T]) ?? []
        } else {
            return []
        }
    }
    
    static func requestCount<T: NSManagedObject>(from type: T.Type, where predicate: TCPredicate<T>? = nil, into context: NSManagedObjectContext) -> Int {
        
        let request = self.createRequest(predicate: predicate)
        
        var count = 0
               
        if let countResult = try? context.count(for: request) {
            count = countResult
        }
               
        return count
    }
}

class TCSorting<Root> {
    
    private(set) var sortDescriptor: NSSortDescriptor
    
    init<Value>(_ keyPath: KeyPath<Root, Value>, orderType: OrderType) {
        
        let ascending: Bool
        switch orderType {
        case .asc:
            ascending = true
        case .desc:
            ascending = false
        }
        
        self.sortDescriptor = NSSortDescriptor(keyPath: keyPath, ascending: ascending)
    }
}

enum OrderType {
    case asc
    case desc
}

prefix operator <>
prefix operator ><
extension KeyPath {
    
    static prefix func <>(rhs: KeyPath<Root, Value>) -> TCSorting<Root> {
        TCSorting(rhs, orderType: .asc)
    }
    
    static prefix func ><(rhs: KeyPath<Root, Value>) -> TCSorting<Root> {
        TCSorting(rhs, orderType: .desc)
    }
}
