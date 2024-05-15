//
//  InteresseViewController.swift
//  sensei.ia
//
//  Created by user262081 on 5/11/24.
//

import UIKit

class InteresseViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    var buttonStates: [Int: Bool] = [:]
    
    var habilidade: (id: Int, nome: String)?
    var experiencia: (id: Int, nome: String)?
    var areasDeInteresse: [Int: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Verifica se habilidade e experiencia são fornecidas e as imprime
        if let habilidade = habilidade, let experiencia = experiencia {
            print("Habilidade: \(habilidade), Experiência: \(experiencia)")
        } else {
            print("Habilidade ou experiência não fornecida")
        }

        // Define o estado inicial dos botões
        buttons.forEach { button in
            buttonStates[button.tag] = false
        }
    }
    
    @IBAction func interesseTapped(_ sender: UIButton) {
        let valor = sender.tag
        let area: String
        
        switch valor {
        case 1:
            area = "TECNOLOGIA"
        case 2:
            area = "MARKETING"
        case 3:
            area = "FINANÇAS"
        case 4:
            area = "RECURSOS HUMANOS"
        case 5:
            area = "COMERCIAL"
        case 6:
            area = "LIDERANÇA"
        default:
            print("Tag inválida: \(valor)")
            return  // Caso inválido
        }
        
        var currentConfig = sender.configuration ?? UIButton.Configuration.filled()
        let selectedImage = UIImage(named: "Card3Selecionado.png")
        let normalImage = UIImage(named: "Card3.png")
        let isCurrentlySelected = currentConfig.background.image?.pngData() == selectedImage?.pngData()

        // Toggle the background image and update the dictionary based on the selection
        if isCurrentlySelected {
           currentConfig.background.image = normalImage
           areasDeInteresse.removeValue(forKey: valor) // Remove item from dictionary when unselected
        } else {
           currentConfig.background.image = selectedImage
           areasDeInteresse[valor] = area // Add item to dictionary when selected
        }

        sender.configuration = currentConfig
    }
    
    @IBAction func irParaFormacaoButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "irParaFormacaoSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irParaFormacaoSegue" {
            if let destinationVC = segue.destination as? FormacaoViewController {
                destinationVC.habilidade = self.habilidade
                destinationVC.experiencia = self.experiencia
                destinationVC.areasDeInteresse = self.areasDeInteresse
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
