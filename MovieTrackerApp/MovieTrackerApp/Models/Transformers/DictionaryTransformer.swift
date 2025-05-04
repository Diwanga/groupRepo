//
//  DictionaryTransformer.swift
//  MovieTrackerApp
//
//  Created by Diwanga Amasith on 2025-05-03.
//
import Foundation
import CoreData

// For storing dictionaries in Core Data
class DictionaryTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSDictionary.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let dict = value as? [String: Int] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: true)
            return data
        } catch {
            print("Error transforming dictionary: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, NSString.self, NSNumber.self], from: data)
        } catch {
            print("Error reverse transforming dictionary: \(error)")
            return nil
        }
    }
}

extension DictionaryTransformer {
    static let name = NSValueTransformerName(rawValue: "DictionaryTransformer")
    
    public static func register() {
        let transformer = DictionaryTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
