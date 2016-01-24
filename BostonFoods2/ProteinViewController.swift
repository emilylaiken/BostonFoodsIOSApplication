//
//  ChickenViewController
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit

class ProteinViewController: UIViewController {
    @IBOutlet weak var textBox: UITextView!
   
    //Sets up view and picker object upon loading of view
    override func viewDidLoad() {
        print("HEREEEE PROTEIN")
        super.viewDidLoad()
        //read in data from file into text box
        let path = "Users/emily/Desktop/Harvard/Fresh/CS50/FinalProj/Texts/protein.txt"
        do {
            let myText = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            textBox.text = myText as String
        }
        catch {
            print("Error loading data from text file, check that path is correct.")
        }
    }
    
}




