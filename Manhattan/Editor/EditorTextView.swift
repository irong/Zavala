//
//  EditorTextView.swift
//  Manhattan
//
//  Created by Maurice Parker on 11/17/20.
//

import UIKit
import Templeton

protocol EditorTextViewDelegate: class {
	var undoManager: UndoManager? { get }
	func deleteHeadline(_: Headline)
	func createHeadline(_: Headline)
	func indentHeadline(_: Headline, attributedText: NSAttributedString)
	func outdentHeadline(_: Headline, attributedText: NSAttributedString)
	func splitHeadline(_: Headline, attributedText: NSAttributedString, cursorPosition: Int)
}

class EditorTextView: UITextView {
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		commonInit()
	}

	func commonInit() {
		textDropDelegate = self
		
		// These gesture recognizers will conflict with context menu preview dragging if not removed.
		gestureRecognizers?.forEach {
			if $0.name == "dragInitiation"
				|| $0.name == "dragExclusionRelationships"
				|| $0.name == "dragFailureRelationships"
				|| $0.name == "com.apple.UIKit.longPressClickDriverPrimary" {
				removeGestureRecognizer($0)
			}
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var undoManager: UndoManager? {
		guard let textViewUndoManager = super.undoManager, let controllerUndoManager = editorDelegate?.undoManager else { return nil }
		if stackedUndoManager == nil {
			stackedUndoManager = StackedUndoManger(mainUndoManager: textViewUndoManager, fallBackUndoManager: controllerUndoManager)
		}
		return stackedUndoManager
	}
	
	override var keyCommands: [UIKeyCommand]? {
		let keys = [
			UIKeyCommand(action: #selector(tabPressed(_:)), input: "\t"),
			UIKeyCommand(input: "\t", modifierFlags: [.shift], action: #selector(shiftTabPressed(_:))),
			UIKeyCommand(input: "\r", modifierFlags: [.alternate], action: #selector(optionReturnPressed(_:))),
			UIKeyCommand(input: "\r", modifierFlags: [.shift, .alternate], action: #selector(shiftOptionReturnPressed(_:)))
		]
		return keys
	}
	
	weak var editorDelegate: EditorTextViewDelegate?
	var headline: Headline?
	
	var isSelecting: Bool {
		return !(selectedTextRange?.isEmpty ?? true)
	}
	
	var cursorPosition: Int {
		return selectedRange.location
	}

	private var stackedUndoManager: UndoManager?

	override func deleteBackward() {
		guard let headline = headline else { return }
		if attributedText.length == 0 {
			editorDelegate?.deleteHeadline(headline)
		} else {
			super.deleteBackward()
		}
	}

	@objc func tabPressed(_ sender: Any) {
		guard let headline = headline else { return }
		editorDelegate?.indentHeadline(headline, attributedText: attributedText)
	}
	
	@objc func shiftTabPressed(_ sender: Any) {
		guard let headline = headline else { return }
		editorDelegate?.outdentHeadline(headline, attributedText: attributedText)
	}
	
	@objc func optionReturnPressed(_ sender: Any) {
		insertText("\n")
	}
	
	@objc func shiftOptionReturnPressed(_ sender: Any) {
		guard let headline = headline else { return }
		editorDelegate?.splitHeadline(headline, attributedText: attributedText, cursorPosition: cursorPosition)
	}
	
}

extension EditorTextView: UITextDropDelegate {
	
	// We dont' allow local text drops because regular dragging and dropping of Headlines was dropping Markdown into our text view
	func textDroppableView(_ textDroppableView: UIView & UITextDroppable, proposalForDrop drop: UITextDropRequest) -> UITextDropProposal {
		if drop.dropSession.localDragSession == nil {
			return UITextDropProposal(operation: .copy)
		} else {
			return UITextDropProposal(operation: .cancel)
		}
	}
	
}
