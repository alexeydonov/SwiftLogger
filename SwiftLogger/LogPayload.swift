//
//  LogPayload.swift
//  SwiftLogger
//
//  Created by Alexey Donov on 25.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import Foundation

public struct LogPayload {
    public var date: Date
    public var device: String
    public var os: String
    public var file: String
    public var function: String
    public var line: Int
    public var environment: String
    public var username: String
    public var level: LogLevel
    public var content: Any
}
