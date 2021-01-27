//
//  EntityID.swift
//  
//
//  Created by Maurice Parker on 11/10/20.
//

import Foundation

public enum EntityID: CustomStringConvertible, Hashable, Equatable, Codable {
	case search(String)
	case account(Int)
	case folder(Int, String) // Account, Folder
	case document(Int, String, String) // Account, Folder, Document

	private enum CodingKeys: String, CodingKey {
		case type
		case searchText
		case accountID
		case folderID
		case documentID
	}
	
	var isAccount: Bool {
		switch self {
		case .account(_):
			return true
		default:
			return false
		}
	}
	
	var isFolder: Bool {
		switch self {
		case .folder(_, _):
			return true
		default:
			return false
		}
	}
	
	var isDocument: Bool {
		switch self {
		case .document(_, _, _):
			return true
		default:
			return false
		}
	}
	
	var accountID: Int {
		switch self {
		case .account(let accountID):
			return accountID
		case .folder(let accountID, _):
			return accountID
		case .document(let accountID, _, _):
			return accountID
		default:
			fatalError()
		}
	}

	var folderUUID: String {
		switch self {
		case .folder(_, let folderID):
			return folderID
		case .document(_, let folderID, _):
			return folderID
		default:
			fatalError()
		}
	}
	
	var documentUUID: String {
		switch self {
		case .document(_, _, let documentID):
			return documentID
		default:
			fatalError()
		}
	}
	
	public var description: String {
		switch self {
		case .search(let searchText):
			return "search:\(searchText)"
		case .account(let id):
			return "account:\(id)"
		case .folder(let accountID, let folderID):
			return "folder:\(accountID)_\(folderID)"
		case .document(let accountID, let folderID, let documentID):
			return "document:\(accountID)_\(folderID)_\(documentID)"
		}
	}
	
	public init?(description: String) {
		if description.starts(with: "search:") {
			let searchText = description.suffix(from: description.index(description.startIndex, offsetBy: 7))
			self = .search(String(searchText))
			return
		} else if description.starts(with: "account:") {
			let idString = description.suffix(from: description.index(description.startIndex, offsetBy: 8))
			if let accountID = Int(idString) {
				self = .account(accountID)
				return
			}
		} else if description.starts(with: "folder:") {
			let idString = description.suffix(from: description.index(description.startIndex, offsetBy: 7))
			let ids = idString.split(separator: "_")
			if let accountID = Int(ids[0]) {
				self = .folder(accountID, String(ids[1]))
				return
			}
		} else if description.starts(with: "document:") {
			let idString = description.suffix(from: description.index(description.startIndex, offsetBy: 9))
			let ids = idString.split(separator: "_")
			if let accountID = Int(ids[0]) {
				self = .document(accountID, String(ids[1]), String(ids[2]))
				return
			}
		}
		return nil
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)
		
		switch type {
		case "search":
			let searchText = try container.decode(String.self, forKey: .searchText)
			self = .search(searchText)
		case "account":
			let accountID = try container.decode(Int.self, forKey: .accountID)
			self = .account(accountID)
		case "folder":
			let accountID = try container.decode(Int.self, forKey: .accountID)
			let folderID = try container.decode(String.self, forKey: .folderID)
			self = .folder(accountID, folderID)
		case "outline":
			let accountID = try container.decode(Int.self, forKey: .accountID)
			let folderID = try container.decode(String.self, forKey: .folderID)
			let documentID = try container.decode(String.self, forKey: .documentID)
			self = .document(accountID, folderID, documentID)
		default:
			fatalError()
		}
	}
	
	public init?(userInfo: [AnyHashable: AnyHashable]) {
		guard let type = userInfo["type"] as? String else { return nil }
		
		switch type {
		case "search":
			guard let searchText = userInfo["searchText"] as? String else { return nil }
			self = .search(searchText)
		case "account":
			guard let accountID = userInfo["accountID"] as? Int else { return nil }
			self = .account(accountID)
		case "folder":
			guard let accountID = userInfo["accountID"] as? Int else { return nil }
			guard let folderID = userInfo["folderID"] as? String else { return nil }
			self = .folder(accountID, folderID)
		case "outline":
			guard let accountID = userInfo["accountID"] as? Int else { return nil }
			guard let folderID = userInfo["folderID"] as? String else { return nil }
			guard let documentID = userInfo["documentID"] as? String else { return nil }
			self = .document(accountID, folderID, documentID)
		default:
			return nil
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		switch self {
		case .search(let searchText):
			try container.encode("search", forKey: .type)
			try container.encode(searchText, forKey: .searchText)
		case .account(let accountID):
			try container.encode("account", forKey: .type)
			try container.encode(accountID, forKey: .accountID)
		case .folder(let accountID, let folderID):
			try container.encode("folder", forKey: .type)
			try container.encode(accountID, forKey: .accountID)
			try container.encode(folderID, forKey: .folderID)
		case .document(let accountID, let folderID, let documentID):
			try container.encode("outline", forKey: .type)
			try container.encode(accountID, forKey: .accountID)
			try container.encode(folderID, forKey: .folderID)
			try container.encode(documentID, forKey: .documentID)
		}
	}
	
	public var userInfo: [AnyHashable: AnyHashable] {
		switch self {
		case .search(let searchText):
			return [
				"type": "search",
				"searchText": searchText
			]
		case .account(let accountID):
			return [
				"type": "account",
				"accountID": accountID
			]
		case .folder(let accountID, let folderID):
			return [
				"type": "folder",
				"accountID": accountID,
				"folderID": folderID
			]
		case .document(let accountID, let folderID, let documentID):
			return [
				"type": "outline",
				"accountID": accountID,
				"folderID": folderID,
				"documentID": documentID
			]
		}
	}
	

}
