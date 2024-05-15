import Foundation

struct Habilidade {
    var id: Int
    var nome: String
    var nivelDeExperiencia: Int // 1 a 4
}

struct AreaDeInteresse {
    var id: Int
    var nome: String
}

class Usuario {
    var id: Int
    var nome: String
    var sobrenome: String
    var email: String
    var senha: String
    var formacao : Int
    var areasDeInteresse: [AreaDeInteresse]
    var habilidades: [Habilidade]
    
    init(id: Int, nome: String, sobrenome: String, email: String, senha: String, formacao: Int,areasDeInteresse: [AreaDeInteresse] = [], habilidades: [Habilidade] = []) {
        self.id = id
        self.nome = nome
        self.sobrenome = sobrenome
        self.email = email
        self.senha = senha
        self.formacao = formacao
        self.areasDeInteresse = areasDeInteresse
        self.habilidades = habilidades
    }
}
