//
//  TableViewCell.swift
//  Play
//
//  Created by Rajesh Senapathi on 18/05/1400 AP.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func cell(id :Int,userid: Int,email: String) {
        idLabel.text = String(id)
        emailLabel.text =  String(userid)
        usernameLabel.text = email
        
    }
    func loadWithViewModel(indexpath  :IndexPath){
        let some = jsonParser.shared.configurecell(indexpath: indexpath)
        cell(id: some.id, userid: some.userID, email: some.title)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
