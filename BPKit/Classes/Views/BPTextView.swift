//
//  BPTextView.swift
//  Tenant
//
//  Created by samsha on 2021/3/25.
//

import Foundation
import IQKeyboardManager

public protocol BPTextViewDelegate: NSObjectProtocol {
    func textViewDidChange(_ textView: UITextView)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)
}

extension BPTextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {}
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) {}
}

open class BPTextView: IQTextView, UITextViewDelegate, BPViewDelegate {
    public var maxLength: Int = .max
    
    public weak var delegateBP: BPTextViewDelegate?
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.bindProperty()
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
    
    open func bindProperty() {
        self.delegate = self
        self.contentInset = UIEdgeInsets(top: AdaptSize(10), left: AdaptSize(10), bottom: AdaptSize(10), right: AdaptSize(10))
    }
    
    open func bindData() {}
    
    open func updateUI() {}
    
    // MARK: ==== UITextViewDelegate ====
    
    public func textViewDidChange(_ textView: UITextView) {
        self.delegateBP?.textViewDidChange(textView)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        defer {
            self.delegateBP?.textView(textView, shouldChangeTextIn: range, replacementText: text)
        }
        
        if text.isEmpty { return true }
        guard (textView.text.count - range.length) < maxLength else {
            return false
        }
        if (textView.text.count - range.length + text.count) > maxLength {
            let subtext = text.substring(maxIndex: maxLength - textView.text.count)
            textView.text += subtext
            return false
        } else {
            return true
        }
    }
}
