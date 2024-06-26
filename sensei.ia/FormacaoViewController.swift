//
//  FormacaoViewController.swift
//  sensei.ia
//
//  Created by Guilherme on 5/11/24.
//

import UIKit

class FormacaoViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    
    var habilidade: (id: Int, nome: String)?
    var experiencia: (id: Int, nome: String)?
    var areasDeInteresse: [Int: String] = [:]
    var formacao: (id: Int, nome: String)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Os dados abaixo serão salvos para a criação de perfil do usuário
        let habilidadeDescricao = habilidade != nil ? "Habilidade: \(habilidade!.nome) (ID: \(habilidade!.id))" : "Habilidade: não fornecida"
        let experienciaDescricao = experiencia != nil ? "Experiência: \(experiencia!.nome) (ID: \(experiencia!.id))" : "Experiência: não fornecida"
        let areasDeInteresseDescricao = areasDeInteresse.isEmpty ? "Áreas de Interesse: não fornecidas" : "Áreas de Interesse: \(areasDeInteresse.description)"
        
        print("\(habilidadeDescricao), \(experienciaDescricao), \(areasDeInteresseDescricao)")
    }

    
    @IBAction func formacaoTapped(_ sender: UIButton) {
        
        
        let valor = sender.tag

        switch valor {
        case 1:
            formacao = (id: 1, nome: "CURSO LIVRE")
        case 2:
            formacao = (id: 2, nome: "CURSO TÉCNICO")
        case 3:
            formacao = (id: 3, nome: "GRADUAÇÃO")
        case 4:
            formacao = (id: 4, nome: "ESPECIALIZAÇÃO")
        case 5:
            formacao = (id: 5, nome: "MBA")
        case 6:
            formacao = (id: 6, nome: "MESTRADO")
        case 7:
            formacao = (id: 7, nome: "DOUTORADO")
        default:
            print("Tag inválida: \(valor)")
            return  // Caso inválido
        }
        
        let selectedImage = UIImage(named: "Card3Selecionado.png")
        let normalImage = UIImage(named: "Card3.png")
        
        var currentConfig = sender.configuration ?? UIButton.Configuration.filled()
        let isCurrentlySelected = currentConfig.background.image?.pngData() == selectedImage?.pngData()

        if isCurrentlySelected {
            currentConfig.background.image = normalImage
            formacao = nil
        } else {
            buttons.forEach { button in
                var config = button.configuration ?? UIButton.Configuration.filled()
                config.background.image = normalImage
                button.configuration = config
            }
            currentConfig.background.image = selectedImage
        }

        sender.configuration = currentConfig
    }
    
    @IBAction func irParaFormacaoButtonTapped(_ sender: UIButton) {
        // As informações sobre formação de usuários serão salvas no banco de dados e usadas posteriormente para matchmaking
        
        if formacao == nil {
            let alert = UIAlertController(title: "Seleção de Formação", message: "Por favor, selecione uma formação antes de prosseguir.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "irParaMatchSegue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irParaMatchSegue" {
            if let destinationVC = segue.destination as? MatchViewController {
                destinationVC.habilidade = self.habilidade
                destinationVC.experiencia = self.experiencia
                destinationVC.areasDeInteresse = self.areasDeInteresse
                destinationVC.formacao = self.formacao
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
