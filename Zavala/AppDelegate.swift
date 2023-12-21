//
//  AppDelegate.swift
//  Zavala
//
//  Created by Maurice Parker on 11/5/20.
//

import UIKit
import Intents
import VinOutlineKit

var appDelegate: AppDelegate!

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	override var keyCommands: [UIKeyCommand]? {
		#if targetEnvironment(macCatalyst)
		return nil
		#else
		if #available(iOS 15.0, *) {
			return nil
		}
		
		var menuKeyCommands = [UIKeyCommand]()
		
		menuKeyCommands.append(showPreferences)
		menuKeyCommands.append(beginDocumentSearchCommand)
		menuKeyCommands.append(showOpenQuicklyCommand)
		
		if AccountManager.shared.isSyncAvailable {
			menuKeyCommands.append(syncCommand)
		}


		if !(mainCoordinator?.isOutlineFunctionsUnavailable ?? true) {
			menuKeyCommands.append(toggleFilterOnCommand)
			menuKeyCommands.append(beginInDocumentSearchCommand)
			menuKeyCommands.append(useSelectionForSearchCommand)
			menuKeyCommands.append(nextInDocumentSearchCommand)
			menuKeyCommands.append(previousInDocumentSearchCommand)
			menuKeyCommands.append(printDocsCommand)
			menuKeyCommands.append(printListsCommand)
			menuKeyCommands.append(outlineGetInfoCommand)
		}
		
		menuKeyCommands.append(newOutlineCommand)
		menuKeyCommands.append(importOPMLCommand)
		
		if !(mainCoordinator?.isOutlineFunctionsUnavailable ?? true) {
			menuKeyCommands.append(exportMarkdownListsCommand)
			menuKeyCommands.append(exportOPMLsCommand)
		}
		
		menuKeyCommands.append(newWindowCommand)
		menuKeyCommands.append(toggleSidebarCommand)
		
		menuKeyCommands.append(deleteCommand)

		if !(mainCoordinator?.isGoBackwardOneUnavailable ?? true) {
			menuKeyCommands.append(goBackwardOneCommand)
		}
		
		if !(mainCoordinator?.isGoForwardOneUnavailable ?? true) {
			menuKeyCommands.append(goForwardOneCommand)
		}
		
		if !(mainCoordinator?.isInsertImageUnavailable ?? true) {
			menuKeyCommands.append(insertImageCommand)
		}
		
		if !(mainCoordinator?.isLinkUnavailable ?? true) {
			menuKeyCommands.append(linkCommand)
		}
		
		if !(mainCoordinator?.isInsertRowUnavailable ?? true) {
			menuKeyCommands.append(insertRowCommand)
		}
		
		if !(mainCoordinator?.isCreateRowUnavailable ?? true) {
			menuKeyCommands.append(createRowCommand)
		}
		
		if !(mainCoordinator?.isDuplicateRowsUnavailable ?? true) {
			menuKeyCommands.append(duplicateRowsCommand)
		}
		
		if !(mainCoordinator?.isCreateRowInsideUnavailable ?? true) {
			menuKeyCommands.append(createRowInsideCommand)
		}
		
		if !(mainCoordinator?.isCreateRowOutsideUnavailable ?? true) {
			menuKeyCommands.append(createRowOutsideCommand)
		}
		
		if !(mainCoordinator?.isMoveRowsUpUnavailable ?? true) {
			menuKeyCommands.append(moveRowsUpCommand)
		}
		
		if !(mainCoordinator?.isMoveRowsDownUnavailable ?? true) {
			menuKeyCommands.append(moveRowsDownCommand)
		}
		
		if !(mainCoordinator?.isMoveRowsLeftUnavailable ?? true) {
			menuKeyCommands.append(moveRowsLeftCommand)
		}
		
		if !(mainCoordinator?.isMoveRowsRightUnavailable ?? true) {
			menuKeyCommands.append(moveRowsRightCommand)
		}
		
		if !(mainCoordinator?.isToggleRowCompleteUnavailable ?? true) {
			if mainCoordinator?.isCompleteRowsAvailable ?? false {
				menuKeyCommands.append(completeRowsCommand)
			} else {
				menuKeyCommands.append(uncompleteRowsCommand)
			}
		}
		
		if !(mainCoordinator?.isCreateRowNotesUnavailable ?? true) {
			menuKeyCommands.append(createRowNotesCommand)
		}

		if !(mainCoordinator?.isDeleteRowNotesUnavailable ?? true) {
			menuKeyCommands.append(deleteRowNotesCommand)
		}

		if !(mainCoordinator?.isSplitRowUnavailable ?? true) {
			menuKeyCommands.append(splitRowCommand)
		}

		if !(mainCoordinator?.isExpandAllInOutlineUnavailable ?? true) {
			menuKeyCommands.append(expandAllInOutlineCommand)
		}
		
		if !(mainCoordinator?.isCollapseAllInOutlineUnavailable ?? true) {
			menuKeyCommands.append(collapseAllInOutlineCommand)
		}

		if !(mainCoordinator?.isExpandAllUnavailable ?? true) {
			menuKeyCommands.append(expandAllCommand)
		}
		
		if !(mainCoordinator?.isCollapseAllUnavailable ?? true) {
			menuKeyCommands.append(collapseAllCommand)
		}
		
		if !(mainCoordinator?.isExpandUnavailable ?? true) {
			menuKeyCommands.append(expandCommand)
		}
		
		if !(mainCoordinator?.isCollapseUnavailable ?? true) {
			menuKeyCommands.append(collapseCommand)
		}
		
		if !(mainCoordinator?.isCollapseParentRowUnavailable ?? true) {
			menuKeyCommands.append(collapseParentRowCommand)
		}
		
		if !(mainCoordinator?.isDeleteCompletedRowsUnavailable ?? true) {
			menuKeyCommands.append(deleteCompletedRowsCommand)
		}

		return menuKeyCommands
		#endif
	}
		
	let showPreferences: UIKeyCommand = {
		let title: String
		if #available(iOS 16, *) {
			title = AppStringAssets.settingsEllipsisControlLabel
		} else {
			title = AppStringAssets.preferencesEllipsisControlLabel
		}
		
		return UIKeyCommand(title: title,
							action: #selector(showPreferences(_:)),
							input: ",",
							modifierFlags: [.command])
			
	}()
	
	let syncCommand = UIKeyCommand(title: AppStringAssets.syncControlLabel,
								   action: #selector(syncCommand(_:)),
								   input: "r",
								   modifierFlags: [.command])
	
	let exportOPMLsCommand = UIKeyCommand(title: AppStringAssets.exportOPMLEllipsisControlLabel,
										  action: #selector(exportOPMLsCommand(_:)),
										  input: "e",
										  modifierFlags: [.shift, .command])
	
	let exportPDFDocsCommand = UICommand(title: AppStringAssets.exportPDFDocEllipsisControlLabel, action: #selector(exportPDFDocsCommand(_:)))

	let exportPDFListsCommand = UICommand(title: AppStringAssets.exportPDFListEllipsisControlLabel, action: #selector(exportPDFListsCommand(_:)))

	let exportMarkdownDocsCommand = UICommand(title: AppStringAssets.exportMarkdownDocEllipsisControlLabel, action: #selector(exportMarkdownDocsCommand(_:)))
	
	let exportMarkdownListsCommand = UIKeyCommand(title: AppStringAssets.exportMarkdownListEllipsisControlLabel,
												  action: #selector(exportMarkdownListsCommand(_:)),
												  input: "e",
												  modifierFlags: [.control, .command])
	
	let importOPMLCommand = UIKeyCommand(title: AppStringAssets.importOPMLEllipsisControlLabel,
										 action: #selector(importOPMLCommand(_:)),
										 input: "i",
										 modifierFlags: [.shift, .command])
	
	let newWindowCommand = UIKeyCommand(title: AppStringAssets.newMainWindowControlLabel,
										action: #selector(newWindow(_:)),
										input: "n",
										modifierFlags: [.alternate, .command])
	
	let newOutlineCommand = UIKeyCommand(title: AppStringAssets.newOutlineControlLabel,
										 action: #selector(createOutlineCommand(_:)),
										 input: "n",
										 modifierFlags: [.command])
	
	let toggleSidebarCommand = UIKeyCommand(title: AppStringAssets.togglerSidebarControlLabel,
											action: #selector(toggleSidebarCommand(_:)),
											input: "s",
											modifierFlags: [.control, .command])
	
	let deleteCommand = UIKeyCommand(title: AppStringAssets.deleteControlLabel,
									 action: #selector(delete),
									 input: "\u{8}",
									 modifierFlags: [])
	
	let goBackwardOneCommand = UIKeyCommand(title: AppStringAssets.backControlLabel,
											action: #selector(goBackwardOneCommand(_:)),
											input: "[",
											modifierFlags: [.command])
	
	let goForwardOneCommand = UIKeyCommand(title: AppStringAssets.forwardControlLabel,
										   action: #selector(goForwardOneCommand(_:)),
										   input: "]",
										   modifierFlags: [.command])
	
	let insertRowCommand = UIKeyCommand(title: AppStringAssets.addRowAboveControlLabel,
										action: #selector(insertRowCommand(_:)),
										input: "\n",
										modifierFlags: [.shift])
	
	let createRowCommand = UIKeyCommand(title: AppStringAssets.addRowBelowControlLabel,
										action: #selector(createRowCommand(_:)),
										input: "\n",
										modifierFlags: [])
	
	let duplicateRowsCommand = UIKeyCommand(title: AppStringAssets.duplicateControlLabel,
											action: #selector(duplicateRowsCommand(_:)),
											input: "r",
											modifierFlags: [.command, .control])
	
	let createRowInsideCommand = UIKeyCommand(title: AppStringAssets.addRowInsideControlLabel,
											  action: #selector(createRowInsideCommand(_:)),
											  input: "}",
											  modifierFlags: [.command])
	
	let createRowOutsideCommand = UIKeyCommand(title: AppStringAssets.addRowOutsideControlLabel,
											   action: #selector(createRowOutsideCommand(_:)),
											   input: "{",
											   modifierFlags: [.command])
	
	let moveRowsUpCommand = UIKeyCommand(title: AppStringAssets.moveUpControlLabel,
										 action: #selector(moveRowsUpCommand(_:)),
										 input: UIKeyCommand.inputUpArrow,
										 modifierFlags: [.control, .command])
	
	let moveRowsDownCommand = UIKeyCommand(title: AppStringAssets.moveDownControlLabel,
										   action: #selector(moveRowsDownCommand(_:)),
										   input: UIKeyCommand.inputDownArrow,
										   modifierFlags: [.control, .command])
	
	let moveRowsLeftCommand = UIKeyCommand(title: AppStringAssets.moveLeftControlLabel,
										   action: #selector(moveRowsLeftCommand(_:)),
										   input: UIKeyCommand.inputLeftArrow,
										   modifierFlags: [.control, .command])
	
	let moveRowsRightCommand = UIKeyCommand(title: AppStringAssets.moveRightControlLabel,
											action: #selector(moveRowsRightCommand(_:)),
											input: UIKeyCommand.inputRightArrow,
											modifierFlags: [.control, .command])
	
	let toggleCompleteRowsCommand = UIKeyCommand(title: AppStringAssets.completeControlLabel,
												 action: #selector(toggleCompleteRowsCommand(_:)),
												 input: "\n",
												 modifierFlags: [.command])
	
	let completeRowsCommand = UIKeyCommand(title: AppStringAssets.completeControlLabel,
										   action: #selector(toggleCompleteRowsCommand(_:)),
										   input: "\n",
										   modifierFlags: [.command])
	
	let uncompleteRowsCommand = UIKeyCommand(title: AppStringAssets.uncompleteControlLabel,
											 action: #selector(toggleCompleteRowsCommand(_:)),
											 input: "\n",
											 modifierFlags: [.command])
	
	let createRowNotesCommand = UIKeyCommand(title: AppStringAssets.addNoteLevelControlLabel,
											 action: #selector(createRowNotesCommand(_:)),
											 input: "-",
											 modifierFlags: [.control])
	
	let deleteRowNotesCommand = UIKeyCommand(title: AppStringAssets.deleteNoteControlLabel,
											 action: #selector(deleteRowNotesCommand(_:)),
											 input: "-",
											 modifierFlags: [.control, .shift])
	
	let splitRowCommand = UIKeyCommand(title: AppStringAssets.splitRowControlLabel,
									   action: #selector(splitRowCommand(_:)),
									   input: "\n",
									   modifierFlags: [.shift, .alternate])
	
	let toggleBoldCommand = UIKeyCommand(title: AppStringAssets.boldControlLabel,
										 action: #selector(toggleBoldCommand(_:)),
										 input: "b",
										 modifierFlags: [.command])
	
	let toggleItalicsCommand = UIKeyCommand(title: AppStringAssets.italicControlLabel,
											action: #selector(toggleItalicsCommand(_:)),
											input: "i",
											modifierFlags: [.command])
	
	let insertImageCommand = UIKeyCommand(title: AppStringAssets.insertImageEllipsisControlLabel,
										  action: #selector(insertImageCommand(_:)),
										  input: "i",
										  modifierFlags: [.alternate, .command])
	
	let linkCommand = UIKeyCommand(title: AppStringAssets.linkEllipsisControlLabel,
								   action: #selector(linkCommand(_:)),
								   input: "k",
								   modifierFlags: [.command])
	
	let copyDocumentLinkCommand = UICommand(title: AppStringAssets.copyDocumentLinkControlLabel, action: #selector(copyDocumentLinkCommand(_:)))
	
	let toggleFilterOnCommand = UIKeyCommand(title: AppStringAssets.turnFilterOnControlLabel,
											 action: #selector(toggleFilterOnCommand(_:)),
											 input: "h",
											 modifierFlags: [.shift, .command])
	
	let toggleCompletedFilterCommand = UICommand(title: AppStringAssets.filterCompletedControlLabel, action: #selector(toggleCompletedFilterCommand(_:)))
	
	let toggleNotesFilterCommand = UICommand(title: AppStringAssets.filterNotesControlLabel, action: #selector(toggleNotesFilterCommand(_:)))
	
	let expandAllInOutlineCommand = UIKeyCommand(title: AppStringAssets.expandAllInOutlineControlLabel,
												 action: #selector(expandAllInOutlineCommand(_:)),
												 input: "9",
												 modifierFlags: [.control, .command])
	
	let collapseAllInOutlineCommand = UIKeyCommand(title: AppStringAssets.collapseAllInOutlineControlLabel,
												   action: #selector(collapseAllInOutlineCommand(_:)),
												   input: "0",
												   modifierFlags: [.control, .command])
	
	let expandAllCommand = UIKeyCommand(title: AppStringAssets.expandAllInRowControlLabel,
										action: #selector(expandAllCommand(_:)),
										input: "9",
										modifierFlags: [.alternate, .command])
	
	let collapseAllCommand = UIKeyCommand(title: AppStringAssets.collapseAllInRowControlLabel,
										  action: #selector(collapseAllCommand(_:)),
										  input: "0",
										  modifierFlags: [.alternate, .command])
	
	let expandCommand = UIKeyCommand(title: AppStringAssets.expandControlLabel,
									 action: #selector(expandCommand(_:)),
									 input: "9",
									 modifierFlags: [.command])
	
	let collapseCommand = UIKeyCommand(title: AppStringAssets.collapseControlLabel,
									   action: #selector(collapseCommand(_:)),
									   input: "0",
									   modifierFlags: [.command])
	
	let collapseParentRowCommand = UIKeyCommand(title: AppStringAssets.collapseParentRowControlLabel,
												action: #selector(collapseParentRowCommand(_:)),
												input: "0",
												modifierFlags: [.control, .alternate, .command])
	
	let deleteCompletedRowsCommand = UIKeyCommand(title: AppStringAssets.deleteCompletedRowsControlLabel,
									   action: #selector(deleteCompletedRowsCommand(_:)),
									   input: "d",
									   modifierFlags: [.command])
	
	let showHelpCommand = UICommand(title: AppStringAssets.zavalaHelpControlLabel, action: #selector(showHelpCommand(_:)))

	let reportAnIssueCommand = UICommand(title: AppStringAssets.reportAnIssueControlLabel, action: #selector(reportAnIssueCommand(_:)))

	let showOpenQuicklyCommand = UIKeyCommand(title: AppStringAssets.openQuicklyEllipsisControlLabel,
											  action: #selector(showOpenQuicklyCommand(_:)),
											  input: "o",
											  modifierFlags: [.shift, .command])
	
	let beginDocumentSearchCommand = UIKeyCommand(title: AppStringAssets.documentFindEllipsisControlLabel,
												  action: #selector(beginDocumentSearchCommand(_:)),
												  input: "f",
												  modifierFlags: [.alternate, .command])
	
	let beginInDocumentSearchCommand = UIKeyCommand(title: AppStringAssets.findEllipsisControlLabel,
													action: #selector(beginInDocumentSearchCommand(_:)),
													input: "f",
													modifierFlags: [.command])
	
	let useSelectionForSearchCommand = UIKeyCommand(title: AppStringAssets.useSelectionForFindControlLabel,
													action: #selector(useSelectionForSearchCommand(_:)),
													input: "e",
													modifierFlags: [.command])
	
	let nextInDocumentSearchCommand = UIKeyCommand(title: AppStringAssets.findNextControlLabel,
												   action: #selector(nextInDocumentSearchCommand(_:)),
												   input: "g",
												   modifierFlags: [.command])
	
	let previousInDocumentSearchCommand = UIKeyCommand(title: AppStringAssets.findPreviousControlLabel,
													   action: #selector(previousInDocumentSearchCommand(_:)),
													   input: "g",
													   modifierFlags: [.shift, .command])
	
	let printDocsCommand = UIKeyCommand(title: AppStringAssets.printDocEllipsisControlLabel,
										action: #selector(printDocsCommand(_:)),
										input: "p",
										modifierFlags: [.alternate, .command])
	
	let printListsCommand = UIKeyCommand(title: AppStringAssets.printListControlEllipsisLabel,
										 action: #selector(printListsCommand(_:)),
										 input: "p",
										 modifierFlags: [.command])

	// Currently unused because it automatically adds Services menus to my other context menus
	let shareCommand = UICommand(title: AppStringAssets.shareControlLabel,
								 action: #selector(share(_:)),
								 propertyList: UICommandTagShare)

	let collaborateCommand = UICommand(title: AppStringAssets.collaborateEllipsisControlLabel, action: #selector(collaborateCommand(_:)))

	let outlineGetInfoCommand = UIKeyCommand(title: AppStringAssets.getInfoControlLabel,
											 action: #selector(outlineGetInfoCommand(_:)),
											 input: "i",
											 modifierFlags: [.control, .command])

	var mainCoordinator: MainCoordinator? {
		return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? MainCoordinator
	}
	
	private var history = [Pin]()
	private var documentIndexer: DocumentIndexer?
	
	#if targetEnvironment(macCatalyst)
	var appKitPlugin: AppKitPlugin?
	#endif

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		appDelegate = self

		let oldDocumentAccountURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let oldDocumentAccountsFolder = oldDocumentAccountURL.appendingPathComponent("Accounts").absoluteString

		let oldDocumentAccountsFolderPath = String(oldDocumentAccountsFolder.suffix(from: oldDocumentAccountsFolder.index(oldDocumentAccountsFolder.startIndex, offsetBy: 7)))
		
		let appGroup = Bundle.main.object(forInfoDictionaryKey: "AppGroup") as! String
		let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
		let documentAccountsFolderPath = containerURL!.appendingPathComponent("Accounts").path
		
		// Migrate test users to the Mac App Store version
		if FileManager.default.fileExists(atPath: oldDocumentAccountsFolderPath) && !FileManager.default.fileExists(atPath: documentAccountsFolderPath) {
			try? FileManager.default.moveItem(atPath: oldDocumentAccountsFolderPath, toPath: documentAccountsFolderPath)
		}
		
		AccountManager.shared = AccountManager(accountsFolderPath: documentAccountsFolderPath, errorHandler: self)
		let _ = OutlineFontCache.shared
		
		MetadataViewManager.provider = MetadataViewProvider()
		
		return true
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		AppDefaults.registerDefaults()

		NotificationCenter.default.addObserver(self, selector: #selector(checkForUserDefaultsChanges), name: UserDefaults.didChangeNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(pinWasVisited), name: .PinWasVisited, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(accountDocumentsDidChange), name: .AccountDocumentsDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(accountManagerAccountsDidChange), name: .AccountManagerAccountsDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(accountMetadataDidChange), name: .AccountMetadataDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(documentTitleDidChange), name: .DocumentTitleDidChange, object: nil)

		var menuItems = [UIMenuItem]()
		menuItems.append(UIMenuItem(title: AppStringAssets.linkControlLabel, action: .editLink))
		menuItems.append(UIMenuItem(title: AppStringAssets.imageControlLabel, action: .insertImage))
		menuItems.append(UIMenuItem(title: AppStringAssets.splitRowControlLabel, action: .splitRow))
		UIMenuController.shared.menuItems = menuItems

		#if targetEnvironment(macCatalyst)
		guard let pluginPath = (Bundle.main.builtInPlugInsPath as NSString?)?.appendingPathComponent("AppKitPlugin.bundle"),
			  let bundle = Bundle(path: pluginPath),
			  let cls = bundle.principalClass as? NSObject.Type,
			  let appKitPlugin = cls.init() as? AppKitPlugin else { return true }
		
		self.appKitPlugin = appKitPlugin
		appKitPlugin.setDelegate(self)
		appKitPlugin.start()
		#endif
		
		UIApplication.shared.registerForRemoteNotifications()
		NSUbiquitousKeyValueStore.default.synchronize()
		
		documentIndexer = DocumentIndexer()
		
		return true
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		DispatchQueue.main.async {
			if UIApplication.shared.applicationState == .background {
				AccountManager.shared.resume()
			}
			AccountManager.shared.receiveRemoteNotification(userInfo: userInfo) {
				if UIApplication.shared.applicationState == .background {
					AccountManager.shared.suspend()
				}
				completionHandler(.newData)
			}
		}
	}
	
	func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
		switch intent {
		case is AddOutlineIntent:
			return AddOutlineIntentHandler()
		case is AddOutlineTagIntent:
			return AddOutlineTagIntentHandler()
		case is AddRowsIntent:
			return AddRowsIntentHandler()
		case is CopyRowsIntent:
			return CopyRowsIntentHandler()
		case is EditOutlineIntent:
			return EditOutlineIntentHandler()
		case is EditRowsIntent:
			return EditRowsIntentHandler()
		case is ExportIntent:
			return ExportIntentHandler()
		case is GetCurrentOutlineIntent:
			return GetCurrentOutlineIntentHandler(mainCoordinator: mainCoordinator)
		case is GetCurrentTagsIntent:
			return GetCurrentTagsIntentHandler(mainCoordinator: mainCoordinator)
		case is GetImagesForOutlineIntent:
			return GetImagesForOutlineIntentHandler()
		case is GetOutlinesIntent:
			return GetOutlinesIntentHandler()
		case is GetRowsIntent:
			return GetRowsIntentHandler()
		case is ImportIntent:
			return ImportIntentHandler()
		case is MoveRowsIntent:
			return MoveRowsIntentHandler()
		case is RemoveOutlineIntent:
			return RemoveOutlineIntentHandler()
		case is RemoveOutlineTagIntent:
			return RemoveOutlineTagIntentHandler()
		case is RemoveRowsIntent:
			return RemoveRowsIntentHandler()
		case is ShowOutlineIntent:
			return ShowOutlineIntentHandler(mainCoordinator: mainCoordinator)
		default:
			fatalError("Unhandled intent type: \(intent)")
		}
	}
	
	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		switch options.userActivities.first?.activityType {
		case NSUserActivity.ActivityType.openEditor, NSUserActivity.ActivityType.newOutline:
			return UISceneConfiguration(name: "Outline Editor Configuration", sessionRole: connectingSceneSession.role)
		case NSUserActivity.ActivityType.openQuickly:
			return UISceneConfiguration(name: "Open Quickly Configuration", sessionRole: connectingSceneSession.role)
		case NSUserActivity.ActivityType.viewImage:
			return UISceneConfiguration(name: "Image Configuration", sessionRole: connectingSceneSession.role)
		case NSUserActivity.ActivityType.showAbout:
			return UISceneConfiguration(name: "About Configuration", sessionRole: connectingSceneSession.role)
		default:
			guard options.userActivities.first?.userInfo == nil else {
				return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
			}
			guard AppDefaults.shared.lastMainWindowWasClosed else {
				return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
			}
			if AppDefaults.shared.enableMainWindowAsDefault {
				return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
			} else {
				return UISceneConfiguration(name: "Open Quickly Configuration", sessionRole: connectingSceneSession.role)
			}
		}
	}

	// MARK: Actions

	@objc func showPreferences(_ sender: Any?) {
		#if targetEnvironment(macCatalyst)
		appKitPlugin?.showPreferences()
		#else
		mainCoordinator?.showSettings()
		#endif
	}

	@objc func syncCommand(_ sender: Any?) {
		AccountManager.shared.sync()
	}

	@objc func importOPMLCommand(_ sender: Any?) {
		if let mainSplitViewController = mainCoordinator as? MainSplitViewController {
			mainSplitViewController.importOPML()
		} else {
			#if targetEnvironment(macCatalyst)
			appKitPlugin?.importOPML()
			#endif
		}
	}

	@objc func exportPDFDocsCommand(_ sender: Any?) {
		mainCoordinator?.exportPDFDocs()
	}

	@objc func exportPDFListsCommand(_ sender: Any?) {
		mainCoordinator?.exportPDFLists()
	}

	@objc func exportMarkdownDocsCommand(_ sender: Any?) {
		mainCoordinator?.exportMarkdownDocs()
	}

	@objc func exportMarkdownListsCommand(_ sender: Any?) {
		mainCoordinator?.exportMarkdownLists()
	}

	@objc func exportOPMLsCommand(_ sender: Any?) {
		mainCoordinator?.exportOPMLs()
	}

	@objc func newWindow(_ sender: Any?) {
		let userActivity = NSUserActivity(activityType: NSUserActivity.ActivityType.newWindow)
		UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
	}
	
	@objc func createOutlineCommand(_ sender: Any?) {
		if let mainSplitViewController = mainCoordinator as? MainSplitViewController {
			mainSplitViewController.createOutline()
		} else {
			let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.newOutline)
			UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
		}
	}
	
	@objc func toggleSidebarCommand(_ sender: Any?) {
		if let mainSplitViewController = mainCoordinator as? MainSplitViewController {
			mainSplitViewController.toggleSidebar()
		}
	}
	
	@objc func goBackwardOneCommand(_ sender: Any?) {
		mainCoordinator?.goBackwardOne()
	}
	
	@objc func goForwardOneCommand(_ sender: Any?) {
		mainCoordinator?.goForwardOne()
	}
	
	@objc func insertRowCommand(_ sender: Any?) {
		mainCoordinator?.insertRow()
	}
	
	@objc func createRowCommand(_ sender: Any?) {
		mainCoordinator?.createRow()
	}
	
	@objc func duplicateRowsCommand(_ sender: Any?) {
		mainCoordinator?.duplicateRows()
	}
	
	@objc func createRowInsideCommand(_ sender: Any?) {
		mainCoordinator?.createRowInside()
	}
	
	@objc func createRowOutsideCommand(_ sender: Any?) {
		mainCoordinator?.createRowOutside()
	}
	

	@objc func moveRowsUpCommand(_ sender: Any?) {
		mainCoordinator?.moveRowsUp()
	}
	
	@objc func moveRowsDownCommand(_ sender: Any?) {
		mainCoordinator?.moveRowsDown()
	}
	
	@objc func moveRowsLeftCommand(_ sender: Any?) {
		mainCoordinator?.moveRowsLeft()
	}
	
	@objc func moveRowsRightCommand(_ sender: Any?) {
		mainCoordinator?.moveRowsRight()
	}
	
	@objc func toggleCompleteRowsCommand(_ sender: Any?) {
		mainCoordinator?.toggleCompleteRows()
	}
	
	@objc func createRowNotesCommand(_ sender: Any?) {
		mainCoordinator?.createRowNotes()
	}
	
	@objc func deleteRowNotesCommand(_ sender: Any?) {
		mainCoordinator?.deleteRowNotes()
	}
	
	@objc func splitRowCommand(_ sender: Any?) {
		mainCoordinator?.splitRow()
	}
	
	@objc func toggleBoldCommand(_ sender: Any?) {
		mainCoordinator?.outlineToggleBoldface()
	}
	
	@objc func toggleItalicsCommand(_ sender: Any?) {
		mainCoordinator?.outlineToggleItalics()
	}
	
	@objc func insertImageCommand(_ sender: Any?) {
		mainCoordinator?.insertImage()
	}

	@objc func linkCommand(_ sender: Any?) {
		mainCoordinator?.link()
	}

	@objc func copyDocumentLinkCommand(_ sender: Any?) {
		mainCoordinator?.copyDocumentLink()
	}

	@objc func toggleFilterOnCommand(_ sender: Any?) {
		mainCoordinator?.toggleFilterOn()
	}

	@objc func toggleCompletedFilterCommand(_ sender: Any?) {
		mainCoordinator?.toggleCompletedFilter()
	}

	@objc func toggleNotesFilterCommand(_ sender: Any?) {
		mainCoordinator?.toggleNotesFilter()
	}

	@objc func expandAllInOutlineCommand(_ sender: Any?) {
		mainCoordinator?.expandAllInOutline()
	}

	@objc func collapseAllInOutlineCommand(_ sender: Any?) {
		mainCoordinator?.collapseAllInOutline()
	}

	@objc func expandAllCommand(_ sender: Any?) {
		mainCoordinator?.expandAll()
	}

	@objc func collapseAllCommand(_ sender: Any?) {
		mainCoordinator?.collapseAll()
	}

	@objc func expandCommand(_ sender: Any?) {
		mainCoordinator?.expand()
	}

	@objc func collapseCommand(_ sender: Any?) {
		mainCoordinator?.collapse()
	}
	
	@objc func collapseParentRowCommand(_ sender: Any?) {
		mainCoordinator?.collapseParentRow()
	}
	
	@objc func deleteCompletedRowsCommand(_ sender: Any?) {
		mainCoordinator?.deleteCompletedRows()
	}
	
	@objc func showHelpCommand(_ sender: Any?) {
		mainCoordinator?.openURL(AppStringAssets.helpURL)
	}

	@objc func reportAnIssueCommand(_ sender: Any?) {
		UIApplication.shared.open(URL(string: AppStringAssets.reportAnIssueURL)!)
	}

	@objc func showOpenQuicklyCommand(_ sender: Any?) {
		if let mainSplitViewController = mainCoordinator as? MainSplitViewController {
			mainSplitViewController.showOpenQuickly()
		} else {
			let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.openQuickly)
			UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
		}
	}

	@objc func showAbout(_ sender: Any?) {
		let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.showAbout)
		UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
	}

	@objc func printDocsCommand(_ sender: Any?) {
		mainCoordinator?.printDocs()
	}

	@objc func printListsCommand(_ sender: Any?) {
		mainCoordinator?.printLists()
	}

	@objc func share(_ sender: Any?) {
		mainCoordinator?.share()
	}

	@objc func collaborateCommand(_ sender: Any?) {
		mainCoordinator?.collaborate()
	}

	@objc func beginDocumentSearchCommand(_ sender: Any?) {
		if let mainSplitViewController = mainCoordinator as? MainSplitViewController {
			mainSplitViewController.beginDocumentSearch()
		}
	}

	@objc func beginInDocumentSearchCommand(_ sender: Any?) {
		mainCoordinator?.beginInDocumentSearch()
	}

	@objc func useSelectionForSearchCommand(_ sender: Any?) {
		mainCoordinator?.useSelectionForSearch()
	}

	@objc func nextInDocumentSearchCommand(_ sender: Any?) {
		mainCoordinator?.nextInDocumentSearch()
	}

	@objc func previousInDocumentSearchCommand(_ sender: Any?) {
		mainCoordinator?.previousInDocumentSearch()
	}
	
	@objc func outlineGetInfoCommand(_ sender: Any?) {
		mainCoordinator?.showGetInfo()
	}
	
	// MARK: Validations
	
	override func validate(_ command: UICommand) {
		switch command.action {
		case #selector(toggleSidebarCommand(_:)):
			if !(mainCoordinator is MainSplitViewController) {
				command.attributes = .disabled
			}
		case #selector(beginDocumentSearchCommand(_:)):
			if !(mainCoordinator is MainSplitViewController) {
				command.attributes = .disabled
			}
		case #selector(syncCommand(_:)):
			if !AccountManager.shared.isSyncAvailable {
				command.attributes = .disabled
			}
		case #selector(outlineGetInfoCommand(_:)):
			if mainCoordinator?.isOutlineFunctionsUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(exportPDFDocsCommand(_:)),
			#selector(exportPDFListsCommand(_:)),
			#selector(exportMarkdownDocsCommand(_:)),
			#selector(exportMarkdownListsCommand(_:)),
			#selector(exportOPMLsCommand(_:)),
			#selector(printDocsCommand(_:)),
			#selector(printListsCommand(_:)):
			if mainCoordinator?.isExportAndPrintUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(goBackwardOneCommand(_:)):
			if mainCoordinator?.isGoBackwardOneUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(goForwardOneCommand(_:)):
			if mainCoordinator?.isGoForwardOneUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(insertRowCommand(_:)):
			if mainCoordinator?.isInsertRowUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(createRowCommand(_:)):
			if mainCoordinator?.isCreateRowUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(duplicateRowsCommand(_:)):
			if mainCoordinator?.isDuplicateRowsUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(createRowInsideCommand(_:)):
			if mainCoordinator?.isCreateRowInsideUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(createRowOutsideCommand(_:)):
			if mainCoordinator?.isCreateRowOutsideUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(moveRowsUpCommand(_:)):
			if mainCoordinator?.isMoveRowsUpUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(moveRowsDownCommand(_:)):
			if mainCoordinator?.isMoveRowsDownUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(moveRowsLeftCommand(_:)):
			if mainCoordinator?.isMoveRowsLeftUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(moveRowsRightCommand(_:)):
			if mainCoordinator?.isMoveRowsRightUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(toggleCompleteRowsCommand(_:)):
			if mainCoordinator?.isCompleteRowsAvailable ?? false {
				command.title = AppStringAssets.completeControlLabel
			} else {
				command.title = AppStringAssets.uncompleteControlLabel
			}
			if mainCoordinator?.isToggleRowCompleteUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(createRowNotesCommand(_:)):
			if mainCoordinator?.isCreateRowNotesUnavailable ?? true  {
				command.attributes = .disabled
			}
		case #selector(deleteRowNotesCommand(_:)):
			if mainCoordinator?.isDeleteRowNotesUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(splitRowCommand(_:)):
			if mainCoordinator?.isSplitRowUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(toggleBoldCommand(_:)), #selector(toggleItalicsCommand(_:)):
			if mainCoordinator?.isFormatUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(insertImageCommand(_:)):
			if mainCoordinator?.isInsertImageUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(linkCommand(_:)):
			if mainCoordinator?.isLinkUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(toggleFilterOnCommand(_:)):
			if mainCoordinator?.isFilterOn ?? false {
				command.title = AppStringAssets.turnFilterOffControlLabel
			} else {
				command.title = AppStringAssets.turnFilterOnControlLabel
			}
		case #selector(toggleCompletedFilterCommand(_:)):
			if mainCoordinator?.isCompletedFiltered ?? false {
				command.state = .on
			} else {
				command.state = .off
			}
			if !(mainCoordinator?.isFilterOn ?? false) {
				command.attributes = .disabled
			}
		case #selector(toggleNotesFilterCommand(_:)):
			if mainCoordinator?.isNotesFiltered ?? false {
				command.state = .on
			} else {
				command.state = .off
			}
			if !(mainCoordinator?.isFilterOn ?? false) {
				command.attributes = .disabled
			}
		case #selector(expandAllInOutlineCommand(_:)):
			if mainCoordinator?.isExpandAllInOutlineUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(collapseAllInOutlineCommand(_:)):
			if mainCoordinator?.isCollapseAllInOutlineUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(expandAllCommand(_:)):
			if mainCoordinator?.isExpandAllUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(collapseAllCommand(_:)):
			if mainCoordinator?.isCollapseAllUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(expandCommand(_:)):
			if mainCoordinator?.isExpandUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(collapseCommand(_:)):
			if mainCoordinator?.isCollapseUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(collapseParentRowCommand(_:)):
			if mainCoordinator?.isCollapseParentRowUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(deleteCompletedRowsCommand(_:)):
			if mainCoordinator?.isDeleteCompletedRowsUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(collaborateCommand(_:)):
			if mainCoordinator?.isCollaborateUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(beginInDocumentSearchCommand(_:)),
			#selector(useSelectionForSearchCommand(_:)),
			#selector(nextInDocumentSearchCommand(_:)),
			#selector(previousInDocumentSearchCommand(_:)),
			#selector(copyDocumentLinkCommand(_:)):
			if mainCoordinator?.isOutlineFunctionsUnavailable ?? true {
				command.attributes = .disabled
			}
		default:
			break
		}
	}
		
	// MARK: Menu

	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)

		guard builder.system == UIMenuSystem.main else { return }

		// Application Menu
		let appMenu = UIMenu(title: "", options: .displayInline, children: [showPreferences])
		builder.insertSibling(appMenu, afterMenu: .about)

		let aboutMenuTitle = builder.menu(for: .about)?.children.first?.title ?? "About Zavala"
		let showAboutCommand = UICommand(title: aboutMenuTitle, action: #selector(showAbout(_:)))
		builder.replace(menu: .about, with: UIMenu(options: .displayInline, children: [showAboutCommand]))
		
		// File Menu
		builder.remove(menu: .newScene)
		builder.remove(menu: .openRecent)

		let cloudKitMenu = UIMenu(title: "", options: .displayInline, children: [collaborateCommand, syncCommand])
		builder.insertChild(cloudKitMenu, atStartOfMenu: .file)

		let exportMenu = UIMenu(title: AppStringAssets.exportControlLabel, children: [exportPDFDocsCommand, exportPDFListsCommand, exportMarkdownDocsCommand, exportMarkdownListsCommand, exportOPMLsCommand])
		let importExportMenu = UIMenu(title: "", options: .displayInline, children: [importOPMLCommand, exportMenu])
		builder.insertChild(importExportMenu, atStartOfMenu: .file)

		let newMenu = UIMenu(title: "", options: .displayInline, children: [newOutlineCommand, newWindowCommand, showOpenQuicklyCommand])
		builder.insertChild(newMenu, atStartOfMenu: .file)

		let printMenu = UIMenu(title: "", options: .displayInline, children: [printDocsCommand, printListsCommand])
		builder.insertChild(printMenu, atEndOfMenu: .file)

		let getInfoMenu = UIMenu(title: "", options: .displayInline, children: [outlineGetInfoCommand])
		builder.insertChild(getInfoMenu, atEndOfMenu: .file)

		// Edit
		builder.replaceChildren(ofMenu: .standardEdit) { oldElements in
			var newElements = [UIMenuElement]()
			for oldElement in oldElements {
				if let oldCommand = oldElement as? UICommand, oldCommand.action == #selector(delete) {
					newElements.append(deleteCommand)
				} else {
					newElements.append(oldElement)
				}
			}
			return newElements
		}
		
		let linkMenu = UIMenu(title: "", options: .displayInline, children: [insertImageCommand, linkCommand, copyDocumentLinkCommand])
		builder.insertSibling(linkMenu, afterMenu: .standardEdit)

		builder.remove(menu: .find)
		
		let documentFindMenu = UIMenu(title: "", options: .displayInline, children: [beginDocumentSearchCommand])
		let inDocumentFindMenu = UIMenu(title: "", options: .displayInline, children: [beginInDocumentSearchCommand, nextInDocumentSearchCommand, previousInDocumentSearchCommand])
		let useSelectionMenu = UIMenu(title: "", options: .displayInline, children: [useSelectionForSearchCommand])
		let findMenu = UIMenu(title: AppStringAssets.findControlLabel, children: [documentFindMenu, inDocumentFindMenu, useSelectionMenu])
		builder.insertSibling(findMenu, beforeMenu: .spelling)
		
		// Format
		builder.remove(menu: .format)
		let formatMenu = UIMenu(title: AppStringAssets.formatControlLabel, children: [toggleBoldCommand, toggleItalicsCommand])
		builder.insertSibling(formatMenu, afterMenu: .edit)

		// View Menu
		let expandCollapseMenu = UIMenu(title: "",
										options: .displayInline,
										children: [expandAllInOutlineCommand, expandAllCommand, expandCommand, collapseAllInOutlineCommand, collapseAllCommand, collapseCommand, collapseParentRowCommand])
		builder.insertChild(expandCollapseMenu, atStartOfMenu: .view)
		let toggleFilterOutlineMenu = UIMenu(title: "", options: .displayInline, children: [toggleFilterOnCommand, toggleCompletedFilterCommand, toggleNotesFilterCommand])
		builder.insertChild(toggleFilterOutlineMenu, atStartOfMenu: .view)

		if #available(macOS 12.0, *) {
			// This is included automatically on 12 and up
		} else {
			let toggleSidebarMenu = UIMenu(title: "", options: .displayInline, children: [toggleSidebarCommand])
			builder.insertSibling(toggleSidebarMenu, afterMenu: .toolbar)
		}
		
		// Outline Menu
		let completeMenu = UIMenu(title: "", options: .displayInline, children: [toggleCompleteRowsCommand, deleteCompletedRowsCommand, createRowNotesCommand, deleteRowNotesCommand])
		let moveRowMenu = UIMenu(title: "", options: .displayInline, children: [moveRowsLeftCommand, moveRowsRightCommand, moveRowsUpCommand, moveRowsDownCommand])
		let mainOutlineMenu = UIMenu(title: "",
									 options: .displayInline,
									 children: [insertRowCommand,
												createRowCommand,
												createRowInsideCommand,
												createRowOutsideCommand,
												duplicateRowsCommand,
												splitRowCommand])
		let outlineMenu = UIMenu(title: AppStringAssets.outlineControlLabel, children: [mainOutlineMenu, moveRowMenu, completeMenu])
		builder.insertSibling(outlineMenu, afterMenu: .view)

		// History Menu
		let navigateMenu = UIMenu(title: "", options: .displayInline, children: [goBackwardOneCommand, goForwardOneCommand])
		
		var historyItems = [UIAction]()
		for (index, pin) in history.enumerated() {
			historyItems.append(UIAction(title: pin.document?.title ?? AppStringAssets.noTitleLabel) { [weak self] _ in
				DispatchQueue.main.async {
					self?.openHistoryItem(index: index)
				}
			})
		}
		let historyItemsMenu = UIMenu(title: "", options: .displayInline, children: historyItems)

		let historyMenu = UIMenu(title: AppStringAssets.historyControlLabel, children: [navigateMenu, historyItemsMenu])
		builder.insertSibling(historyMenu, afterMenu: .view)

		// Help Menu
		builder.replaceChildren(ofMenu: .help, from: { _ in return [showHelpCommand, reportAnIssueCommand] })
	}

}

