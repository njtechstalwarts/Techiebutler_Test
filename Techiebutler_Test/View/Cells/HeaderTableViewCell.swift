//
//  HeaderTableViewCell.swift
//  Techiebutler_Test
//
//  Created by techstalwarts on 26/04/24.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureCell(header: String) {
        headerLabel.text = header
    }

}
