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

let drawerController = ZKDrawerController.init(main: centerController, right: rightController)
let drawerController = ZKDrawerController.init(main: centerController, left: leftController)
let drawerController = ZKDrawerController.init(main: centerController, right: rightController, left: leftController)

// have none of the two sides, and then add dynamically
let drawerController = ZKDrawerController.init(main: centerController)
drawerController.rightVC = UIViewController()
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
drawerController.show(animated: true)
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

### use ZKDrawerController as your root controller and show various main controller-based side controllers.
```swift
// in AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let home = ViewController()
    let nav = UINavigationController(rootViewController: home)
    let drawer = ZKDrawerController(main: nav, right: nil, left: nil)
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
    let rightVC = UIViewController()
    drawerController.rightVC = rightVC
}
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    drawerController.rightVC = nil   
}
```
