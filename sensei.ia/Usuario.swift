import Foundation

// Calsse para usuarios, que representa uma entidade em nosso banco de dados

struct Habilidade {
    var id: Int
    var nome: String
    var nivelDeExperiencia: Int // 1 a 4
}

struct AreaDeInteresse {
    var id: Int
    var nome: String
}

struct Localizacao {
    var id: Int
    var nome: String
}

struct Formacao {
    var id: Int
    var nome: String
}

class Usuario {
    var id: Int
    var nome: String
    var sobrenome: String
    var email: String
    var senha: String
    var formacao: Formacao
    var areasDeInteresse: [AreaDeInteresse]
    var habilidades: [Habilidade]
    var localizacao: Localizacao?
    var avaliacao: Int

    init(id: Int, nome: String, sobrenome: String, email: String, senha: String, formacao: Formacao, areasDeInteresse: [AreaDeInteresse] = [], habilidades: [Habilidade] = [], localizacao: Localizacao? = nil, avaliacao: Int = 0) {
        self.id = id
        self.nome = nome
        self.sobrenome = sobrenome
        self.email = email
        self.senha = senha
        self.formacao = formacao
        self.areasDeInteresse = areasDeInteresse
        self.habilidades = habilidades
        self.localizacao = localizacao
        self.avaliacao = avaliacao
    }
}
