/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

//the view controller for the add interface
import UIKit
import CoreData

//UIImagePickerControllerDelegate and UINavigationControllerDelegate are the protocols for using photo album
class AddAreaController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var area : AreaMO!
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBAction func saveTap(_ sender: UIBarButtonItem) {
        //get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //save the data
        area = AreaMO(context: appDelegate.persistentContainer.viewContext)
        area.name = tfName.text

        if let imageData = UIImageJPEGRepresentation(coverImageView.image!, 0.7) {
            area.image = NSData(data: imageData)
        }
        print("saving")
        appDelegate.saveContext()
        
        //unwind segue to go back to the dailycheck interface
        performSegue(withIdentifier: "unwindToHomeList", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //After picking the photo, the photo will be shown in the imageview
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        coverImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        
        //constrain
        let coverWidthCons = NSLayoutConstraint(item: coverImageView, attribute: .width, relatedBy: .equal, toItem: coverImageView.superview, attribute: .width, multiplier: 1, constant: 0)
        
        let coverHeightCons = NSLayoutConstraint(item: coverImageView, attribute: .height, relatedBy: .equal, toItem: coverImageView.superview, attribute: .height, multiplier: 1, constant: 0)
        
        coverWidthCons.isActive = true
        coverHeightCons.isActive = true
        
        //dimiss the view
        dismiss(animated: true, completion: nil)
    }
    
    
    //select talbe cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //Check whether the photo album can be used or not
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("Photo album cannot be used！")
                return
            }
            //If the photo album can be used
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            
            //If you want to use the camera, change photoLibrary to camera.
            picker.sourceType = .photoLibrary
            
            //Set the delegate as itself
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
