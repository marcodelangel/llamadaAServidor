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
    @IBOutlet weak var cajaMuestraInformacion: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capturaDeIsbn.delegate = self
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if Reachability.isConnectedToNetwork() == false {
            print("Internet connection FAILED")
            let alert = UIAlertController (title: "Alerta",
                                           message: "No tienes Internet",
                                           preferredStyle: UIAlertControllerStyle(rawValue: 1)!)
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: UIAlertActionStyle.Default,
                                             handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                                                completion: nil)
        } else {
            print("Internet connection OK")
            var ISBN = capturaDeIsbn.text!
            ISBN.insert("-", atIndex: ISBN.startIndex.advancedBy(3))
            ISBN.insert("-", atIndex: ISBN.startIndex.advancedBy(6))
            ISBN.insert("-", atIndex: ISBN.startIndex.advancedBy(10))
            ISBN.insert("-", atIndex: ISBN.endIndex.predecessor())
            let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
            let url = NSURL(string: urls)
            let datos:NSData? = NSData(contentsOfURL: url!)
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            let informacion:NSString = texto!
            cajaMuestraInformacion.text! = informacion as String
            capturaDeIsbn.resignFirstResponder()
        }
        
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

