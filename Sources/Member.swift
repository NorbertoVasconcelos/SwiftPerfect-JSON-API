//
//  Member.swift
//  Perfect-JSON-APIPackageDescription
//
//  Created by Norberto Vasconcelos on 19/10/2017.
//

import PerfectHTTP

import StORM
import PostgresStORM

class Member: PostgresStORM {
    
    // Primary Key is the first property defined in the class.
    var memberId: Int = 0
    var name: String = ""
    var photoUrl: String = ""
    
    override init() { }
    
    init(name: String, photoUrl: String) {
        self.name = name
        self.photoUrl = photoUrl
    }
    
    override open func table() -> String {
        return "members"
    }
    
    override func to(_ this: StORMRow) {
        memberId = this.data["id"] as? Int ?? 0
        name = this.data["name"] as? String ?? ""
        photoUrl = this.data["photourl"] as? String ?? ""
    }
    
    func rows() -> [Member] {
        var rows = [Member]()
        for i in 0..<self.results.rows.count {
            let row = Member()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "memberid": self.memberId,
            "name": self.name,
            "photourl": self.photoUrl
        ]
    }
    
    func getMembers(request: HTTPRequest, response: HTTPResponse) {
        do {
            // Get all members in JSON format
            let getObj = Member()
            try getObj.findAll()
            var members: [[String: Any]] = []
            for row in getObj.rows() {
                members.append(row.asDictionary())
            }
            
            try response.setBody(json: members)
                .setHeader(.contentType, value: "application/json")
                .completed()
            
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
    
    func addMember(request: HTTPRequest, response: HTTPResponse) {
        do {
            // Save Member
            let name = request.param(name: "name", defaultValue: "") ?? ""
            let photoUrl = request.param(name: "photourl", defaultValue:  "") ?? ""
            let member = Member(name: name, photoUrl: photoUrl)
            
            try member.save {
                id in
                if let mId = id as? Int {
                    member.memberId = mId
                }
            }
            
            response.completed()
            
        } catch  {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
}
