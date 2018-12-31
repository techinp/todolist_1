//
//  Test1ViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/31/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit

class Test1ViewController: UIViewController {
    
    
    

    @IBOutlet weak var create_time: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func looktime_btn(_ sender: Any) {
        let date = Date()
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        let result = dateformatter.string(from: date)
        
        create_time.text = result
                
        print(result)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
