# BPLog

[![CI Status](https://img.shields.io/travis/TestEngineerFish/BPLog.svg?style=flat)](https://travis-ci.org/TestEngineerFish/BPLog)
[![Version](https://img.shields.io/cocoapods/v/BPLog.svg?style=flat)](https://cocoapods.org/pods/BPLog)
[![License](https://img.shields.io/cocoapods/l/BPLog.svg?style=flat)](https://cocoapods.org/pods/BPLog)
[![Platform](https://img.shields.io/cocoapods/p/BPLog.svg?style=flat)](https://cocoapods.org/pods/BPLog)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BPLog is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BPLog'
```

## Author

TestEngineerFish, 916878440@qq.com

## License

BPLog is available under the MIT license. See the LICENSE file for more info.

* 网络请求日志：BPRequest("request")
* 普通操作日志：BPLog("e.g. click button")

## 说明
可通过继承 **BPLogDelegate** 对打包后的日志追加需要的信息，比如用户信息和设备信息等
如需获取日志具体地址，可通过 **BPLogManger** 来获取，实际上大部分的操作也都是由其来提供


