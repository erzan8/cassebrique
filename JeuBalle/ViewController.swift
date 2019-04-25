//
//  ViewController.swift
//  JeuBalle
//
//  Created by Guilhem Carron on 20/03/2019.
//  Copyright © 2019 Guilhem Carron. All rights reserved.
//

import UIKit
//import de la librairie audio
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var ViewRaquette: UIImageView!
    @IBOutlet weak var ViewBalle: UIImageView!
    var hauteurEcran : CGFloat!
    var largeurEcran : CGFloat!
    var hauteurElement : CGFloat!
    var largeurElement: CGFloat!
    var soundEffect: AVAudioPlayer?
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        
        
        //Récupérer la taille de l'ecran selon le type de device
         hauteurEcran = self.view.frame.size.height
         largeurEcran = self.view.frame.size.width
        
        hauteurElement = hauteurEcran * 0.05 //5% de la hauteur de l'ecran
        largeurElement = largeurEcran * 0.05
        
        

        
        //Positionner la balle au centre de la vue de type CGRect
        let positionIniBalle : CGRect = CGRect(x: largeurEcran/2 - 30, y: hauteurEcran/2, width: 40, height: 40)
        self.ViewBalle.frame = positionIniBalle
        
        //Animation rotation

        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        ViewBalle.layer.add(rotation, forKey: "rotationAnimation")
        
        
        //Position de la raquette
        let positionInitialeRaq : CGRect = CGRect(x: largeurEcran/2 - 50, y: hauteurEcran - 100, width: 100, height: 50)
        self.ViewRaquette.frame = positionInitialeRaq

      
        
        
    }
    //initialisation des briques
    @IBOutlet weak var brique: UIImageView!
    @IBOutlet weak var brique1: UIImageView!
    @IBOutlet weak var brique2: UIImageView!
    @IBOutlet weak var brique3: UIImageView!
    @IBOutlet weak var brique4: UIImageView!
    @IBOutlet weak var brique5: UIImageView!
    @IBOutlet weak var brique6: UIImageView!
    @IBOutlet weak var brique7: UIImageView!
    @IBOutlet weak var brique8: UIImageView!
    
    
    //label d'accueil du niveau
    @IBOutlet weak var welcomeLabel: UILabel!
    // bouton qui lance le jeu
    @IBOutlet weak var playButton1: UIButton!
    var seconds = 3 // initialisation timer de départ
    var start = false
    var timerDepart: Timer?
    var timer: Timer?
    
 //lorsqu'on clique sur le bouton on cache les labels et on lance le jeu
    @IBAction func playButton(_ sender: Any) {

        //on masque le label
        welcomeLabel.isHidden = true
        playButton1.isHidden = true
         var timerDepart : Timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
    }
   

    @objc func updateTimer() {
        //Timer de départ
        
        seconds -= 1     //décrémente le timer en secondes
        timerLabel.text = "\(seconds)" //affiche les econdes dans le label
        
        if seconds == 0 {
            timerDepart?.invalidate()
            timerLabel.isHidden = true
            jeu()
            
        }
    }
   
    @objc func jeu() {
        //Creation d'un timer qui appelle la fonction tout les 0,1s
        var timer : Timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(rafraichissement), userInfo: nil, repeats: true)
    }
 //vitesse du mouvement
    var mouvementX : CGFloat = 5
    var mouvementY : CGFloat = 5
    
