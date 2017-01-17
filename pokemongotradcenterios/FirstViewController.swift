//
//  FirstViewController.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/22/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import UIKit
import Firebase
import GeoFire
import Foundation
import GoogleMobileAds
import UserNotifications

class FirstViewController: UITableViewController, CLLocationManagerDelegate, GADBannerViewDelegate {
    
    @IBOutlet var loadingScreenView: UIView!
    
    @IBOutlet var clickedButtonView: UIView!
    
    static var notificationsNumber = 0
    
    
    static var messageTo_DisplayName = String()
    
    var radius = Double()
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    
    var startLocation: CLLocation!
    
    static var stringLocation = ""
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var ref: FIRDatabaseReference!
    
    var geoLocationsKeys = [String]()
    
    var indicator = UIActivityIndicatorView()
    
    var reachThEndOfTheTable = Bool()
    var tablePreviousPokemonsNumber = Int()
    
    var tablePokemonNumber = Int()
    
    let maxRadius:Double = 14
    
    var spinnerWhileOpenTheView = true
    
   // var isRefreshing: Bool
    

    //@IBOutlet var bannerView: GADBannerView!
     let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    @IBAction func showMessageView(_ sender: UIButton) {
        
        //let sendMessageController = UICollectionViewController()
        //navigationController?.pushViewController(SendMessageViewController() , animated: true)
        
        //This is related to move the controller()
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let firstViewController = storyboard.instantiateViewController(withIdentifier: "SendMessageNavigation") as! UINavigationController
        // self.present(firstViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func closeView(_ sender: UIButton) {
        
        removeView()
    }
    
    
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
        print("Error getting the location")
        
    }
    
    var pokemonsList = [Pokemon]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
            locationManager.stopUpdatingLocation()
        
        
        
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {(timer) in
            
            
            FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).child("pokemons").observeSingleEvent(of: .value, with: { (snapshot
                )
                in
                
                for Id in snapshot.children
                {
                    
                    let key = String(describing: (Id as! FIRDataSnapshot).key)
                  FIRDatabase.database().reference().child("Pokemons").child(key).updateChildValues(["Location":FirstViewController.stringLocation])
                    
                    var currentCoordinates  = FirstViewController.stringLocation.components(separatedBy: " ")
                    
                    
                    FIRDatabase.database().reference().child("Pokemons Location").child(key).child("l").updateChildValues(["0": currentCoordinates[0], "1": currentCoordinates[1]])

                    
                }
                
                
            })
            
            
        }
        
        
        // here we should do the work.
        _ = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { (
            time) in
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
            // This is realted to the location...so let's do it..
            
            if (self.reachThEndOfTheTable)
            {
                    self.pokemonsList = [Pokemon]()
                    self.populateLocationFromGeoFire()
                    self.tablePreviousPokemonsNumber = 0
                    self.tablePokemonNumber = 0
                
                    // here to competing doing the location stuff.
    
            }

            
           var updateLocationReference = FIRDatabase.database().reference()
            
            
            //This is realted to update the notification mr.
            var isThereNotifaction = String()


            var notificationCheckRef = FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).child("notified").observeSingleEvent(of: .value, with: {(snapshot) in
               
                isThereNotifaction = String(describing: snapshot.value!)
            
                
                
                
                
                if isThereNotifaction == "1"
                {
                    
                    print ("refresh")
                    FirstViewController.notificationsNumber += 1
                    var notificationNumberString:String = "\(FirstViewController.notificationsNumber)"
                    self.tabBarController?.tabBar.items?[2].badgeValue = notificationNumberString
                    
                    
                    // This is realted to the notification
                    let content = UNMutableNotificationContent()
                    content.title = "You've got a new message from other trainer!"
                    content.subtitle = " "
                    content.body = "Please check out messages"
                    content.badge = 1
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    
                    FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).updateChildValues(["notified":false])
                    
                }
              
            })
           
            
        }
        

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
            print("User Did Not Allow Notification")
            
            
        })
        
        initializeBannerView()
        
        tablePokemonNumber = 0
        reachThEndOfTheTable = true

        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        startLocation = nil
        
        

        
        
        //  activityIndicator()
        
        // effect = self.visualEffectView.effect
        visualEffectView.effect = nil
        
        let buttonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        buttonItem.tintColor = UIColor.white
        
        radius = 0.2
        
        navigationItem.leftBarButtonItem = buttonItem
        
        clickedButtonView.layer.cornerRadius = 5
        
        self.pokemonsList = [Pokemon]()
        
        self.populateLocationFromGeoFire()
        
        // Here is where we reload t
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print(ids[indexPath.row])
        
        // Here to check if the user is on the list or not.
        
        var reference = FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).child("block")
        
        reference.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            if snapshot.hasChild(self.pokemonsList[indexPath.row].getPublicName()) == false{
                FirstViewController.messageTo_DisplayName =  self.pokemonsList[indexPath.row].getPublicName()
                
                
                let flowLayout = UICollectionViewFlowLayout()
                
                
                let chatLogController = SendMessageViewController(collectionViewLayout:flowLayout)
                
                self.navigationController?.pushViewController(chatLogController, animated: true)
                
            }
            else{
                
                let alertController = UIAlertController(title: "You can't reach this trainer!", message: "This trainer is not available for you right now", preferredStyle: .actionSheet)
                
                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })

        //addView()
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
        return pokemonsList.count
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        //The second boolean to check when we get starting...
        if offsetY > contentHeight - scrollView.frame.size.height && pokemonsList.count > 0 {
            
            
            if (reachThEndOfTheTable && radius < maxRadius)
            {
                self.radius = self.radius + 0.2
                self.pokemonsList = [Pokemon]()
                self.geoLocationsKeys = [String]()
                reachThEndOfTheTable = false
                self.populateLocationFromGeoFire()
                
            }
            
        }
        
    }
    
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return bannerView   }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return bannerView.frame.height
    }
    
    
    func initializeBannerView()
    {
        
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-7667118939953898/4557764765"
        var request = GADRequest()
        bannerView.rootViewController = self
        bannerView.load(request)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        
        if pokemonsList.count == 0 || pokemonsList.count - 1 < indexPath.row
        {
            return cell
        }
        
        var pokemon = pokemonsList[indexPath.row]
        
        cell.pokemonName.text = pokemon.getPokemonName()
        cell.pokemonCp.text = pokemon.getPokemonCp()
        
        
        if Double(pokemon.getDistance()) >= 1
        {
            cell.distance.text = String(Float(pokemon.getDistance())) + " Km"
        }
            
            
        else
        {
            cell.distance.text = String(Float(pokemon.getDistance()) * 1000) + " m"
            
        }
        
        cell.publicName.text = pokemon.getPublicName()
        cell.photo.image = pokemon.getPokemonImage()
        
        //let lastElement = pokemonsList.count - 1
        //if indexPath.row == lastElement {
        //
        //}
        
        return cell
        
        // Set Cell contents
    }
    
    
    func populateLocationFromGeoFire()
    {
        let geofireRef = FIRDatabase.database().reference().child("Pokemons Location")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        locationManager.stopUpdatingLocation()
        
        self.geoLocationsKeys = [String]()
        
        
        var arrayLocation = FirstViewController.stringLocation.components(separatedBy: " ")
        
        let lat = Double(arrayLocation[0])
        
        var lon: Double?
        
        if lat == nil
        {
            // TODO Location is not available somehow you should not continue some how
        }
            
        else
        {
            lon = Double(arrayLocation[1])
        }
        
        
        var queryHandle = geoFire?.query(at: CLLocation(latitude: lat!, longitude: lon!), withRadius: radius)
        
        queryHandle?.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
            
            
            self.geoLocationsKeys.append(key!)
            
        })
        
        queryHandle?.observeReady({
            
            if (self.spinnerWhileOpenTheView)
            {
                
                self.indicator.startAnimating()
                
                self.spinnerWhileOpenTheView = false
                self.activityIndicator()
                
            }
            
            
            if (self.geoLocationsKeys.count > 0)
            {
            
                self.popluateCells()
            }
                
            else
            {

                self.indicator.stopAnimating()
                self.locationManager.stopUpdatingHeading()
                self.spinnerWhileOpenTheView = true
                self.indicator.hidesWhenStopped = true
                self.hideActivityIndicator()
                self.reachThEndOfTheTable = true
            }
            
        })
        
    }
    
    func showNoPokemonsLabel()
    {
        var emptyLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.view.bounds.size.width,height: self.view.bounds.size.height)))
        
        emptyLabel.text = "There is no nearby pokemons try again later"
        emptyLabel.textColor = UIColor.orange
        emptyLabel.textAlignment = NSTextAlignment.center
        self.tableView.backgroundView = emptyLabel
        
    }
    
    
    func showTransparentScreen()
    {
        tableView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        
    }
    
    func activityIndicator() {
        
        view.superview?.addSubview(loadingScreenView)
        
        self.loadingScreenView.addSubview(indicator)
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        loadingScreenView.layer.cornerRadius = 5
        loadingScreenView.center = view.center
        indicator.center = loadingScreenView.center
        indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:40, height:40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.loadingScreenView.center
        
        loadingScreenView.alpha = 0
        loadingScreenView.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.4)
        {
            // self.visualEffect.effect = self.effect
            self.loadingScreenView.alpha = 1
            self.loadingScreenView.transform = CGAffineTransform.identity
        }
        
    }
    
    
    func hideActivityIndicator()
    {
        UIView.animate(withDuration: 0.3, animations:
            {
                self.loadingScreenView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.loadingScreenView.alpha = 0
                
        })
            
        {(success: Bool) in
            
            self.loadingScreenView.removeFromSuperview()
        }
        
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        
    }
    
    
    func popluateCells()
    {
        var checker = 0
        var pokemonName = String()
        var pokemonCp = String()
        var publicName = String()
        var pokemonImage = UIImage()
        var pokemonLocation = String()
        var id = String()
        
        
        for i in 0..<geoLocationsKeys.count
        {
            
            var valueRef = FIRDatabase.database().reference().child("Pokemons").child(geoLocationsKeys[i]).observeSingleEvent(of: .value, with: {(snapshot)
                in
                
                for pokemon in snapshot.children
                {
                    let childValue = String(describing: (pokemon as! FIRDataSnapshot).value!) // Remeber this value maybe value.
                    
                    let childKey = String(describing: (pokemon as! FIRDataSnapshot).key)
                    
                    
                    if (childKey == "PublicName")
                    {
                        if (childValue == ThirdViewController.displayName)
                        {
                            pokemonCp = String()
                            pokemonName = String()
                            pokemonLocation = String()
                            pokemonImage = UIImage()
                            publicName = String()
                            checker = 1
                            break
                        }
                            
                        else
                        {
                            publicName = childValue
                            checker = 0
                        }
                    }
                        
                        
                    else if (childKey == "Cp")
                    {
                        
                        pokemonCp = childValue
                        
                    }
                        
                    else if (childKey == "Location")
                    {
                        
                        pokemonLocation = childValue
                        
                    }
                        
                    else if (childKey == "Pokemon")
                    {
                        pokemonName = childValue
                        pokemonImage = UIImage(named: childValue.lowercased())!
                        
                    }
                    
                }
                
                if (checker == 0)
                {
                    
                    let onePokemon = Pokemon(pokemon: pokemonName, cp: pokemonCp, location: pokemonLocation, publicName: publicName, pokemonImage: pokemonImage)
                    
                    self.pokemonsList.append(onePokemon)
                    
                }
                
                if i == self.geoLocationsKeys.count - 1
                {
                    // Here to do the stuff after loading fellow
                    self.tablePokemonNumber = self.pokemonsList.count
                    
                    if self.tablePokemonNumber - self.tablePreviousPokemonsNumber < 5 && self.radius < self.maxRadius
                    {
                        self.radius = self.radius + 0.2
                        self.pokemonsList = [Pokemon]()
                        self.geoLocationsKeys = [String]()
                        self.populateLocationFromGeoFire()
                    }
                        
                    else
                    {
                        self.tablePreviousPokemonsNumber = self.tablePokemonNumber
                        
                        self.sortDistances()
                        
                        if (self.pokemonsList.count != 0)
                        {
                            
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                            }
                           
                        }
                        
                        self.locationManager.stopUpdatingLocation()
                        self.indicator.stopAnimating()
                        self.spinnerWhileOpenTheView = true
                        self.indicator.hidesWhenStopped = true
                        self.hideActivityIndicator()
                        self.reachThEndOfTheTable = true
                    }
                }
                
            })
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
            //   self.visualEffect.effect = self.effect
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
                //      self.visualEffect.effect = nil
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
    
    
    func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double, unit: String) -> Double
    {
        var radlat1 = Double.pi * lat1 / 180
        
        var radlat2 = Double.pi * lat2 / 180
        
        var radlon1 = Double.pi * lon1 / 180
        
        var radlon2 = Double.pi * lon2 / 180
        
        var theta = lon1 - lon2
        
        var radtheta = Double.pi * theta/180
        
        var dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta)
        
        dist = acos(dist)
        
        dist = dist * 180 / Double.pi
        
        dist = dist * 60 * 1.1515
        
        if unit == "k"
        {
            dist = dist * 1.609344
        }
        
        if unit == "m"
        {
            dist = dist * 0.8684
        }
        
        return dist
    }
    
    func sortDistances()
    {
        for i in 0..<pokemonsList.count
        {
            // not the best way to do it
            var coordinates = pokemonsList[i].getPokemonLocation().components(separatedBy: " ")
            var currentCoordinates  = FirstViewController.stringLocation.components(separatedBy: " ")

            
            
            let distance = calculateDistance(lat1: Double(currentCoordinates[0])!, lon1:  Double(currentCoordinates[1])!, lat2: Double(coordinates[0])!, lon2: Double(coordinates[1])!, unit: "k")
            pokemonsList[i].setDistance(d: distance)
            
        }
        
        pokemonsList.sort(by: { $0.getDistance() < $1.getDistance()})
        
    }
    
}
