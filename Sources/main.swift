//
//  Lists.swift
//  Perfect-JSON-APIPackageDescription
//
//  Created by Norberto Vasconcelos on 18/10/2017.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import StORM
import PostgresStORM

// Setup Postgres DB
PostgresConnector.host = "localhost"
PostgresConnector.username = "norberto"
PostgresConnector.password = "postgres"
PostgresConnector.database = "json_api"
PostgresConnector.port = 5432

let member = Member()
try? member.setup()

// Create HTTP server.
let server = HTTPServer()

// Create the container variable for routes to be added to.
var routes = Routes()

// Testing DB
routes.add(method: .get, uri: "/members", handler: member.getMembers)
routes.add(method: .post, uri: "/members/add", handler: member.addMember)

// Register your own routes and handlers
// This is an example "Hello, world!" HTML route
routes.add(method: .get, uri: "/", handler: {
	request, response in
	// Setting the response content type explicitly to text/html
	response.setHeader(.contentType, value: "text/html")
	// Adding some HTML to the response body object
	response.appendBody(string: "<html><title>JSON API</title><body>Welcome to the Shopping JSON API.</body></html>")
	// Signalling that the request is completed
	response.completed()
	}
)


// Adding a route to handle the GET people list URL
routes.add(method: .get, uri: "/api/v1/lists", handler: {
	request, response in

	let lists = Lists()

	// Setting the response content type explicitly to application/json
	response.setHeader(.contentType, value: "application/json")
	// Setting the body response to the JSON list generated
	response.appendBody(string: lists.list())
	// Signalling that the request is completed
	response.completed()
	}
)

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
