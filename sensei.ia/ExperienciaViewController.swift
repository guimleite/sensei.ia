//
//  ExperienciaViewController.swift
//  sensei.ia
//
//  Created by user262081 on 5/11/24.
//

import UIKit

class ExperienciaViewController: UIViewController {

    var habilidade: (id: Int, nome: String)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skill = habilidade {
            print("Habilidade selecionada: \(skill)")
        } else {
            print("Nenhuma habilidade foi selecionada.")
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func experienceButtonTapped(_ sender: UIButton) {
        let experiencia: (id: Int, nome: String)

        switch sender.tag {
        case 1:
            experiencia = (id: 1, nome: "Iniciante")
        case 2:
            experiencia = (id: 2, nome: "Intermediário")
        case 3:
            experiencia = (id: 3, nome: "Avançado")
        case 4:
            experiencia = (id: 4, nome: "Especialista")
        default:
            print("Seleção inválida")
            return
        }

        // Navegar para a próxima tela
        performSegue(withIdentifier: "irParaInteresseSegue", sender: (habilidade, experiencia))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irParaInteresseSegue",
           let destination = segue.destination as? InteresseViewController,
           let (habilidade, experiencia) = sender as? ((id: Int, nome: String), (id: Int, nome: String)) {
            
            destination.habilidade = habilidade
            destination.experiencia = experiencia
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
