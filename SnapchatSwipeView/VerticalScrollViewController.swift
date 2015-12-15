//
//  MiddleScrollViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 12/14/15.
//  Copyright © 2015 Brendan Lee. All rights reserved.
//

import UIKit

class VerticalScrollViewController: UIViewController, UIScrollViewDelegate {
    var topVc: UIViewController!
    var middleVc: UIViewController!
    var scrollView: UIScrollView!
    
    class func verticalScrollVcWith(middleVc: UIViewController, topVc: UIViewController) -> VerticalScrollViewController {
        let middleScrollVc = VerticalScrollViewController()
        middleScrollVc.middleVc = middleVc
        middleScrollVc.topVc = topVc
        return middleScrollVc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view:
        setupScrollView()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        self.scrollView!.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = CGRectGetWidth(self.view.bounds)
        let scrollHeight: CGFloat  = 2 * CGRectGetHeight(self.view.bounds)
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
        topVc.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        middleVc.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        
        self.addChildViewController(middleVc)
        self.scrollView!.addSubview(middleVc.view)
        middleVc.didMoveToParentViewController(self)
        
        self.addChildViewController(topVc)
        self.scrollView!.addSubview(topVc.view)
        topVc.didMoveToParentViewController(self)
        
        self.scrollView!.contentOffset.y = middleVc.view.frame.origin.y
        self.scrollView!.delegate = self;
    }
    
}

extension VerticalScrollViewController: SnapContainerViewControllerDelegate {
    func innerScrollViewShouldScroll() -> Bool {
        if scrollView.contentOffset.y < middleVc.view.frame.origin.y {
            return false
        } else {
            return true
        }
    }
}

