//
//  SucessoMatchViewController.swift
//  sensei.ia
//
//  Created by user262081 on 5/15/24.
//

import UIKit

class SucessoMatchViewController: UIViewController {
    
    @IBOutlet weak var nomeMatchLabel: UILabel!
    @IBOutlet weak var tipoMatchLabel: UILabel!
    @IBOutlet weak var matchButton: UIButton!
    
    var match: Usuario?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let match = match {
            let nome = match.nome
            let experiencia = match.habilidades.first?.nivelDeExperiencia ?? 0
            let tipo = (experiencia == 1 || experiencia == 2 || experiencia == 0) ? "aprendiz" : "mentor"
            
            nomeMatchLabel.text = "Confira o perfil de \(nome), seu novo \(tipo)!"
            tipoMatchLabel.text = (experiencia == 1 || experiencia == 2) ? "seu aprendiz!" : "seu mentor!"
        }
        
        matchButton.addTarget(self, action: #selector(matchButtonTapped), for: .touchUpInside)
    }
      
    @objc func matchButtonTapped() {
        performSegue(withIdentifier: "perfilSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "perfilSegue" {
            if let destinationVC = segue.destination as? PerfilViewController {
                destinationVC.usuario = match
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
