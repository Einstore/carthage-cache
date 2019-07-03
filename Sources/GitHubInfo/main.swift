//
//  main.swift
//  
//
//  Created by Ondrej Rafaj on 09/06/2019.
//

import Vapor
import ConsoleKit
import GitHubKit


let console = Terminal()

var commandInput = CommandInput(arguments: CommandLine.arguments)

struct Config {
    let server: String
    let token: String
    let username: String
    let org: String
    let repo: String
    let tag: String
    let proxy: HTTPClient.Proxy?
    let fullCommit: Bool
}

func config() -> Config {
    var accessToken: String?
    var username: String?
    var server: String?
    var org: String?
    var repo: String?
    var tag: String?
    var verbose: Bool = false
    var proxy: HTTPClient.Proxy?
    var fullCommit: Bool = false
    
    var previous: String?
    for arg in commandInput.arguments {
        switch true {
        case previous == "-t":
            accessToken = arg
        case previous == "-u":
            username = arg
        case previous == "-s":
            server = arg
        case previous == "-o":
            org = arg
        case previous == "-r":
            repo = arg
        case previous == "-v":
            tag = arg
        case previous == "-p":
            let split = arg.split(separator: ":")
            guard split.count == 2, let host = split.first, let portString = split.last, let port = Int(portString) else {
                fatalError("Invalid proxy settings, please use format host:port (proxy.example.com:83)")
            }
            proxy = HTTPClient.Proxy.server(host: String(host), port: port)
        case arg == "--verbose":
            verbose = true
            previous = arg
        case arg == "--full":
            fullCommit = true
            previous = arg
        case arg == "-h" || arg == "--help":
            print("Arguments:")
            print("    -p (optional) Proxy, format host:port, ex proxy.example.com:83")
            print("    -s (optional) https://github.example.com")
            print("    -u GitHub username")
            print("    -t GitHub private access token")
            print("    -o Organization")
            print("    -r Repo")
            print("    -v Tag")
            print("    --full Full commit info (as pretty printed json)")
            print("    --verbose Print debug comments")
            exit(0)
        default:
            previous = arg
            continue
        }
        previous = arg
    }
    
    guard let t = accessToken else { fatalError("Missing GitHub private access token (-t)") }
    guard let u = username else { fatalError("Missing GitHub username (-u)") }
    guard let o = org else { fatalError("Missing GitHub organization (-o)") }
    guard let r = repo else { fatalError("Missing GitHub repo (-r)") }
    guard let v = tag else { fatalError("Missing GitHub tag (-v)") }
    
    let s = server ?? "https://api.github.com/"
    
    if verbose {
        print("GitHub server URL: \(s)")
        print("GitHub username: \(u)")
        print("GitHub private access token: ***************")
        print("GitHub organization: \(o)")
        print("GitHub repo: \(r)")
        print("GitHub tag: \(v)")
        print("Print full commit info: \(fullCommit)")
    }
    
    return Config(
        server: s,
        token: t,
        username: u,
        org: o,
        repo: r,
        tag: v,
        proxy: proxy,
        fullCommit: fullCommit
    )
}

let c = config()

let github = try Github(Github.Config(username: c.username, token: c.token, server: c.server), proxy: c.proxy)

if c.fullCommit == true {
    let future: EventLoopFuture<String> = try Tag.query(on: github).get(org: c.org, repo: c.repo).flatMap { tags in
        for tag in tags {
            if tag.name == c.tag {
                let future: EventLoopFuture<Commit> = try! Commit.query(on: github).get(org: c.org, repo: c.repo, sha: tag.commit.sha)
                return future.map { commit in
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let data = try! encoder.encode(commit)
                    return String(data: data, encoding: .utf8)!
                }
            }
        }
        fatalError()
    }
    let commit = try future.wait()
    print(commit)
} else {
    let future: EventLoopFuture<String> = try Tag.query(on: github).get(org: c.org, repo: c.repo).map { tags in
        for tag in tags {
            if tag.name == c.tag {
                return tag.commit.sha
            }
        }
        fatalError()
    }
    let commit = try future.wait()
    print(commit)
}
