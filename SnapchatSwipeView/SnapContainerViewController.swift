//
//  ContainerViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 8/9/15.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//

import UIKit

protocol SnapContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
}

class SnapContainerViewController: UIViewController, UIScrollViewDelegate {
    
    var topVc: UIViewController?
    var leftVc: UIViewController!
    var middleVc: UIViewController!
    var rightVc: UIViewController!
    var bottomVc: UIViewController?
    
    var directionLockDisabled: Bool!
    
    var horizontalViews = [UIViewController]()
    var veritcalViews = [UIViewController]()
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var middleVertScrollVc: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: SnapContainerViewControllerDelegate?
    
    class func containerViewWith(_ leftVC: UIViewController,
                                 middleVC: UIViewController,
                                 rightVC: UIViewController,
                                 topVC: UIViewController?=nil,
                                 bottomVC: UIViewController?=nil,
                                 directionLockDisabled: Bool?=false) -> SnapContainerViewController {
        let container = SnapContainerViewController()
        
        container.directionLockDisabled = directionLockDisabled
        
        container.topVc = topVC
        container.leftVc = leftVC
        container.middleVc = middleVC
        container.rightVc = rightVC
        container.bottomVc = bottomVC
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVerticalScrollView()
        setupHorizontalScrollView()
    }
    
    func setupVerticalScrollView() {
        middleVertScrollVc = VerticalScrollViewController.verticalScrollVcWith(middleVc: middleVc,
                                                                               topVc: topVc,
                                                                               bottomVc: bottomVc)
        delegate = middleVertScrollVc
    }
    
    func setupHorizontalScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        scrollView.frame = CGRect(x: view.x,
                                  y: view.y,
                                  width: view.width,
                                  height: view.height
        )
        
        self.view.addSubview(scrollView)
        
        let scrollWidth  = 3 * view.width
        let scrollHeight  = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        leftVc.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.width,
                                   height: view.height
        )
        
        middleVertScrollVc.view.frame = CGRect(x: view.width,
                                               y: 0,
                                               width: view.width,
                                               height: view.height
        )
        
        rightVc.view.frame = CGRect(x: 2 * view.width,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )
        
        addChildViewController(leftVc)
        addChildViewController(middleVertScrollVc)
        addChildViewController(rightVc)
        
        scrollView.addSubview(leftVc.view)
        scrollView.addSubview(middleVertScrollVc.view)
        scrollView.addSubview(rightVc.view)
        
        leftVc.didMove(toParentViewController: self)
        middleVertScrollVc.didMove(toParentViewController: self)
        rightVc.didMove(toParentViewController: self)
        
        scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        scrollView.delegate = self
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if delegate != nil && !delegate!.outerScrollViewShouldScroll() && !directionLockDisabled {
            let newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
        
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            self.scrollView!.setContentOffset(newOffset, animated:  false)
        }
    }
    
}
