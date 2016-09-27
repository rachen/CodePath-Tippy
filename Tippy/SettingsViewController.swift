//
//  SettingsViewController.swift
//  Tippy
//
//  Created by Raymond Chen on 9/23/16.
//  Copyright © 2016 Raymond Chen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipPicker: UISegmentedControl!
    @IBOutlet weak var customTipAmount: UITextField!
    let defaults = NSUserDefaults.standardUserDefaults()

    
    override func viewWillAppear(animated: Bool) {
        if (animated) {
            self.view.alpha = 0
            UIView.animateWithDuration(0.5, animations: {
                self.view.alpha = 1
            })
        }
    }

    
    override func viewWillDisappear(animated: Bool) {
        if (animated) {
            UIView.animateWithDuration(1, animations: {
                self.view.alpha = 0
            })
        }
    }
    
    func insertCustomSegment() {
        defaultTipPicker.insertSegmentWithTitle(String(defaults.integerForKey("customTipAmount")) + "%", atIndex: 3, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertCustomSegment()
        let tipIndex = defaults.integerForKey("defaultPercentageIndex")
        defaultTipPicker.selectedSegmentIndex = tipIndex
        customTipAmount.text = String(defaults.integerForKey("customTipAmount"))
    }
    
    @IBAction func defaultTipValueChanged(sender: AnyObject) {
        let defaultPercentageIndex =  defaultTipPicker.selectedSegmentIndex
        defaults.setInteger(defaultPercentageIndex, forKey: "defaultPercentageIndex")
        defaults.synchronize()
        
    }
    
    @IBAction func customTipEdited(sender: AnyObject) {
        let customTip = Int(customTipAmount.text!) ?? 0
        defaults.setInteger(customTip, forKey: "customTipAmount")
        defaults.synchronize()
        if (defaultTipPicker.numberOfSegments == 4 && customTip != 0) {
            defaultTipPicker.setTitle(String(customTip) + "%", forSegmentAtIndex: 3)
            print("def tip picker set title")
        }
        else {
            if (customTip != 0) {
                defaultTipPicker.insertSegmentWithTitle(String(customTip) + "%", atIndex: 3, animated: true)
            }
        }
    }

}
