/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

import UIKit

class ContentViewController: UIViewController {
    var index = 0
    var heading = ""
    var imageName = ""
    var footer = ""
    
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var laberFooter: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnDone: UIButton!
    
    //the guider interface will disappear after clicking this button
    @IBAction func doneBtnTap(_ sender: UIButton) {
        
        //use UserDefaults to store a parameter about whether the guider interface has been shown or not
        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: "GuiderShow")
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelHeading.text = heading
        laberFooter.text = footer
        imageView.image = UIImage(named: imageName)
        
        //let the page number correct
        pageControl.currentPage = index
        
        //the button will be hiden if the guider interface is not the last one.
        btnDone.isHidden = (index != 2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
