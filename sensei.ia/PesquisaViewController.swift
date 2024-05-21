import UIKit

class PesquisaViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, PesquisaTableViewCellDelegate {

    @IBOutlet weak var pesquisaBar: UISearchBar!
    @IBOutlet weak var filtroTableView: UITableView!
    @IBOutlet var filtroButton: [UIButton]!
    @IBOutlet weak var pesquisaTableView: UITableView!

    var usuarios: [Usuario] = []
    var usuarioSelecionado: Usuario?
    var filtroAtual: Int?
    
    // Os parametros para filtros serão carregados do back end
    var opcoesDeFormacao = ["Curso livre", "Curso técnico", "Graduação", "Especialização", "MBA", "Mestrado", "Doutorado"]
    var opcoesDeExperiencia = ["Iniciante", "Intermediário", "Avançado", "Especialista"]
    var opcoesDeAvaliacao = ["Uma estrela", "Duas estrelas", "Três estrelas", "Quatro estrelas", "Cinco estrelas"]
    var opcoesFiltradas: [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(filtroTableView)
        
        // A busca padrão filtra usuários com base em habilidades presentes no perfil
        configureButtons()
        pesquisaBar.delegate = self
        filtroAtual = 1
        filtroTableView.isHidden = true
        filtroTableView.dataSource = self
        filtroTableView.delegate = self
        filtroTableView.rowHeight = 44
        filtroTableView.isUserInteractionEnabled = true
        filtroTableView.layer.zPosition = 1
        filtroTableView.isScrollEnabled = true
        opcoesFiltradas = loadHabilidadesData()
        filtroTableView.reloadData()


        pesquisaTableView.dataSource = self
        pesquisaTableView.delegate = self
        pesquisaTableView.rowHeight = UITableView.automaticDimension
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.scheduleLocalNotification(title: "SenseiChat 💬", delay: 3, message: "Ana Silva te mandou uma nova mensagem!")
    }
    
