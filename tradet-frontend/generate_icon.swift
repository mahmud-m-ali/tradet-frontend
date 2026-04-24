import Cocoa
import CoreGraphics
import CoreText
import Foundation

func createIcon(size: CGFloat) -> NSImage {
    let img = NSImage(size: NSSize(width: size, height: size))
    img.lockFocus()

    guard let ctx = NSGraphicsContext.current?.cgContext else {
        fatalError("No graphics context")
    }

    let s = size / 1024.0

    // --- Background rounded rect ---
    let margin = 80 * s
    let cornerRadius = 180 * s
    let bgRect = CGRect(x: margin, y: margin, width: size - 2 * margin, height: size - 2 * margin)
    let bgPath = CGPath(roundedRect: bgRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)

    // Dark green fill
    ctx.setFillColor(CGColor(red: 13/255, green: 59/255, blue: 32/255, alpha: 1))
    ctx.addPath(bgPath)
    ctx.fillPath()

    // Lighter green inner glow
    ctx.saveGState()
    ctx.addPath(bgPath)
    ctx.clip()
    let gradient = CGGradient(
        colorsSpace: CGColorSpaceCreateDeviceRGB(),
        colors: [
            CGColor(red: 25/255, green: 90/255, blue: 50/255, alpha: 0.6),
            CGColor(red: 13/255, green: 59/255, blue: 32/255, alpha: 0.0)
        ] as CFArray,
        locations: [0.0, 1.0]
    )!
    ctx.drawRadialGradient(
        gradient,
        startCenter: CGPoint(x: size * 0.4, y: size * 0.6),
        startRadius: 0,
        endCenter: CGPoint(x: size * 0.4, y: size * 0.6),
        endRadius: size * 0.5,
        options: []
    )
    ctx.restoreGState()

    // --- Crescent Moon ---
    // Note: CoreGraphics has Y going up, so we flip
    let moonCx = 512 * s
    let moonCy = size - 280 * s  // Flip Y
    let moonR = 100 * s

    // Main moon circle (bright green)
    ctx.setFillColor(CGColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1))
    ctx.addEllipse(in: CGRect(x: moonCx - moonR, y: moonCy - moonR, width: moonR * 2, height: moonR * 2))
    ctx.fillPath()

    // Cut-out for crescent
    let cutOffset = 35 * s
    let cutR = 85 * s
    ctx.setFillColor(CGColor(red: 13/255, green: 59/255, blue: 32/255, alpha: 1))
    ctx.addEllipse(in: CGRect(
        x: moonCx + cutOffset - cutR,
        y: moonCy + 15 * s - cutR,
        width: cutR * 2,
        height: cutR * 2
    ))
    ctx.fillPath()

    // Star
    drawStar(ctx: ctx, cx: moonCx + 75 * s, cy: moonCy + 40 * s, size: 28 * s,
             color: CGColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1))

    // --- Chart line ---
    // Y is flipped: original y values from top, so subtract from size
    let chartPoints: [(CGFloat, CGFloat)] = [
        (200 * s, size - 620 * s),
        (350 * s, size - 580 * s),
        (480 * s, size - 530 * s),
        (580 * s, size - 490 * s),
        (680 * s, size - 440 * s),
        (800 * s, size - 380 * s),
    ]

    ctx.setStrokeColor(CGColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1))
    ctx.setLineWidth(max(12 * s, 2))
    ctx.setLineCap(.round)
    ctx.setLineJoin(.round)

    ctx.move(to: CGPoint(x: chartPoints[0].0, y: chartPoints[0].1))
    for i in 1..<chartPoints.count {
        ctx.addLine(to: CGPoint(x: chartPoints[i].0, y: chartPoints[i].1))
    }
    ctx.strokePath()

    // Chart dots
    let dotR = max(10 * s, 2)
    ctx.setFillColor(CGColor(red: 129/255, green: 199/255, blue: 132/255, alpha: 1))
    for pt in chartPoints {
        ctx.addEllipse(in: CGRect(x: pt.0 - dotR, y: pt.1 - dotR, width: dotR * 2, height: dotR * 2))
        ctx.fillPath()
    }

    // --- Text: ሃኢ on top, HE below ---
    let textCenterX = 680 * s

    // ሃኢ text (Amharic)
    let amharicFontSize = 115 * s
    let amharicFont = CTFontCreateWithName("Kefa-Regular" as CFString, amharicFontSize, nil)
    let amharicStr = "ሃኢ" as NSString
    let amharicAttrs: [NSAttributedString.Key: Any] = [
        .font: amharicFont,
        .foregroundColor: NSColor.white
    ]
    let amharicSize = amharicStr.size(withAttributes: amharicAttrs)
    let amharicY = size - 660 * s - amharicSize.height  // Flip Y
    amharicStr.draw(
        at: NSPoint(x: textCenterX - amharicSize.width / 2, y: amharicY),
        withAttributes: amharicAttrs
    )

    // HE text (Latin)
    let latinFontSize = 135 * s
    let latinFont = CTFontCreateWithName("Helvetica-Bold" as CFString, latinFontSize, nil)
    let latinStr = "HE" as NSString
    let latinAttrs: [NSAttributedString.Key: Any] = [
        .font: latinFont,
        .foregroundColor: NSColor.white
    ]
    let latinSize = latinStr.size(withAttributes: latinAttrs)
    let latinY = size - 770 * s - latinSize.height  // Flip Y
    latinStr.draw(
        at: NSPoint(x: textCenterX - latinSize.width / 2, y: latinY),
        withAttributes: latinAttrs
    )

    img.unlockFocus()
    return img
}

