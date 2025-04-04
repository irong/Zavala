//
//  ConsistentCollectionViewListCell.swift
//  Zavala
//
//  Created by Maurice Parker on 12/4/20.
//

import UIKit

class ConsistentCollectionViewListCell: UICollectionViewListCell {
	
	var insetBackground = false
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		super.updateConfiguration(using: state)
		
		guard var contentConfig = contentConfiguration as? UIListContentConfiguration else { return }

		if state.isSelected || state.isHighlighted {
			contentConfig.secondaryTextProperties.color = .lightGray
		} else {
			contentConfig.secondaryTextProperties.color = .tertiaryLabel
		}

		contentConfiguration = contentConfig
		
		var backgroundConfig = UIBackgroundConfiguration.listSidebarCell().updated(for: state)

		if state.traitCollection.userInterfaceIdiom == .mac {
			backgroundConfig.cornerRadius = 5
			
			if insetBackground {
				backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 2, leading: 9, bottom: 2, trailing: 9)
			}
			
			if !state.isSelected && !state.isHighlighted {
				backgroundConfig.backgroundColor = .clear
			}
		}
		
		backgroundConfiguration = backgroundConfig
	}
	
}
