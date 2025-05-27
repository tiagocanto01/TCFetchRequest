import CoreData

import CoreData

public struct TCFetchRequest {
    
    private static func createRequest<T: NSManagedObject>(predicate: TCPredicate<T>? = nil, orderBy: [TCSorting<T>]? = nil) -> NSFetchRequest<NSManagedObject> {
        
        let request = T.makeFetchRequest()
        request.predicate = predicate?.toNSPredicate()
        request.sortDescriptors = orderBy?.compactMap { $0.sortDescriptor }
        
        return request
    }
    
    public static func makeFetchRequest<T: NSManagedObject>(from type: T.Type, where predicate: TCPredicate<T>? = nil, orderBy: TCSorting<T>..., limit: Int? = nil, offset: Int? = nil) -> NSFetchRequest<T> {
        
        let request = T.makeFetchRequest() as NSFetchRequest<T>
        request.predicate = predicate?.toNSPredicate()
        request.sortDescriptors = orderBy.compactMap { $0.sortDescriptor }
        
        if let limit {
            request.fetchLimit = limit
        }
        
        if let offset {
            request.fetchOffset = offset
        }
        
        return request
    }
    
    public static func requestFirst<T: NSManagedObject>(from type: T.Type, where predicate: TCPredicate<T>, orderBy: TCSorting<T>..., into context: NSManagedObjectContext) -> T? {
        
        let request = self.createRequest(predicate: predicate, orderBy: orderBy)
        request.fetchLimit = 1
        
        if let result = try? context.fetch(request) {
            return result.first as? T
        } else {
            return nil
        }
    }
    
    public static func requestAll<T: NSManagedObject>(from type: T.Type, orderBy: TCSorting<T>..., into context: NSManagedObjectContext) -> [T] {
        
        let request = self.createRequest(orderBy: orderBy)
        
        if let result = try? context.fetch(request) {
            return (result as? [T]) ?? []
        } else {
            return []
        }
    }
    
    public static func request<T: NSManagedObject>(from type: T.Type, where predicate: TCPredicate<T>, orderBy: TCSorting<T>..., limit: Int? = nil, into context: NSManagedObjectContext) -> [T] {
        
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
    
    public static func requestCount<T: NSManagedObject>(from type: T.Type, where predicate: TCPredicate<T>? = nil, into context: NSManagedObjectContext) -> Int {
        
        let request = self.createRequest(predicate: predicate)
        
        var count = 0
               
        if let countResult = try? context.count(for: request) {
            count = countResult
        }
               
        return count
    }
}

public class TCSorting<Root> {
    
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
    
    public static func asc<Value>(_ keyPath: KeyPath<Root, Value>) -> TCSorting<Root> {
        .init(keyPath, orderType: .asc)
    }
    
    public static func desc<Value>(_ keyPath: KeyPath<Root, Value>) -> TCSorting<Root> {
        .init(keyPath, orderType: .desc)
    }
}

public enum OrderType {
    case asc
    case desc
}

prefix operator <>
prefix operator ><
extension KeyPath {
    
    public static prefix func <>(rhs: KeyPath<Root, Value>) -> TCSorting<Root> {
        TCSorting(rhs, orderType: .asc)
    }
    
    public static prefix func ><(rhs: KeyPath<Root, Value>) -> TCSorting<Root> {
        TCSorting(rhs, orderType: .desc)
    }
}
