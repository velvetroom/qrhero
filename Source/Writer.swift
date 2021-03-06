import UIKit
import CoreImage

class Writer {
    func write(content:String) -> UIImage? {
        var image:UIImage?
        if let cgImage = cgImageFor(content:content) {
            image = UIImage(cgImage:cgImage, scale:1, orientation:.up)
        }
        return image
    }
    
    private func cgImageFor(content:String) -> CGImage? {
        var image:CGImage?
        if let ci = filter(content:content)?.outputImage?.transformed(by:
            CGAffineTransform(scaleX:10, y:10)) {
            image = CIContext().createCGImage(ci, from:ci.extent)
        }
        return image
    }
    
    private func filter(content:String) -> CIFilter? {
        let filter = CIFilter(name:"CIQRCodeGenerator")
        filter?.setValue("H", forKey:"inputCorrectionLevel")
        if let data = content.data(using:.utf8, allowLossyConversion:false) {
            filter?.setValue(data, forKey:"inputMessage")
        }
        return filter
    }
}
