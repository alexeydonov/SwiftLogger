//
//  GELFDestination.swift
//  SwiftLogger
//
//  Created by Alexey Donov on 25.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import Foundation

fileprivate extension LogLevel {
    var syslog: Int {
        switch self {
        case .trace: return 7
        case .debug: return 6
        case .info: return 5
        case .warning: return 4
        case .error: return 3
        case .fatal: return 1
        }
    }
}

open class GELFDestination: LogDestination {
    private let endpoint: URL
    
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }
    
    open func sendPayload(_ payload: LogPayload) {
        var gelfPayload: [String : Encodable] = [
            "version": "1.1",
            "host": "Muso.AI iOS",
            "level": payload.level.syslog,
            "short_message": String(describing: payload.content),
            "timestamp": payload.date.timeIntervalSince1970,
            "_device": payload.device,
            "_os": payload.os,
            "_environment": payload.environment,
            "_username": payload.username,
            "_file": payload.file,
            "_function": payload.function,
            "_line": payload.line
        ]
        
        if let dictionary = payload.content as? [String : Encodable] {
            dictionary.forEach {
                gelfPayload["_\($0)"] = $1
            }
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: gelfPayload, options: []) else { return }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = data
        
        session.dataTask(with: request).resume()
    }

    open private(set) lazy var session: URLSession = URLSession(configuration: configuration)
    
    open private(set) lazy var configuration: URLSessionConfiguration = {
        $0.networkServiceType = .background
        $0.sessionSendsLaunchEvents = false
        $0.httpAdditionalHeaders = [
            "Content-Type": "application/json"
        ]
        
        return $0
    }(URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).logging.gelf"))
}
