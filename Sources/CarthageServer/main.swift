//
//  File.swift
//  
//
//  Created by Ondrej Rafaj on 02/07/2019.
//

import Vapor


enum ServerError: Error {
    case invalidKey
    case invalidData
    case missingData
}

func routes(_ r: Routes, _ c: Container) throws {
    func url(for hash: String) -> URL {
        return URL(fileURLWithPath: "/tmp/\(hash).framework-cache")
    }
    
    r.get("build") { req -> Response in
        guard let hash = req.parameters.get("hash") else {
            throw ServerError.invalidKey
        }
        guard let data = try? Data(contentsOf: url(for: hash)) else {
            throw ServerError.missingData
        }
        return Response(
            status: .ok,
            headers: [
                "Content-Type": "application/tar+gzip"
            ],
            body: .init(data: data)
        )
    }
    
    r.post("build") { req -> Response in
        guard let hash = req.parameters.get("hash") else {
            throw ServerError.invalidKey
        }
        var d = req.body.data
        guard let readableBytes = req.body.data?.readableBytes, let data: Data = d?.readData(length: readableBytes) else {
            throw ServerError.invalidData
        }
        try data.write(to: url(for: hash))
        return Response(
            status: .noContent
        )
    }
}

func configure(_ s: inout Services) throws {
    s.extend(Routes.self) { r, c in
        try routes(r, c)
    }
    
    s.register(MiddlewareConfiguration.self) { c in
        var middlewares = MiddlewareConfiguration()
        try middlewares.use(c.make(ErrorMiddleware.self))
        return middlewares
    }
}


func app(_ environment: Environment) throws -> Application {
    let app = Application(environment: environment) { s in
        try configure(&s)
    }
    try app.boot()
    return app
}

try app(.detect()).run()
