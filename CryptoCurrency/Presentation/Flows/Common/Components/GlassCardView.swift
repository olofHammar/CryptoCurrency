//
//  GlassCardView.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-03-06.
//

import SwiftUI

struct GlassCardView<Content: View>: View {
    @State private var blurView: UIVisualEffectView = .init()
    @State private var defaultBlurRadius: CGFloat = 0
    @State private var defaultSaturationAmount: CGFloat = 0

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            ZStack{
                CustomBlurView(effect: .systemUltraThinMaterialDark) { view in
                    blurView = view
//                    if defaultBlurRadius == 0{defaultBlurRadius = view.gaussianBlurRadius}
//                    if defaultSaturationAmount == 0{defaultSaturationAmount = view.saturationAmount}
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                // MARK: Building Glassmorphic Card
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(
                        .linearGradient(colors: [
                            .white.opacity(0.25),
                            .white.opacity(0.05),
                            .clear
                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .blur(radius: 5)

                // MARK: Borders
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .stroke(
                        .linearGradient(colors: [
                            .white.opacity(0.6),
                            .clear,
                            .purple.opacity(0.2),
                            .purple.opacity(0.5)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 2
                    )
            }
            // MARK: Shadows
            .shadow(color: .black.opacity(0.15), radius: 5, x: -10, y: 10)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 10, y: -10)
            .overlay(content: {
                content
                    .padding(16)
                    .blendMode(.overlay)
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
            })
            .padding(.horizontal,25)
            .frame(height: 220)
        }
    }
}

struct GlassCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            GlassCardView() {
                HStack {
                    Text("Sample text")
                        .foregroundColor(.theme.lightGold)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Spacer()

                    VStack {
                        Text("Other text")
                            .foregroundColor(.theme.lightGold)
                            .font(.headline)
                            .fontWeight(.semibold)

                        Spacer()

                        Text("More text")
                            .foregroundColor(.theme.lightGold)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .background(
            VStack(spacing: 0) {
                Color.theme.backgroundColor

                Color.theme.darkGold
            }
        )
    }
}


// MARK: Custom Blur View
// With The Help of UiVisualEffect View
struct CustomBlurView: UIViewRepresentable{
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView)->()

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }
}

// MARK: Adjusting Blur Radius in UIVisualEffectView
extension UIVisualEffectView{
    // MARK: Steps
    // Extracting Private Class BackDropView Class
    // Then From that View Extracting ViewEffects like Gaussian Blur & Saturation
    // With the Help of this We ca Achevie Glass Morphism
    var backDrop: UIView?{
        // PRIVATE CLASS
        return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
    }

    // MARK: Extracting Gaussian Blur From BackDropView
    var gaussianBlur: NSObject?{
        return backDrop?.value(key: "filters", filter: "gaussianBlur")
    }
    // MARK: Extracting Saturation From BackDropView
    var saturation: NSObject?{
        return backDrop?.value(key: "filters", filter: "colorSaturate")
    }

    // MARK: Updating Blur Radius And Saturation
    var gaussianBlurRadius: CGFloat{
        get{
            // MARK: We Know The Key For Gaussian Blur = "inputRadius"
            return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
        }
        set{
            gaussianBlur?.values?["inputRadius"] = newValue
            // Updating the Backdrop View with the New Filter Updates
            applyNewEffects()
        }
    }

    func applyNewEffects(){
        // MARK: Animating the Change
        UIVisualEffectView.animate(withDuration: 0.5) {
            self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
        }
    }

    var saturationAmount: CGFloat{
        get{
            // MARK: We Know The Key For Gaussian Blur = "inputAmount"
            return saturation?.values?["inputAmount"] as? CGFloat ?? 0
        }
        set{
            saturation?.values?["inputAmount"] = newValue
            applyNewEffects()
        }
    }
}

// MARK: Finding SubView for Class
extension UIView{
    func subView(forClass: AnyClass?)->UIView?{
        return subviews.first { view in
            type(of: view) == forClass
        }
    }
}

// MARK: Custom Key Filtering
extension NSObject{
    // MARK: Key Values From NSOBject
    var values: [String: Any]?{
        get{
            return value(forKeyPath: "requestedValues") as? [String: Any]
        }
        set{
            setValue(newValue, forKeyPath: "requestedValues")
        }
    }

    func value(key: String,filter: String)->NSObject?{
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            return obj.value(forKeyPath: "filterType") as? String == filter
        })
    }
}
