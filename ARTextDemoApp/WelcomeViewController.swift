//
//  WelcomeViewController.swift
//  ARTextDemoApp
//
//  Created by talha on 25/09/2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var mainLbl : UILabel!{
        didSet{
            mainLbl.text = ""
            mainLbl.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var loadingLbl : UILabel!
    
    let loadingLblText : (String , String) = ("Please wait, text is preparing...","Tap to see in AR")
    
    var ref: DatabaseReference!
    var isDataLoaded : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addTapOMainLbl(_:)))
        mainLbl.addGestureRecognizer(tap)
        
        loadingLbl.text = loadingLblText.0
        
        
        ref = Database.database().reference()
        ref.child("placeHolder").observe(.value) { snap in
            if let dummyText = snap.value as? String{
                self.loadingLbl.text = "Tap \(dummyText) to see in AR"
                self.mainLbl.text = dummyText
                self.isDataLoaded = true
                
            }else{
                self.isDataLoaded = false
                self.loadingLbl.text = "Sorry, Please check Database"
                print("Sorry We are not able to retrive data")
            }
           
        }
    }


}

extension WelcomeViewController{
    
    @objc func addTapOMainLbl(_ sender : UITapGestureRecognizer){
        
        if isDataLoaded{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "ViewController") as! ViewController
            vc.textData = self.mainLbl.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    
    }
}
