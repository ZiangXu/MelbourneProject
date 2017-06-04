/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

//the view controller for the map interface
import UIKit
import MapKit
import CoreLocation
import FirebaseStorage

//MKMapViewDelegate is the protocol for making the map
class MapViewController: UIViewController, MKMapViewDelegate {
    
    var area: AreaMO!
    var alert: Alert!
    var storageRef: StorageReference!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsScale = true
        mapView.showsCompass = true

        //standard map
        mapView.mapType = MKMapType.standard
        
        //create an object of MKCoordinateSpan. set the range of the map (the smaller, the more accurate)
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //use the latitude and the longitude
        let center:CLLocation = CLLocation(latitude: alert.latitude, longitude: alert.longitude)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                                                                  span: currentLocationSpan)
        mapView.setRegion(currentRegion, animated: true)

        //annotation
        let annotation = MKPointAnnotation()
        annotation.title = self.alert.cameraId
        annotation.subtitle = "\(self.alert.longitude),\(self.alert.latitude)"
        
        annotation.coordinate = center.coordinate
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
    
    //define the stlye of the annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        //reuse the annotation for the efficiency
        let id = "myid"
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView
        
        //if reusing fail, initial a new one
        if av == nil {
            av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            av?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        
        //get the image from the firebase
        storageRef = Storage.storage().reference()
        
        let tempImageRef = storageRef.child(alert.key)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        tempImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                leftIconView.image = UIImage(data: data!)!
            }
        }
        
        av?.leftCalloutAccessoryView = leftIconView
        
        //the color of the pin
        av?.pinTintColor = UIColor.red
        
        return av
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
