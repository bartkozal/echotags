//
//  HomeViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!

    @IBAction internal func unwindToHomeViewController (sender: UIStoryboardSegue) {}

    @IBAction func toggleOverlayView(sender: UIButton) {
        overlayView.hidden = !overlayView.hidden
    }
}
