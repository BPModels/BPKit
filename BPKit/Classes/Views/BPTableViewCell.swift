//
//  BPTableViewCell.swift
//  BPKit
//
//  Created by samsha on 2021/6/28.
//

import Foundation
import ObjectMapper

private struct AssociatedKeys {
    static var lineView: String = "kLineView"
}

open class BPTableViewCell: UITableViewCell {
    
    open func createSubviews() {}
    
    open func bindProperty() {
        self.separatorInset = UIEdgeInsets(top: 0, left: kScreenWidth, bottom: 0, right: 0)
    }
    
    open func bindData(model: Mappable, indexPath: IndexPath) {}
    
    /// 设置底部分割线
    /// - Parameters:
    ///   - left: 距左边距离
    ///   - right: 距右边距离
    public func setLine(isHide: Bool = false, left: CGFloat = AdaptSize(15), right: CGFloat = .zero) {
        // 追加属性
        if let lineView = objc_getAssociatedObject(self, &AssociatedKeys.lineView) as? UIView {
            lineView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(left)
                make.right.equalToSuperview().offset(right)
            }
            lineView.isHidden = isHide
        } else {
            let lineView = BPView()
            lineView.backgroundColor = UIColor.gray1
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(left)
                make.right.equalToSuperview().offset(right)
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
            lineView.isHidden = isHide
            objc_setAssociatedObject(self, &AssociatedKeys.lineView, lineView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
