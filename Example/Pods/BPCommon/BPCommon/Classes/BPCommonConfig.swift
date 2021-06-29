//
//  BPCommonConfig.swift
//  BPCommon
//
//  Created by samsha on 2021/6/23.
//

import Foundation

public protocol BPCommonConfigDelegate: NSObjectProtocol {
    func printLog(log: String)
}

public struct BPCommonConfig {
    public static var share = BPCommonConfig()
    
    public weak var delegate: BPCommonConfigDelegate?
    
}
