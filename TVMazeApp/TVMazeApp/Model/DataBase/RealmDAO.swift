//
//  RealmDAO.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/21/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - class to makes operations in database

public final class WriteTransaction {
    private let realm: Realm
    internal init(realm: Realm) {
        
        self.realm = realm
    }
    public func add<T: Persistable>(_ value: T, update: Realm.UpdatePolicy) {
        realm.add(value.managedObject(), update: update)
    }
    
    public func update<T: Persistable>(_ type: T.Type, values:[T.PropertyValue]) {
        
        var dictionary: [String: Any] = [:]
        
        values.forEach {
            let pair = $0.propertyValuePair
            dictionary[pair.name] = pair.value
        }
        
        realm.create(T.ManagedObject.self,
                     value: dictionary,
                     update: .modified)
    }
    
    func delete<T: Persistable>(_ value: T) {
        realm.delete(value.managedObject())
    }
}

public final class Container {
    
    private let realm: Realm
    
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    
    internal init(realm: Realm) {
        self.realm = realm
    }
    
    public func write(_ block: (WriteTransaction) throws -> Void)
        throws {
            let transaction = WriteTransaction(realm: realm)
            try realm.write {
                try block(transaction)
            }
    }
    
    public func values<T: Persistable> (_ type: T.Type, matching query: T.Query) -> FetchedResults<T> {
        
        var results = realm.objects(T.ManagedObject.self)
        if let predicate = query.predicate {
            results = results.filter(predicate)
        }
        results = results.sorted(by: query.sortDescriptors)
        return FetchedResults(results: results)
    }
}





// MARK: - Protocol to managed objects

public protocol Persistable {
    
    associatedtype ManagedObject: Object
    associatedtype PropertyValue: PropertyValueType
    associatedtype Query: QueryType
    
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

// MARK: - Protocol to update only one field from database\

public typealias PropertyValuePair = (name: String, value: Any)
public protocol PropertyValueType {
    var propertyValuePair: PropertyValuePair { get }
}

// MARK: - Protocol to QUERY

public protocol QueryType {
    var predicate: NSPredicate? { get }
    var sortDescriptors: [SortDescriptor] { get }
}

// MARK: - Class to fetch query results

public final class FetchedResults<T: Persistable> {
    internal let results: Results<T.ManagedObject>
    
    public var count: Int {
        return results.count
    }
    
    internal init(results: Results<T.ManagedObject>) {
        self.results = results
    }
    
    public func value(at index: Int) -> T {
        return T(managedObject: results[index])
    }
    
    func values() -> [T] {
        //return
        return [T](results.map({(manObj) -> T in
            return T(managedObject: manObj)})
        )
    }
}
