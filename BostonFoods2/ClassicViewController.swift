//
//  ChickenViewController
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit


class ClassicViewController: UIViewController {

    @IBOutlet weak var textBox: UITextView!

    //Sets up view and picker object upon loading of view
    override func viewDidLoad() {
        print("HEREEE CLASSIC")
        super.viewDidLoad()
        var path = ""
        //read in data from file into text box
        if boxType == "classic" {
            path = "Users/emily/Desktop/Harvard/Fresh/CS50/FinalProj/Texts/classic.txt"
        }
        else if boxType == "protein" {
            path = "Users/emily/Desktop/Harvard/Fresh/CS50/FinalProj/Texts/protein.txt"
        }
        else {
            path = "Users/emily/Desktop/Harvard/Fresh/CS50/FinalProj/Texts/produce.txt"
        }
        do {
            let myText = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            textBox.text = myText as String
        }
        catch {
            print("Error loading data from text file, check that path is correct.")
        }
    }
    
}




