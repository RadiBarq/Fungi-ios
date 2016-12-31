//
//  MyPokemonsController.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/27/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import UIKit
import Firebase

class MyPokemonsController: UITableViewController {
    
    
    var pokemons = [String]()
    var cps = [String]()
    var publicNames = [String]()
    var images = [UIImage]()
    var ref: FIRDatabaseReference!
    var distances = [String]()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        
        ref.child("Pokemons").observe(.value, with: {snapshot in
            
            self.pokemons = [String]()
            self.cps = [String]()
            self.publicNames = [String]()
            self.images = [UIImage]()
            self.distances = [String]()
            
            
            self.popluateCells(s: snapshot)
            
            self.tableView.reloadData()
            
        })

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokemons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellMyPokemons

        // Configure the cell...
        
        cell.pokemonName.text = pokemons[indexPath.row]
        cell.pokemonCp.text = cps[indexPath.row]
        cell.publicName.text = publicNames[indexPath.row]
        cell.photo.image = images[indexPath.row]
        cell.distance.text = distances[indexPath.row]
     
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func popluateCells(s: FIRDataSnapshot!)
    {
        for Id in s.children
        {
            //pokemonsList.append(onePokemon as! FIRDataSnapshot)
            
            for pokemon in (Id as! FIRDataSnapshot).children
            {
                let childValue = String(describing: (pokemon as! FIRDataSnapshot).value!) //Remember this is an optional value.
                
                let childKey = String(describing: (pokemon as! FIRDataSnapshot).key)
                
                if (childKey == "Cp")
                {
                    cps.append(childValue)
                }
                    
                else if (childKey == "Pokemon")
                {
                    pokemons.append(childValue)
                    images.append(UIImage(named: childValue.lowercased())!)
                    
                    
                }
                    
                else if (childKey == "Location")
                {
                    distances.append(" ")
                }

                    
                else if (childKey == "PublicName")
                {
                    if (childValue == ThirdViewController.displayName)
                    {
                    
                        publicNames.append(childValue)
                    }
                    
                    else
                    {
                        cps.popLast()
                        images.popLast()
                        pokemons.popLast()
                        distances.popLast()
                        
                        
                    }
                    
                }
                
            }
            
        }
    }
}
