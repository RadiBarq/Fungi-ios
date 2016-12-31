//
//  PopulatePokemons.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/26/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import Foundation
import Firebase

class PopulatePokemons
{
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var pokemonsList = [Pokemon]()


    init()
    {
        
        ref = FIRDatabase.database().reference().child("Pokemons")
        
    }

    
}
