import UIKit
import CoreImage

class Reader {
    func read(image:UIImage) throws -> String {
        return try read(features:features(image:image))
    }
    
    private func features(image:UIImage) throws -> [CIFeature] {
        if let image = CIImage(image:image) {
            let options = optionsFor(image:image)
            if let detector = CIDetector(ofType:CIDetectorTypeQRCode, context:nil, options:options) {
                return detector.features(in:image, options:options)
            }
        }
        throw HeroError.tryingToReadInvalidImage
    }
    
    private func optionsFor(image:CIImage) -> [String:Any] {
        var options:[String:Any] = [CIDetectorAccuracy:CIDetectorAccuracyHigh, CIDetectorImageOrientation:1]
        if let imageOrientation = image.properties[kCGImagePropertyOrientation as String] {
            options = [CIDetectorImageOrientation:imageOrientation]
        }
        return options
    }
    
    private func read(features:[CIFeature]) throws -> String {
        if let message = (features.first { feature in feature is CIQRCodeFeature } as? CIQRCodeFeature)?.messageString {
            return message
        }
        throw HeroError.imageHasNoQrCode
    }
}
