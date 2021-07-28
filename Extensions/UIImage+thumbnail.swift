//
//  UIImage+thumbnail.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/25.
//

import UIKit

extension UIViewController {
    
    func textToImage(_ text: String) -> UIImage? {
        let image = UIImage(named: text)
        return image
    }
    
    func thumbnailImage(str: String) -> UIImage?{
        
        if let image =  textToImage(str) {
            
            let thumbnailSize = CGSize(width:50, height: 50);
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)
            
            let widthRatio = thumbnailSize.width / image.size.width;
            let heightRadio = thumbnailSize.height / image.size.height;
            let ratio = max(widthRatio,heightRadio);
            
            let imageSize = CGSize(width:image.size.width*ratio,height: image.size.height*ratio);
            
            let circlePath = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: thumbnailSize.width,height: thumbnailSize.height))
            circlePath.addClip()
            
            image.draw(in:CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0,y: -(imageSize.height-thumbnailSize.height)/2.0,
                                 width: imageSize.width,height: imageSize.height))
            
            let smallImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return smallImage
        }
        return nil
    }
}

