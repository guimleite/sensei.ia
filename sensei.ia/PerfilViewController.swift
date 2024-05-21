//
//  PerfilViewController.swift
//  sensei.ia
//
//  Created by Guilherme on 5/15/24.
//

import UIKit

class PerfilViewController: UIViewController {

    @IBOutlet weak var experienciaLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var localizacaoLabel: UILabel!
    @IBOutlet weak var formacaoLabel: UILabel!
    @IBOutlet weak var habilidadeLabel: UILabel!
    @IBOutlet weak var avaliacaoLabel: UILabel!
    
    var usuario: Usuario?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let usuario = usuario else {
            return
        }
        
        // Dados do usuario vindos do back end
        nomeLabel.text = "\(usuario.nome) \(usuario.sobrenome)"
        localizacaoLabel.text = usuario.localizacao?.nome
        
        if let habilidade = usuario.habilidades.first {
            habilidadeLabel.text = habilidade.nome
            
            switch habilidade.nivelDeExperiencia {
            case 1:
                experienciaLabel.text = "Iniciante"
            case 2:
                experienciaLabel.text = "Intermediário"
            case 3:
                experienciaLabel.text = "Avançado"
            case 4:
                experienciaLabel.text = "Especialista"
            default:
                experienciaLabel.text = "N/A"
            }
        } else {
            habilidadeLabel.text = "N/A"
            experienciaLabel.text = "N/A"
        }
        formacaoLabel.text = usuario.formacao.nome
        avaliacaoLabel.text = String(usuario.avaliacao)
    }
    
    @IBAction func avaliacaoTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "avaliacaoSegue", sender: self)
    }
    
    @IBAction func chatTapped(_ sender: Any) {
        performSegue(withIdentifier: "privateChatSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "avaliacaoSegue" {
            if let destinationVC = segue.destination as? AvaliacaoViewController {
                if let usuario = usuario {
                    destinationVC.nome = "\(usuario.nome) \(usuario.sobrenome)"
                }
            }
        } else if segue.identifier == "privateChatSegue" {
            if let destinationVC = segue.destination as? PrivateChatViewController {
                if let usuario = usuario {
                    destinationVC.nome = "\(usuario.nome) \(usuario.sobrenome)"
                }
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
