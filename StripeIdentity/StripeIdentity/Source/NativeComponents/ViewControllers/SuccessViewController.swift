//
//  SuccessViewController.swift
//  StripeIdentity
//
//  Created by Mel Ludowise on 11/16/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

@_spi(STP) import StripeCore
@_spi(STP) import StripeUICore
import UIKit

final class SuccessViewController: IdentityFlowViewController {
    private let htmlView = HTMLViewWithIconLabels()

    init(
        successContent: StripeAPI.VerificationPageStaticContentTextPage,
        sheetController: VerificationSheetControllerProtocol
    ) {
        super.init(
            sheetController: sheetController,
            analyticsScreenName: .success,
            shouldShowCancelButton: false
        )

        do {
            // In practice, this shouldn't throw an error since HTML copy will
            // be vetted. But in the event that an error occurs parsing the HTML,
            // body text will be empty but user will still see success title and
            // button.
            try htmlView.configure(
                with: .init(
                    bodyHtmlString: "<p>Click Complete to move on.</p>",
                    didOpenURL: { [weak self] url in
                        self?.openInSafariViewController(url: url)
                    }
                )
            )
        } catch {
            sheetController.analyticsClient.logGenericError(error: error, sheetController: sheetController)
        }

        configure(
            backButtonTitle: nil,
            viewModel: .init(
                headerViewModel: .init(
                    backgroundColor: .systemBackground,
                    headerType: .banner(
                        iconViewModel: .init(
                            iconType: .plain,
                            iconImage: Image.iconClock.makeImage(template: true),
                            iconImageContentMode: .center,
                            iconTintColor: .white,
                            shouldIconBackgroundMatchTintColor: true
                        )
                    ),
                    titleText: "Done"
                ),
                contentView: htmlView,
                buttonText: successContent.buttonText,
                didTapButton: { [weak self] in
                    self?.didTapButton()
                }
            )
        )
    }

    @available(*, unavailable)
    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SuccessViewController {
    func didTapButton() {
        dismiss(animated: true, completion: nil)
    }
}
