/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

//the view controller for the about interface
import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitle = ["Feedback", "Follow our webpage"]
    var sectionContent = [["Rate the app on app store", "Advice"], ["Home page", "Our work", "Donate"]]
    var links1 = ["https://www.apple.com/au//?afid=p238%7CsWvpb2gYZ-dc_mtid_18707vxu38484_pcrid_176873174365_&cid=aos-au-kwgo-brand--slid-", "https://www.apple.com/retail/"]
    var links2 = ["https://www.panthera.org/", "https://www.panthera.org/initiative/tigers-forever", "https://www.panthera.org/donate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 3
    }

    //the title of section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            //use SFSafariViewController to open the webpage
            if let url = URL(string: links1[indexPath.row]) {
                let sfVc = SFSafariViewController(url: url)
                present(sfVc, animated: true, completion: nil)
            }
        case 1:
            //use SFSafariViewController to open the webpage
            if let url = URL(string: links2[indexPath.row]) {
                let sfVc = SFSafariViewController(url: url)
                present(sfVc, animated: true, completion: nil)
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
