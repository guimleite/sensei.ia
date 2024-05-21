//
//  AvaliacaoViewController.swift
//  sensei.ia
//
//  Created by Guilherme on 5/19/24.
//

import UIKit

class AvaliacaoViewController: UIViewController {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet var avaliacaoButton: [UIButton]!
    
    var nome: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nome = nome {
            nomeLabel.text = nome
        }
    }

    @IBAction func avaliacaoTapped(_ sender: UIButton) {
        let selectedTag = sender.tag
        
        let selectedImage = UIImage(named: "avaliacao.png")
        let normalImage = UIImage(named: "avaliacao-off.png")
        
        avaliacaoButton.forEach { button in
            var config = button.configuration ?? UIButton.Configuration.filled()
            if button.tag <= selectedTag {
                config.background.image = selectedImage
            } else {
                config.background.image = normalImage
            }
            button.configuration = config
        }
    }
    
    @IBAction func enviarTapped(_ sender: UIButton) {
        // Avalicação do usuário será recebido do back end
        
        let alert = UIAlertController(title: nil, message: "Avaliação salva", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
