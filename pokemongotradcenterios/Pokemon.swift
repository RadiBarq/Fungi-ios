//
//  Pokemon.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/26/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import Foundation
import Firebase

class Pokemon: NSObject
{
    var Pokemon = String()
    var Cp = String()
    var Location = String()
    var  PublicName = String()
    var pokemonDictionary = Dictionary<String, String>()
    
    
    init (pokemon: String, cp: String, location: String, publicName: String)
    {
        Pokemon = pokemon
        Cp = cp
        Location = location
        PublicName = publicName
        
        
        pokemonDictionary = ["Pokemon": Pokemon, "Cp":Cp, "Location":Location, "PublicName":PublicName]
        
    }
    
    func returnDictionary() -> Dictionary<String, String>
    {
        return pokemonDictionary
        
    }
    

}
