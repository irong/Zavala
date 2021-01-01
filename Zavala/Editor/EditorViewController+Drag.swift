//
//  EditorViewController+Drag.swift
//  Zavala
//
//  Created by Maurice Parker on 12/1/20.
//

import UIKit
import MobileCoreServices
import Templeton

extension EditorViewController: UICollectionViewDragDelegate {
	
	func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		guard indexPath.section == 1, let shadowTable = outline?.shadowTable else { return [] }
		
		var dragItems = [UIDragItem]()
		let row = shadowTable[indexPath.row]

		let itemProvider = NSItemProvider(row: row)
		let dragItem = UIDragItem(itemProvider: itemProvider)
		dragItem.localObject = row
	
		dragItem.previewProvider = { () -> UIDragPreview? in
			guard let cell = collectionView.cellForItem(at: indexPath) as? EditorTextRowViewCell else { return nil}
			return UIDragPreview(view: cell, parameters: EditorTextRowPreviewParameters(cell: cell, row: row.associatedRow))
		}
		
		dragItems.append(dragItem)
		
		return dragItems
	}
	
}
