//
//  BPWebViewImplementClass.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/22.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

open class BPWebViewImplementClass: NSObject {
    public func jsToOcWithPrams(_ parms: [String:Any])  {
        BPLog("jsToOcWithPrams, params : \(parms)")
    }
    
    public func jsToOcNoPrams() {
        BPLog("jsToOcNoPrams")
    }
    
    public func goBackValue() -> String {
        BPLog("goBackValue")
        return "sam"
    }
    
}
