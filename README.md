# Snapchat-Swipe-View

Hide more ViewControllers in ALL the directions! Snapchat-Swipe-View mimics (sort of) the classic 2015 Snapchat top, down, left, and right swiping that lets you go to a different view controller in every direction. There are versions of this that let you scroll to the left and right, but not up and down as well, which required some additional hacking to prevent diagonal scrolling.

![Demo](https://cloud.githubusercontent.com/assets/7165897/9416939/73c08a56-4816-11e5-9441-9b3a5656cce8.gif)

## How to use:

Replace AViewController-EViewController with your own viewControllers of choice and rename the "files owner" as well as the filenames for all of the Xib's. To add to an existing project, drag everything from the "Container View" folder in this workspace into your project and create a new viewcontroller in your storyboard. Add a UIScrollView to the ViewController and make it full screen. Link the new storyboard controller to ContainerViewController.swift, and then connect the "scrollView" property in the connections inspector to the UIScrollView. Piece of cake :) 

