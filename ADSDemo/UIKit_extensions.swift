import UIKit
import Foundation

public extension UIView {

  /// Add a subview and constraint to fill the view
  /// - parameter subview: The view to add to self
  /// - parameter insets: Insets to apply between the subview and self
  func addFillerSubview(_ subview: UIView, insets: UIEdgeInsets = .zero) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      subview.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
      subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
      subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
      subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
    ])
  }
}

public extension UINib {
  /// Load the view from a XIB file.
  /// - parameter type: A view type **for** which to load a XIB file
  /// - note: The XIB must have the same name as the class, if not this method will crash.
  class func instantiateView<T: UIView>(for type: T.Type) -> T {
    let className = String(describing: type).components(separatedBy: ".").last!
    let classBundle = Bundle(for: type as AnyClass)
    let bundle = Bundle.bundle(forResource: className, withExtension: "nib", rootBundle: classBundle)
    assert(bundle != nil, "Can't find Nib for \(className)")

    let nib = UINib(nibName: className, bundle: bundle)
    return nib.instantiate(withOwner: nil, options: nil).first as! T
  }
}
