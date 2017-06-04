/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
*/

//view cell for the detailed interface
import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
