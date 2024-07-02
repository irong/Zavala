//
//  Created by Maurice Parker on 7/1/24.
//

import UIKit
import AppIntents

struct GetCurrentOutlineAppIntent: AppIntent {

    static let title: LocalizedStringResource = "Get Current Outline"
    static let description = IntentDescription("Get the currently viewed outline from the foremost window for Zavala.")

    static var parameterSummary: some ParameterSummary {
        Summary("Get Current Outline")
    }

	@MainActor
	func perform() async throws -> some IntentResult & ReturnsValue<OutlineAppEntity> {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let outline = appDelegate.mainCoordinator?.selectedDocuments.first?.outline else {
			throw ZavalaAppIntentError.outlineNotBeingViewed
		}
		
		return .result(value: OutlineAppEntity(outline: outline))
    }
}

