//
//  ViewControllerToPresent.swift
//  curtainTest
//
//  Created by Dmytro on 8/9/16.
//  Copyright © 2016 Dmytro. All rights reserved.
//

import UIKit

class ViewControllerToPresent: UIViewController {
    
    @IBAction func dismissButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
