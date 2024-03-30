//
//  Personaje.swift
//  Servicios_Api
//
//  Created by david gomez herrera on 26/03/24.
//

import UIKit

class Personaje: NSObject {
    var name = ""
    var status = ""
    var specie = ""
    var image = ""
    var episodios:[String] = []

    init(name: String, status: String, specie: String, image: String) {
        self.name = name
        self.status = status
        self.specie = specie
        self.image = image
    }
    
    override var description: String {
        return String(format: "Nombre: %@\nEspecie: %@\nStatus: %@\nImagen: %@", name, specie, status, image)
    }
}
