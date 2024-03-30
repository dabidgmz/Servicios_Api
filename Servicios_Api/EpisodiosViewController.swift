//
//  EpisodiosViewController.swift
//  Servicios_Api
//
//  Created by david gomez herrera on 26/03/24.
//

import UIKit

class EpisodiosViewController: UIViewController {

    @IBOutlet weak var scrEpisodios: UIScrollView!
    var episodios:[String] = []
    var nombres:[String] = []
    var fechas:[String] = []
    var codigos:[String] = []
    var indice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        consultarEpisodios()
    }
    
    func consultarEpisodios() {
        for episodio in episodios {
            let conexion = URLSession(configuration: .default)
            conexion.dataTask(with: URL(string: episodio)!) { datos, respuesta, error in
                do {
                    let json = try JSONSerialization.jsonObject(with: datos!) as! [String:Any]
                    self.nombres += [json["name"] as! String]
                    self.fechas += [json["air_date"] as! String]
                    self.codigos += [json["episode"] as! String]
                    
                    self.indice += 1
                    if self.indice == self.episodios.count {
                        DispatchQueue.main.async {
                            self.dibujarEpisodios()
                        }
                    }
                } catch {
                    print("Algo salió mal")
                }
            }.resume()
        }
    }
    
    func dibujarEpisodios() {
        var y = 10
        
        for i in 0..<codigos.count {
            let vista = UIView(frame: CGRect(x: 10, y: y, width: Int(scrEpisodios.frame.width) - 20, height: 70))
            vista.backgroundColor = .systemGray5
            
            let nombre = UILabel(frame: CGRect(x: 5, y: 3, width: Int(vista.frame.width) - 10, height: 27))
            nombre.text = nombres[i]
            nombre.font = .boldSystemFont(ofSize: 22)
            nombre.adjustsFontSizeToFitWidth = true
            nombre.minimumScaleFactor = 0.5
            
            let fecha = UILabel(frame: CGRect(x: 5, y: 30, width: Int(vista.frame.width) - 10, height: 20))
            fecha.text = fechas[i]
            fecha.font = .systemFont(ofSize: 17)
            
            let codigo = UILabel(frame: CGRect(x: 5, y: 50, width: Int(vista.frame.width) - 10, height: 20))
            codigo.text = "Código: " + codigos[i]
            codigo.font = .systemFont(ofSize: 15)
            codigo.textAlignment = .right
            
            vista.addSubview(nombre)
            vista.addSubview(fecha)
            vista.addSubview(codigo)
            scrEpisodios.addSubview(vista)
            y += 80
        }
        scrEpisodios.contentSize = CGSize(width: 0, height: y)
    }
}
