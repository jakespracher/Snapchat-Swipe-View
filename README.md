# Snapchat-Swipe-View

Hide more ViewControllers in ALL the directions! Snapchat-Swipe-View mimics the classic 2015 Snapchat top, down, left, and right swiping that lets you go to a different view controller in every direction. There are versions of this that let you scroll to the left and right, but not up and down as well, which required some additional hacking.

![Demo](https://cloud.githubusercontent.com/assets/7165897/9416939/73c08a56-4816-11e5-9441-9b3a5656cce8.gif)

## How to use:
1.) Add SnapContainerViewController.swift and VerticalScrollViewController.swift to your project

1.5) [Make sure your project supports swift](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)

2.) In your appDelegate:
```swift
let storyboard = UIStoryboard(name: "Main", bundle: nil)
let left = storyboard.instantiateViewControllerWithIdentifier("left")
let middle = storyboard.instantiateViewControllerWithIdentifier("middle")
let right = storyboard.instantiateViewControllerWithIdentifier("right")
let top = storyboard.instantiateViewControllerWithIdentifier("top")
let snapContainer = SnapContainerViewController.containerViewWith(left, middleVC: middle, rightVC: right, topVC: top)
self.window?.rootViewController = snapContainer
self.window?.makeKeyAndVisible()
'''
NOTE: If any of your view controllers depend on scroll gestures (e.g. UITableViewController) be aware that only the left and right view controllers can recieve vertical scroll gestures. Horizontal scroll gestures are not supported anywhere, and vertical ones arent supporeted on the middle view controllers because it wouldnt make sense (you will notice snapchat doesnt use them either).
