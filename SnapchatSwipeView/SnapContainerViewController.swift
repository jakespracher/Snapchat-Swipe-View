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
        
        let view = [
                "x": self.view.bounds.origin.x,
                "y": self.view.bounds.origin.y,
                "width": CGRectGetWidth(self.view.bounds),
                "height": CGRectGetHeight(self.view.bounds)
            ];
        
        self.scrollView!.frame = CGRectMake(view["x"]!, view["y"]!, view["width"]!, view["height"]!)
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = 3 * view["width"]!
        let scrollHeight: CGFloat  = view["height"]!
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
        leftVc.view.frame = CGRectMake(0, 0, view["width"]!, view["height"]!)
        middleVertScrollVc.view.frame = CGRectMake(view["width"]!, 0, view["width"]!, view["height"]!)
        rightVc.view.frame = CGRectMake(2*view["width"]!, 0, view["width"]!, view["height"]!)
        
        self.addChildViewController(leftVc)
        self.addChildViewController(middleVertScrollVc)
        self.addChildViewController(rightVc)
        
        self.scrollView!.addSubview(leftVc.view)
        self.scrollView!.addSubview(middleVertScrollVc.view)
        self.scrollView!.addSubview(rightVc.view)
        
        leftVc.didMoveToParentViewController(self)
        middleVertScrollVc.didMoveToParentViewController(self)
        rightVc.didMoveToParentViewController(self)
        
        self.scrollView!.contentOffset.x = middleVertScrollVc.view.frame.origin.x

    }
    
}
