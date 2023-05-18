import Foundation
import AVFoundation

@objc public class VideoCacheManager: NSObject {
    
    var completionHandler: ((_ success:Bool) -> Void)? = nil
    
    private var assetDownloadManager = AssetDownloadManager()

    @objc public func setup() {
        assetDownloadManager.setupConfiguration()
    }

    @objc public func setMaxCacheSize(_ maxCacheSize: NSNumber?){
        if let unsigned = maxCacheSize {
                    assetDownloadManager.setMaxCacheSize(unsigned)
                }
    }

    func getAssetWrapper(_ url: URL, cacheKey: String?) -> AssetWrapper? {
        let key: String = cacheKey ?? url.absoluteString
        let urlAsset = AVURLAsset(url: url)
        let asset = AssetWrapper(urlAsset: urlAsset, assetTitle: key)
        return asset
    }

    @objc public func preCacheUrl(_ url: URL, cacheKey: String?, videoExtension: String?, completionHandler: ((_ success:Bool) -> Void)?) {
        self.completionHandler = completionHandler
        
        let asset = getAssetWrapper(url, cacheKey: cacheKey)!

        assetDownloadManager.downloadStream(for: asset, completion:  { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.completionHandler?(true)
            case .failure(let error):
                print(error)
                self.completionHandler?(false)
            }
        })
    }

    @objc public func stopPreCache(_ url: URL, cacheKey: String?, completionHandler: ((_ success:Bool) -> Void)?){
        let asset = getAssetWrapper(url, cacheKey: cacheKey)!
        assetDownloadManager.cancelDownload(for: asset)
        self.completionHandler?(false)
    }

    @objc public func getPlayerItem(for url: URL, cacheKey: String?) -> AVPlayerItem {
        let key: String = cacheKey ?? url.absoluteString
        guard let arg = AssetDownloadManager.shared.retrieveLocalAsset(with: key) else {
            let asset = getAssetWrapper(url, cacheKey: key)!

            assetDownloadManager.downloadStream(for: asset)
            return AVPlayerItem(asset: AVURLAsset(url: url))
        }
        let item = AVPlayerItem(asset: arg.0.urlAsset)
        return item
    }
    
    @objc public func clearCache() {
        assetDownloadManager.removeAllData()
    }
    
    @objc func cancelDownload(for url: URL, cacheKey: String?) {
        let asset = getAssetWrapper(url, cacheKey: cacheKey)!
        assetDownloadManager.cancelDownload(for: asset)
    }
}
