//
//  SwiftLogger.swift
//  SwiftLogger
//
//  Created by Alexey Donov on 25.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import Foundation

public final class SwiftLogger {
    public let environment: String
    
    public var username: String?
    
    public init(environment: String) {
        self.environment = environment
    }
    
    public func addDestination(_ destination: LogDestination) {
        destinations.append(destination)
    }
    
    public func write(_ message: Any, level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        let now = Date()
        
        let fileUrl = URL(string: file)!
        let cleanFile = fileUrl.lastPathComponent
        
        var cleanFunction = function
        if let parenthesisIndex = function.firstIndex(of: "(") {
            cleanFunction = String(function.prefix(upTo: parenthesisIndex))
        }
        
        let payload = LogPayload(date: now,
                                 device: cachedDevice,
                                 os: cachedOS,
                                 file: cleanFile,
                                 function: cleanFunction,
                                 line: line,
                                 environment: environment,
                                 username: username ?? cachedUUID,
                                 level: level,
                                 content: message)
        
        destinations.forEach {
            $0.sendPayload(payload)
        }
    }
    
    public func trace(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        write(message, level: .trace, file: file, function: function, line: line)
    }
    
    public func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        write(message, level: .debug, file: file, function: function, line: line)
    }
    
    public func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        write(message, level: .info, file: file, function: function, line: line)
    }
    
    public func warning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        write(message, level: .warning, file: file, function: function, line: line)
    }
    
    public func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        write(message, level: .error, file: file, function: function, line: line)
    }
    
    public func fatal(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        write(message, level: .fatal, file: file, function: function, line: line)
    }
    
    // MARK: Implementation
    
    private var destinations: [LogDestination] = []
    
    private lazy var cachedDevice: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        if let value = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return value
        } else {
            return identifier
        }
    }()
    
    private lazy var cachedOS: String = {
        return "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }()
    
    private lazy var cachedUUID: String = {
        return UIDevice.current.identifierForVendor!.uuidString
    }()
}
