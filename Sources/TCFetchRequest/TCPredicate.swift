import Foundation

protocol TCPredicateProtocol {
    func toNSPredicate() -> NSPredicate
}

prefix operator *
extension TCPredicateProtocol {
    static prefix func *(rhs: Self) -> NSPredicate {
        rhs.toNSPredicate()
    }
}

class TCPredicate<Root>: TCPredicateProtocol {
    func toNSPredicate() -> NSPredicate {
        NSPredicate()
    }
}

class TCComparisonExpressionPredicate<Root, Value>: TCPredicate<Root> {
    
    enum ComparisonOperation {
        case equals
        case notEqual
        case greaterThan
        case greaterThanOrEqual
        case lessThanOrEqual
        case lessThan
        
        var symbol: String {
            switch self {
            case .equals:
                return "="
            case .notEqual:
                return "!="
            case .greaterThan:
                return ">"
            case .greaterThanOrEqual:
                return ">="
            case .lessThan:
                return "<"
            case .lessThanOrEqual:
                return "<="
            }
        }
    }
    
    private var property: KeyPath<Root, Value>
    private var value: Value
    private var comparison: ComparisonOperation
    
    private var format: String {
        "%K \(self.comparison.symbol) %@"
    }
    
    init(property: KeyPath<Root, Value>, comparison: ComparisonOperation, value: Value) {
        self.property = property
        self.comparison = comparison
        self.value = value
    }
    
    override func toNSPredicate() -> NSPredicate {
        NSPredicate(format: self.format, argumentArray: [NSExpression(forKeyPath: self.property).keyPath,
                                                                self.value])
    }
}

extension KeyPath {
    static func ==(lhs: KeyPath<Root, Value>, rhs: Value) -> TCCompoundPredicate<Root> {
        TCCompoundPredicate(operation: .same(predicate: TCComparisonExpressionPredicate(property: lhs, comparison: .equals, value: rhs)))
    }
    
    static func !=(lhs: KeyPath<Root, Value>, rhs: Value) -> TCCompoundPredicate<Root> {
        TCCompoundPredicate(operation: .same(predicate: TCComparisonExpressionPredicate(property: lhs, comparison: .notEqual, value: rhs)))
    }
    
    static func >(lhs: KeyPath<Root, Value>, rhs: Value) -> TCCompoundPredicate<Root> {
        TCCompoundPredicate(operation: .same(predicate: TCComparisonExpressionPredicate(property: lhs, comparison: .greaterThan, value: rhs)))
    }
    
    static func >=(lhs: KeyPath<Root, Value>, rhs: Value) -> TCCompoundPredicate<Root> {
        TCCompoundPredicate(operation: .same(predicate: TCComparisonExpressionPredicate(property: lhs, comparison: .greaterThanOrEqual, value: rhs)))
    }
    
    static func <(lhs: KeyPath<Root, Value>, rhs: Value) -> TCCompoundPredicate<Root> {
        TCCompoundPredicate(operation: .same(predicate: TCComparisonExpressionPredicate(property: lhs, comparison: .lessThan, value: rhs)))
    }
    
    static func <=(lhs: KeyPath<Root, Value>, rhs: Value) -> TCCompoundPredicate<Root> {
        TCCompoundPredicate(operation: .same(predicate: TCComparisonExpressionPredicate(property: lhs, comparison: .lessThanOrEqual, value: rhs)))
    }
}

enum TCCompoundPredicateOperation<Root> {
    case and(leftSide: TCPredicate<Root>, rightSide: TCPredicate<Root>)
    case or(leftSide: TCPredicate<Root>, rightSide: TCPredicate<Root>)
    case not(predicate: TCPredicate<Root>)
    case same(predicate: TCPredicate<Root>)
}

class TCCompoundPredicate<Root>: TCPredicate<Root> {
    
    var operation: TCCompoundPredicateOperation<Root>
    
    init(operation: TCCompoundPredicateOperation<Root>) {
        self.operation = operation
    }
    
    override func toNSPredicate() -> NSPredicate {
        let predicate: NSPredicate
        
        switch self.operation {
        case let .and(leftPredicate, rightPredicate):
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [leftPredicate.toNSPredicate(), rightPredicate.toNSPredicate()])
        case let .or(leftPredicate, rightPredicate):
            predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [leftPredicate.toNSPredicate(), rightPredicate.toNSPredicate()])
        case let .not(subPredicate):
            predicate = NSCompoundPredicate(notPredicateWithSubpredicate: subPredicate.toNSPredicate())
        case let .same(subPredicate):
            predicate = subPredicate.toNSPredicate()
        }
        
        return predicate
    }
    
    static func &&(lhs: TCCompoundPredicate, rhs: TCCompoundPredicate) -> TCCompoundPredicate {
        TCCompoundPredicate(operation: .and(leftSide: lhs, rightSide: rhs))
    }
    
    static func ||(lhs: TCCompoundPredicate, rhs: TCCompoundPredicate) -> TCCompoundPredicate {
        TCCompoundPredicate(operation: .or(leftSide: lhs, rightSide: rhs))
    }
    
    static prefix func !(rhs: TCCompoundPredicate) -> TCCompoundPredicate {
        TCCompoundPredicate(operation: .not(predicate: rhs))
    }
}

