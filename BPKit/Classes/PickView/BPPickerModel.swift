//
//  BPPickerModel.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/1/18.
//

import ObjectMapper

public struct BPPickerModel: Mappable {
    public var id: Int       = 0
    public var title: String = ""
    public var relation: Any?
    
    public init() {}
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {}
}
