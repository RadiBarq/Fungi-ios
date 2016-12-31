//
//  ThirdViewController.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/23/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ThirdViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
    
    @IBOutlet weak var singInButton: GIDSignInButton!
    
    static var email = String()
    static var displayName = String()
    static var userImage:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        navigationItem.title = "Nearby Pokemons"

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            // ...
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                    accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                // ...
                print(error.localizedDescription)
                return
            }
            
            // This is when the user loged in.
            
            
            
            print ("User login with google....")
            
        
            ThirdViewController.email = user!.email!
            ThirdViewController.displayName = user!.displayName!
            ThirdViewController.userImage = user!.photoURL
            
            
            
            
            // This is related to move the controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let firstViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(firstViewController, animated: true, completion: nil)
        // ...
    }
    
    
    }
    
}
