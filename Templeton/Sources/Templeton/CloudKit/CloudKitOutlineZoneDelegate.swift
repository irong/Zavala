//
//  CloudKitOutlineZoneDelegate.swift
//  
//
//  Created by Maurice Parker on 2/6/21.
//

import Foundation
import os.log
import RSCore
import CloudKit

class CloudKitAcountZoneDelegate: CloudKitZoneDelegate {
	
	private var log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "CloudKit")

	weak var account: Account?

	init(account: Account) {
		self.account = account
	}
	
	func cloudKitDidModify(changed: [CKRecord], deleted: [CloudKitRecordKey], completion: @escaping (Result<Void, Error>) -> Void) {
//		for deletedRecordKey in deleted {
//			switch deletedRecordKey.recordType {
//			case CloudKitAccountZone.CloudKitWebFeed.recordType:
//				removeWebFeed(deletedRecordKey.recordID.externalID)
//			case CloudKitAccountZone.CloudKitContainer.recordType:
//				removeContainer(deletedRecordKey.recordID.externalID)
//			default:
//				assertionFailure("Unknown record type: \(deletedRecordKey.recordType)")
//			}
//		}
//
//		for changedRecord in changed {
//			switch changedRecord.recordType {
//			case CloudKitAccountZone.CloudKitWebFeed.recordType:
//				addOrUpdateWebFeed(changedRecord)
//			case CloudKitAccountZone.CloudKitContainer.recordType:
//				addOrUpdateContainer(changedRecord)
//			default:
//				assertionFailure("Unknown record type: \(changedRecord.recordType)")
//			}
//		}
		
		completion(.success(()))
	}

}
