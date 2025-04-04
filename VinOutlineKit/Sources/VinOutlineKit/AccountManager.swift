//
//  AccountManager.swift
//  
//
//  Created by Maurice Parker on 11/6/20.
//

import Foundation
import OSLog

public extension Notification.Name {
	static let AccountManagerAccountsDidChange = Notification.Name(rawValue: "AccountManagerAccountsDidChange")
}

@MainActor
public final class AccountManager {
	
	public var localAccount: Account? {
		return accountsDictionary[AccountType.local.rawValue]
	}

	public var cloudKitAccount: Account? {
		return accountsDictionary[AccountType.cloudKit.rawValue]
	}

	public var isSyncAvailable: Bool {
		return cloudKitAccount?.cloudKitManager?.isSyncAvailable ?? false
	}
	
	public var accounts: [Account] {
		return accountsDictionary.values.map { $0 }
	}

	public var activeAccounts: [Account] {
		return Array(accountsDictionary.values.filter { $0.isActive })
	}

	public var sortedActiveAccounts: [Account] {
		return sort(activeAccounts)
	}
	
	public var activeTags: [Tag] {
		return activeAccounts.reduce(into: [Tag]()) { $0.append(contentsOf: $1.tags ?? [Tag]() ) }
	}
	
	public var documents: [Document] {
		return accounts.reduce(into: [Document]()) { $0.append(contentsOf: $1.documents ?? [Document]() ) }
	}
	
	public var activeDocuments: [Document] {
		return activeAccounts.reduce(into: [Document]()) { $0.append(contentsOf: $1.documents ?? [Document]() ) }
	}
	
	var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "VinOutlineKit")

	var accountsDictionary = [Int: Account]()

	var accountsFolder: URL
	var localAccountFolder: URL
	var localAccountFile: URL
	var cloudKitAccountFolder: URL
	var cloudKitAccountFile: URL
	
	weak var errorHandler: ErrorHandler?

	private var accountFiles = [Int: AccountFile]()
	
	public init(accountsFolderPath: String, errorHandler: ErrorHandler) {
		self.accountsFolder = URL(fileURLWithPath: accountsFolderPath, isDirectory: true)
		self.localAccountFolder = accountsFolder.appendingPathComponent(AccountType.local.folderName)
		self.localAccountFile = localAccountFolder.appendingPathComponent(AccountFile.filenameComponent)
		self.cloudKitAccountFolder = accountsFolder.appendingPathComponent(AccountType.cloudKit.folderName)
		self.cloudKitAccountFile = cloudKitAccountFolder.appendingPathComponent(AccountFile.filenameComponent)
		self.errorHandler = errorHandler
		
		NotificationCenter.default.addObserver(self, selector: #selector(accountMetadataDidChange(_:)), name: .AccountMetadataDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(accountTagsDidChange(_:)), name: .AccountTagsDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(accountDocumentsDidChange(_:)), name: .AccountDocumentsDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(documentTitleDidChange(_:)), name: .DocumentTitleDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(documentMetadataDidChange(_:)), name: .DocumentMetaDataDidChange, object: nil)

		// The local account must always exist, even if it's empty.
		if FileManager.default.fileExists(atPath: localAccountFile.path) {
			initializeFile(accountType: .local)
		} else {
			do {
				try FileManager.default.createDirectory(atPath: localAccountFolder.path, withIntermediateDirectories: true, attributes: nil)
			} catch {
				assertionFailure("Could not create folder for local account.")
				abort()
			}
			
			let localAccount = Account(accountManager: self, accountType: .local)
			accountsDictionary[AccountType.local.rawValue] = localAccount
			initializeFile(accountType: .local)
		}
		
		if FileManager.default.fileExists(atPath: cloudKitAccountFile.path) {
			initializeFile(accountType: .cloudKit)
		}
	}

	// MARK: API
	
	public func createCloudKitAccount() {
		do {
			try FileManager.default.createDirectory(atPath: cloudKitAccountFolder.path, withIntermediateDirectories: true, attributes: nil)
		} catch {
			assertionFailure("Could not create folder for CloudKit account.")
			abort()
		}
		
		let cloudKitAccount = Account(accountManager: self, accountType: .cloudKit)
		accountsDictionary[AccountType.cloudKit.rawValue] = cloudKitAccount
		initializeFile(accountType: .cloudKit)
		accountManagerAccountsDidChange()
		self.cloudKitAccount?.initializeCloudKit(errorHandler: errorHandler!)
		self.cloudKitAccount?.firstTimeCloudKitSetup()
	}
	
	public func deleteLocalAccount() {
		guard let localAccount else { return }
		
		// Send out all the document delete events for this account to clean up the search index
		localAccount.documents?.forEach { $0.documentDidDelete() }

		accountsDictionary[AccountType.local.rawValue] = nil
		accountFiles[AccountType.local.rawValue] = nil

		try? FileManager.default.removeItem(atPath: localAccountFolder.path)

		accountManagerAccountsDidChange()
	}
	
	public func deleteCloudKitAccount() {
		guard let cloudKitAccount else { return }
		
		// Send out all the document delete events for this account to clean up the search index
		cloudKitAccount.documents?.forEach { $0.documentDidDelete() }
		
		accountsDictionary[AccountType.cloudKit.rawValue] = nil
		accountFiles[AccountType.cloudKit.rawValue] = nil

		try? FileManager.default.removeItem(atPath: cloudKitAccountFolder.path)

		accountManagerAccountsDidChange()

		cloudKitAccount.cloudKitManager?.accountDidDelete(account: cloudKitAccount)
	}
	
	public func findAccount(accountType: AccountType) -> Account? {
		return accountsDictionary[accountType.rawValue]
	}

	public func findAccount(accountID: Int) -> Account? {
		guard let account = accountsDictionary[accountID] else { return nil }
		return account.isActive ? account : nil
	}
	
	public func findDocumentContainer(_ entityID: EntityID) -> DocumentContainer? {
		switch entityID {
		case .search(let searchText):
			return Search(accountManager: self, searchText: searchText)
		case .allDocuments(let accountID), .recentDocuments(let accountID), .tagDocuments(let accountID, _):
			return findAccount(accountID: accountID)?.findDocumentContainer(entityID)
		default:
			return nil
		}
	}
	
	public func findDocument(_ entityID: EntityID) -> Document? {
		switch entityID {
		case .document(let accountID, let documentUUID):
			return findAccount(accountID: accountID)?.findDocument(documentUUID: documentUUID)
		case .row(let accountID, let documentUUID, _):
			return findAccount(accountID: accountID)?.findDocument(documentUUID: documentUUID)
		default:
			return nil
		}
	}
	
	public func receiveRemoteNotification(userInfo: [AnyHashable : Any]) async {
		await cloudKitAccount?.cloudKitManager?.receiveRemoteNotification(userInfo: userInfo)
	}
	
	public func sync() async {
		await cloudKitAccount?.cloudKitManager?.sync()
	}
	
	public func resume() {
		accountFiles.values.forEach { $0.resume() }
		activeDocuments.forEach { $0.resume() }
	}
	
	public func suspend() async {
		for file in accountFiles.values {
			await file.saveIfNecessary()
			file.suspend()
		}

		for document in activeDocuments {
			await document.save()
			document.suspend()
		}
	}
	
}

