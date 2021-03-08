import UIKit

class PopupView: UIView {
  private var timeView: TimeView!
  @IBOutlet private var timeViewContainer: UIView!

  class func make(requestNewTimestamp: @escaping () -> Void) -> PopupView {
    let popupView = UINib.instantiateView(for: Self.self)
    popupView.timeView = TimeView.make { requestNewTimestamp() }
    popupView.setup()
    return popupView
  }

  func updateTimeStamps(timeViewModel: TimeViewModel) {
    timeView.viewModel = timeViewModel
  }

  private func setup() {
    timeViewContainer.addFillerSubview(timeView)
  }
}
