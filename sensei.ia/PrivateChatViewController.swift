//
//  PrivateChatViewController.swift
//  sensei.ia
//
//  Created by user262081 on 5/19/24.
//

import UIKit

class PrivateChatViewController: UIViewController {

    @IBOutlet weak var nomeLabel: UILabel!
    
    var nome: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nome = nome {
            nomeLabel.text = nome
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
