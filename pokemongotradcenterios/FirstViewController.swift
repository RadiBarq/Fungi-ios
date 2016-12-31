//
//  FirstViewController.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/22/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UITableViewController {
    
    @IBOutlet var clickedButtonView: UIView!
    
    @IBOutlet var visualEffect: UIVisualEffectView!
    
    static var messageTo_DisplayName = String()
    
    
    var effect:UIVisualEffect!
    
    @IBAction func showMessageView(_ sender: UIButton) {
        
        
        //let usersRef = FIRDatabase.database().reference().child("Users").child("chat").child(ThirdViewController.displayName)
        
        //createMessageFireBase()
        
        // This is related to move the controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "SendMessageNavigation") as! UINavigationController
        
        self.present(firstViewController, animated: true, completion: nil)

        
    }
    
    
    
    
    
    
    @IBAction func closeView(_ sender: UIButton) {
        
        removeView()
    }
   
    var ref: FIRDatabaseReference!
    
    var pokemons = [String]()
    var cps = [String]()
    var publicNames = [String]()
    var images = [UIImage]()
    var distances = [String]()
    var ids = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        ref = FIRDatabase.database().reference()
        
        effect = visualEffect.effect
        
        visualEffect.effect = nil
        
        
        clickedButtonView.layer.cornerRadius = 5
        
        
        ref.child("Pokemons").observe(.value, with: {snapshot in
            
            self.pokemons = [String]()
            self.cps = [String]()
            self.publicNames = [String]()
            self.images = [UIImage]()
            self.distances = [String]()
            self.popluateCells(s: snapshot)
            
            self.tableView.reloadData()
        })
    
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(ids[indexPath.row])
        
        FirstViewController.messageTo_DisplayName = publicNames[indexPath.row]
        
        addView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
                    // loop through the children and append them to the new array
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int
    {
        
        return pokemons.count
        
    }
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.pokemonName.text = pokemons[indexPath.row]
        cell.pokemonCp.text = cps[indexPath.row]
        cell.distance.text = distances[indexPath.row]
        cell.publicName.text = publicNames[indexPath.row]
        cell.photo.image = images[indexPath.row]

            return cell
        // Set Cell contents
    }
    
    func popluateCells(s: FIRDataSnapshot!)
    {
        for Id in s.children
        {
            //pokemonsList.append(onePokemon as! FIRDataSnapshot)
            
             let parentKey = String(describing: (Id as! FIRDataSnapshot).key)
            
             ids.append(parentKey)
            
            for pokemon in (Id as! FIRDataSnapshot).children
            {
                let childValue = String(describing: (pokemon as! FIRDataSnapshot).value!) // Remeber this value maybe value.
                
                let childKey = String(describing: (pokemon as! FIRDataSnapshot).key)
               
                if (childKey == "Cp")
                {
                    cps.append(childValue)
                }
                
                else if (childKey == "Location")
                {
                    distances.append(childValue)
                }
                
                else if (childKey == "Pokemon")
                {
                    pokemons.append(childValue)
                    images.append(UIImage(named: childValue.lowercased())!)
                    
                }
                
                else if (childKey == "PublicName")
                {
                    publicNames.append(childValue)
                }
        
            }
            
        }
    }
    
    
    func addView()
    {
        self.view.addSubview(clickedButtonView)
        clickedButtonView.center = self.view.center
        
        clickedButtonView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        clickedButtonView.alpha = 0
        
        UIView.animate(withDuration: 0.4)
        {
            self.visualEffect.effect = self.effect
            self.clickedButtonView.alpha = 1
            self.clickedButtonView.transform = CGAffineTransform.identity
        }
        
    }
    
    func removeView()
    {
       UIView.animate(withDuration: 0.3, animations:
        {
            
            self.clickedButtonView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.clickedButtonView.alpha = 0
            self.visualEffect.effect = nil
       })
    
        
       {(success: Bool) in
        self.clickedButtonView.removeFromSuperview()
        
        }
    }
    
    
    func createMessageFireBase()
    {
        let chatRef = FIRDatabase.database().reference().child("Chat").childByAutoId()
        
        let autoId = chatRef.key
        
        
        let usersRef = FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).child("chat") .updateChildValues([FirstViewController.messageTo_DisplayName : autoId])
        
        
        chatRef.child(ThirdViewController.displayName).child(FirstViewController.messageTo_DisplayName)
        
    }
    
}
