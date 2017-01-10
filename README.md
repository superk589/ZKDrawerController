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

// have two sides
let drawerController = ZKDrawerController.init(main: centerController, right: rightController, left: leftController)

// only have right or left side
let drawerController = ZKDrawerController.init(main: centerController, right: rightController, left: nil)
let drawerController = ZKDrawerController.init(main: centerController, right: nil, left: leftController)

// have none of the two sides, and then add dynamically
let drawerController = ZKDrawerController.init(main: centerController, right: nil, left: nil)
drawerController.rightVC = UIViewController()
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
// set or replace
drawerController.mainVC = newViewController
drawerController.rightVC = newViewController
drawerController.leftVC = newViewController
// remove the side view controller, mainVC can not be removed
drawerController.rightVC = nil
drawerController.leftVC = nil
```
