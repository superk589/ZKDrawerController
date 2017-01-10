# ZKDrawerController
![Swift3](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat")
[![Version](https://img.shields.io/cocoapods/v/ZKDrawerController.svg?style=flat)](http://cocoapods.org/pods/ZKDrawerController)
[![License](https://img.shields.io/cocoapods/l/ZKDrawerController.svg?style=flat)](http://cocoapods.org/pods/ZKDrawerController)
[![Platform](https://img.shields.io/cocoapods/p/ZKDrawerController.svg?style=flat)](http://cocoapods.org/pods/ZKDrawerController)  

An iOS drawer controller in swift

## CocoaPods:
```
platform :ios, '8.0'
use_frameworks!
target 'myApp' do
  pod 'ZKDrawerController'
end
```

## Usage

### initialize
```swift
let centerController = UIViewController()
let leftController = UIViewController()
let rightController = UIViewController()
let drawerController = ZKDrawerController.init(main: centerController, right: rightController, left: leftController)
```
### set drawer style
```swift
// side controller covers the main controller, shadows the edge of side controllers' view
drawerController.drawerStyle = .cover

// side controller insert below the main controller, shadows the edge of main controller's view
drawerController.drawerStyle = .insert

// side controller lays beside the main controller
drawerController.drawerStyle = .plain
```

### show or hide side controller manually
```swift
drawerController.showRight(animated: Bool)
drawerController.showLeft(animated: Bool)
```

### set main controller's scale
```swift
// scale should be 0 to 1
drawerController.mainScale = 0.8
```
### set left and right side width
```swift
drawerController.defalutRightWidth = 300
drawerController.defalutLeftWidth = 300

```
### set shadow width
```swift
drawerController.shadowWidth = 5
```

### set gesture recognizer width in main controller
```swift
drawerController.gestureRecognizerWidth = 40
```

### set the side or main controller dynamically
```swift
drawerController.mainVC = newViewController
drawerController.rightVC = newViewController
drawerController.leftVC = newViewController
```
