//
//  LogDestination.swift
//  SwiftLogger
//
//  Created by Alexey Donov on 25.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import Foundation

public protocol LogDestination {
    func sendPayload(_ payload: LogPayload)
}
