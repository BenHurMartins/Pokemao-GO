//
//  PokemonAnotacao.swift
//  Pokemão GOL
//
//  Created by Ben Hur Martins on 15/03/17.
//  Copyright © 2017 Ben Hur Martins. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnotacao : NSObject, MKAnnotation {
 
    var coordinate: CLLocationCoordinate2D
    
    var pokemao:Pokemao
    
    init(coordenadas : CLLocationCoordinate2D, pokemao: Pokemao) {
        self.coordinate = coordenadas
        self.pokemao = pokemao
    }
}
