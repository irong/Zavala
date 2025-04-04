//
//  CollectionsSearchContentView.swift
//  Zavala
//
//  Created by Maurice Parker on 1/11/21.
//

import UIKit

class CollectionsSearchContentView: UIView, UIContentView {

	let searchTextField = UISearchTextField()
	
	var appliedConfiguration: CollectionsSearchContentConfiguration!
	
	init(configuration: CollectionsSearchContentConfiguration) {
		super.init(frame: .zero)
		
		searchTextField.delegate = self
		searchTextField.placeholder = .searchPlaceholder
		searchTextField.translatesAutoresizingMaskIntoConstraints = false
		searchTextField.autocorrectionType = .no
		searchTextField.focusGroupIdentifier = CollectionsViewController.focusGroupIdentifier
		addSubview(searchTextField)

		let heightConstraint = searchTextField.heightAnchor.constraint(equalToConstant: 28)
		heightConstraint.priority = .defaultHigh
		
		NSLayoutConstraint.activate([
			searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
			searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
			searchTextField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
			searchTextField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
			heightConstraint
		])
		
		searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)

		apply(configuration: configuration)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var configuration: UIContentConfiguration {
		get { appliedConfiguration }
		set {
			guard let newConfig = newValue as? CollectionsSearchContentConfiguration else { return }
			apply(configuration: newConfig)
		}
	}

	@objc func searchTextFieldDidChange(textField: UITextField) {
		appliedConfiguration.delegate?.collectionsSearchDidUpdate(searchText: textField.text)
	}
	
	private func apply(configuration: CollectionsSearchContentConfiguration) {
		guard appliedConfiguration != configuration else { return }
		appliedConfiguration = configuration
		searchTextField.text = configuration.searchText
	}
	
}

extension CollectionsSearchContentView: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.text == nil || textField.text!.isEmpty {
			appliedConfiguration.delegate?.collectionsSearchDidBecomeActive()
		}
	}
	
}
