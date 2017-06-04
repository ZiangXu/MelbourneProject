/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

//the view controller for the dailychek interface
import UIKit
import CoreData
import FirebaseDatabase
import FirebaseStorage

//NSFetchedResultsControllerDelegate is the protocol for updating the data.
//UISearchResultsUpdating is the protocol for the search bar
class AreaTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    var ref: DatabaseReference!
    var storage: StorageReference!
    var databaseHandle: DatabaseHandle!
    
    //search bar
    var sc: UISearchController!
    
    var alert = [Alert(cameraId: "aaa", key: "bbb", longitude: 1.1, latitude: 1.1, captureTime: 1, checkIn: "ccc")]
    
    var fc: NSFetchedResultsController<AreaMO>!
    
    var areas: [AreaMO] = []
    
    var searchResult: [AreaMO] = []
    
    //the method for searching 
    func searchFilter(text: String) {
        searchResult = areas.filter({ (area) -> Bool in
            return area.name!.localizedCaseInsensitiveContains(text)
        })
    }

    //the method required by UISearchResultsUpdating protocol to update the table and display the result
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text {
            
            //ignore whitespace
            text = text.trimmingCharacters(in: .whitespaces)
            
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the firebase reference
        ref = Database.database().reference()
        
        //search bar
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
       
        //the background of the search bar
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Input cameraID to search"
        sc.searchBar.searchBarStyle = .minimal
        
        //delete the text for the back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //fetch the data from Area entity
        fetchAllData()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //use UserDefaults to check whether the guider interface appeared or not. If appeared, then return.
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "GuiderShow") {
            return
        }
        
        //show the guider interface before showing the dailycheck interface
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "GuideController") as? GuiderViewController {
            present(pageVC, animated: true, completion: nil)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            tableView.reloadData()
        }
        
        if let object = controller.fetchedObjects {
            areas = object as! [AreaMO]
        }
    }
    
    //fetch the data from the area entity
    func fetchAllData() {
        let request: NSFetchRequest<AreaMO> = AreaMO.fetchRequest()
        let sd = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sd]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        fc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fc.delegate = self
        
        do {
            try fc.performFetch()
            if let object = fc.fetchedObjects {
                areas = object
            }
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view delegate
    
    //add Share, Top and Delet funtions for each camera item
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //top
        let actionTop = UITableViewRowAction(style: .normal, title: "Top") { (_, _) in
        }
        
        actionTop.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 0/255, alpha: 1)
        
        //share
        let actionShare = UITableViewRowAction(style: .normal, title: "Share") { (_, indexPath) in
            let actionSheet = UIAlertController(title: "Share by", message: nil, preferredStyle: .actionSheet)
            let option1 = UIAlertAction(title: "Facebook", style: .default, handler: nil)
            let option2 = UIAlertAction(title: "Wechat", style: .default, handler: nil)
            let optionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(option1)
            actionSheet.addAction(option2)
            actionSheet.addAction(optionCancel)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        actionShare.backgroundColor = UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1)
        
        //delet
        let actionDel = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(self.fc.object(at: indexPath))
            appDelegate.saveContext()
        }
        
        return [actionDel, actionTop, actionShare]
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //choose when searching result is displayed and when gereal table is displayed
        return sc.isActive ? searchResult.count : areas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let area = sc.isActive ? searchResult[indexPath.row] : areas[indexPath.row]
        
        // Configure the cell
        cell.nameLabel.text = area.name
        cell.todayLabel.text = "Today:"
        
        //read the data from the firebase and store them in a list.
        databaseHandle = ref.child("camera1").child("cameraId").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! String
            self.alert[0].cameraId = postDict
        })
        
        databaseHandle = ref.child("camera1").child("latitude").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! Double
            self.alert[0].latitude = postDict
            
        })
        
        databaseHandle = ref.child("camera1").child("longitude").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! Double
            self.alert[0].longitude = postDict
            
        })
        
        databaseHandle = ref.child("camera1").child("captureTime").observe(DataEventType.value, with: { (snapshot) in
            let timeStamp = snapshot.value as! Int
            self.alert[0].captureTime = timeStamp
            
        })
        
        databaseHandle = ref.child("camera1").child("checkIn").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! String
            self.alert[0].checkIn = postDict
            cell.statusLabel.text = self.alert[0].checkIn
        })
        
        databaseHandle = ref.child("camera1").child("imagePath").child("Key").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! String
            self.alert[0].key = postDict
            
        })

        //Show thumbnail
        cell.thumbImageView.image = UIImage(data: area.image as! Data)
        
        //Make it be a circle
        cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.frame.size.width/2
        cell.thumbImageView.clipsToBounds = true
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !sc.isActive
    }
 
    //the function fro unwind segue
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showAreaDetail" {
            let dest = segue.destination as! DetailTableViewController
            
            //pass the value according to click the searching result or gerenal table
            if sc.isActive {
                dest.area = searchResult[tableView.indexPathForSelectedRow!.row]
                for index in 0 ..< alert.count {
                    if searchResult[tableView.indexPathForSelectedRow!.row].name == alert[index].cameraId {
                        dest.alert = alert[index]
                    }
                }
            } else {
                dest.area = areas[tableView.indexPathForSelectedRow!.row]
                for index in 0 ..< alert.count {
                    if areas[tableView.indexPathForSelectedRow!.row].name == alert[index].cameraId {
                        dest.alert = alert[index]
                    }
                }
            }
        }
    }
}
