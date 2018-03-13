//
//  ViewControllerToPresent.swift
//  curtainTest
//
//  Created by Dmytro on 8/9/16.
//  Copyright © 2016 Dmytro. All rights reserved.
//

import UIKit

class ViewControllerToPresent: UIViewController {
    
    @IBAction func dismissButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
