import AVFoundation
import Foundation

public struct AssetWrapper {
    // MARK: - public
    public let urlAsset: AVURLAsset
    public let assetTitle: String
    
    // MARK: - initializer
    public init(urlAsset: AVURLAsset, assetTitle: String) {
        self.urlAsset = urlAsset
        self.assetTitle = assetTitle
    }
}

extension AssetWrapper: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.urlAsset.url == rhs.urlAsset.url && lhs.assetTitle == rhs.assetTitle
    }
}