//
//  CompareViewController.swift
//  ComparisionUI
//
//  Created by Sameer Poudel on 17/08/17.
//  Copyright © 2017 Data Health. All rights reserved.
//

import UIKit

class CompareViewController: UIPageViewController, UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var images:[[String: String]]? = []
    var orderedViewControllers:[UIViewController] = []
    var isFullScreen: Bool = false
    
    func createViewController(title: String, image: String) -> UIViewController {
        
        let viewController = UIViewController()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: 64))
        headerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        let heading = UILabel(frame: CGRect(x: 10, y: 30, width: 100, height: 20))
        heading.text = title
        heading.textColor = UIColor.white
        
        headerView.addSubview(heading)
        headerView.tag = 101
        
        let scrollView = UIScrollView(frame: viewController.view.frame)
        scrollView.maximumZoomScale = 10
        scrollView.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width:viewController.view.frame.width, height: viewController.view.frame.height))
        imageView.image = UIImage(named: image)
        imageView.tag = 100
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        viewController.view.addSubview(scrollView)
        
        let scrollViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(_:)))
        scrollViewTapGestureRecognizer.numberOfTapsRequired = 2
        scrollViewTapGestureRecognizer.isEnabled = true
        scrollViewTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(scrollViewTapGestureRecognizer)
        
        let scrollViewTapGestureRecognizerSingle = UITapGestureRecognizer(target: self, action: #selector(scrollViewTappedSingle(_:)))
        scrollViewTapGestureRecognizerSingle.numberOfTapsRequired = 1
        scrollViewTapGestureRecognizerSingle.isEnabled = true
        scrollViewTapGestureRecognizerSingle.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(scrollViewTapGestureRecognizerSingle)
        
        viewController.view.addSubview(headerView)
        return viewController
    }
    
    var currentIndex:Int {
        get {
            return orderedViewControllers.index(of: self.viewControllers!.first!)!
        }
        
        set {
            guard newValue >= 0,
                newValue < orderedViewControllers.count else {
                    return
            }
            
            let vc = orderedViewControllers[newValue]
            let direction:UIPageViewControllerNavigationDirection = newValue > currentIndex ? .forward : .reverse
            self.setViewControllers([vc], direction: direction, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func scrollViewTapped(_ sender: UITapGestureRecognizer) {
        let scrollView = sender.view as! UIScrollView
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            UIView.animate(withDuration: 0.25) {
                sender.view?.superview?.viewWithTag(101)?.frame.origin.y = 0
                let scroll = sender.view as! UIScrollView
                scroll.zoomScale = 1
                self.isFullScreen = false
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                let touchPoint = sender.location(in: scrollView.superview)
                let scrollViewSize = scrollView.bounds.size
                
                let width = scrollViewSize.width / 3
                let height = scrollViewSize.height / 3
                let x = touchPoint.x - (width/2.0)
                let y = touchPoint.y - (height/2.0)
                let rect = CGRect(x: x, y: y, width: width, height: height)
                scrollView.zoom(to: rect, animated: true)
                sender.view?.superview?.viewWithTag(101)?.frame.origin.y = -64
                self.isFullScreen = true
            }
        }
        
        
    }
    
    
    func scrollViewTappedSingle(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25) {
            if (sender.view?.superview?.viewWithTag(101)?.frame.origin.y)! < CGFloat(0) {
                sender.view?.superview?.viewWithTag(101)?.frame.origin.y = 0
                self.isFullScreen = false
            }else{
                sender.view?.superview?.viewWithTag(101)?.frame.origin.y = -64
                self.isFullScreen = true
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        self.view.backgroundColor = UIColor.lightGray
        
        images?.append(["image": "img1", "name": "Image 1"])
        images?.append(["image": "img2", "name": "Image 2"])
        images?.append(["image": "img1", "name": "Image 3"])
        images?.append(["image": "img2", "name": "Image 4"])
        
        for image in images! {
            let vc = createViewController(title: image["name"]!, image: image["image"]!)
            orderedViewControllers.append(vc)
        }
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        let vc = orderedViewControllers[previousIndex]
        if(isFullScreen){
            vc.view.viewWithTag(101)?.frame.origin.y = -64
        }else{
            vc.view.viewWithTag(101)?.frame.origin.y = 0
        }
        return vc
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let nextIndex = currentIndex + 1
        
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        let vc = orderedViewControllers[nextIndex]
        if(isFullScreen){
            vc.view.viewWithTag(101)?.frame.origin.y = -64
        }else{
            vc.view.viewWithTag(101)?.frame.origin.y = 0
        }
        return vc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(100)
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if(isFullScreen){
            orderedViewControllers[currentIndex].view.viewWithTag(101)?.frame.origin.y = -64
        }else{
            orderedViewControllers[currentIndex].view.viewWithTag(101)?.frame.origin.y = 0
        }
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.superview?.backgroundColor = UIColor.black
        if(scrollView.zoomScale > 1){
            UIView.animate(withDuration: 0.5) {
                scrollView.superview?.viewWithTag(101)?.frame.origin.y = -64
                self.isFullScreen = true
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                scrollView.superview?.viewWithTag(101)?.frame.origin.y = 0
                self.isFullScreen = false
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
