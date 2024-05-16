//
//  MatchViewController.swift
//  sensei.ia
//
//  Created by user262081 on 5/12/24.
//

import UIKit

class MatchViewController: UIViewController {

    var habilidade: (id: Int, nome: String)?
    var experiencia: (id: Int, nome: String)?
    var areasDeInteresse: [Int: String] = [:]
    var formacao: (id: Int, nome: String)?
    
    var usuarios: [Usuario] = []

    @IBOutlet var nomeMatch: [UILabel]!
    @IBOutlet var habilidadeMatch: [UILabel]!
    @IBOutlet var formacaoMatch: [UILabel]!
    @IBOutlet var experienciaMatch: [UILabel]!
    @IBOutlet var iconeMatch: [UIImageView]!
    @IBOutlet var botaoMatch: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        for botao in botaoMatch {
            botao.addTarget(self, action: #selector(botaoMatchTapped(_:)), for: .touchUpInside)
        }
        carregarUsuariosBaseadosNaExperiencia()
        preencherLabelsComUsuarios()
        
        let habilidadeDescricao = habilidade != nil ? "Habilidade: \(habilidade!.nome) (ID: \(habilidade!.id))" : "Habilidade: não fornecida"
        let experienciaDescricao = experiencia != nil ? "Experiência: \(experiencia!.nome) (ID: \(experiencia!.id))" : "Experiência: não fornecida"
        let areasDeInteresseDescricao = areasDeInteresse.isEmpty ? "Áreas de Interesse: não fornecidas" : "Áreas de Interesse: \(areasDeInteresse.description)"
        let formacaoDescricao = formacao != nil ? "Formação: \(formacao!.nome) (ID: \(formacao!.id))" : "Formação: não fornecida"

        print("\(habilidadeDescricao), \(experienciaDescricao), \(areasDeInteresseDescricao), \(formacaoDescricao)")
    }
    
    func carregarUsuariosBaseadosNaExperiencia() {
        guard let nivelDeExperiencia = experiencia?.id else {
            print("Experiência não fornecida")
            return
        }
        print("Experiência --> ", nivelDeExperiencia)
        // Ajuste para carregar o arquivo JSON correto
        let nomeArquivo = (nivelDeExperiencia == 1 || nivelDeExperiencia == 2) ? "mentores.json" : "aprendizes.json"
        
        if let path = Bundle.main.path(forResource: nomeArquivo, ofType: nil) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let jsonDict = json as? [String: Any], let usuariosArray = jsonDict["usuarios"] as? [[String: Any]] {
                    for usuarioDict in usuariosArray {
                        if let id = usuarioDict["id"] as? Int,
                           let nome = usuarioDict["nome"] as? String,
                           let sobrenome = usuarioDict["sobrenome"] as? String,
                           let email = usuarioDict["email"] as? String,
                           let senha = usuarioDict["senha"] as? String,
                           let formacao = usuarioDict["formacao"] as? Int,
                           let areasDeInteresseArray = usuarioDict["areasDeInteresse"] as? [[String: Any]],
                           let habilidadesArray = usuarioDict["habilidades"] as? [[String: Any]] {
                            
                            let areasDeInteresse = areasDeInteresseArray.compactMap { areaDict -> AreaDeInteresse? in
                                if let id = areaDict["id"] as? Int, let nome = areaDict["nome"] as? String {
                                    return AreaDeInteresse(id: id, nome: nome)
                                }
                                return nil
                            }
                            
                            let habilidades = habilidadesArray.compactMap { habilidadeDict -> Habilidade? in
                                if let id = habilidadeDict["id"] as? Int, let nome = habilidadeDict["nome"] as? String, let nivelDeExperiencia = habilidadeDict["nivelDeExperiencia"] as? Int {
                                    return Habilidade(id: id, nome: nome, nivelDeExperiencia: nivelDeExperiencia)
                                }
                                return nil
                            }
                            
                            if let habilidade = habilidade, habilidades.contains(where: { $0.id == habilidade.id }) {
                                let usuario = Usuario(id: id, nome: nome, sobrenome: sobrenome, email: email, senha: senha, formacao: formacao, areasDeInteresse: areasDeInteresse, habilidades: habilidades)
                                usuarios.append(usuario)
                            }
                        }
                    }
                } else {
                    print("Formato de JSON inválido")
                }
            } catch {
                print("Erro ao carregar JSON: \(error)")
            }
        } else {
            print("Arquivo JSON não encontrado")
        }
    }
    
    func preencherLabelsComUsuarios() {
        for i in 0..<min(usuarios.count, 3) {
            let usuario = usuarios[i]
            nomeMatch[i].text = "\(usuario.nome) \(usuario.sobrenome)"
            nomeMatch[i].sizeToFit()
            
            if let habilidadeEncontrada = usuario.habilidades.first(where: { $0.id == habilidade?.id }) {
                habilidadeMatch[i].text = habilidadeEncontrada.nome
            } else {
                habilidadeMatch[i].text = "Habilidade não encontrada"
            }
            habilidadeMatch[i].sizeToFit()
            
            // Dicionário para mapear níveis de experiência
            let experienciaNiveis = [
                1: "Iniciante",
                2: "Intermediário",
                3: "Avançado",
                4: "Especialista"
            ]
            
            let experiencia = usuario.habilidades[0].nivelDeExperiencia

            experienciaMatch[i].text = experienciaNiveis[experiencia] ?? "Nível desconhecido"
            experienciaMatch[i].sizeToFit()
            
            let formacaoNiveis = [
                1: "Curso Livre",
                2: "Curso Técnico",
                3: "Graduação",
                4: "Especialização",
                5: "MBA",
                6: "Mestrado",
                7: "Doutorado"
            ]
            
            let formacao = usuario.formacao
            
            formacaoMatch[i].text = formacaoNiveis[formacao] ?? "Formação desconhecida"
            formacaoMatch[i].sizeToFit()
            
            let iconeImagens = [
                1: "perfilIniciante",
                2: "perfilIntermediario",
                3: "perfilAvancado",
                4: "perfilEspecialista"
            ]
            
            if let imagemNome = iconeImagens[experiencia] {
                iconeMatch[i].image = UIImage(named: imagemNome)
            }
            

        }
    }
    @objc func botaoMatchTapped(_ sender: UIButton) {
        let tag = sender.tag
        performSegue(withIdentifier: "sucessoMatchSegue", sender: tag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sucessoMatchSegue" {
            if let tag = sender as? Int, let destinationVC = segue.destination as? SucessoMatchViewController {
                destinationVC.match = usuarios[tag]
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
