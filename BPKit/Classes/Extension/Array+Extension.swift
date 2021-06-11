//
//  Array+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/28.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

extension Array {
    func transformJson() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            return ""
        }

        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return ""
        }
        return str
    }
}
