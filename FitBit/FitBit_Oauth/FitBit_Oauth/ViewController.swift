//
//  ViewController.swift
//  FitBit_Oauth
//
//  Created by Mahendra Yadav on 3/14/16.
//  Copyright © 2016 App Engineer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MSYFitBit.shareFitBit.fetchDataFromFitbit { (result, success) -> Void in
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

