# Snapchat-Swipe-View

Snapchat-Swipe-View mimics the classic 2015 Snapchat top, down, left, and right swipe navigation that lets you swipe to a different view controller in every direction. There are versions of this that let you scroll to the left and right, but not up and down as well, which requires some additional hacking.

![Demo](https://cloud.githubusercontent.com/assets/7165897/9416939/73c08a56-4816-11e5-9441-9b3a5656cce8.gif)

## How to use:
1. Add SnapContainerViewController.swift and VerticalScrollViewController.swift to your project

2. [Make sure your project supports swift](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)

3.  If you are using Storyboards, ensure you have an arbitrary initial view controller set in your storyboard. If you use the code in step 4, the middle view controller will always be shown first, so this is needless but you will get an error if you don't do it. 

4. In your App Delegate:
```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let left = storyboard.instantiateViewControllerWithIdentifier("left")
    let middle = storyboard.instantiateViewControllerWithIdentifier("middle")
    let right = storyboard.instantiateViewControllerWithIdentifier("right")
    let top = storyboard.instantiateViewControllerWithIdentifier("top")
    let bottom = storyboard.instantiateViewControllerWithIdentifier("bottom")
    
    let snapContainer = SnapContainerViewController.containerViewWith(left,
                                                                      middleVC: middle,
                                                                      rightVC: right,
                                                                      topVC: top,
                                                                      bottomVC: bottom)
    
    self.window?.rootViewController = snapContainer
    self.window?.makeKeyAndVisible()
}
```
NOTE: This is an example, you will likely need to modify this to suit your needs. (e.g. if you will be adding a separate login/sign up flow)
NOTE: If any of your view controllers depend on scroll gestures (e.g. UITableViewController) be aware that only the left and right view controllers can recieve vertical scroll gestures. Horizontal scroll gestures are not supported anywhere, and vertical ones arent supporeted on the middle view controllers because it wouldnt make sense (you will notice snapchat doesnt use them either).
