//
//  LoginViewController.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/4.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import FBSDKLoginKit
import FBSDKCoreKit



class LoginVC: UIViewController, GIDSignInDelegate {


    let sigeIn = GIDSignIn.sharedInstance()

    let clientID = "431461496521-7di89c4tiqoqlasenaajvj6m77lcvfto.apps.googleusercontent.com"


    override func viewDidLoad() {
        super.viewDidLoad()

        Profile.enableUpdatesOnAccessTokenChange(true)

        sigeIn?.delegate = self
        sigeIn?.scopes = [kGTLRAuthScopeDriveFile]
        sigeIn?.clientID = clientID
        sigeIn?.restorePreviousSignIn()

        //segue tabbarVC
    }

    //MARK: - FB登入
    @IBAction func fblogin(sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile"], from: self) { (result, error) in
            if let error = error {
                print(error)
                return
            }
            print("FB登入成功")

        }

    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

    }
    //登出時呼叫
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {

    }


    //MARK: - Google登入

    @IBAction func googlelogin(_ sender: Any) {
        guard let canAuthorize = sigeIn?.currentUser?.authentication?.fetcherAuthorizer()?.canAuthorize else{
            //Launch SignIn.
            launchSignIn()
            return
        }
        if canAuthorize{
            //Start to use GDrive functions.
            print("Google登入成功 \(canAuthorize)")

        } else {
            //Launch SignIn.
            launchSignIn()
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("Auth Fail: \(error)")
            return
        }
    }


    func launchSignIn() {
        sigeIn?.presentingViewController = self
        sigeIn?.signIn()
    }


    //MARK: - 遊客登入
    @IBAction func freelogin(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "真的不登入嗎?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "是的！", style: .default) { (seague) in
            //...
        }
        let cancel = UIAlertAction(title: "再讓我想想", style: .default, handler: nil)
        alert.addAction(yes)
        alert.addAction(cancel)
        present(alert, animated: true)


    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}





