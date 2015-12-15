//
//  ContainerViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 8/9/15.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//

import UIKit

protocol SnapContainerViewControllerDelegate {
    func innerScrollViewShouldScroll() -> Bool
}

class SnapContainerViewController: UIViewController {
    
    var leftVc: UIViewController!
    var middleVc: UIViewController!
    var rightVc: UIViewController!
    var topVc: UIViewController!
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var middleVertScrollVc: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: SnapContainerViewControllerDelegate?
    
    class func containerViewWith(leftVC: UIViewController, middleVC: UIViewController, rightVC: UIViewController, topVC: UIViewController) -> SnapContainerViewController {
        let container = SnapContainerViewController()
        container.leftVc = leftVC
        container.middleVc = middleVC
        container.rightVc = rightVC
        container.topVc = topVC
        return container
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVerticalScrollView()
        setupHorizontalScrollView()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    func setupVerticalScrollView() {
        middleVertScrollVc = VerticalScrollViewController.verticalScrollVcWith(middleVc, topVc: topVc)
        delegate = middleVertScrollVc
    }
    
    func setupHorizontalScrollView() {
        
        scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        
        self.scrollView!.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = 3 * CGRectGetWidth(self.view.bounds)
        let scrollHeight: CGFloat  = CGRectGetHeight(self.view.bounds)
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
        leftVc.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        middleVertScrollVc.view.frame = CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        rightVc.view.frame = CGRectMake(2*CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        
        self.addChildViewController(leftVc)
        self.scrollView!.addSubview(leftVc.view)
        leftVc.didMoveToParentViewController(self)
        
        self.addChildViewController(middleVertScrollVc)
        self.scrollView!.addSubview(middleVertScrollVc.view)
        middleVertScrollVc.didMoveToParentViewController(self)
        
        self.addChildViewController(rightVc)
        self.scrollView!.addSubview(rightVc.view)
        self.scrollView!.sendSubviewToBack(rightVc.view)
        rightVc.didMoveToParentViewController(self)
        
        self.scrollView!.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        self.scrollView!.delegate = self;
    }
    
}

// MARK: UIScrollView Delegate

extension SnapContainerViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if delegate != nil && !delegate!.innerScrollViewShouldScroll() {
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

