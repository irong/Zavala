//
//  EditorViewController+Drop.swift
//  Manhattan
//
//  Created by Maurice Parker on 12/1/20.
//

import UIKit
import Templeton

extension EditorViewController: UICollectionViewDropDelegate {
	
	func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
		return session.localDragSession != nil
	}
	
	func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
		if destinationIndexPath == nil || (destinationIndexPath?.section == 0 && destinationIndexPath?.row == 1) {
			return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
		}

		guard destinationIndexPath?.section ?? 0 != 0,
			  let headline = session.localDragSession?.localContext as? Headline,
			  let headlineShadowTableIndex = headline.shadowTableIndex,
			  let shadowTable = outline?.shadowTable,
			  let targetIndexPath = destinationIndexPath else {
			return UICollectionViewDropProposal(operation: .cancel)
		}
		
		var droppingInto = false
		if headlineShadowTableIndex > targetIndexPath.row {
			if let destCell = collectionView.cellForItem(at: targetIndexPath) {
				droppingInto = session.location(in: destCell).y >= destCell.bounds.height / 2
			}
		}
		if headlineShadowTableIndex < targetIndexPath.row {
			if let destCell = collectionView.cellForItem(at: targetIndexPath) {
				droppingInto = session.location(in: destCell).y <= destCell.bounds.height / 2
			}
		}

		if droppingInto {
			let dropInHeadline = shadowTable[targetIndexPath.row]
			if dropInHeadline == headline {
				return UICollectionViewDropProposal(operation: .cancel)
			}

			if dropInHeadline.isDecendent(headline) {
				return UICollectionViewDropProposal(operation: .forbidden)
			}
			
			return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
		}
		
		if let proposedParent = shadowTable[targetIndexPath.row].parent as? Headline {
			if proposedParent == headline {
				return UICollectionViewDropProposal(operation: .cancel)
			}
			
			if proposedParent.isDecendent(headline) {
				return UICollectionViewDropProposal(operation: .forbidden)
			}
		}
		
		return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
	}
	
	func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
		guard let dragItem = coordinator.items.first?.dragItem,
			  let headline = dragItem.localObject as? Headline,
			  let outline = outline,
			  let shadowTable = outline.shadowTable else { return }
		
		// Dropping into a Headline is easy peasy
		if coordinator.proposal.intent == .insertIntoDestinationIndexPath, let dropInIndexPath = coordinator.destinationIndexPath {
			runEditorMoveHeadlineCommand(headline: headline, toParent: shadowTable[dropInIndexPath.row], toChildIndex: 0)
			return
		}
		
		// Drop into the first entry in the Outline
		if coordinator.destinationIndexPath == IndexPath(row: 1, section: 0) {
			runEditorMoveHeadlineCommand(headline: headline, toParent: outline, toChildIndex: 0)
			return
		}
		
		// If we don't have a destination index, drop it at the back
		guard let targetIndexPath = coordinator.destinationIndexPath else {
			runEditorMoveHeadlineCommand(headline: headline, toParent: outline, toChildIndex: outline.headlines?.count ?? 0)
			return
		}

		// THis is where most of the sibling moves happen at
		let newSibling = shadowTable[targetIndexPath.row]
		guard let newParent = newSibling.parent, let newIndex = newParent.headlines?.firstIndex(of: newSibling) else { return }
		runEditorMoveHeadlineCommand(headline: headline, toParent: newParent, toChildIndex: newIndex)
	}
	
	
}

// MARK: Helpers

extension EditorViewController {
	
	private func runEditorMoveHeadlineCommand(headline: Headline, toParent: HeadlineContainer, toChildIndex: Int) {
		guard let undoManager = undoManager, let outline = outline else { return }

		let command = EditorMoveHeadlineCommand(undoManager: undoManager,
												delegate: self,
												outline: outline,
												headline: headline,
												toParent: toParent,
												toChildIndex: toChildIndex)
		
		runCommand(command)
	}
	
}
