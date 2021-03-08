import Foundation

public extension Bundle {

  func contains(ressource name: String?, withExtension ext: String?) -> Bool {
    return url(forResource: name, withExtension: ext) != nil
  }

  /// Find the bundle associated with a specific resource
  /// - parameter rootBundle: The resource should be found inside this bundle or inside a *child* bundle
  class func bundle(forResource name: String?, withExtension ext: String?, rootBundle: Bundle) -> Bundle? {
    if rootBundle.contains(ressource: name, withExtension: ext) {
      return rootBundle
    }
    else {
      if let innerBundlesURLs = rootBundle.urls(forResourcesWithExtension: "bundle", subdirectory: nil) {
        for bundleURL in innerBundlesURLs {
          if let bundle = Bundle(url: bundleURL), bundle.contains(ressource: name, withExtension: ext) {
            return bundle
          }
        }
      }
      return nil
    }
  }
}
