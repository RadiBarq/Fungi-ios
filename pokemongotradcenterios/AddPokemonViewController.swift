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
import GeoFire



//


class AddPokemonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate{
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var cpTextField: UITextField!
    
    @IBOutlet weak var textFieldCp: UITextField!
    
    var pokemonsNames = PokemonsNames()
    
    var pickerData = Array<String>()
    
    var ref: FIRDatabaseReference!
    
    var chosenPokemon = "Bulbasaur"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        textFieldCp.addTarget(self, action: "addDoneButtonOnKeyboard", for: UIControlEvents.touchDown)
        
        
        let buttonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        buttonItem.tintColor = UIColor.white
        
        navigationItem.leftBarButtonItem = buttonItem
        
    
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
                if FirstViewController.stringLocation == ""
                {
                    let alertController = UIAlertController(title: "Location Problem!", message: "Please check your location service and try again", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    present(alertController, animated: true, completion: nil)
                    
                }
                    
                    // This is when everything works well
                else
                {
                    // This is awsome
                    addNewUser(pokemon: chosenPokemon, cp: cp, location: FirstViewController.stringLocation, publicName: ThirdViewController.displayName)
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
        
        ref = ref.child("Pokemons").childByAutoId()
        
        var autoId = ref.key
        
        var userRefrence = FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).child("pokemons").child(autoId)
        
        ref.setValue(pokemon.pokemonDictionary)
        userRefrence.setValue(pokemon.pokemonDictionary)

        
        let geofireRef = FIRDatabase.database().reference().child("Pokemons Location")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        
        ref = FIRDatabase.database().reference()
        
        
        var userCoordinates = location.components(separatedBy: " ")
        
        var lat = CLLocationDegrees(userCoordinates[0])!
        var lon = CLLocationDegrees(userCoordinates[1])!
        
        
        geoFire?.setLocation(CLLocation(latitude: lat, longitude: lon), forKey: autoId)
        { (error) in
            
            if error != nil {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
            
        }
        
        
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
    
        func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "ThirdViewController")
        self.present(firstViewController, animated: true, completion: nil)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame:  CGRect(x: 0, y: 0, width: 320, height: 50))
        
        doneToolbar.barStyle = UIBarStyle.default
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        done.tintColor = UIColor.orange
        
        var items = [UIBarButtonItem]()
        items.append(done)
        items.append(flexSpace)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textFieldCp.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction()
    {
        
        self.textFieldCp.resignFirstResponder()
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
