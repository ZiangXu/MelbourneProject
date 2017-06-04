/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

//the view controller for the guider interface
import UIKit

//UIPageViewControllerDataSource is the protocol that the guirder interface needs.
class GuiderViewController: UIPageViewController, UIPageViewControllerDataSource {

    var headings = ["PANTHERA", "PANTHERA", "PANTHERA"]
    var images = ["web1", "web2", "logo"]
    var footers = ["Our Work", "Conserve Tigers", "Take Actions"]
    
    //two functions that UIPageViewControllerDataSource protocol needs to realize
    //get the next page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        
        index += 1
        
        return vc(atIndex: index)
    }
    
    //get the last page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        
        index -= 1
        
        return vc(atIndex: index)
    }
    
    //get a ContentViewController
    func vc(atIndex: Int) -> ContentViewController? {
        if case 0..<headings.count = atIndex{
            if let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentController") as? ContentViewController{
                
                contentVC.heading = headings[atIndex]
                contentVC.footer = footers[atIndex]
                contentVC.imageName = images[atIndex]
                contentVC.index = atIndex
                
                return contentVC
            }
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //set the data source as itself
        dataSource = self
        
        //create the first interface
        if let startVC = vc(atIndex: 0) {
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
