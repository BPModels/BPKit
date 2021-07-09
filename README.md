# BPKit

[![CI Status](https://img.shields.io/travis/TestEngineerFish/BPKit.svg?style=flat)](https://travis-ci.org/TestEngineerFish/BPKit)
[![Version](https://img.shields.io/cocoapods/v/BPKit.svg?style=flat)](https://cocoapods.org/pods/BPKit)
[![License](https://img.shields.io/cocoapods/l/BPKit.svg?style=flat)](https://cocoapods.org/pods/BPKit)
[![Platform](https://img.shields.io/cocoapods/p/BPKit.svg?style=flat)](https://cocoapods.org/pods/BPKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BPKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BPKit'
```

## Author

TestEngineerFish, 916878440@qq.com

## License

BPKit is available under the MIT license. See the LICENSE file for more info.



## USE

### BPTableView

* 刷新、加载更多

    ```swift
    /// 开启下拉刷新
    tableView.refreshHeaderEnable = true
    /// 开启上拉加载更多
    tableView.refreshFooterEnable = true
    /// 实现协议，接收回调
    self.tableView.refreshDelegate = self
    // MARK: ==== BPRefreshProtocol ====
    /// 显示刷新动画
    public func loadingHeader(scrollView: UIScrollView, completion block: DefaultBlock?) {
          // 记得结束后调用block，隐藏加载动画
        self.request(block)
    }
    /// 显示加载动画 
    public func loadingFooter(scrollView: UIScrollView, completion block: DefaultBlock?) {
       // 记得结束后调用block，隐藏加载动画
        self.request(block)
     }
    ```

* 索引

    ```swift
    /// 实现索引回调即可
    tableView.indexDelegate = self
    /// 索引内容
    func indexTitle(section: Int) -> String
    ```

* 空页面

    ```swift
    /// 实现协议
    tableView.dataSource = self
    /// 设置空页面内容
        /// - Parameters:
        ///   - image: 图片（为空则取默认图）
        ///   - hintText: 文案
        ///   - buttonText: 按钮文案
        ///   - actionBlock: 按钮事件
    self.tableView.dataSource?.setDefaultViewData(image: nil, hintText: "暂无内容", buttonText: "添加", actionBlock: {
        print("Show create view controller")
    })
    ```

* 通用列表 **BPTableViewController**

    ```swift
    /// 继承自 BPTableViewController
    /// BPModel：列表数据类型
    /// BPTestell：列表类型 
    class ViewController: BPTableViewController<BPModel, BPTestCell>, BPTableViewControllerDelegate {}
    
    /// 协议如下
    public protocol BPTableViewControllerDelegate: NSObjectProtocol {
        /// 显示的Header（可选）
        func headerView() -> BPView
        /// 显示的Footer（可选）
        func footerView() -> BPView
        /// 请求体 （ --必须实现--）
        var request: BPRequest { get set }
        /// 是否显示搜索（可选）
        var isShowSearch: Bool { get }
        /// 是否显示筛选（可选）
        var isShowFilter: Bool { get }
        /// 是否显示悬浮添加按钮（可选）
        var isShowAddButton: Bool { get }
    }
    ```

* 通用Cell **BPCommonTableViewCell**

    ```swift
            /// 配置数据
        /// - Parameters:
        ///   - isRequired: 是否必选
        ///   - title: 标题
        ///   - placeholder: 默认
        ///   - canEdit: 是否可编辑
        ///   - icon: 图标
        ///   - unit: 单位
        ///   - hideLine: 是否显示底部分割线
        public func setData(_ isRequired: Bool, title: String?, placeholder: String?, canEdit: Bool, icon: UIImage?, unit: String?, hideLine: Bool = true) 
    ```
    
    

