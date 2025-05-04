//
//  ArrayTransformer.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//


// MARK: - Category Transformations for Arrays and Dictionaries in Core Data

import Foundation
import CoreData

// For storing arrays in Core Data
class ArrayTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [Any] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
            return data
        } catch {
            print("Error transforming array: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self, NSNumber.self], from: data)
        } catch {
            print("Error reverse transforming array: \(error)")
            return nil
        }
    }
}


extension ArrayTransformer {
    static let name = NSValueTransformerName(rawValue: "ArrayTransformer")
    
    public static func register() {
        let transformer = ArrayTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
