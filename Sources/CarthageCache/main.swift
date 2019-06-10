//
//  File.swift
//  
//
//  Created by Ondrej Rafaj on 09/06/2019.
//

import Vapor
import ConsoleKit


let console = Terminal()

var commandInput = CommandInput(arguments: CommandLine.arguments)

func config() -> Cache.Config {
    var carthagePath: String?
    var cartfile: String?
    var server: String?
    
    var previous: String?
    for arg in commandInput.arguments {
        switch true {
        case previous == "-p":
            carthagePath = arg
        case previous == "-c":
            cartfile = arg
        case previous == "-s":
            server = arg
        case arg == "-h" || arg == "--help":
            print("Arguments:")
            print("    -s https://cache_server.example.com")
            print("    -p /path/to/Carthage folder")
            print("    -c (optional) /path/to/Cartfile")
            exit(0)
        default:
            previous = arg
            continue
        }
        previous = arg
    }
    
    guard let p = carthagePath else {
        fatalError("Missing Carthage path (-p PATH)")
    }
    
    guard let s = server else {
        fatalError("Missing server url (-s http://example.com)")
    }
    
    print("Cache server URL: \(s)")
    print("Carthage folder path: \(p)")
    
    if cartfile == nil {
        let url = URL(fileURLWithPath: p)
        cartfile = url.deletingLastPathComponent().path
    }
    
    print("Cartfile path: \(cartfile!)")
    
    return Cache.Config(
        path: p,
        server: s,
        cartfile: cartfile!
    )
}

print("carthage-cache by Einstore, the open source enterprise appstore solution")
print("https://github.com/Einstore/carthage-cache")

let cache = Cache(config())
cache.run()
