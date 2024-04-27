//
//  PostsTableViewCell.swift
//  Techiebutler_Test
//
//  Created by techstalwarts on 26/04/24.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    
    func configureCell(data: GetPostsResponse) {
        titleLabel.text = data.title
        postLabel.text = data.body
        idLabel.text = "\(data.id ?? 0)"
        userIdLabel.text = "\(data.userId ?? 0)"
        
    }

}
