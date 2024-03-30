//
//  ViewController.swift
//  Servicios_Api
//
//  Created by david gomez herrera on 26/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrPersonajes: UIScrollView!
    var personajes:[Personaje] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        consultarServicio()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let boton = sender as! UIButton
        let vc = segue.destination as! EpisodiosViewController
        
        vc.episodios = personajes[boton.tag].episodios
    }
    
    func consultarServicio() {
        let conexion = URLSession(configuration: .default)
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        
        conexion.dataTask(with: url) { datos, respuesta, error in
            do {
                let json = try JSONSerialization.jsonObject(with: datos!) as! [String: Any]
                let personajes = json["results"]! as! [Any]
                for personaje in personajes {
                    if let info = personaje as? [String: Any] {
                        self.personajes.append(Personaje(name: info["name"] as! String, status: info["status"] as! String, specie: info["species"] as! String, image: info["image"] as! String))
                        self.personajes.last?.episodios = info["episode"] as! [String]
                    }
                    print(self.personajes)
                }
                DispatchQueue.main.async {
                    self.dibujarPersonajes()
                }
            } catch {
                print("Algo salió mal")
            }
        }.resume()
    }
    
    func dibujarPersonajes() {
        var y = 10
        for i in 0..<personajes.count {
            let vista = UIView(frame: CGRect(x: 10, y: y, width: Int(scrPersonajes.frame.width - 20), height: 100))
            vista.backgroundColor = .systemGray5
            
            let imagen = UIImageView(frame: CGRect(x: 5, y: 5, width: 90, height: 90))
            imagen.image = UIImage(named: "loading.png")
            let conexion = URLSession(configuration: .default)
            conexion.dataTask(with: URL(string: personajes[i].image)!) { datos, respuesta, error in
                DispatchQueue.main.async {
                    imagen.image = UIImage(data: datos!)
                }
            }.resume()
            
            let lblNombre = UILabel(frame: CGRect(x: 100, y: 5, width: Int(vista.frame.width - 105), height: 30))
            lblNombre.text = personajes[i].name
            lblNombre.font = .boldSystemFont(ofSize: 22)
            lblNombre.minimumScaleFactor = 0.5
            lblNombre.adjustsFontSizeToFitWidth = true
            
            let lblEspecie = UILabel(frame: CGRect(x: 100, y: 37, width: Int(vista.frame.width - 105), height: 28))
            lblEspecie.text = personajes[i].specie
            lblEspecie.font = .systemFont(ofSize: 17)
            
            let lblStatus = UILabel(frame: CGRect(x: 100, y: 70, width: Int(vista.frame.width - 105), height: 25))
            lblStatus.text = personajes[i].status
            lblStatus.font = .systemFont(ofSize: 15)
            lblStatus.textAlignment = .right
            
            let boton = UIButton(frame: CGRect(x: 0, y: 0, width: vista.frame.width, height: vista.frame.height))
            boton.tag = i
            boton.addTarget(self, action: #selector(mostrarDetalle(sender:)), for: .touchDown)
            
            vista.addSubview(imagen)
            vista.addSubview(lblNombre)
            vista.addSubview(lblEspecie)
            vista.addSubview(lblStatus)
            vista.addSubview(boton)
            scrPersonajes.addSubview(vista)
            y += 110
        }
        scrPersonajes.contentSize = CGSize(width: 0, height: y)
    }
    
    @objc func mostrarDetalle(sender: UIButton) {
        performSegue(withIdentifier: "sgEpisodios", sender: sender)
    }
}
