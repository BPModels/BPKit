//
//  BPTextField.swift
//  Ant
//
//  Created by 沙庭宇 on 2020/12/28.
//

import Foundation

public enum BPTextFieldType {
    /// 常规
    case normal
    /// 纯数字（不包含小数）
    case onlyNumber
    /// 大写字母和数字
    case upLetterNumber
    /// 字母和数字
    case letterNumber
    /// 金额(包含小数)
    case money
}

open class BPTextField: UITextField, UITextFieldDelegate {
    
    private var type: BPTextFieldType
    /// 最长字符长度
    public var maxLength: Int    = .max
    /// 最多显示小数数量
    public var decimalCount: Int = 2
    /// 最大的金额数字
    public var maxMoney: Double?
    private var _maxMoney:Double?{
        // 取maxMoney
        if let maxMoney = self.maxMoney{
            return maxMoney
        }else{
            // 按maxLength得到最大整数，按decimalCount得到最大小数
            var _money:Double = 0
            var maxInteger:Double = 0
            if maxLength != .max{
                for index in 0..<maxLength{
                    maxInteger += 9.0*pow(10.0, Double(index))
                }
            }
            var maxDecimal:Double = 0
            for index in 0..<decimalCount{
                maxDecimal += 9.0/Double( pow(10.0, Double(index+1)) )
            }
            _money = maxInteger+maxDecimal
            
            return _money
        }
    }

    /// 编辑时闭包回调
    public var editingBlock: StringBlock?
    /// 编辑结束后闭包回调
    public var editFinishedBlock: StringBlock?
    
    public var showLeftView: Bool = true {
        willSet {
            if newValue {
                let _leftView = BPView(frame: CGRect(origin: .zero, size: CGSize(width: AdaptSize(15), height: AdaptSize(1))))
                _leftView.backgroundColor = UIColor.clear
                self.leftView     = _leftView
                self.leftViewMode = .always
            } else {
                self.leftView     = nil
                self.leftViewMode = .never
            }
        }
    }
    public var showBorder: Bool = false {
        willSet {
            if newValue {
                self.layer.borderWidth  = AdaptSize(0.6)
                self.layer.borderColor  = UIColor.gray1.cgColor
                self.layer.cornerRadius = AdaptSize(10)
            } else {
                self.layer.borderWidth  = 0
                self.layer.borderColor  = UIColor.clear.cgColor
                self.layer.cornerRadius = 0
                self.borderStyle        = .none
            }
        }
    }
    public var showRightView: Bool = false {
        willSet {
            if newValue {
                let _rightView = BPView(frame: CGRect(origin: .zero, size: CGSize(width: AdaptSize(15), height: AdaptSize(1))))
                _rightView.backgroundColor = UIColor.clear
                self.rightView     = _rightView
                self.rightViewMode = .always
            } else {
                self.rightView     = nil
                self.rightViewMode = .never
            }
        }
    }
    
    public init(type: BPTextFieldType = .normal) {
        self.type = type
        super.init(frame: .zero)
        self.bindProperty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindProperty() {
        self.delegate = self
        self.addTarget(self, action: #selector(editingAction), for: .editingChanged)
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    // MARK: ==== Event ====
    @objc
    private func editingAction() {
        self.editingBlock?(self.text ?? "")
    }
    
    // MARK: ==== UITextFieldDelegate ====
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if self.type == .money && Double(text) == 0 {
            textField.text = nil
        }
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.type != .money{
            guard let currentText = textField.text, string.isNotEmpty else { return true }
            // 长度判断
            if(currentText.count - range.length + string.count) > maxLength {
                textField.text = currentText.substring(maxIndex: maxLength)
                return false
            }
        }
 
        // 内容判断
        switch self.type {
        case .normal:
            return true
        case .onlyNumber:
            return self.isValidAboutOnlyNumberInputText(textField, shouldChangeCharactersIn: range, replacementString: string,decimalCount:decimalCount,maxNum: self._maxMoney)
        case .upLetterNumber:
            guard string.isUpLetterNumber() else {
                return false
            }
        case .letterNumber:
            guard string.isLetterNumber() else {
                return false
            }
        case .money:
            return self.isValidAboutMoneyInputText(textField, shouldChangeCharactersIn: range, replacementString: string,decimalCount:decimalCount,maxNum: self._maxMoney)
        }
        
        return true
    }
    
    /// 处理纯数字输入逻辑
    private func isValidAboutOnlyNumberInputText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, decimalCount:Int, maxNum:Double?) -> Bool {
        guard let currentText = textField.text else { return true }
        guard string.isOnlyNumber() else {
            return false
        }
        let tempStr = currentText.replacingCharacters(in: Range(range, in: currentText)! , with: string)
        if let maxNum = maxNum, let doubleValue = Double(tempStr), doubleValue >= maxNum {
            return false
        }
        return true
    }
    /// 处理金钱输入逻辑
    private func isValidAboutMoneyInputText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, decimalCount:Int, maxNum:Double?) -> Bool {
        guard let currentText = textField.text else { return true }
        // 输入框中只能输入数字和小数点，且小数点只能输入decimalCount位
        let scanner = Scanner(string: string)
        let numbers: CharacterSet
        let pointRange = (currentText as NSString).range(of: ".")
        if pointRange.length > 0 && (pointRange.length < range.location || pointRange.location > range.location + range.length){
            numbers = CharacterSet(charactersIn: "0123456789")
        }else{
            numbers = CharacterSet(charactersIn: "0123456789.")
        }
        if !scanner.scanCharacters(from: numbers as CharacterSet, into: nil) && string.count != 0 {
            return false
        }
        if currentText.isEmpty && string == "."{
            return false
        }
        /// 先模拟得到输入完成的内容,包括移动光标情况
        let tempStr = currentText.replacingCharacters(in: Range(range, in: currentText)! , with: string)
        let strlen:Int = tempStr.count
        // 判断输入框内是否含有“.”
        if pointRange.length > 0 && pointRange.location > 0 {
            if string == "."{//当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return false
            }
            //输入的位置位于小数点后面，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
            if range.location > pointRange.location && (strlen > 0 && (strlen - pointRange.location) > decimalCount+1) {
                return false
            }
        }
        let zeroRange = (currentText as NSString).range(of: "0")
        if zeroRange.length == 1 && zeroRange.location == 0 { // 判断输入框第一个字符是否为“0”
            // 当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，且输入的位置位于0的后面, 则将此输入替换输入框的这唯一字符。
            if string != "0" && string != "." && currentText.count == 1 && range.location > zeroRange.location {
                textField.text = string
                self.editingAction()
                return false
            } else {
                // 当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                if pointRange.length == 0 && pointRange.location > 0 {
                    if string == "0"{
                        return false
                    }
                }
            }
        }
        // 限制最大输入金额
        if let maxNum = maxNum, let doubleValue = Double(tempStr), doubleValue >= maxNum {
            return false
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.editFinishedBlock?(text ?? "")
    }
    
    public func updateType(type: BPTextFieldType) {
        self.type = type
    }
}
