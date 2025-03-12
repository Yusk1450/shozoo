//
//  disConnectViewController.swift
//  shozoo
//
//  Created by ichinose-PC on 2025/02/21.
//

import Foundation
import UIKit

class disConnectViewController: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
    }
    @IBAction func ReConnectBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
