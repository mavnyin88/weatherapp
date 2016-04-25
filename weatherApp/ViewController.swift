//
//  ViewController.swift
//  weatherApp
//
//  Created by Michael Avnyin on 2/21/16.
//  Copyright © 2016 Michael Avnyin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cityTF: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func searchSubmit(sender: AnyObject) {
        
        var wasSuccessful = false
        
        let attemptURL = NSURL(string: "http://www.weather-forecast.com/locations/"+cityTF.text!.stringByReplacingOccurrencesOfString(" ", withString: "-")+"/forecasts/latest")
        
        if let url = attemptURL {
       
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
           
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let webArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                if webArray!.count > 1 {
                    
                    let webArrayEnd = webArray![1].componentsSeparatedByString("</span>")
                    
                    
                    if webArrayEnd.count > 1 {
                    
                    wasSuccessful = true
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.resultLabel.textColor = UIColor(red: 82, green: 175, blue: 131, alpha: 0.90)
                        //self.resultLabel.backgroundColor = UIColor.blueColor()
                        self.resultLabel.shadowColor = UIColor.blackColor()
                        self.resultLabel.text = webArrayEnd[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    })
                    
                        
                    }
                }

            }
            if wasSuccessful == false {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.resultLabel.textColor = UIColor(red: 255, green: 165, blue: 0, alpha: 0.90)
                    self.resultLabel.shadowColor = UIColor.blackColor()
                    self.resultLabel.text = "No match found - you must enter a city"
                })
                
            }
        }
        task.resume()
        }
        else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.resultLabel.textColor = UIColor.redColor()
                
                self.resultLabel.shadowColor = UIColor.blackColor()
                self.resultLabel.text = "No match - please check the spelling of your city"
                
            })
        }
        
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}

