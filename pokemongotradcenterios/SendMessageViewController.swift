//
//  SendMessageViewController.swift
//  pokemongotradcenterios
//
//  Created by Radi Barq on 12/30/16.
//  Copyright © 2016 Radi Barq. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class SendMessageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let inputTextField = UITextField()
    
    var messagesTexts = [String]()
    var messagesFrom = [String]()
    var messagesTimeStamps = [Float]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        
        
        
        navigationItem.title = FirstViewController.messageTo_DisplayName
        
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        
        collectionView?.scrollIndicatorInsets = UIEdgeInsets (top: 8, left:  0, bottom: 50, right: 0)
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        
        setupInputComponents()
        
        observeMessages()
        
        // Building the cell
        
    }
    
    
    func setupInputComponents()
    {
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        
        //ios9 constraint anchors
        
        // x,y,w,h
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        // This code to add the button
        let sendButton = UIButton(type: .system)
        sendButton.setTitleColor(UIColor.orange, for: .normal)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        inputTextField.textColor = UIColor.orange
        inputTextField.placeholder = "Enter message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        containerView.addSubview(inputTextField)
        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
    }
    
    
    func handleSend()
    {
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        let ref = FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).child("chat").child(FirstViewController.messageTo_DisplayName).childByAutoId().updateChildValues(["messageText": inputTextField.text, "messageFrom": ThirdViewController.displayName, "timestamp": timestamp])
        
        
        let ref2 = FIRDatabase.database().reference().child("Users").child(FirstViewController.messageTo_DisplayName).child("chat").child(ThirdViewController.displayName).childByAutoId().updateChildValues(["messageText": inputTextField.text, "messageFrom": ThirdViewController.displayName, "timestamp": timestamp])
        
    }
    
    
    func observeMessages()
    {
        
        
        let ovserveReference = FIRDatabase.database().reference().child("Users").child(ThirdViewController.displayName).child("chat").child(FirstViewController.messageTo_DisplayName)
        
        
        
        ovserveReference.observe(.value, with: {snapshot in
            
            
            
            self.messagesTimeStamps = [Float]()
            self.messagesTexts =  [String]()
            self.messagesFrom = [String]()
            
            
            for messages in snapshot.children
            {
                
                
                for  message in (messages as! FIRDataSnapshot).children
                {
                    let childValue = String(describing: (message as! FIRDataSnapshot).value!) // Remeber this value maybe value.
                    
                    let childKey = String(describing: (message as! FIRDataSnapshot).key)
                    
                    
                    if childKey == "messageFrom"
                    {
                        self.messagesFrom.append(childValue)
                    }
                        
                    else if childKey == "messageText"
                    {
                        self.messagesTexts.append(childValue)
                    }
                        
                    else if childKey == "timestamp"
                    {
                        
                        self.messagesTimeStamps.append(Float(childValue)!)
                        
                    }
                }
            }
            
            self.collectionView?.reloadData()
            self.inputTextField.text = nil
            
        })
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messagesTexts.count
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        
        
        let message = messagesTexts[indexPath.row]
        
        cell.textView.text = message
        
        //cell.backgroundColor = UIColor.orange
    
        
        if messagesFrom[indexPath.row] == ThirdViewController.displayName
        {
            
                // Will make the message orange
             cell.bubbleView.backgroundColor = UIColor.orange
             cell.textView.textColor = UIColor.white
            
        }
        
        else
        {
            
            // will make the message gray somehow.
            let color = hexStringToUIColor(hex: "E6E6E6")
            cell.textView.textColor = UIColor.black
            cell.bubbleView.backgroundColor = color
            
        }
        
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message).width + 32
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        // get estimated height somehow??
        
         let text = messagesTexts[indexPath.row]
        
         height = estimateFrameForText(text: text).height + 20
        
        
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    private func estimateFrameForText(text: String) -> CGRect
    {
         let size = CGSize(width: 200, height: 1000)
         let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}