// MARK: Helpers

private extension AccountManager {
	
	func accountManagerAccountsDidChange() {
		NotificationCenter.default.post(name: .AccountManagerAccountsDidChange, object: self, userInfo: nil)
	}

	// MARK: Notifications
	
	@objc func accountMetadataDidChange(_ note: Notification) {
		let account = note.object as! Account
		markAsDirty(account)
	}

	@objc func accountTagsDidChange(_ note: Notification) {
		let account = note.object as! Account
		markAsDirty(account)
	}

	@objc func accountDocumentsDidChange(_ note: Notification) {
		let account = note.object as! Account
		markAsDirty(account)
	}

	@objc func documentTitleDidChange(_ note: Notification) {
		guard let document = note.object as? Document, let account = document.account else { return }
		markAsDirty(account)
		
		if let outline = document.outline {
			account.fixAltLinks(excluding: outline)
		}

		account.disambiguate(document: document)
	}
	
	@objc func documentMetadataDidChange(_ note: Notification) {
		guard let account = (note.object as? Document)?.account else { return }
		markAsDirty(account)
	}

	func sort(_ accounts: [Account]) -> [Account] {
		return accounts.sorted { (account1, account2) -> Bool in
			if account1.type == .local {
				return true
			}
			if account2.type == .local {
				return false
			}
			return (account1.name as NSString).localizedStandardCompare(account2.name) == .orderedAscending
		}
	}
	
	func initializeFile(accountType: AccountType) {
		let file: URL
		if accountType == .local {
			file = localAccountFile
		} else {
			file = cloudKitAccountFile
		}
		
		let managedFile = AccountFile(fileURL: file, accountType: accountType, accountManager: self)
		managedFile.load()
		accountFiles[accountType.rawValue] = managedFile
	}

	func markAsDirty(_ account: Account) {
		guard let accountFile = accountFiles[account.type.rawValue] else { return }
		accountFile.markAsDirty()
	}
	
}
