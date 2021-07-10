//
//  PageViewController.swift
//  TravelAssist
//
//  Created by Алексей Горбунов on 08.07.2021.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var articles: [Article]!
    var tip: TipCellData!
    
//    var pageControl = UIPageControl(frame: CGRect(x: 146, y: 780, width: 300, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        pageControl.currentPageIndicatorTintColor = UIColor.black
//        pageControl.pageIndicatorTintColor = UIColor.gray
        
        self.dataSource = self
        self.navigationItem.title = tip.tipName
        if let vc = self.pageViewController(for: 0) {
            self.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        for view in self.view.subviews {
//            if view is UIScrollView {
//                view.frame = UIScreen.main.bounds
//            } else if view is UIPageControl {
//                view.backgroundColor = UIColor.clear
//            }
//        }
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? DetailViewController)?.index ?? 0) - 1
        return self.pageViewController(for: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? DetailViewController)?.index ?? 0) + 1
        return self.pageViewController(for: index)
    }
    
    func pageViewController(for index: Int) -> DetailViewController? {
        if index < 0 {
            return nil
        }
        
        if index >= articles.count {
            return nil
        }
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController)
        
        vc.article = articles[index]
        vc.index = index
        
        return vc
    }
}
