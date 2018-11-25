//
//  LogstashDestination.swift
//  SwiftLogger
//
//  Created by Alexey Donov on 25.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import Foundation

extension LogLevel: Encodable { }

extension LogPayload: Encodable {
    enum Key: CodingKey {
        case date
        case device
        case os
        case file
        case function
        case line
        case environment
        case username
        case level
        case content
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(date, forKey: .date)
        try container.encode(device, forKey: .device)
        try container.encode(os, forKey: .os)
        try container.encode(file, forKey: .file)
        try container.encode(function, forKey: .function)
        try container.encode(line, forKey: .line)
        try container.encode(environment, forKey: .environment)
        try container.encode(username, forKey: .username)
        try container.encode(level, forKey: .level)
        if let encodableContent = content as? Encodable {
            try encodableContent.encode(to: container.superEncoder(forKey: .content))
        }
    }
}

open class LogstashDestination: LogDestination {
    private let endpoint: URL
    
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }
    
    open func sendPayload(_ payload: LogPayload) {
        guard let data = try? jsonEncoder.encode(payload) else { return }
        
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
    }(URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).logging.logstash"))
    
    open private(set) lazy var jsonEncoder: JSONEncoder = {
        $0.dateEncodingStrategy = .formatted(dateFormatter)
        
        return $0
    }(JSONEncoder())
    
    open private(set) lazy var dateFormatter: DateFormatter = {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        $0.timeZone = TimeZone(abbreviation: "GMT")
        
        return $0
    }(DateFormatter())
}
