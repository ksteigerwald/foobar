//
//  UploadHandler.swift
//  Upload Enumerator
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectLogger
import PerfectRedis
import Jobs
import StORM
import PostgresStORM
import PerfectSession

PostgresConnector.host		= "localhost"
PostgresConnector.username	= "postgres"
PostgresConnector.password	= "postgres"
PostgresConnector.database	= "portfolio_development"
PostgresConnector.port		= 5432

SessionConfig.CORS.enabled = true
SessionConfig.CORS.acceptableHostnames.append("http://localhost:8080")
SessionConfig.CORS.maxAge = 60


//let balance = Balance()

CoinMarket.shared.poll()

// Create HTTP server
let server = HTTPServer()

// Set the server's webroot
server.documentRoot = "./webroot"

// Add our routes and such
let routes = makeRoutes()
server.addRoutes(routes)

// Listen on port 8181
server.serverPort = 8181
do {
    // Launch the HTTP server on port 8181
    try server.start()
    
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}



