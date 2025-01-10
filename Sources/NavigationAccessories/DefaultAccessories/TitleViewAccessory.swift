import SwiftUI

struct TitleViewAccessory<Content: Hashable & View>: NavigationAccessory {
    let id = "TitleViewAccessory"

    let height: CGFloat?
    let hideStandardTitle: Bool
    let content: Content

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        let navigationItem = viewController.navigationController?.topViewController?.navigationItem

        switch reason {
        case .added:
            let hostingController = UIHostingController(rootView: content)
            viewController.hostingControllers[id] = hostingController

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

                navigationItem?.tallTitleView = titleView
            }

        case .modified:
            let hostingController = viewController.hostingControllers[id] as? UIHostingController<Content>
            hostingController?.rootView = content

            if let contentView = hostingController?.view {
                contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                contentView.backgroundColor = nil

                let targetSize = CGSize(
                    width: viewController.view.frame.width,
                    height: UIView.layoutFittingCompressedSize.height
                )

                let viewHeight = height ?? contentView.systemLayoutSizeFitting(targetSize).height

                navigationItem?.tallTitleView?.subviews.forEach { $0.removeFromSuperview() }
                navigationItem?.tallTitleView?.addSubview(contentView)

                navigationItem?.tallTitleView?.hideStandardTitle = hideStandardTitle
                navigationItem?.tallTitleView?.setHeight(viewHeight)
            }

        case .removed:
            viewController.hostingControllers[id] = nil
            navigationItem?.tallTitleView = nil
        }
    }
}