    func loadNomes() -> [String] {
        // Realiza uma soliciatão ao back end para carregar usuário com base na busca
        
        var nomes: [String] = []
        // Função para carregar e processar a resposta JSON
        func loadFromJSON(named fileName: String) {
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let usuarios = jsonResult?["usuarios"] as? [[String: Any]] {
                        for usuario in usuarios {
                            if let nome = usuario["nome"] as? String, let sobrenome = usuario["sobrenome"] as? String {
                                nomes.append("\(nome) \(sobrenome)")
                            }
                        }
                    }
                } catch {
                    print("Erro ao ler \(fileName) JSON: \(error)")
                }
            }
        }

        // Carregar nomes dos aprendizes e mentores
        loadFromJSON(named: "aprendizes")
        loadFromJSON(named: "mentores")

        return nomes
    }

    func loadHabilidadesData() -> [String] {

        // Realiza uma soliciatão ao back end para carregar habilidades para busca
        
        var habilidades: [String] = []
        // Função para carregar e processar a resposta JSON

        if let path = Bundle.main.path(forResource: "habilidades", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let areasDeInteresse = jsonResult?["areasDeInteresse"] as? [[String: Any]] {
                    for area in areasDeInteresse {
                        if let habilidadesArray = area["habilidades"] as? [[String: Any]] {
                            for habilidade in habilidadesArray {
                                if let nome = habilidade["nome"] as? String {
                                    habilidades.append(nome)
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Erro ao ler habilidades JSON: \(error)")
            }
        }
        return habilidades
    }
    
    func loadLocalizacaoData() -> [String] {
        // Realiza uma soliciatão ao back end para carregar locais para busca

        var localizacoes: [String] = []
        
        // Função para carregar e processar a resposta JSON
        if let path = Bundle.main.path(forResource: "localizacao", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let estados = jsonResult?["localizacao"] as? [[String: Any]] {
                    localizacoes = estados.compactMap { $0["nome"] as? String }
                }
            } catch {
                print("Erro ao ler localizações JSON: \(error)")
            }
        }
        filtroTableView.isHidden = true  // Esconde a tabela inicialmente para tag 4
        return localizacoes
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Atualiaza sugestões de busca com base no texto digitado
        
        if searchText.isEmpty {
            opcoesFiltradas = []
            filtroTableView.isHidden = true
        } else {
            switch filtroAtual {
            case 0:
                // Carrega e filtra nomes dos usuários com base no texto da barra de pesquisa
                let nomes = loadNomes()
                opcoesFiltradas = nomes.filter { nome in
                    nome.lowercased().contains(searchText.lowercased())
                }
            case 1:
                // Carrega e filtra habilidades baseadas no texto da barra de pesquisa
                let habilidades = loadHabilidadesData()
                opcoesFiltradas = habilidades.filter { habilidade in
                    habilidade.lowercased().contains(searchText.lowercased())
                }
            case 2:
                opcoesFiltradas = opcoesDeFormacao.filter { opcao in
                    opcao.lowercased().contains(searchText.lowercased())
                }
            case 3:
                opcoesFiltradas = opcoesDeExperiencia.filter { opcao in
                    opcao.lowercased().contains(searchText.lowercased())
                }
            case 4:
                // Usa a função loadLocalizacaoData() para carregar e filtrar os dados de localização
                let localizacoes = loadLocalizacaoData()
                opcoesFiltradas = localizacoes.filter { localizacao in
                    localizacao.lowercased().contains(searchText.lowercased())
                }
            case 5:
                opcoesFiltradas = opcoesDeAvaliacao.filter { opcao in
                    opcao.lowercased().contains(searchText.lowercased())
                }
            default:
                opcoesFiltradas = []
            }
            filtroTableView.isHidden = opcoesFiltradas.isEmpty
        }

        filtroTableView.reloadData()
        ajustarAlturaDaTabela()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // A tabela permanece escondida quando a pesquisa é iniciada, só aparece com resultados válidos
        filtroTableView.isHidden = opcoesFiltradas.isEmpty || searchBar.text!.isEmpty
    }
    
    func configureButtons() {
        for button in filtroButton {
            
            var configuration = button.configuration ?? UIButton.Configuration.plain()
            configuration.baseForegroundColor = .black
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = UIColor(hex: "#EBEBEB")
            configuration.background = backgroundConfig
            button.configuration = configuration
            
            button.addTarget(self, action: #selector(filtroButtonTapped(_:)), for: .touchUpInside)
        }
    }

    func updateFilterOptions(forTag tag: Int) {
        // Atualiza sugestoes com base no filtro selecionado
        
        pesquisaBar.text = ""
        
        switch tag {
        case 0:
            // Carrega e mostra os nomes dos usuários
            opcoesFiltradas = loadNomes()
        case 1:
            // Carrega e mostra as habilidades
            opcoesFiltradas = loadHabilidadesData()
        case 2:
            // Quando o botão com tag 2 é pressionado, mostra todas as opções de formação
            opcoesFiltradas = opcoesDeFormacao
        case 3:
            // Mostra os níveis de experiencia
            opcoesFiltradas = opcoesDeExperiencia
        case 4:
            // Carrega e mostra os estados
            opcoesFiltradas = loadLocalizacaoData()
            filtroTableView.isHidden = true
        case 5:
            // Mostra as opções de avaliação
            opcoesFiltradas = opcoesDeAvaliacao
        default:
            // Para outras tags, podemos limpar as opções filtradas ou definir outro comportamento
            opcoesFiltradas = []
        }
        
        filtroTableView.isHidden = true
        
        filtroTableView.reloadData()
        ajustarAlturaDaTabela()  // Ajusta a altura baseada no número de células visíveis
    }

    @objc func filtroButtonTapped(_ sender: UIButton) {
        filtroAtual = sender.tag
        
        for button in filtroButton {
            var config = button.configuration ?? UIButton.Configuration.plain()
            var bgConfig = config.background ?? UIBackgroundConfiguration.listPlainCell()
            config.baseForegroundColor = .black
            bgConfig.backgroundColor = UIColor(hex: "#EBEBEB")
            config.background = bgConfig
            button.configuration = config
        }

        var selectedConfig = sender.configuration ?? UIButton.Configuration.plain()
        var selectedBackgroundConfig = selectedConfig.background ?? UIBackgroundConfiguration.listPlainCell()
        if selectedBackgroundConfig.backgroundColor == UIColor(hex: "#EBEBEB") {
            selectedConfig.baseForegroundColor = .white
            selectedBackgroundConfig.backgroundColor = UIColor(hex: "#06ADBF")
        } else {
            selectedConfig.baseForegroundColor = .black
            selectedBackgroundConfig.backgroundColor = UIColor(hex: "#EBEBEB")
        }
        selectedConfig.background = selectedBackgroundConfig
        sender.configuration = selectedConfig

        // Chama a função de atualização com base na tag do botão
        updateFilterOptions(forTag: sender.tag)
    }
    
    func pesquisaButtonTapped(usuario: Usuario) {
        // Mostra o perifl do usuario selecionado
        
        self.usuarioSelecionado = usuario
        performSegue(withIdentifier: "pesquisaPerfilSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pesquisaPerfilSegue" {
            if let destinationVC = segue.destination as? PerfilViewController {
                destinationVC.usuario = self.usuarioSelecionado
            }
        }
    }

    // UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filtroTableView {
            return opcoesFiltradas.count
        } else { // assumindo que seja a tabela de usuários
            return usuarios.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filtroTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FiltroCell", for: indexPath)
            cell.textLabel?.text = opcoesFiltradas[indexPath.row]
            return cell
        } else { // assumindo que seja a tabela de usuários
            let cell = tableView.dequeueReusableCell(withIdentifier: "PesquisaTableViewCell", for: indexPath) as! PesquisaTableViewCell
            let usuario = usuarios[indexPath.row]
            cell.usuario = usuario
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Povoa a tabela de uusario com base no filtro selecionado e texto digitado
        
        if tableView == filtroTableView {
            filtroTableView.isHidden = true
            
            switch filtroAtual {
            case 0:
                let selectedName = opcoesFiltradas[indexPath.row]
                pesquisaBar.text = selectedName
                filterUsersByName(selectedName: selectedName)
            case 1: // Supondo que tag 1 seja para habilidades
                let selectedSkill = opcoesFiltradas[indexPath.row]
                pesquisaBar.text = selectedSkill
                filterUsersByHabilidade(selectedSkill: selectedSkill)
            case 2: // Supondo que tag 2 seja para formação
                let selectedFormacao = opcoesFiltradas[indexPath.row]
                pesquisaBar.text = selectedFormacao
                filterUsersByFormacao(selectedFormacao: selectedFormacao)
            case 3:
                let selectedExperiencia = opcoesFiltradas[indexPath.row]
                pesquisaBar.text = selectedExperiencia
                filterUsersByExperiencia(selectedExperiencia: selectedExperiencia)
            case 4:
                let selectedLocalizacao = opcoesFiltradas[indexPath.row]
                pesquisaBar.text = selectedLocalizacao
                filterUsersByLocalizacao(selectedLocalizacao: selectedLocalizacao)
            case 5:
                let selectedAvaliacao = opcoesFiltradas[indexPath.row]
                pesquisaBar.text = selectedAvaliacao
                filterUsersByAvaliacao(selectedAvaliacao: selectedAvaliacao)
            default:
                break
            }
            
            pesquisaTableView.reloadData()
        } else{
            pesquisaTableView.deselectRow(at: indexPath, animated: false)
        }
    }

    func ajustarAlturaDaTabela() {
        let alturaDaLinha = filtroTableView.rowHeight
        let alturaTotal = alturaDaLinha * CGFloat(opcoesFiltradas.count)
        filtroTableView.frame.size.height = alturaTotal        
        filtroTableView.isScrollEnabled = true
    }


    func filterUsersByName(selectedName: String) {
        // Filtra usuarios por nome no json resposta do back end
        
        let components = selectedName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        guard components.count == 2 else { return }
        let firstName = String(components[0])
        let lastName = String(components[1])

        var filteredUsers: [Usuario] = []

        func loadAndFilterUsers(from fileName: String) {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"), let data = try? Data(contentsOf: url) {
                if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let usuariosArray = jsonDict["usuarios"] as? [[String: Any]] {
                    for usuarioDict in usuariosArray {
                        if let nome = usuarioDict["nome"] as? String,
                           let sobrenome = usuarioDict["sobrenome"] as? String,
                           nome == firstName && sobrenome == lastName {
                            if let usuario = parseUsuario(from: usuarioDict) {
                                filteredUsers.append(usuario)
                            }
                        }
                    }
                }
            }
        }

        loadAndFilterUsers(from: "aprendizes")
        loadAndFilterUsers(from: "mentores")

        usuarios = filteredUsers
    }

    func filterUsersByHabilidade(selectedSkill: String) {
        // Filtra usuarios no json resposta do back end por habilidade
        
        var filteredUsers: [Usuario] = []

        func loadAndFilterUsers(from fileName: String) {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let usuariosArray = jsonDict?["usuarios"] as? [[String: Any]] {
                        for usuarioDict in usuariosArray {
                            if let habilidadesArray = usuarioDict["habilidades"] as? [[String: Any]],
                               let primeiraHabilidade = habilidadesArray.first,
                               let nomeHabilidade = primeiraHabilidade["nome"] as? String,
                               nomeHabilidade == selectedSkill {
                                if let usuario = parseUsuario(from: usuarioDict) {
                                    filteredUsers.append(usuario)
                                }
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON from \(fileName): \(error)")
                }
            } else {
                print("Failed to load data from \(fileName)")
            }
        }

        loadAndFilterUsers(from: "aprendizes")
        loadAndFilterUsers(from: "mentores")

        usuarios = filteredUsers
    }
    
    func filterUsersByFormacao(selectedFormacao: String) {
        // Filtra usuarios no json resposta do back end com base na formação
        
        guard let index = opcoesDeFormacao.firstIndex(of: selectedFormacao) else {
            print("Formação selecionada não encontrada.")
            return
        }
        let formacaoID = index + 1

        var filteredUsers: [Usuario] = []

        func loadAndFilterUsers(from fileName: String) {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let usuariosArray = jsonDict?["usuarios"] as? [[String: Any]] {
                        for usuarioDict in usuariosArray {
                            if let formacaoDict = usuarioDict["formacao"] as? [String: Any],
                               let formacao = formacaoDict["id"] as? Int, formacao == formacaoID {
                                if let usuario = parseUsuario(from: usuarioDict) {
                                    filteredUsers.append(usuario)
                                }
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON from \(fileName): \(error)")
                }
            } else {
                print("Failed to load data from \(fileName)")
            }
        }

        loadAndFilterUsers(from: "aprendizes")
        loadAndFilterUsers(from: "mentores")

        usuarios = filteredUsers
    }
    
    func filterUsersByExperiencia(selectedExperiencia: String) {
        // Filtra usuarios no json resposta do back end com base na experiência
        
        guard let index = opcoesDeExperiencia.firstIndex(of: selectedExperiencia) else {
            print("Nível de experiência selecionado não encontrado.")
            return
        }
        let experienciaID = index + 1

        var filteredUsers: [Usuario] = []

        func loadAndFilterUsers(from fileName: String) {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let usuariosArray = jsonDict?["usuarios"] as? [[String: Any]] {
                        for usuarioDict in usuariosArray {
                            if let habilidadesArray = usuarioDict["habilidades"] as? [[String: Any]],
                               let primeiraHabilidade = habilidadesArray.first,
                               let nivelDeExperiencia = primeiraHabilidade["nivelDeExperiencia"] as? Int,
                               nivelDeExperiencia == experienciaID {
                                if let usuario = parseUsuario(from: usuarioDict) {
                                    filteredUsers.append(usuario)
                                }
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON from \(fileName): \(error)")
                }
            } else {
                print("Failed to load data from \(fileName)")
            }
        }

        loadAndFilterUsers(from: "aprendizes")
        loadAndFilterUsers(from: "mentores")

        usuarios = filteredUsers
    }
    
    func filterUsersByLocalizacao(selectedLocalizacao: String) {
        // Filtra usuarios no json resposta do back end com base noa localizacao
        
        var filteredUsers: [Usuario] = []

        func loadAndFilterUsers(from fileName: String) {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let usuariosArray = jsonDict?["usuarios"] as? [[String: Any]] {
                        for usuarioDict in usuariosArray {
                            if let localizacaoDict = usuarioDict["localizacao"] as? [String: Any],
                               let nomeLocalizacao = localizacaoDict["nome"] as? String,
                               nomeLocalizacao == selectedLocalizacao {
                                if let usuario = parseUsuario(from: usuarioDict) {
                                    filteredUsers.append(usuario)
                                }
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON from \(fileName): \(error)")
                }
            } else {
                print("Failed to load data from \(fileName)")
            }
        }

        loadAndFilterUsers(from: "aprendizes")
        loadAndFilterUsers(from: "mentores")

        usuarios = filteredUsers
    }

    func filterUsersByAvaliacao(selectedAvaliacao: String) {
        // Filtra usuarios no json resposta do back end com base na pontuacao de avaliacao
        
        guard let index = opcoesDeAvaliacao.firstIndex(of: selectedAvaliacao) else {
            print("Avaliação selecionada não encontrada.")
            return
        }
        let avaliacaoID = index + 1

        var filteredUsers: [Usuario] = []

        func loadAndFilterUsers(from fileName: String) {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let usuariosArray = jsonDict?["usuarios"] as? [[String: Any]] {
                        for usuarioDict in usuariosArray {
                            if let avaliacao = usuarioDict["avaliacao"] as? Int,
                               avaliacao == avaliacaoID {
                                if let usuario = parseUsuario(from: usuarioDict) {
                                    filteredUsers.append(usuario)
                                }
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON from \(fileName): \(error)")
                }
            } else {
                print("Failed to load data from \(fileName)")
            }
        }

        loadAndFilterUsers(from: "aprendizes")
        loadAndFilterUsers(from: "mentores")

        usuarios = filteredUsers
    }

    
    func parseUsuario(from dict: [String: Any]) -> Usuario? {
        // Converte os usuario recebidos do back end em classes no app
        
        if let id = dict["id"] as? Int,
           let nome = dict["nome"] as? String,
           let sobrenome = dict["sobrenome"] as? String,
           let email = dict["email"] as? String,
           let senha = dict["senha"] as? String,
           let formacaoDict = dict["formacao"] as? [String: Any],
           let formacaoId = formacaoDict["id"] as? Int,
           let formacaoNome = formacaoDict["nome"] as? String,
           let areasDeInteresseArray = dict["areasDeInteresse"] as? [[String: Any]],
           let habilidadesArray = dict["habilidades"] as? [[String: Any]],
           let localizacaoDict = dict["localizacao"] as? [String: Any],
           let localizacaoId = localizacaoDict["id"] as? Int,
           let localizacaoNome = localizacaoDict["nome"] as? String,
           let avaliacao = dict["avaliacao"] as? Int {
            
            let formacao = Formacao(id: formacaoId, nome: formacaoNome)
            
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
            
            let localizacao = Localizacao(id: localizacaoId, nome: localizacaoNome)
            
            return Usuario(id: id, nome: nome, sobrenome: sobrenome, email: email, senha: senha, formacao: formacao, areasDeInteresse: areasDeInteresse, habilidades: habilidades, localizacao: localizacao, avaliacao: avaliacao)
        }
        return nil
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let r = (color >> 16) & 0xFF
        let g = (color >> 8) & 0xFF
        let b = color & 0xFF
        
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: 1.0
        )
    }
}
