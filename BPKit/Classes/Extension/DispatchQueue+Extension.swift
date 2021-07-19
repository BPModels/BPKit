//
//  DispatchQueue+Extension.swift
//  BPKit
//
//  Created by samsha on 2021/7/15.
//

import Foundation

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()

    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
