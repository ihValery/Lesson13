//
//  backgroundColorVC.swift
//  RGBColor
//
//  Created by Валерий Игнатьев on 15.02.2021.
//

import UIKit

protocol mySetColor {
    func setColor(color: UIColor)
}

class backgroundColorVC: UIViewController,mySetColor {
 
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let colorVC = segue.destination as! ViewController
        colorVC.colorMainVC = view.backgroundColor
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        let sourceVC = segue.source as! ViewController
        sourceVC.delegate = self
        sourceVC.setColor()
        // Use data from the view controller which initiated the unwind segue
    }
    
    func setColor(color: UIColor) {
        view.backgroundColor = color
    }
}
