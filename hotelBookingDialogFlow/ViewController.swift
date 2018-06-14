//
//  ViewController.swift
//  hotelBookingDialogFlow
//
//  Created by Indresh Arora on 15/06/18.
//  Copyright © 2018 Indresh Arora. All rights reserved.
//

import UIKit
import AVFoundation
import ApiAI


class ViewController: UIViewController {
    
    
    @IBOutlet weak var messageLbl: UITextField!
    @IBOutlet weak var botResponse: UILabel!
    
    @IBAction func sendMessage(_ sender: Any){
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messageLbl.text, text != nil{
            request?.query = text
        }else{
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech{
                self.speechText(convertText: textResponse)
            }
        }, failure: { (request, error) in
            let alertController = UIAlertController(title: "Datebayo", message: error?.localizedDescription, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Chidori", style: .destructive, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        })
        
        ApiAI.shared().enqueue(request)
        messageLbl.text = ""
        
    }
    
    let speechSynthesizers = AVSpeechSynthesizer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func speechText(convertText text: String){
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizers.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations:{
          self.botResponse.text = text
        } , completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

