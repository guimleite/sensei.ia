//
//  ChatViewController.swift
//  sensei.ia
//
//  Created by Guilherme on 5/19/24.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet var chatButton: [UIButton]!
    @IBOutlet var nomeLabel: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Historico de conversas sera recebido do back end
        
        for button in chatButton {
            button.addTarget(self, action: #selector(chatButtonTapped(_:)), for: .touchUpInside)
        }
        
        // Simulação mensagem push sobre agendamento de reunião
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.scheduleLocalNotification(title: "Nova reunião📱", delay: 4, message: "John Smith quer marcar uma call com você!")

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
