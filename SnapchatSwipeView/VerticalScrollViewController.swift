//
//  MiddleScrollViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 12/14/15.
//  Copyright © 2015 Jake Spracher. All rights reserved.
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
        
        scrollView.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = view.bounds.width
        let scrollHeight: CGFloat  = 2 * view.bounds.height
        
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        topVc.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        middleVc.view.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
        
        addChildViewController(middleVc)
        addChildViewController(topVc)

        scrollView.addSubview(middleVc.view)
        scrollView.addSubview(topVc.view)
        
        middleVc.didMoveToParentViewController(self)
        topVc.didMoveToParentViewController(self)
        
        scrollView.contentOffset.y = middleVc.view.frame.origin.y
        scrollView.delegate = self;
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

