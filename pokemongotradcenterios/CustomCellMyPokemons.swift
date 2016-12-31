//
//  CustomCellMyPokemons.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/27/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import UIKit


class CustomCellMyPokemons: UITableViewCell  {
    
    @IBOutlet weak var publicName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var pokemonCp: UILabel!
    @IBOutlet weak var pokemonName: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
}