// MARK: AppKitPluginDelegate

extension AppDelegate: AppKitPluginDelegate {
	
	func importOPML(_ url: URL) {
		let accountID = AppDefaults.shared.lastSelectedAccountID
		guard let account = AccountManager.shared.findAccount(accountID: accountID) ?? AccountManager.shared.activeAccounts.first else { return }
		guard let document = try? account.importOPML(url, tags: nil) else { return }

		let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.openEditor)
		activity.userInfo = [Pin.UserInfoKeys.pin: Pin(document: document).userInfo]
		UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
	}
	
}

// MARK: ErrorHandler

extension AppDelegate: ErrorHandler {
	
	func presentError(_ error: Error, title: String) {
		if let controller = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
			if controller.presentedViewController == nil {
				controller.presentError(title: title, message: error.localizedDescription)
			}
		}
	}
	
}

// MARK: Helpers

private extension AppDelegate {
	
	@objc func willEnterForeground() {
		checkForUserDefaultsChanges()
		AccountManager.shared.resume()
		
		if let userInfos = AppDefaults.shared.documentHistory {
			history = userInfos.compactMap { Pin(userInfo: $0) }
		}
		cleanUpHistory()
		
		UIMenuSystem.main.setNeedsRebuild()
	}
	
	@objc private func didEnterBackground() {
		AccountManager.shared.suspend()
		AppDefaults.shared.documentHistory = history.map { $0.userInfo }
	}
	
