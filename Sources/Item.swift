//
//  Item.swift
//  Perfect-JSON-APIPackageDescription
//
//  Created by Norberto Vasconcelos on 18/10/2017.
//
import PerfectLib

class Item : JSONConvertibleObject {
    
    static let registerName = "item"
    
    var name: String = ""
    var itemDescription: String = ""
    
    init(name: String, description: String) {
        self.name = name
        self.itemDescription = description
    }
    
    override public func setJSONValues(_ values: [String : Any]) {
        self.name = getJSONValue(named: "name", from: values, defaultValue: "")
        self.itemDescription = getJSONValue(named: "description", from: values, defaultValue: "")
    }
    
    override public func getJSONValues() -> [String : Any] {
        return [
            "name":name,
            "description":itemDescription,
        ]
    }
    
}
