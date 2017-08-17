//
//  ViewController.swift
//  ComparisionUI
//
//  Created by Sameer Poudel on 16/08/17.
//  Copyright © 2017 Data Health. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func compare(_ sender: UIButton){
        let compare = CompareViewController()
        self.present(compare, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
    }
    
    
}

