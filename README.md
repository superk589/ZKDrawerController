# ZKDrawerController
![Swift4](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)
[![Version](https://img.shields.io/cocoapods/v/ZKDrawerController.svg?style=flat)](http://cocoapods.org/pods/ZKDrawerController)
[![License](https://img.shields.io/cocoapods/l/ZKDrawerController.svg?style=flat)](http://cocoapods.org/pods/ZKDrawerController)
[![Platform](https://img.shields.io/cocoapods/p/ZKDrawerController.svg?style=flat)](http://cocoapods.org/pods/ZKDrawerController)  

An iOS drawer controller in swift

## Requirements
* Xcode 9.0+
* Swift 4.2+
* iOS Deployment Target 8.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
To integrate ZKDrawerController into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/superk589/ZKDrawerController.git'
platform :ios, '8.0'
use_frameworks!

target 'YourApp' do
    pod 'ZKDrawerController'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ZKPageViewController into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "superk589/ZKDrawerController"
```

Run `carthage update` to build the framework and drag the built `ZKDrawerController.framework` into your Xcode project.

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate ZKDrawerController into your project manually.


## Usage

### initialize
```swift
let centerController = UIViewController()
let leftController = UIViewController()
let rightController = UIViewController()

let drawerController = ZKDrawerController(center: centerController, right: rightController)
let drawerController = ZKDrawerController(center: centerController, left: leftController)
let drawerController = ZKDrawerController(center: centerController, right: rightController, left: leftController)

// have none of the two sides, and then add dynamically
let drawerController = ZKDrawerController(center: centerController)
drawerController.rightViewController = UIViewController()
```
### set drawer style
```swift
// side controller covers the main controller, shadows the edge of side controllers' view
drawerController.drawerStyle = .cover

// side controller inserts below the main controller, shadows the edge of main controller's view
drawerController.drawerStyle = .insert

// side controller lays beside the main controller
drawerController.drawerStyle = .plain
```

### show or hide side controller manually
```swift
drawerController.show(.right, animated: true)
drawerController.show(.left, animated: true)
drawerController.hide(animated: true)
```

### set main controller's scale
```swift
// scale should be 0 to 1
drawerController.mainScale = 0.8
```

### set background color or image
```swift
// set background color
drawerController.containerView.backgroundColor = UIColor.white

// set background image
drawerController.backgroundImageView.image = image
```

### set center controller's view foreground color while side view is showing
```swift
// this view will change it's alpha while side view is showing from 0 to 1
drawerController.mainCoverView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
```

### set left and right side width
```swift
drawerController.defaultRightWidth = 300
drawerController.defaultLeftWidth = 300

```
### set shadow width
```swift
drawerController.shadowWidth = 5
```

### set gesture recognizer width in main controller
```swift
drawerController.gestureRecognizerWidth = 40
```

### should require failure of navigation pop gesture, default true (if setting false, showing left drawer gesture will have higher priority)
```swift
drawerController.shouldRequireFailureOfNavigationPopGesture = true
```

### setup gestures priority, higher priority gestures will proc before drawer controller's gesture and lower priority gestures will proc after failure of drawer controller's gesture
```swift
drawerController.higherPriorityGestures = [gesture1, gesture2]
drawerController.lowerPriorityGestures = [gesture3, gesture4]
```

### set the side or main controller dynamically
```swift
// set or replace
drawerController.centerViewController = newViewController
drawerController.rightViewController = newViewController
drawerController.leftViewController = newViewController
// remove the side view controller, mainVC can not be removed
drawerController.rightViewController = nil
drawerController.leftViewController = nil
```

### use ZKDrawerController as your root controller and show various main controller-based side controllers.
```swift
// in AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let home = ViewController()
    let nav = UINavigationController(rootViewController: home)
    let drawer = ZKDrawerController(center: nav, right: nil, left: nil)
    // do some setup
    drawer.mainScale = 0.8
    drawer.drawerStyle = .cover
    // ...
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = drawer
    window?.makeKeyAndVisible()
    home.drawerController = drawer
    return true
}

// in ViewController.swift
var drawerController: ZKDrawerController!
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let vc = UIViewController()
    drawerController.rightViewController = vc
}
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    drawerController.rightViewController = nil   
}
```
