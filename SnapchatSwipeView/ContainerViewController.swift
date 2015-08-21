//
//  ContainerViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 8/9/15.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//

import UIKit

enum ScrollDirection {
    case ScrollDirectionNone
    case ScrollDirectionCrazy
    case ScrollDirectionLeft
    case ScrollDirectionRight
    case ScrollDirectionUp
    case ScrollDirectionDown
    case ScrollDirectionHorizontal
    case ScrollDirectionVertical
}

class ContainerViewController: UIViewController, UIScrollViewDelegate {
    
    // scrollView initial offset
    var initialContentOffset = CGPoint()
    
    // Outlet used in storyboard
    @IBOutlet var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) Create the three views used in the swipe container view
        var leftVc :AViewController =  AViewController(nibName: "AViewController", bundle: nil)
        var middleVc :BViewController =  BViewController(nibName: "BViewController", bundle: nil)
        var rightVc :CViewController =  CViewController(nibName: "CViewController", bundle: nil)
        var topVc :DViewController =  DViewController(nibName: "DViewController", bundle: nil)
        var bottomVc :EViewController =  EViewController(nibName: "EViewController", bundle: nil)
        
        // 2) Add in each view to the container view hierarchy
        //    Add them in opposite order since the view hieracrhy is a stack
        self.addChildViewController(bottomVc);
        self.scrollView!.addSubview(bottomVc.view)
        bottomVc.didMoveToParentViewController(self)
        
        self.addChildViewController(topVc)
        self.scrollView!.addSubview(topVc.view)
        topVc.didMoveToParentViewController(self)
        
        self.addChildViewController(leftVc)
        self.scrollView!.addSubview(leftVc.view)
        leftVc.didMoveToParentViewController(self)

        self.addChildViewController(middleVc)
        self.scrollView!.addSubview(middleVc.view)
        middleVc.didMoveToParentViewController(self)

        self.addChildViewController(rightVc)
        self.scrollView!.addSubview(rightVc.view)
        rightVc.didMoveToParentViewController(self)

        // 3) Set up the frames of the view controllers to align
        //    with eachother inside the container view
        leftVc.view.frame.origin.y = leftVc.view.frame.height // put left frame into position
        
        var middleFrame :CGRect = leftVc.view.frame
        middleFrame.origin.x = middleFrame.width
        middleVc.view.frame = middleFrame; // Put middle frame into position
        
        var rightFrame :CGRect = middleVc.view.frame
        rightFrame.origin.x = 2*rightFrame.width
        rightVc.view.frame = rightFrame // Put right frame into position
        
        var topFrame :CGRect = middleVc.view.frame
        topFrame.origin.x = middleFrame.width
        topFrame.origin.y = 0
        topVc.view.frame = topFrame // Put top frame into position
        
        var bottomFrame :CGRect = middleVc.view.frame
        bottomFrame.origin.x = middleFrame.width
        bottomFrame.origin.y = 2 * middleFrame.height
        bottomVc.view.frame = bottomFrame // Put bottom frame into position
        
        // 4) Finally set the size of the scroll view that contains the frames
        var scrollWidth: CGFloat  = 3 * self.view.frame.width
        var scrollHeight: CGFloat  = 3 * self.view.frame.size.height
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        self.scrollView!.contentOffset.x = middleFrame.origin.x
        self.scrollView!.contentOffset.y = middleFrame.height

        self.scrollView!.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UIScollView Direction Locking
    
    func determineScrollDirection(scrollView: UIScrollView) -> ScrollDirection {
        
        var scrollDirection = ScrollDirection.ScrollDirectionNone
        
        if (self.initialContentOffset.x != scrollView.contentOffset.x &&
            self.initialContentOffset.y != scrollView.contentOffset.y) {
                scrollDirection = .ScrollDirectionCrazy;
        } else {
            if (self.initialContentOffset.x > scrollView.contentOffset.x) {
                scrollDirection = .ScrollDirectionLeft;
            } else if (self.initialContentOffset.x < scrollView.contentOffset.x) {
                scrollDirection = .ScrollDirectionRight;
            } else if (self.initialContentOffset.y > scrollView.contentOffset.y) {
                scrollDirection = .ScrollDirectionUp;
            } else if (self.initialContentOffset.y < scrollView.contentOffset.y) {
                scrollDirection = .ScrollDirectionDown;
            } else {
                scrollDirection = .ScrollDirectionNone;
            }
        }
        
        return scrollDirection;
    }
    
    func determineScrollDirectionAxis(scrollView: UIScrollView) -> ScrollDirection {
        
        var scrollDirection = self.determineScrollDirection(self.scrollView!)
        
        switch (scrollDirection) {
        case .ScrollDirectionLeft,
             .ScrollDirectionRight :
            return .ScrollDirectionHorizontal;
            
        case .ScrollDirectionUp,
             .ScrollDirectionDown:
            return .ScrollDirectionVertical;
            
        default:
            return .ScrollDirectionNone;
        }
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var scrollDirection = self.determineScrollDirectionAxis(self.scrollView!)
        
        if (scrollDirection == .ScrollDirectionVertical && !(scrollView.contentOffset.x < self.view.frame.width || scrollView.contentOffset.x >= 2 * self.view.frame.width)) {
            println("Scrolling direction: vertical \(scrollView.contentOffset.x)")
        } else if (scrollDirection == .ScrollDirectionHorizontal && !(scrollView.contentOffset.y < self.view.frame.height || scrollView.contentOffset.y >= 2 * self.view.frame.height)) {
            println("Scrolling direction: horizontal \(scrollView.contentOffset.y)")
        } else {
            // This is probably crazy movement: diagonal scrolling
            var newOffset = CGPoint()
            
            if (abs(scrollView.contentOffset.x) > abs(scrollView.contentOffset.y)) {
                newOffset = CGPointMake(self.initialContentOffset.x, self.initialContentOffset.y)
            } else {
                newOffset = CGPointMake(self.initialContentOffset.x, self.initialContentOffset.y)
            }
            
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            self.scrollView!.setContentOffset(newOffset,animated:  false)
        }
    }
}

