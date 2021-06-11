//
//  BPTextView.swift
//  Tenant
//
//  Created by samsha on 2021/3/25.
//

import Foundation
import IQKeyboardManager

protocol BPTextViewDelegate: NSObjectProtocol {
    func textViewDidChange(_ textView: UITextView)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)
}

extension BPTextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {}
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) {}
}

class BPTextView: IQTextView, UITextViewDelegate {
    var maxLength: Int = .max
    
    var delegateBP: BPTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindProperty() {
        self.delegate = self
        self.contentInset = UIEdgeInsets(top: AdaptSize(10), left: AdaptSize(10), bottom: AdaptSize(10), right: AdaptSize(10))
    }
    
    // MARK: ==== UITextViewDelegate ====
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegateBP?.textViewDidChange(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
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
