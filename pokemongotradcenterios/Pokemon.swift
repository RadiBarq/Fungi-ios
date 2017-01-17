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
    
    private var pokemonName = String()
    private var cp = String()
    private var location = String()
    private var  publicName = String()
    public var pokemonDictionary = Dictionary<String, String>() // This is the public dictionary
    private var pokemonImage = UIImage()
    private var distance = Double()
    
    
    
    init (pokemon: String, cp: String, location: String, publicName: String, pokemonImage: UIImage)
    {
        self.pokemonName = pokemon
        self.cp = cp
        self.location = location
        self.publicName = publicName
        self.pokemonImage = pokemonImage
    }
    
    
    
    init (pokemon: String, cp: String, location: String, publicName: String)
    {
        self.pokemonName = pokemon
        self.cp = cp
        self.location = location
        self.publicName = publicName
        
        pokemonDictionary = ["Pokemon": pokemon, "Cp":cp, "Location":location, "PublicName":publicName]
    }
    
    
    public func getPokemonName() -> String
    {
        return pokemonName
    }
    
    
    public func getPokemonCp() -> String
    {
        return cp
    }
    
    
    public func getPokemonLocation() -> String
    {
        return  location
        
    }
    
    public func getPublicName() -> String
    {
        return publicName
    }
    
    public func getPokemonImage() -> UIImage
    {
        return pokemonImage
    }
    
    public func returnDictionary() -> Dictionary<String, String>
    {
        return pokemonDictionary
        
    }
    
    
    func getDistance() -> Double
    {
        return distance
        
    }
    
    
    func setDistance(d: Double)
    {
        
        distance = d
        
    }
    
}
