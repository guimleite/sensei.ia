//
//  PesquisaTableViewCell.swift
//  sensei.ia
//
//  Created by user262081 on 5/9/24.
//

import UIKit

class PesquisaTableViewCell: UITableViewCell {

    @IBOutlet weak var pesquisaButton: UIButton!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var habilidadeLabel: UILabel!
    @IBOutlet weak var experienciaLabel: UILabel!
    @IBOutlet weak var formacaoLabel: UILabel!
    @IBOutlet weak var pesquisaImage: UIImageView!
    @IBOutlet weak var localizacaoLabel: UILabel!
    @IBOutlet var avaliacaoImage: [UIImageView]!
    var delegate: PesquisaTableViewCellDelegate?

    var usuario: Usuario? {
        didSet {
            guard let usuario = usuario else { return }
            nomeLabel.text = "\(usuario.nome) \(usuario.sobrenome)"
            habilidadeLabel.text = usuario.habilidades.first?.nome
            
            if let nivelDeExperiencia = usuario.habilidades.first?.nivelDeExperiencia {
                switch nivelDeExperiencia {
                case 1:
                    experienciaLabel.text = "Iniciante"
                    pesquisaImage.image = UIImage(named: "perfilIniciante")
                case 2:
                    experienciaLabel.text = "Intermediário"
                    pesquisaImage.image = UIImage(named: "perfilIntermediario")
                case 3:
                    experienciaLabel.text = "Avançado"
                    pesquisaImage.image = UIImage(named: "perfilAvancado")
                case 4:
                    experienciaLabel.text = "Especialista"
                    pesquisaImage.image = UIImage(named: "perfilEspecialista")
                default:
                    experienciaLabel.text = "Desconhecido"
                }
            }
            
            formacaoLabel.text = usuario.formacao.nome
            localizacaoLabel.text = usuario.localizacao?.nome
            
            let avaliacao = usuario.avaliacao
                    
            for imageView in avaliacaoImage {
                if imageView.tag <= avaliacao {
                    imageView.image = UIImage(named: "estrela-preenchida")
                } else {
                    imageView.image = UIImage(named: "estrela-sem-preenchimento")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pesquisaButton.addTarget(self, action: #selector(pesquisaButtonTapped), for: .touchUpInside)

        // Initialization code
    }

    @objc func pesquisaButtonTapped() {
        if let usuario = usuario {
            delegate?.pesquisaButtonTapped(usuario: usuario)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

protocol PesquisaTableViewCellDelegate {
    func pesquisaButtonTapped(usuario: Usuario)
}
