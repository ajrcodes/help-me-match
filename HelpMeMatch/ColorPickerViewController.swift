//
//  ColorPickerViewController.swift
//  HelpMeMatch
//
//  Created by Andrew Roberts on 6/27/16.
//  Copyright © 2016 ajrcodes. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, HSBColorPickerDelegate {
    
    //MARK: - Stored Properties
    
    let formatString = "HSB: %4.2f,%4.2f,%4.2f RGB: %4.2f,%4.2f,%4.2f"
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var currentColor: UIView!    
    @IBOutlet weak var colorPicker: HSBColorPicker!
    
    // MARK: - HSBColorPickerDelegate Functions
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        currentColor.backgroundColor = color
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
}