//Fonction qui remet la balle au centre, remet le compteur et relance le jeu lorsque l'utilisateur perd
    @objc func relance(){
        //Positionner la balle au centre de la vue de type CGRect
        let positionIniBalle : CGRect = CGRect(x: largeurEcran/2 - 30, y: hauteurEcran/2, width: 40, height: 40)
        self.ViewBalle.frame = positionIniBalle
        print("balle positionnée")
        seconds = 3
        var timerDepart : Timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    
 //fonction qui rafraichit la position de la balle
    @objc func rafraichissement(){
        //recuperation de la position actuelle de la balle
        var positionActuelleBalle : CGRect = self.ViewBalle.frame
        
        //Modification de la position de la balle aux coordonnées de son centre
        positionActuelleBalle.origin.x += mouvementX
        positionActuelleBalle.origin.y += mouvementY
        
        //Vérifier que la balle est toujours à l'intérieur de la vue
        //Si elle touche le bord gauche ou droit, alors elle rebondit (mvt inverse)
        if positionActuelleBalle.origin.x > largeurEcran - self.ViewBalle.frame.width || positionActuelleBalle.origin.x < 0 {
            mouvementX = -mouvementX
            let path2 = Bundle.main.path(forResource: "coup.mp3", ofType: nil)!
             let url2 = URL(fileURLWithPath: path2)
            do{
                soundEffect = try
                    AVAudioPlayer(contentsOf: url2)
                soundEffect?.play()
            }catch{
                //couldnt load file
            }
            
        }
        //si elle touche le haut de l'ecran elle rebondit
        if positionActuelleBalle.origin.y < 0 {
            mouvementY = -mouvementY
        }
        /*
        if positionActuelleBalle.origin.y > hauteurEcran{
            positionActuelleBalle.origin.y = 0
            mouvementY = abs(mouvementY)
            //Ajout des sons
            //chemin absolu vers la ressource claque.mp3
            
            let path = Bundle.main.path(forResource: "claque.mp3", ofType: nil)!
            
            //Conversion de "string" à "url"
            let url = URL(fileURLWithPath: path)
            
            //charger le son et le jouer
            do{
                soundEffect = try
                    AVAudioPlayer(contentsOf: url)
                soundEffect?.play()
            }catch{
                //couldnt load file
            }
        }*/
        //Test retour balle
        if positionActuelleBalle.origin.y > hauteurEcran - 40{
            timer?.invalidate()
            timerDepart?.invalidate()
            mouvementY = 0
            mouvementX = 0
            timerLabel.isHidden = false
            print("perdu")
            relance()
        }
        
        if(positionActuelleBalle.origin.y + positionActuelleBalle.size.height - 20 > self.ViewRaquette.frame.origin.y) && (positionActuelleBalle.origin.x > self.ViewRaquette.frame.origin.x - ViewRaquette.frame.size.width && positionActuelleBalle.origin.x < self.ViewRaquette.frame.origin.x + ViewRaquette.frame.size.width ){
            //on l'a eue
            mouvementY = -mouvementY
        }
        
        //Gestion des collisions entre balle et briques
        //position des briques
        var positionbrique : CGRect = self.brique.frame
        var positionbrique1 : CGRect = self.brique1.frame
        var positionbrique2 : CGRect = self.brique2.frame
        var positionbrique3 : CGRect = self.brique3.frame
        var positionbrique4 : CGRect = self.brique4.frame
        var positionbrique5 : CGRect = self.brique5.frame
        var positionbrique6 : CGRect = self.brique6.frame
        var positionbrique7 : CGRect = self.brique7.frame
        var positionbrique8 : CGRect = self.brique8.frame
       
        //tableau des positions de briques
       let tabPosBriques = [
            positionbrique,
            positionbrique1,
            positionbrique2,
            positionbrique3,
        positionbrique5,
        positionbrique6,
        positionbrique7,
        positionbrique8,
        ]
        //tableau des briques (images)
        let imgBriques = [brique, brique1, brique2, brique3, brique4, brique5, brique6, brique7, brique8,]
        //compteur du tableau
        let size = tabPosBriques.count
        //si ne brique entre en collision avec la balle, on la cache et on inverse le mvt de la balle
        for var i in 0...size - 1 {
            
            if (positionActuelleBalle.intersects(tabPosBriques[i]) && imgBriques[i]!.isHidden == false)
            {
                mouvementY = -mouvementY
                imgBriques[i]!.isHidden = true
                
               
            }
        }
        self.ViewBalle.frame = positionActuelleBalle

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("j'ai touché l'ecran")
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("je bouge")
        //Recupération de la position du doigtSOltuion
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            print(location.x)
            print(location.y)
            //Position raquette = position du doigt
            self.ViewRaquette.frame.origin.x = location.x
            
        }
       

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("j'ai levé le doigt")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}

