//
//  MyPokemonsController.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/27/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import UIKit
import Firebase

class MyPokemonsController: UITableViewController{
    
        @IBOutlet weak var deletButton: UIButton!
        var pokemons = [String]()
        var cps = [String]()
        var ids = [String]()
        var publicNames = [String]()
        var images = [UIImage]()
        var ref: FIRDatabaseReference!
        var distances = [String]()
        var holdingRow = Int()
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        ref.child("Users").child(ThirdViewController.displayName).child("pokemons").observe(.value, with: {snapshot in
            
            self.pokemons = [String]()
            self.cps = [String]()
            self.publicNames = [String]()
            self.images = [UIImage]()
            self.distances = [String]()
            self.ids = [String]()
            
            self.popluateCells(s: snapshot)
            
            self.tableView.reloadData()
            
        })
        
        let buttonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        buttonItem.tintColor = UIColor.white
        
        navigationItem.leftBarButtonItem = buttonItem
        
        
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
    
    @IBOutlet var holdingView: UIView!
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellMyPokemons
        
        // Configure the cell...
        
        cell.pokemonName.text = pokemons[indexPath.row]
        cell.pokemonCp.text = cps[indexPath.row]
        cell.publicName.text = publicNames[indexPath.row]
        cell.photo.image = images[indexPath.row]
        cell.distance.text = distances[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    
    }
    
    
    func addView()
    {
        
        view.superview?.addSubview(holdingView)
        
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        
        holdingView.layer.cornerRadius = 5
        
        //   holdView.translatesAutoresizingMaskIntoConstraints = false
        holdingView.center = view.center
        
        
        holdingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        holdingView.alpha = 0
        
        UIView.animate(withDuration: 0.4)
        {
            // self.visualEffect.effect = self.effect
            self.holdingView.alpha = 1
            self.holdingView.transform = CGAffineTransform.identity
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        holdingRow = indexPath.row
        addView()
    
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .delete {
            
            // here to do the indexing
            confirmDelete()
            
        }
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
            
            ids.append(String(describing: (Id as! FIRDataSnapshot).key))
            
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
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        removeView()
        
    }
    
    
    func removeView()
    {
        
        UIView.animate(withDuration: 0.3, animations:
            {
                self.holdingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.holdingView.alpha = 0
        })
            
        {(success: Bool) in
            
            self.holdingView.removeFromSuperview()
        }
        
        
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        // tableView.deselectRow(at: holdingTouchIndex, animated: true)
        
        //fetchUsers()
    }
    
    @IBAction func deletePokemonAction(_ sender: UIButton) {
        
        var userPokemonreference = FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).child("pokemons").child(ids[holdingRow]).removeValue()
        
            removeView()
        
    }
    
    func confirmDelete() {
        
        let alert = UIAlertController(title: "Delete Planet", message: "Are you sure you want to permanently delete this pokemon?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func handleDeletePlanet(alertAction: UIAlertAction!)
    {
        
        
    }
    
    
    func cancelDeletePlanet(alertAction: UIAlertAction!)
    {
        
        
        
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
    
}
