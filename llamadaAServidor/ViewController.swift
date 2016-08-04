//
//  ViewController.swift
//  llamadaAServidor
//
//  Created by Marco Del Angel on 24/07/16.
//  Copyright © 2016 Marco Del Angel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var capturaDeIsbn: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capturaDeIsbn.delegate = self

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if Reachability.isConnectedToNetwork() == false {
                print("Internet connection FAILED")
                noInternetAlert()
        
        }else{
            var ISBN:String = capturaDeIsbn.text!
            
            if ISBN.characters.count < 12 || ISBN == "Ingresa el ISBN" {
                incorrectISBNCaptureAlert()
            }else{
                ISBN.insert("-", atIndex: ISBN.startIndex.advancedBy(3))
                ISBN.insert("-", atIndex: ISBN.startIndex.advancedBy(6))
                ISBN.insert("-", atIndex: ISBN.startIndex.advancedBy(10))
                ISBN.insert("-", atIndex: ISBN.endIndex.predecessor())
                let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
                let url = NSURL(string: urls)
                let datos:NSData? = NSData(contentsOfURL: url!)
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                let informacion:NSString = texto!
            
                if informacion == "{}"{
                    noBookFoundAlert()
                }else{
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                            let dictionaryFirstLevel = json as! NSDictionary
                            let dictionaryISBN = dictionaryFirstLevel["ISBN:" + ISBN] as! NSDictionary
                            self.titulo.text = dictionaryISBN["title"] as! NSString as String
                            let dictionaryAuthors = dictionaryISBN["authors"] as! NSMutableArray
                            let ejemplo = dictionaryAuthors.objectAtIndex(0)
                            print (ejemplo)
                            let array = dictionaryAuthors.objectAtIndex(0) as! NSDictionary
                            self.autores.text = array["name"] as! NSString as String
                        
                                if let dictionaryImages = dictionaryISBN["cover"] as! NSDictionary? {
                                    let urlsImage = dictionaryImages["large"] as! NSString as String
                                    let urlImage = NSURL(string: urlsImage)
                                    let datosImage:NSData? = NSData(contentsOfURL: urlImage!)
                                    let imageCover:UIImage = UIImage(data: datosImage!)!
                                    self.portada.image = imageCover
                                }else{
                                    let noCover:UIImage = UIImage(imageLiteral: "noCover.jpg")
                                    self.portada.image = noCover
                        }
                    }
                    catch _{
                        
                    }
                    capturaDeIsbn.resignFirstResponder()
                }
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        capturaDeIsbn.resignFirstResponder(dismissViewControllerAnimated(true,
                                            completion: nil))
    }
    
    func noInternetAlert() {
        let alert = UIAlertController (title: "Alerta",
                                       message: "No tienes Internet",
                                       preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertActionStyle.Default,
                                         handler: nil)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true,
                                   completion: nil)
    }

    func incorrectISBNCaptureAlert(){
        let alertEmpty = UIAlertController(title: "Mensaje",
                                           message: "Anota un ISBN sin guiones para iniciar la búsqueda",
                                           preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: UIAlertActionStyle.Default,
                                     handler: nil)
        alertEmpty.addAction(okAction)
        self.presentViewController(alertEmpty,
                                   animated: true,
                                   completion: nil)
    }
    
    func noBookFoundAlert(){
        let alertNoBook = UIAlertController(title: "Mensaje",
                                            message: "No existe el libro para el ISBN buscado",
                                            preferredStyle: UIAlertControllerStyle.Alert)
        let okActionNoBook = UIAlertAction(title: "Ok",
                                           style: UIAlertActionStyle.Default,
                                           handler: nil)
        alertNoBook.addAction(okActionNoBook)
        self.presentViewController(alertNoBook,
                                   animated: true,
                                   completion: nil)
    }
}

