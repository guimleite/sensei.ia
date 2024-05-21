import UIKit

class HabilidadeViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var habilidadeTextField: UITextField!
    @IBOutlet weak var habilidadesTableView: UITableView!
    
    var habilidades: [Int: String] = [:]
    var habilidadesFiltradas: [(id: Int, nome: String)] = []
    var habilidadeSelecionada: (id: Int, nome: String)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        habilidadesTableView.dataSource = self
        habilidadesTableView.delegate = self
        habilidadeTextField.delegate = self
        
        // A lista de habilidades que usaremos para unir mentores e aprendizes pode ser poderá ser carregada com dados de tabelas no banco de dados ou de uma chamada de API
        loadHabilidades()
        habilidadesTableView.isHidden = true // Esconde a tabela até que seja necessário mostrá-la
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        filterContentForSearchText(currentText)
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habilidadesFiltradas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabilidadeCell", for: indexPath)
        cell.textLabel?.text = habilidadesFiltradas[indexPath.row].nome
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        habilidadeSelecionada = habilidadesFiltradas[indexPath.row]
        habilidadeTextField.text = habilidadeSelecionada?.nome
        habilidadesTableView.isHidden = true
    }

    func filterContentForSearchText(_ searchText: String) {
        habilidadesFiltradas = habilidades.filter { (_, nome) in
            return nome.lowercased().contains(searchText.lowercased())
        }.map { (id, nome) in
            (id, nome)
        }
        habilidadesTableView.isHidden = habilidadesFiltradas.isEmpty
        habilidadesTableView.reloadData()
    }

    func loadHabilidades() {
        // O JSON habilidades representa uma resposta do back end
        
        if let path = Bundle.main.path(forResource: "habilidades", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let areasDeInteresse = json["areasDeInteresse"] as? [[String: Any]] {
                    for area in areasDeInteresse {
                        if let habilidadesArray = area["habilidades"] as? [[String: Any]] {
                            for habilidade in habilidadesArray {
                                if let id = habilidade["id"] as? Int, let nome = habilidade["nome"] as? String {
                                    habilidades[id] = nome
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Erro ao carregar ou decodificar JSON: \(error)")
            }
        }
    }

    @IBAction func irParaExperienciaButtonTapped(_ sender: UIButton) {
        if let selecao = habilidadeSelecionada, !selecao.nome.isEmpty {
            // Navegar para a próxima tela
            performSegue(withIdentifier: "irParaExperienciaSegue", sender: self)
        } else {
            // Alertar o usuário que nenhuma habilidade foi selecionada
            let alert = UIAlertController(title: "Seleção de Habilidade", message: "Por favor, selecione uma habilidade antes de prosseguir.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irParaExperienciaSegue" {
            if let nextViewController = segue.destination as? ExperienciaViewController {
                nextViewController.habilidade = habilidadeSelecionada
            }
        }
    }
}
