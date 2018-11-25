//
//  ConsoleDestination.swift
//  SwiftLogger
//
//  Created by Alexey Donov on 25.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import Foundation

open class ConsoleDestination: LogDestination {
    open func sendPayload(_ payload: LogPayload) {
        print("\(dateFormatter.string(from: payload.date)) \(payload.level.rawValue) \(payload.file):\(payload.function):\(payload.line) \(payload.content)")
    }
    
    open private(set) lazy var dateFormatter: DateFormatter = {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
        $0.timeZone = Locale.current.calendar.timeZone
        
        return $0
    }(DateFormatter())
}
