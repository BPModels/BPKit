//
//  BPTableViewHeaderFooterView.swift
//  BPKit
//
//  Created by samsha on 2021/7/14.
//

import Foundation

open class BPTableViewHeaderFooterView: UITableViewHeaderFooterView, BPViewDelegate {
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    // MARK: ==== BPViewDelegate ====
    open func createSubviews() {}
    
    open func bindProperty() {}
    
    open func bindData() {}
    
    open func updateUI() {
        // 默认颜色
        self.backgroundColor = UIColor.with(.white0, dark: .black0)
    }
}
