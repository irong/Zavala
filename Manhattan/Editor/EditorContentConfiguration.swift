//
//  EditorContentConfiguration.swift
//  Manhattan
//
//  Created by Maurice Parker on 11/17/20.
//

import UIKit

struct EditorContentConfiguration: UIContentConfiguration, Hashable {

	weak var delegate: EditorCollectionViewCellDelegate? = nil

	var editorItem: EditorItem
	var indentionLevel: Int
	var indentationWidth: CGFloat
	var isChevronShowing: Bool {
		return !editorItem.children.isEmpty
	}
	
	func makeContentView() -> UIView & UIContentView {
		return EditorContentView(configuration: self)
	}
	
	func updated(for state: UIConfigurationState) -> Self {
		return self
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(editorItem)
	}
	
	static func == (lhs: EditorContentConfiguration, rhs: EditorContentConfiguration) -> Bool {
		return lhs.editorItem == rhs.editorItem
	}
}
