/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

////the view controller for the rating interface
import UIKit
import FirebaseStorage

class ReviewViewController: UIViewController {
    
    var alert: Alert!
    
    var storageRef: StorageReference!
    
    //for passing the value in unwind segue
    var rating: String?
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    //assign the value after choosing the rating
    @IBAction func ratingTap(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            rating = "none"
        case 101:
            rating = "med"
        case 102:
            rating = "high"
        default:
            break
        }
        
        //code for unwind segue to be back to detail interface
        performSegue(withIdentifier: "unwindToDetailView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the image from the firebase
        storageRef = Storage.storage().reference()
        
        //let tempImageRef = storageRef.child("K1250823.jpeg")
        let tempImageRef = storageRef.child(alert.key)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        tempImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                self.bgImageView.image = UIImage(data: data!)!
            }
        }
        
        //Blur effect
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        
        effectView.frame = view.frame
        bgImageView.addSubview(effectView)
        
        //Animation for chosen button
        let startPos = CGAffineTransform(translationX: 0, y: 500)
        let startScale = CGAffineTransform(scaleX: 0, y: 0)
        
        ratingStackView.transform = startScale.concatenating(startPos)
    }
    
    //the animation will appear every time users open the rating interface
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1) {
        let endPos = CGAffineTransform(translationX: 0, y: 0)
        let endScale = CGAffineTransform.identity
        self.ratingStackView.transform = endPos.concatenating(endScale)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
