//
//  ShoppingList.swift
//  Perfect-JSON-APIPackageDescription
//
//  Created by Norberto Vasconcelos on 18/10/2017.
//

import PerfectHTTP
import PerfectLib

public class ShoppingList: JSONConvertibleObject {
    // Container for array of type Item
    var data = [Item]()
    var name: String = ""
    
    // Populating with a mock data object
    init(name: String){
        self.name = name
        data = [
            Item(name: "Lasagna", description: "That tasty dinner we all love!")
        ]
    }
    
    // A simple JSON encoding function for listing data members.
    // Ordinarily in an API list directive, cursor commands would be included.
    public func list() -> String {
        return toString()
    }
    
    // Accepts the HTTPRequest object and adds a new Item from post params.
    public func add(_ request: HTTPRequest) -> String {
        let new = Item(
            name: request.param(name: "name") ?? "",
            description: request.param(name: "description") ?? ""
        )
        data.append(new)
        return toString()
    }
    
    // Accepts raw JSON string, to be converted to JSON and consumed.
    public func add(_ json: String) -> String {
        do {
            let incoming = try json.jsonDecode() as! [String: String]
            let new = Item(
                name: incoming["name"] ?? "",
                description: incoming["description"] ?? ""
            )
            data.append(new)
        } catch {
            return "ERROR"
        }
        return toString()
    }
    
    
    // Convenient encoding method that returns a string from JSON objects.
    private func toString() -> String {
        var out = [String]()
        
        for m in self.data {
            do {
                out.append(try m.jsonEncodedString())
            } catch {
                print(error)
            }
        }
        return "[\(out.joined(separator: ","))]"
    }
    
    override public func setJSONValues(_ values: [String : Any]) {
        self.name = getJSONValue(named: "name", from: values, defaultValue: "")
        self.data = getJSONValue(named: "items", from: values, defaultValue: [])
    }
    
    override public func getJSONValues() -> [String : Any] {
        return [
            "name":name,
            "items":data
        ]
    }
    
}
