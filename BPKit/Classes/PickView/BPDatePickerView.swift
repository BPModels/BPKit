//
//  BPDatePickerView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/1/19.
//

import Foundation
public enum BPDatePickerType {
    case day
    case month
    case year
}

public class BPDatePickerView: BPTopWindowView {
    private var title:String?
    private var subtitle:String?
    private var type: BPDatePickerType
    private var onTitleClick:(()->Void)?
    private var selectedBlock: ((Date)->Void)?

    private var contentView: BPView = {
        let view = BPView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: AdaptSize(450) + kSafeBottomMargin))
        view.backgroundColor = UIColor.white0
        view.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(10))
        return view
    }()
    private var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(17))
        label.textAlignment = .center
        return label
    }()
    private var titleTipButton: BPButton = {
        let button = BPButton()
        return button
    }()
    private var subtitleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.gray2
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()
    
    private var closeButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.close.rawValue, for: .normal)
        button.setTitleColor(UIColor.black0, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(11))
        return button
    }()
    private var confirmButton: BPButton = {
        let button = BPButton(.second)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.white0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        return button
    }()
    public let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh-Hans")
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()
    
    public init(type: BPDatePickerType = .day, selected block: ((Date)->Void)?) {
        self.type = type
        super.init(frame: .zero)
        self.selectedBlock = block
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    public init(title:String?, subtitle:String?, type: BPDatePickerType = .day,selected block: ((Date)->Void)?) {
        self.title = title
        self.subtitle = subtitle
        self.type = type
        super.init(frame: .zero)
        self.selectedBlock = block
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(datePicker)
        contentView.addSubview(confirmButton)
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kScreenHeight)
            make.left.right.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(AdaptSize(15))
            make.right.equalTo(-AdaptSize(15))
            make.top.equalTo(AdaptSize(25))
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(subtitle == nil ? 0 : AdaptSize(10))
            make.left.equalTo(AdaptSize(15))
            make.right.equalTo(-AdaptSize(15))
        }
        let buttonSize = CGSize(width: AdaptSize(45), height: AdaptSize(70))
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(buttonSize)
        }
        datePicker.snp.makeConstraints { (make) in
            make.top.equalTo(subtitleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(200))
        }
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(datePicker.snp.bottom)
            make.size.equalTo(CGSize(width: AdaptSize(185), height: AdaptSize(40)))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-30) - kSafeBottomMargin)
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard datePicker.subviews.first?.subviews.first?.subviews.count == 3 else {
            return
        }
        switch type {
        case .year:
            datePicker.subviews.first?.subviews.first?.subviews[0].isHidden = false
            datePicker.subviews.first?.subviews.first?.subviews[1].isHidden = true
            datePicker.subviews.first?.subviews.first?.subviews[2].isHidden = true
            datePicker.subviews.first?.subviews.first?.subviews[0].left += AdaptSize(75)
        case .month:
            datePicker.subviews.first?.subviews.first?.subviews[0].isHidden = false
            datePicker.subviews.first?.subviews.first?.subviews[1].isHidden = false
            datePicker.subviews.first?.subviews.first?.subviews[2].isHidden = true
            datePicker.subviews.first?.subviews.first?.subviews[0].left += AdaptSize(20)
            datePicker.subviews.first?.subviews.first?.subviews[1].left += AdaptSize(70)
        case .day:
            break
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.closeButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    public override func bindData() {
        super.bindData()
        self.titleLabel.text = self.title ?? "请选择日期"
        self.subtitleLabel.text = self.subtitle
    }
    
    // MARK: ==== Event ====
    @discardableResult
    public func setTitleIcon(icon: UIImage?, direction:BPDirectionType = .right) -> Self{
        if let _icon = icon{
            let attachment = NSTextAttachment()
            attachment.image = _icon
            //计算图片大小，与文字同高，按比例设置宽度
            let imgH = self.titleLabel.font.pointSize
            let imgW = (_icon.size.width / _icon.size.height) * imgH;
            //计算文字padding-top ，使图片垂直居中
            let textPaddingTop = (self.titleLabel.font.lineHeight - self.titleLabel.font.pointSize) / 2;
            attachment.bounds = CGRect(x: 0, y: -textPaddingTop , width: imgW, height: imgH);
            let attr = NSMutableAttributedString()
            let mAttr = NSMutableAttributedString(attachment: attachment)
            let titleStr = titleLabel.text ?? ""
            if direction == .left {
                attr.append(mAttr)
                attr.append(NSAttributedString(string: " " + titleStr))
            }else if direction == .right{
                attr.append(NSAttributedString(string:titleStr + " "))
                attr.append(mAttr)
            }
            titleLabel.attributedText = attr
        }
        return self
    }
    
    
    @discardableResult
    public func setOnTitleClick(block:@escaping (()->Void)) -> Self{
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickTitleAction)))
        self.onTitleClick = block
        return self
    }
    
    @discardableResult
    public func setMaxDate(date: Date) -> Self{
        self.datePicker.maximumDate = date
        return self
    }
    
    @discardableResult
    public func setMinDate(date: Date) -> Self{
        self.datePicker.minimumDate = date
        return self
    }
    
    public override func show(view: UIView = kWindow) {
        super.show(view: view)
        self.contentView.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.height)
        }
    }
    
    @objc
    public override func hide() {
        super.hide()
        UIView.animate(withDuration: 0.25) { [weak self] in
               guard let self = self else { return }
               self.contentView.transform = .identity
        } completion: { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc
    func confirmAction() {
        let date = self.datePicker.date
        self.selectedBlock?(date)
        self.hide()
    }
    
    @objc
    private func clickTitleAction() {
        self.onTitleClick?()
    }
}
