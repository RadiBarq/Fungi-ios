//
//  AddPokemonViewController.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/25/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation



//


class AddPokemonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate{
    
     @IBOutlet weak var picker: UIPickerView!

    var locationManager: CLLocationManager = CLLocationManager()
    
    var startLocation: CLLocation!
    
    var stringLocation = String()
    
    @IBOutlet weak var textFieldCp: UITextField!
    
    var pokemonsNames = PokemonsNames()
    
    var pickerData = Array<String>()
    
    var ref: FIRDatabaseReference!
    
   
    
     var chosenPokemon = "Bulbasaur"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil

        
        pickerData = pokemonsNames.getPokomensNames()
        
        picker.dataSource = self
        picker.delegate = self
        
        
         ref = FIRDatabase.database().reference()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
            
            return 1;
            
    }
    
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }
    
    
    @available(iOS 2.0, *)
     public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
            return pickerData[row]
        
    }
    
    
    // This is when the user select a row
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        chosenPokemon = pickerData[row]
        
    }

    
    
    @IBAction func buttonTrade(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Cp Is Wrong!", message: "please check pokemon cp", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        let cp = textFieldCp.text!
        
        if (cp == "")
        {
            present(alertController, animated: true, completion: nil)
   
        }
        
        else
        {
            if (rightCp(number: Int(cp)!) == true)
            {
                //TODO firebase wor
                
                // This is when getting the location failed.
                if stringLocation == ""
                {
                    let alertController = UIAlertController(title: "Location Problem!", message: "Please check your location service and try again", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    present(alertController, animated: true, completion: nil)
                    

                }
                
                 // This is when everything works well
                else
                {
                    addNewUser(pokemon: chosenPokemon, cp: cp, location: stringLocation, publicName: ThirdViewController.displayName)
                }
            }
            
            else
            {
                present(alertController, animated: true, completion: nil)

            }
            
        }
        
        
    }
    
    func rightCp(number: Int) -> Bool
    {
        
        if number <= 0 || number >= 5000
        {
            return false
        
        }
            
            
            
        else
        {
            return true
        }
        
    }
    
    
    
    func addNewUser(pokemon: String, cp: String, location: String, publicName: String)
    {
        
        let pokemon = Pokemon(pokemon: pokemon, cp: cp, location: location, publicName: publicName)
       
        self.ref.child("Pokemons").childByAutoId().setValue(pokemon.pokemonDictionary)
        
        
        
        // And this is to present the alert view
        let alertController = UIAlertController(title: "Great Trainer!", message: "Your pokemon has been added!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
        // This is to go to neraby screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(firstViewController, animated: true, completion: nil)
        
    }
    
    @available(iOS 6.0, *)
     public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        stringLocation = String(latestLocation.coordinate.latitude)  + " " + String(latestLocation.coordinate.longitude)
    
        print (stringLocation)
        
    }

   
    @available(iOS 2.0, *)
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
        print("Location Error happened here")
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
