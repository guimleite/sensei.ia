//
//  RegistroViewController.swift
//  sensei.ia
//
//  Created by user262081 on 5/6/24.
//

import UIKit
import Firebase

class RegistroViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registrarClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let senha = senhaTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: senha) { firebaseResult, error in
            if let e = error {
                print("error")
            }else{
                // Go to home
                self.performSegue(withIdentifier: "goToNext", sender: self)
            }
        }
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
