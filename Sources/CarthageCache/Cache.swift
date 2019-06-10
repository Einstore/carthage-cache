//
//  Cache.swift
//  
//
//  Created by Ondrej Rafaj on 09/06/2019.
//

import Foundation


class Cache {
    
    struct Config {
        let path: String
        let server: String
        let cartfile: String
    }
    
    let config: Config
    
    init(_ config: Config) {
        self.config = config
    }
    
    func run() {
        print(config)
        
        checkConfig()
        
        
    }
    
}

extension Cache {
    
    func checkConfig() {
        var dir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: config.path, isDirectory: &dir), dir.boolValue == true else {
            fatalError("Carthage folder doesn't exist")
        }
        
        // Check Cartfile exists
        // Check Cartfile.lock
    }
    
}
