//
//  ViewController.swift
//  TabbarControlSample
//
//  Created by Maochun Sun on 2020/7/2.
//  Copyright © 2020 Maochun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let fontName = "Helvetica"
    let boldFontName = "Helvetica-Bold"
    
    lazy var stateControl : UISegmentedControl = {
       var segCtrl = UISegmentedControl(items: [NSLocalizedString("Tab1", comment: ""), NSLocalizedString("Tab2", comment: "")])
       
       segCtrl.translatesAutoresizingMaskIntoConstraints = false
       
       
       segCtrl.tintColor = UIColor.white
       //segCtrl.backgroundColor = UIColor.gray
       segCtrl.backgroundColor = .none
        
    
       
       //segCtrl.borderColor = UIColor.white
       //segCtrl.borderWidth = 1.0
       //segCtrl.cornerRadius = 10
       
       if #available(iOS 13.0, *){
           segCtrl.selectedSegmentTintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3) //.white
           
           segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                           NSAttributedString.Key.font: UIFont.init(name: self.fontName, size: 16)!], for: .normal)
           segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                           NSAttributedString.Key.font: UIFont.init(name: self.boldFontName, size: 17)!], for: .selected)
           
       }else{
           segCtrl.backgroundColor = .clear
           
           segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                           NSAttributedString.Key.font: UIFont.init(name: self.fontName, size: 16)!], for: .normal)
           segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,
                                           NSAttributedString.Key.font: UIFont.init(name: self.boldFontName, size: 17)!], for: .selected)
       }
       //segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
       //segCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.lightGray], for: .normal)
       
       segCtrl.clipsToBounds = true
        
        
       self.view.addSubview(segCtrl)
       
       if UIScreen.main.bounds.width > 460{
           NSLayoutConstraint.activate([
               
                segCtrl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
                segCtrl.widthAnchor.constraint(equalToConstant: 400),
                segCtrl.heightAnchor.constraint(equalToConstant: 40),
                segCtrl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
           ])
       }else{
           NSLayoutConstraint.activate([
               
               segCtrl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
               segCtrl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
               segCtrl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
               segCtrl.heightAnchor.constraint(equalToConstant: 40)
               
           ])
       }
        
        
       segCtrl.addTarget(
            self,
            action:
            #selector(onTabSwitch),
            for: .valueChanged)
        
        return segCtrl
    }()
    
    
    lazy var pageViewControl : UIPageViewController = {
        let pageViewCtrl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewCtrl.view.frame = CGRect.init(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100)
        pageViewCtrl.delegate = self
        pageViewCtrl.dataSource = self
        
        self.addChild(pageViewCtrl)
        self.view.addSubview(pageViewCtrl.view)
        
        return pageViewCtrl
        
    }()
 
    var viewControllerArr = Array<UIViewController>()
    var selectedIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .black
        
        let vc1 = Test1ViewController()
        vc1.view.tag = 0
        let vc2 = Test2ViewController()
        vc2.view.tag = 1
        self.viewControllerArr.append(vc1)
        self.viewControllerArr.append(vc2)
        
        self.stateControl.selectedSegmentIndex = 0
        self.pageViewControl.setViewControllers([viewControllerArr[0]], direction: .forward, animated: false)
    }

    
    @objc func onTabSwitch(){
        if self.stateControl.selectedSegmentIndex == 0{
            
            pageViewControl.setViewControllers([self.viewControllerArr[0]], direction: .reverse, animated: true)
        }else{
            
            pageViewControl.setViewControllers([self.viewControllerArr[1]], direction: .forward, animated: true)
        }
    }

}

extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        let idx = pendingViewControllers[0].view.tag
        self.stateControl.selectedSegmentIndex = idx
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        if !completed{
            let idx = previousViewControllers[0].view.tag
            self.stateControl.selectedSegmentIndex = idx
        }
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let pageIndex = viewController.view.tag - 1
        if pageIndex < 0 {
            return nil
        }
        selectedIndex = pageIndex
        self.stateControl.selectedSegmentIndex = selectedIndex
        return viewControllerArr[pageIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        let pageIndex = viewController.view.tag + 1
        if pageIndex > 1 {
            return nil
        }
        selectedIndex = pageIndex
        self.stateControl.selectedSegmentIndex = selectedIndex
        return viewControllerArr[pageIndex]
    }
    
    
}
