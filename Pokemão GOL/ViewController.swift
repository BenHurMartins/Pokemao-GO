//
//  ViewController.swift
//  Pokemão GOL
//
//  Created by Ben Hur Martins on 08/03/17.
//  Copyright © 2017 Ben Hur Martins. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemao : CoreDataPokemao!
    var pokemaos : [Pokemao] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //recuperar pokemons
        self.coreDataPokemao = CoreDataPokemao()
        self.pokemaos = self.coreDataPokemao.recuperarTodosPokemaos()
        
        //exibir os pokemons
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) {(timer) in
            
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate{
                
                let numeroPokemon = Int(arc4random_uniform(UInt32(self.pokemaos.count)))
                let pokemon = self.pokemaos[numeroPokemon]
                
                let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemao: pokemon)
                
 //             anotacao.coordinate = coordenadas
                let lat = (Double(arc4random_uniform(500)) - 250) / 100000.0
                let lon = (Double(arc4random_uniform(500)) - 250) / 100000.0
                anotacao.coordinate.latitude += lat
                anotacao.coordinate.longitude += lon
                self.mapa.addAnnotation(anotacao)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador < 5 {
            self.centralizar()
            contador += 1
        
        }else{
            gerenciadorLocalizacao.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined{
            //exibir alerta
            let alert = UIAlertController(title: "Permissão de Localização", message: "Para que você possa caçar pokemãos, precisamos de sua localização", preferredStyle: .alert)
            let acaoConfiguracoes = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alert.addAction(acaoConfiguracoes)
            alert.addAction(acaoCancelar)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
    
        if annotation is MKUserLocation {
            anotacaoView.image = #imageLiteral(resourceName: "player")
        }else{
            
            let pokemao = (annotation as! PokemonAnotacao).pokemao
            
            anotacaoView.image = UIImage(named: pokemao.nomeImagem!)
        }
       
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        anotacaoView.frame = frame
        
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let anotacao = view.annotation
   
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if anotacao is MKUserLocation!{
            return
        }
        
        let anotacaoPokemao = (view.annotation as! PokemonAnotacao)
        
        //centralizar o pokemon
        if let coordenadasPokemaoAnotacao = anotacao?.coordinate {
            let regiao = MKCoordinateRegionMakeWithDistance(coordenadasPokemaoAnotacao, 500, 500)
            mapa.setRegion(regiao, animated: true)
        }
        
        //esperar 1 segundo antes de tentar capturar
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false){(timer) in
        
        if let coordenadasUsuario = self.gerenciadorLocalizacao.location?.coordinate {
            if MKMapRectContainsPoint(self.mapa.visibleMapRect, MKMapPointForCoordinate(coordenadasUsuario)){
                self.coreDataPokemao.salvarPokemao(pokemao: anotacaoPokemao.pokemao)
                self.mapa.removeAnnotation(anotacao!)
                
                let alertaController = UIAlertController(title: "Parabéns", message: "Voce capturou o pokemão: \(anotacaoPokemao.pokemao.nome)", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertaController.addAction(btnOk)
                
                self.present(alertaController, animated: true, completion: nil)
                
            }else{
                let alertaController = UIAlertController(title: ":(", message: "Voce não pode capturar esse pokemão, você precisa se aproximar mais para capturar o: \(anotacaoPokemao.pokemao.nome)", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertaController.addAction(btnOk)
                
                self.present(alertaController, animated: true, completion: nil)
            }
        }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func centralizarJogador(_ sender: UIButton) {
        self.centralizar()
    }
    
    
    @IBAction func abrirPokedex(_ sender: UIButton) {
    }

    func centralizar(){
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate {
            let regiao = MKCoordinateRegionMakeWithDistance(coordenadas, 500, 500)
            mapa.setRegion(regiao, animated: true)
        }
    }
}

