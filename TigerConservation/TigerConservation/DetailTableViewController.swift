/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

////the view controller for the detailed interface
import UIKit
import FirebaseDatabase
import FirebaseStorage

class DetailTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    
    var area : AreaMO!
    var alert : Alert!
    
    //the variables for image processing. There is no need to creart them every time.
    var context: CIContext!
    var filter: CIFilter!
    var beginCIImage: CIImage!
    
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var LargeImageView: UIImageView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var tfLabel: UITextField!
    
    //send button
    @IBAction func btnSend(_ sender: UIButton) {
        let window = UIAlertController(title: "Do you want to send the severity and the notes?", message: nil, preferredStyle: .alert)
        
        let option1 = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            
            //current time
            let currentTime = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        
            self.ref.child("camera1").child("sendTime").setValue(formatter.string(from: currentTime as Date))
            self.ref.child("camera1").child("severity").setValue(self.area.rating)
            self.ref.child("camera1").child("notes").setValue(self.tfLabel.text)
        }
        
        let option2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
        window.addAction(option1)
        window.addAction(option2)
            
        self.present(window, animated: true, completion: nil)
    }
    
    //sliders for the image processing
    @IBAction func brightnessSlider(_ sender: UISlider) {
        let sliderValue = sender.value
        
        filter?.setValue(sliderValue, forKey: "inputBrightness")
        
        let outputCIImage = filter?.outputImage
        let cgimg = context.createCGImage(outputCIImage!, from: (outputCIImage?.extent)!)
        let newImage = UIImage(cgImage: cgimg!)
        
        LargeImageView.image = newImage
    }
    
    @IBAction func contrastSlider(_ sender: UISlider) {
        let sliderValue = sender.value
        
        filter?.setValue(sliderValue, forKey: "inputContrast")
       
        let outputCIImage = filter?.outputImage
        let cgimg = context.createCGImage(outputCIImage!, from: (outputCIImage?.extent)!)
        let newImage = UIImage(cgImage: cgimg!)
        
        LargeImageView.image = newImage
    }
    
    @IBAction func saturationSlider(_ sender: UISlider) {
        let sliderValue = sender.value
        
        filter?.setValue(sliderValue, forKey: "inputSaturation")
        
        let outputCIImage = filter?.outputImage
        let cgimg = context.createCGImage(outputCIImage!, from: (outputCIImage?.extent)!)
        let newImage = UIImage(cgImage: cgimg!)
        
        LargeImageView.image = newImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //zoom
        self.myScrollView.minimumZoomScale = 1.0
        self.myScrollView.maximumZoomScale = 5.0
        
        //firebase
        ref = Database.database().reference()
        
        //get the image from the firebase
        storageRef = Storage.storage().reference()
        
        let tempImageRef = storageRef.child(alert.key)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        tempImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let beginImage = UIImage(data: data!)!
                
                //using core image to realize the image processing
                self.beginCIImage = CIImage(image: beginImage)
                self.filter = CIFilter(name: "CIColorControls")
                self.filter?.setDefaults()
                self.filter?.setValue(self.beginCIImage, forKey: "inputImage")
                
                let outputCIImage = self.filter?.outputImage
            
                self.context = CIContext(options: nil)
                
                let cgimg = self.context.createCGImage(outputCIImage!, from: (outputCIImage?.extent)!)
                let newImage = UIImage(cgImage: cgimg!)
                
                self.LargeImageView.image = newImage
            }
        }
        
        tableView.backgroundColor = UIColor(white: 1, alpha: 1)
        
        //the color of the seprator
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
    
        //the title of view
        self.title = area.name
    }
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.LargeImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //show different backgrounds based on different rating
        if let rating = area.rating {
            if rating == "none" {
                self.ratingBtn.setBackgroundImage(#imageLiteral(resourceName: "noneBack"), for: .normal)
                self.ratingBtn.setImage(UIImage(named: rating), for: .normal)
            }
            if rating == "med" {
                self.ratingBtn.setBackgroundImage(#imageLiteral(resourceName: "medBack"), for: .normal)
                self.ratingBtn.setImage(UIImage(named: rating), for: .normal)
            }
            if rating == "high" {
                self.ratingBtn.setBackgroundImage(#imageLiteral(resourceName: "highBack"), for: .normal)
                self.ratingBtn.setImage(UIImage(named: rating), for: .normal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "CameraID"
            cell.valueLabel.text = area.name
        case 1:
            cell.fieldLabel.text = "Latitude"
            cell.valueLabel.text = "\(alert.latitude)"
        case 2:
            cell.fieldLabel.text = "Longitude"
            cell.valueLabel.text = "\(alert.longitude)"
        case 3:
            cell.fieldLabel.text = "CaptureTime"

            //convert to time people can understand
            let timeInterval:TimeInterval = TimeInterval(alert.captureTime)
            let date = NSDate(timeIntervalSince1970: timeInterval)
            let dformatter = DateFormatter()
            dformatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        
            cell.valueLabel.text = "\(dformatter.string(from: date as Date))"
        default:
            break
        }
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMap" {
            let destvc = segue.destination as! MapViewController
            destvc.area = self.area
            destvc.alert = self.alert
        }
        
        if segue.identifier == "showReview" {
            let destvc = segue.destination as! ReviewViewController
            destvc.alert = self.alert
        }
    }
    
    //the function for unwind segue
    @IBAction func close(segue : UIStoryboardSegue) {
        let reviewVC = segue.source as! ReviewViewController
        
        if let rating = reviewVC.rating {
            self.area.rating = rating
            self.ratingBtn.setImage(UIImage(named: rating), for: .normal)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
}
