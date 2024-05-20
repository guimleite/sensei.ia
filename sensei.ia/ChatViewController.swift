//
//  ChatViewController.swift
//  sensei.ia
//
//  Created by user262081 on 5/19/24.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet var chatButton: [UIButton]!
    @IBOutlet var nomeLabel: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in chatButton {
            button.addTarget(self, action: #selector(chatButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc func chatButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        performSegue(withIdentifier: "privateChatSegue", sender: tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "privateChatSegue" {
            if let tag = sender as? Int, let destinationVC = segue.destination as? PrivateChatViewController {
                let label = nomeLabel[tag]
                destinationVC.nome = label.text ?? ""
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