func drawStar(ctx: CGContext, cx: CGFloat, cy: CGFloat, size: CGFloat, color: CGColor) {
    let outerRadius = size
    let innerRadius = size * 0.4
    let points = 5

    ctx.setFillColor(color)
    var coords: [CGPoint] = []
    for i in 0..<(points * 2) {
        let r = i % 2 == 0 ? outerRadius : innerRadius
        let angle = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
        coords.append(CGPoint(
            x: cx + r * cos(angle),
            y: cy + r * sin(angle)
        ))
    }

    ctx.move(to: coords[0])
    for i in 1..<coords.count {
        ctx.addLine(to: coords[i])
    }
    ctx.closePath()
    ctx.fillPath()
}

func savePNG(image: NSImage, path: String, targetSize: Int) {
    let resized = NSImage(size: NSSize(width: targetSize, height: targetSize))
    resized.lockFocus()
    NSGraphicsContext.current?.imageInterpolation = .high
    image.draw(
        in: NSRect(x: 0, y: 0, width: targetSize, height: targetSize),
        from: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height),
        operation: .copy,
        fraction: 1.0
    )
    resized.unlockFocus()

    guard let tiff = resized.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let pngData = bitmap.representation(using: .png, properties: [:]) else {
        print("Failed to create PNG for \(path)")
        return
    }

    do {
        try pngData.write(to: URL(fileURLWithPath: path))
    } catch {
        print("Failed to write \(path): \(error)")
    }
}

// Main
let baseDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "."

print("Generating 1024x1024 master icon...")
let master = createIcon(size: 1024)

// Android mipmap sizes
let androidSizes: [(String, Int)] = [
    ("mipmap-mdpi", 48),
    ("mipmap-hdpi", 72),
    ("mipmap-xhdpi", 96),
    ("mipmap-xxhdpi", 144),
    ("mipmap-xxxhdpi", 192),
]

for (folder, px) in androidSizes {
    let dir = "\(baseDir)/android/app/src/main/res/\(folder)"
    try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
    let path = "\(dir)/ic_launcher.png"
    savePNG(image: master, path: path, targetSize: px)
    print("  Android \(folder): \(px)x\(px)")
}

// iOS icon sizes
let iosSizes: [(String, Int)] = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]

let iosDir = "\(baseDir)/ios/Runner/Assets.xcassets/AppIcon.appiconset"
try? FileManager.default.createDirectory(atPath: iosDir, withIntermediateDirectories: true)
for (name, px) in iosSizes {
    let path = "\(iosDir)/\(name)"
    savePNG(image: master, path: path, targetSize: px)
    print("  iOS \(name): \(px)x\(px)")
}

// Web icons
let webSizes: [(String, Int)] = [
    ("favicon.png", 32),
    ("icons/Icon-192.png", 192),
    ("icons/Icon-512.png", 512),
    ("icons/Icon-maskable-192.png", 192),
    ("icons/Icon-maskable-512.png", 512),
]

let webDir = "\(baseDir)/web"
for (name, px) in webSizes {
    let path = "\(webDir)/\(name)"
    let dir = (path as NSString).deletingLastPathComponent
    try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
    savePNG(image: master, path: path, targetSize: px)
    print("  Web \(name): \(px)x\(px)")
}

print("\nDone! All icons generated with ሃኢ on top of HE.")
