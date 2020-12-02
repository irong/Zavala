//
//  Headline.swift
//  
//
//  Created by Maurice Parker on 11/6/20.
//

import UIKit

public final class Headline: NSObject, NSCopying, HeadlineContainer, Identifiable, Codable {
	
	public weak var parent: Headline?
	public var shadowTableIndex: Int?

	public var isAncestorComplete: Bool {
		if let parent = parent {
			return parent.isComplete ?? false || parent.isAncestorComplete
		}
		return false
	}
	
	public var indentLevel: Int {
		var parentCount = 0
		var p = parent
		while p != nil {
			parentCount = parentCount + 1
			p = p?.parent
		}
		return parentCount
	}

	public var id: String
	public var text: Data?
	public var isExpanded: Bool?
	public var isComplete: Bool?
	public var headlines: [Headline]?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case text = "text"
		case isExpanded = "isExpanded"
		case isComplete = "isComplete"
		case headlines = "headlines"
	}

	public override init() {
		self.id = UUID().uuidString
		super.init()
		headlines = [Headline]()
	}
	
	public init(plainText: String) {
		self.id = UUID().uuidString
		super.init()

		var attributes = [NSAttributedString.Key: AnyObject]()
		attributes[.foregroundColor] = UIColor.label
		attributes[.font] = UIFont.preferredFont(forTextStyle: .body)
		attributedText = NSAttributedString(string: plainText, attributes: attributes)
											
		headlines = [Headline]()
	}
	
	public var plainText: String? {
		return attributedText?.string
	}
	
	public var attributedText: NSAttributedString? {
		get {
			guard let text = text else { return nil }
			return try? NSAttributedString(data: text,
										   options: [.documentType: NSAttributedString.DocumentType.rtf, .characterEncoding: String.Encoding.utf8.rawValue],
										   documentAttributes: nil)
		}
		set {
			if let attrText = newValue {
				text = try? attrText.data(from: .init(location: 0, length: attrText.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
			} else {
				text = nil
			}
		}
	}
	
	public override func isEqual(_ object: Any?) -> Bool {
		guard let other = object as? Headline else { return false }
		if self === other { return true }
		return id == other.id
	}
	
	public override var hash: Int {
		var hasher = Hasher()
		hasher.combine(id)
		return hasher.finalize()
	}
	
	public func copy(with zone: NSZone? = nil) -> Any {
		return self
	}
	
	func visit(visitor: (Headline) -> Void) {
		visitor(self)
	}
	
}

// MARK: CustomDebugStringConvertible

extension Headline {
	override public var debugDescription: String {
		return "\(plainText ?? "") (\(id))"
	}
}
