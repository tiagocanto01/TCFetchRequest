import CoreData

extension NSManagedObject {
    public static func makeFetchRequest<T>() -> NSFetchRequest<T> where T : NSManagedObject {
        Self.fetchRequest() as! NSFetchRequest<T>
    }
}
