//
//  AboutViewController.swift
//  Zavala
//
//  Created by Maurice Parker on 3/12/23.
//

import UIKit
import SwiftUI

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		let aboutViewController = UIHostingController(rootView: AboutView())
		view.addChildAndPin(aboutViewController.view)
		addChild(aboutViewController)
    }

	override func viewDidAppear(_ animated: Bool) {
		#if targetEnvironment(macCatalyst)
		appDelegate.appKitPlugin?.configureShowAbout(view.window?.nsWindow)
		#endif
	}

}
