//
//  Lists.swift
//  Perfect-JSON-APIPackageDescription
//
//  Created by Norberto Vasconcelos on 18/10/2017.
//

import PerfectHTTP

public class Lists {
    // Container for array of type ShoppingList
    var data = [ShoppingList]()
    
    // Populating with a mock data object
    init(){
        data = [
            ShoppingList(name: "Dinner List"),
            ShoppingList(name: "House List")
        ]
    }
    
    // A simple JSON encoding function for listing data members.
    // Ordinarily in an API list directive, cursor commands would be included.
    public func list() -> String {
        return toString()
    }
    
    // Accepts the HTTPRequest object and adds a new ShoppingList from post params.
    public func add(_ request: HTTPRequest) -> String {
        let new = ShoppingList(
            name: request.param(name: "name") ?? ""
        )
        data.append(new)
        return toString()
    }
    
    // Accepts raw JSON string, to be converted to JSON and consumed.
    public func add(_ json: String) -> String {
        do {
            let incoming = try json.jsonDecode() as! [String: String]
            let new = ShoppingList(
                name: incoming["name"] ?? ""
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
    
}
