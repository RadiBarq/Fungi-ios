
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import CoreLocation

class ThirdViewController: UIViewController ,GIDSignInDelegate, GIDSignInUIDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var singInButton: GIDSignInButton!
    
    static var email = String()
    
    static var displayName = String()
    
    static var userImage:URL?
    
    var startLocation: CLLocation!
    
    static var stringLocation = String()
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        navigationItem.title = "Nearby Pokemons"
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
    }
    
    // So here we deal with the errors concerns
    @available(iOS 6.0, *)
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        FirstViewController.stringLocation = String(latestLocation.coordinate.latitude)  + " " + String(latestLocation.coordinate.longitude)
        
        print(FirstViewController.stringLocation)
        
        // print (AddPokemonViewController.stringLocation)
        
    }
    
    
    @available(iOS 2.0, *)
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        //Todo if the location is not available
        //TODO Also with the location concerns
        
        
        print("Location Error happened here")
        
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
            
            
            var userLoginReference = FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName)
            
            userLoginReference.updateChildValues(["displayName": ThirdViewController.displayName, "email": ThirdViewController.email])
            
            
            if (FirstViewController.stringLocation == "")
            {
                let alertController = UIAlertController(title: "Please enable location service for this app!", message: "To enable location visit Settings-Fungi-Location-Enable Location", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
                
            else
            {
                
                // This is related to move the controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let firstViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(firstViewController, animated: true, completion: nil)
                // ...
            }
            
            
        }
        
    }
}
