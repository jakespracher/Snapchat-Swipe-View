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
                "width": self.view.bounds.width,
                "height": self.view.bounds.height
            ];
        
        scrollView.frame = CGRect(x: view["x"]!, y: view["y"]!, width: view["width"]!, height: view["height"]!)
        self.view.addSubview(scrollView)
        
        let scrollWidth  = 3 * view["width"]!
        let scrollHeight  = view["height"]!
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        leftVc.view.frame = CGRect(x: 0, y: 0, width: view["width"]!, height: view["height"]!)
        middleVertScrollVc.view.frame = CGRect(x: view["width"]!, y: 0, width: view["width"]!, height: view["height"]!)
        rightVc.view.frame = CGRect(x: 2*view["width"]!, y: 0, width: view["width"]!, height: view["height"]!)
        
        addChildViewController(leftVc)
        addChildViewController(middleVertScrollVc)
        addChildViewController(rightVc)
        
        scrollView.addSubview(leftVc.view)
        scrollView.addSubview(middleVertScrollVc.view)
        scrollView.addSubview(rightVc.view)
        
        leftVc.didMoveToParentViewController(self)
        middleVertScrollVc.didMoveToParentViewController(self)
        rightVc.didMoveToParentViewController(self)
        
        scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
    }
    
}
