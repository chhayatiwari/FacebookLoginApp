//
//  ViewController.swift
//  FacebookLoginApp
//
//  Created by Chhaya Tiwari on 10/8/18.
//  Copyright © 2018 chhayatiwari. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [], viewController: self) { (loginResult: LoginResult) in
            switch loginResult {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled :
                print("Cancelled")
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("login succes")
                self.getDetail()
            }
        }
    }
    
    func getDetail() {
        
        guard let accessToken = AccessToken.current else {
            return
        }
        let parameter = ["fields" : "name, picture"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: parameter, accessToken: accessToken)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                print(error.localizedDescription)
            case .success(response: let graphResponse):
                guard let responseDictionary = graphResponse.dictionaryValue else {
                    return
                }
                guard let name = responseDictionary["name"] as? String else {
                    return
                }
                self.username.text = name
                guard let picture = responseDictionary["picture"] as? [String:AnyObject] else { return }
                guard let data = picture["data"] as? [String: AnyObject] else { return }
                guard let urlString = data["url"] as? String else { return }
                guard let url = URL(string: urlString) else { return }
                guard let urlData = try? Data(contentsOf: url) else { return }
                performUIUpdatesOnMain {
                    self.imageView.image = UIImage(data: urlData)
                }
            }
        }
    }
}

