//
//  CursorCoordinates.swift
//  Zavala
//
//  Created by Maurice Parker on 12/16/20.
//

import UIKit
import Templeton

extension CursorCoordinates {

	static var lastKnownCoordinates: CursorCoordinates?

	static var currentCoordinates: CursorCoordinates? {
		if let textView = UIResponder.currentFirstResponder as? OutlineTextView, let row = textView.headline {
			let isInNotes = textView is EditorHeadlineNoteTextView
			return CursorCoordinates(row: row, isInNotes: isInNotes, cursorPosition: textView.cursorPosition)
		}
		return nil
	}

	static var bestCoordinates: CursorCoordinates? {
		if let current = currentCoordinates {
			return current
		}
		return lastKnownCoordinates
	}
	
}
