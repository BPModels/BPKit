//
//  BPTableViewCell.swift
//  BPKit
//
//  Created by samsha on 2021/6/28.
//

import Foundation
import ObjectMapper

open class BPTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func createSubviews() {}
    
    
    open func bindData(model: Mappable) {}
}
