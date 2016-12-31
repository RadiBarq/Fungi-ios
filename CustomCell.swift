//
//  CustomCell.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/27/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonCp: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var publicName: UILabel!
    
    @IBOutlet weak var photo: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
