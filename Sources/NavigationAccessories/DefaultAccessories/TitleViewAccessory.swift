import SwiftUI

struct TitleViewAccessory<Content: Hashable & View>: NavigationAccessory {
    let id = "TitleViewAccessory"

    let height: CGFloat?
    let hideStandardTitle: Bool
    let content: Content

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        let navigationItem = viewController.navigationItem

        switch reason {
        case .added:
            let hostingController = UIHostingController(rootView: content)
            viewController[hostingControllerForID: id] = hostingController

            if let contentView = hostingController.view {
                contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                contentView.backgroundColor = nil

                let targetSize = CGSize(
                    width: viewController.view.frame.width,
                    height: UIView.layoutFittingCompressedSize.height
                )

                let viewHeight = height ?? contentView.systemLayoutSizeFitting(targetSize).height

                let titleView = UINavigationBarTitleView()
                titleView?.hideStandardTitle = hideStandardTitle
                titleView?.setHeight(viewHeight)
                titleView?.addSubview(contentView)

                navigationItem.tallTitleView = titleView
            }

        case .modified:
            let hostingController: UIHostingController<Content>? = viewController[hostingControllerForID: id]
            hostingController?.rootView = content

            if let contentView = hostingController?.view {
                let targetSize = CGSize(
                    width: viewController.view.frame.width,
                    height: UIView.layoutFittingCompressedSize.height
                )

                let viewHeight = height ?? contentView.systemLayoutSizeFitting(targetSize).height
                navigationItem.tallTitleView?.setHeight(viewHeight)
            }

            navigationItem.tallTitleView?.hideStandardTitle = hideStandardTitle

        case .removed:
            navigationItem.tallTitleView = nil
            viewController[hostingControllerForID: id, withContentType: Content.self] = nil
        }
    }
}
