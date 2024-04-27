//
//  PostCommentsTableViewCell.swift
//  Techiebutler_Test
//
//  Created by techstalwarts on 26/04/24.
//

import UIKit

class PostCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configureCell(data: GetComments.Response) {
        comment.text = data.body
        nameLabel.text = data.name
        emailLabel.text = data.email
    }
    
}