	@objc private func checkForUserDefaultsChanges() {
		let localAccount = AccountManager.shared.localAccount
		
		if AppDefaults.shared.enableLocalAccount != localAccount.isActive {
			if AppDefaults.shared.enableLocalAccount {
				localAccount.activate()
			} else {
				localAccount.deactivate()
			}
		}
		
		let cloudKitAccount = AccountManager.shared.cloudKitAccount
		
		if AppDefaults.shared.enableCloudKit && cloudKitAccount == nil {
			AccountManager.shared.createCloudKitAccount(errorHandler: self)
		} else if !AppDefaults.shared.enableCloudKit && cloudKitAccount != nil {
			AccountManager.shared.deleteCloudKitAccount()
		}
	}

	@objc func pinWasVisited(_ note: Notification) {
		guard let pin = note.object as? Pin else { return }
		
		history.removeAll(where: { $0.documentID == pin.documentID })
		history.insert(pin, at: 0)
		history = Array(history.prefix(15))
		
		UIMenuSystem.main.setNeedsRebuild()
	}

	@objc func accountDocumentsDidChange() {
		cleanUpHistory()
	}

	@objc func accountManagerAccountsDidChange() {
		cleanUpHistory()
	}

	@objc func accountMetadataDidChange() {
		cleanUpHistory()
	}
	
	@objc func documentTitleDidChange() {
		UIMenuSystem.main.setNeedsRebuild()
	}

	func openHistoryItem(index: Int) {
		let pin = history[index]
		
		if let mainSplitViewController = mainCoordinator as? MainSplitViewController {
			mainSplitViewController.handlePin(pin)
		} else {
			let activity = NSUserActivity(activityType: NSUserActivity.ActivityType.openEditor)
			activity.userInfo = [Pin.UserInfoKeys.pin: pin.userInfo]
			UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
		}
		
	}

	private func cleanUpHistory() {
		let allDocumentIDs = AccountManager.shared.activeDocuments.map { $0.id }
		
		for pin in history {
			if let documentID = pin.documentID {
				if !allDocumentIDs.contains(documentID) {
					history.removeFirst(object: pin)
					UIMenuSystem.main.setNeedsRebuild()
				}
			}
		}
	}
	
}
