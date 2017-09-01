//
//  PokeAgendaViewController.swift
//  Pokemão GOL
//
//  Created by Ben Hur Martins on 16/03/17.
//  Copyright © 2017 Ben Hur Martins. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemaosCapturados : [Pokemao] = []
    var pokemaosNaoCapturados : [Pokemao] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreData = CoreDataPokemao()
        
        self.pokemaosCapturados = coreData.recuperarPokemaosCapturados(capturado: true)
        self.pokemaosNaoCapturados = coreData.recuperarPokemaosCapturados(capturado: false)
    }

    @IBAction func voltarMapa(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }else{
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.pokemaosCapturados.count
        }else{
            return self.pokemaosNaoCapturados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemao:Pokemao
        if indexPath.section == 0 {
            pokemao = pokemaosCapturados[indexPath.row]
        }else{
            pokemao = pokemaosNaoCapturados[indexPath.row]
        }
        
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celulaPokemao")
        
        celula.textLabel?.text = pokemao.nome
        celula.imageView?.image = UIImage(named: pokemao.nomeImagem!)
        
        
        return celula
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
