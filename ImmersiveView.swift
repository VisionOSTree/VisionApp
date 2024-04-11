import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    // Initial scale of the model
    @State private var modelScale: CGFloat = 0.001
    // Target scale value for the model to grow to
    private let targetScale: CGFloat = 0.5
    // Controls whether the tree is growing or not
    @State private var isGrowing = false

    var body: some View {
        VStack {
            RealityView { content in
                do {
                    let treeEntity = try await Entity(named: "Old_Tree", in: realityKitContentBundle)
                    // Apply initial scale to the model
                    treeEntity.scale = SIMD3<Float>(repeating: Float(modelScale))
                    content.add(treeEntity)

                    // Check if the tree is growing and update its scale
                    if isGrowing {
                        // Animate to the target scale
                        withAnimation(.easeInOut(duration: 2)) {
                            treeEntity.scale = SIMD3<Float>(repeating: Float(targetScale))
                        }
                    }
                } catch {
                    print("Error loading the tree model: \(error)")
                }
            }
            .frame(height: 300) // Specify a frame height for the RealityView

            // Button to toggle the growth of the tree
            Button("Grow") {
                // Ensure it doesn't go beyond the target scale
                guard modelScale < targetScale else { return }
                isGrowing.toggle() // Trigger the growing process
                
                if isGrowing {
                    // Animate to the target scale
                    withAnimation(.easeInOut(duration: 2)) {
                        modelScale = targetScale
                    }
                } else {
                    // Reset to initial scale without animation
                    modelScale = 0.15
                    isGrowing = false
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

