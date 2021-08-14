//
//  LoginViewController.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    struct IDs {
        static var googleClientID = "61552093515-a10uced8mn75kjj30ad38gi8g7ch6lmn.apps.googleusercontent.com"
        static var toTabBarControllerSegue = "toTabBarController"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(userSignInGoogleCompleted(_:)), name: .signInGoogleCompleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userSignInGoogleFail(_:)), name: .signInGoogleFail, object: nil)
    }
    
    // MARK - Google Sign In
    @objc func userSignInGoogleCompleted(_ notification: Notification){
        //present main view controller
        performSegue(withIdentifier: IDs.toTabBarControllerSegue, sender: self)
    }
    
    @objc func userSignInGoogleFail(_ notification: Notification) {
        loginActivityIndicator.stopAnimating()
        googleSignInButton.isHidden = false
    }
    
    // MARK: - IBAction
    @IBAction func googleSignInPressedOnButton(_ sender: Any) {
        let signInConfig = GIDConfiguration.init(clientID: IDs.googleClientID)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { (user, error) in
            guard error == nil, let _ = user else {
                return
            }
            self.performSegue(withIdentifier: IDs.toTabBarControllerSegue, sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
