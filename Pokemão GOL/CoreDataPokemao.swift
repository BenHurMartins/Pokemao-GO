//
//  coreDataPokemao.swift
//  Pokemão GOL
//
//  Created by Ben Hur Martins on 14/03/17.
//  Copyright © 2017 Ben Hur Martins. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPokemao{
    // recuperar o contexto
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = appDelegate?.persistentContainer.viewContext
        
        return context!
    }
    
    func salvarPokemao(pokemao:Pokemao){
        
        let contexto = self.getContext()
        
        pokemao.capturado = true
        
        do{
            try contexto.save()
        }catch{}
    }
    
    // adicionar todos os pokemons
    func adicionarTodosPokemons(){
        
        let context = self.getContext()
        
        self.criarPokemon(nome:"Mew" , nomeImagem: "mew", capturado: false)
        self.criarPokemon(nome:"Meowth" , nomeImagem: "meowth", capturado: false)
        self.criarPokemon(nome:"Snorlax" , nomeImagem: "snorlax", capturado: false)
        self.criarPokemon(nome:"Eevee" , nomeImagem: "eevee", capturado: false)
        self.criarPokemon(nome:"Abra" , nomeImagem: "abra", capturado: false)
        self.criarPokemon(nome:"Dratini" , nomeImagem: "dratini", capturado: false)
        self.criarPokemon(nome:"Venonat" , nomeImagem: "venonat", capturado: false)
        self.criarPokemon(nome:"Bullbasaur" , nomeImagem: "bullbasaur", capturado: false)
        self.criarPokemon(nome:"Pidgey" , nomeImagem: "pidgey", capturado: false)
        self.criarPokemon(nome:"Bellsprout" , nomeImagem: "bellsprout", capturado: false)
        self.criarPokemon(nome:"Squirtle" , nomeImagem: "squirtle", capturado: false)
        self.criarPokemon(nome:"Charmander" , nomeImagem: "charmander", capturado: false)
        self.criarPokemon(nome:"Pikachu" , nomeImagem: "pikachu-2", capturado: false)
        self.criarPokemon(nome:"Weedle" , nomeImagem: "weedle", capturado: false)
        self.criarPokemon(nome:"Mankey" , nomeImagem: "mankey", capturado: false)
        self.criarPokemon(nome:"Zubat" , nomeImagem: "zubat", capturado: false)
        self.criarPokemon(nome:"Psyduck" , nomeImagem: "psyduck", capturado: false)
        self.criarPokemon(nome:"Rattata" , nomeImagem: "rattata", capturado: false)
        self.criarPokemon(nome:"Jigglypuff" , nomeImagem: "jigglypuff", capturado: false)
        
        do{
            try context.save()
        }catch{}
    }
    // criar os pokemons
    func criarPokemon(nome: String, nomeImagem: String, capturado: Bool){
        
        let context = self.getContext()
        let pokemao = Pokemao(context: context)
        
        pokemao.nome = nome
        pokemao.nomeImagem = nomeImagem
        pokemao.capturado = capturado
        
    }
    
    func recuperarPokemaosCapturados(capturado: Bool) -> [Pokemao]{
        
        let context = self.getContext()
    
        let requisicao = Pokemao.fetchRequest() as NSFetchRequest<Pokemao>
        requisicao.predicate = NSPredicate(format: "capturado = %@", capturado as CVarArg)
        
        do{
            let pokemaos = try context.fetch(requisicao) as [Pokemao]
            return pokemaos
        }catch{}
        
        return []
    }
    
    func recuperarTodosPokemaos() -> [Pokemao]{
        let context = self.getContext()
        
        do {
            let pokemaos = try context.fetch(Pokemao.fetchRequest()) as! [Pokemao]
            
            if pokemaos.count == 0 {
                self.adicionarTodosPokemons()
                return recuperarTodosPokemaos()
            }
            
            return pokemaos
        }catch{
            
        }
        return []
    }
}
