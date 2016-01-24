//
//  ChickenViewController
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit

class ProduceViewController: UIViewController {
    @IBOutlet weak var textBox: UITextView!
    //Sets up view and picker object upon loading of view
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HERREEEEE PRODUCE")
        //read in data from file into text box
        let path = "http://theory.stanford.edu/~aiken/emily/protein.txt"
        do {
            let myText = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            textBox.text = myText as String
        }
        catch {
            print("Error loading data from text file, check that path is correct.")
        }
    }
    
}




