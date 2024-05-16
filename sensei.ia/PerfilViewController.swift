//
//  PerfilViewController.swift
//  sensei.ia
//
//  Created by user262081 on 5/15/24.
//

import UIKit

class PerfilViewController: UIViewController {

    @IBOutlet weak var experienciaLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var formacaoLabel: UILabel!
    @IBOutlet weak var habilidadeLabel: UILabel!
    
    var usuario: Usuario?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let usuario = usuario else {
            return
        }
        
        nomeLabel.text = "\(usuario.nome) \(usuario.sobrenome)"
        
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
        
        switch usuario.formacao {
        case 1:
            formacaoLabel.text = "Curso Livre"
        case 2:
            formacaoLabel.text = "Curso Técnico"
        case 3:
            formacaoLabel.text = "Graduação"
        case 4:
            formacaoLabel.text = "Especialização"
        case 5:
            formacaoLabel.text = "MBA"
        case 6:
            formacaoLabel.text = "Mestrado"
        case 7:
            formacaoLabel.text = "Doutorado"
        default:
            formacaoLabel.text = "N/A"
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
