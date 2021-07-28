//
//  PageVC.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/31.
//

import UIKit
protocol walkthroughPageVCDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class PageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageHeadings = ["輸入框內，填入想前往的縣市地點，按下「搜尋」查詢旅社！",
                        "喜愛的旅社按下表情「LOVE」圖案，立即收藏至最愛",
                        "收集所有喜愛的旅社，(右滑)分享給朋友",
                        "開始使用APP吧！"]
    var pageImages = ["page1","page2","page3","page4"]
    var currentIndex = 0

    weak var PageDelegate: walkthroughPageVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        overrideUserInterfaceStyle = .dark
  
        //建立第一個導覽畫面
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    //MARK: - PageSoure
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContenViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContenViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    // 建立頁面顯示
    func contentViewController(at index: Int) -> WalkthroughContenViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        //建立新的圖控制器並傳遞資料
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as? WalkthroughContenViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    //建立下一個內容視圖並導引
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContenViewController {
                currentIndex = contentViewController.index
                PageDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
