//  通用Cell
//  BPCommonTableViewCell.swift
//  BPKit
//
//  Created by samsha on 2021/7/9.
//

import Foundation
import ObjectMapper
import BPCommon

public class BPCommonTableViewCell: BPTableViewCell {
    
    /// 是否必选
    public var isRequired: Bool = false
    
    private var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.font          = UIFont.regularFont(ofSize: AdaptSize(17))
        label.textAlignment = .left
        return label
    }()
    private let textField: BPTextField = {
        let textField = BPTextField()
        textField.placeholder   = ""
        textField.font          = UIFont.regularFont(ofSize: AdaptSize(17))
        textField.textAlignment = .right
        return textField
    }()
    private var iconImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var unitLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.font          = UIFont.regularFont(ofSize: 17)
        label.textAlignment = .right
        return label
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bindProperty()
        self.updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(textField)
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(unitLabel)
        
        titleLabel.sizeToFit()
        titleLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(isRequired ? 10 : 20))
            make.top.height.equalToSuperview()
            make.width.equalTo(titleLabel.width)
        }
        if iconImageView.image != nil {
            textField.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel.snp.right).offset(AdaptSize(10))
                make.top.height.equalToSuperview()
            }
            // 显示icon
            iconImageView.snp.remakeConstraints { make in
                make.left.equalTo(textField.snp.right).offset(AdaptSize(10))
                make.size.equalTo(iconImageView.image?.size ?? CGSize(width: AdaptSize(17), height: AdaptSize(17)))
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(AdaptSize(-15))
            }
        } else if (unitLabel.text ?? "").isNotEmpty {
            textField.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel.snp.right).offset(AdaptSize(10))
                make.top.height.equalToSuperview()
            }
            // 显示单位
            unitLabel.sizeToFit()
            unitLabel.snp.remakeConstraints { make in
                make.left.equalTo(textField.snp.right).offset(AdaptSize(10))
                make.size.equalTo(unitLabel.size)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(AdaptSize(-15))
            }
        } else {
            textField.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel.snp.right).offset(AdaptSize(10))
                make.top.height.equalToSuperview()
                make.right.equalToSuperview().offset(AdaptSize(-15))
            }
        }
    }
    
    public override func bindProperty() {
        self.selectionStyle = .none
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.createSubviews()
    }
    
    public override func bindData(model: Mappable, indexPath: IndexPath) {
        super.bindData(model: model, indexPath: indexPath)
    }
    
    public override func updateUI() {
        super.updateUI()
        titleLabel.textColor = UIColor.with(.black0, dark: .gray0)
        textField.textColor  = UIColor.with(.black0, dark: .gray0)
        unitLabel.textColor  = UIColor.with(.black0, dark: .gray0)
    }
    
    // MARK: ==== Event ====
    /// 配置数据
    /// - Parameters:
    ///   - isRequired: 是否必选
    ///   - title: 标题
    ///   - placeholder: 默认
    ///   - canEdit: 是否可编辑
    ///   - icon: 图标
    ///   - unit: 单位
    ///   - hideLine: 是否显示底部分割线
    public func setData(_ isRequired: Bool, title: String?, content: String?, placeholder: String?, canEdit: Bool, maxLength:Int = .max,icon: UIImage?, unit: String?, hideLine: Bool = true, editBlock: StringBlock?) {
        self.isRequired             = isRequired
        self.titleLabel.text        = title
        self.textField.text         = content
        self.textField.placeholder  = placeholder
        self.textField.maxLength    = maxLength
        self.iconImageView.image    = icon
        self.unitLabel.text         = unit
        self.textField.editingBlock = editBlock
        if isRequired {
            self.titleLabel.setRequiredIcon()
        }
        self.setLine(isHide: hideLine)
        self.textField.isUserInteractionEnabled = canEdit
    }
}
