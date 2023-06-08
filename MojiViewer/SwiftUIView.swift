import SwiftUI
import SceneKit

struct ContentView: View {
    // Liste des emojis
    let emojis = ["😀","😃","😄","😁","😆","🥹","😅","😂","🤣","🥲","☺️","😊","😇","🙂","🙃","😉","😌","😍","🥰","😘","😙","😗","😚","😋","😛","😝","😜","🤪","🤨","🧐","🤓","😎","🥸","🤩","🥳"]
    
    // Initial emoji
    @State private var currentEmoji = "😁"
    
    var body: some View {
        VStack {
            // Emojis list and choice
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(emojis, id: \.self) { emoji in
                        Button(action: {
                            self.currentEmoji = emoji
                        }) {
                            Text(emoji)
                                .font(.system(size: 50))
                                .bold()
                        }
                    }
                }
            }
            
            // 3D view
            SceneKitView(scene: makeScene(for: currentEmoji))
                .id(currentEmoji)
                .frame(width: 300, height: 300)
        }
    }
    
    func makeScene(for emoji: String) -> SCNScene {
        let scene = SCNScene()
        let node = SCNNode()
        
        let sphere = SCNSphere(radius: 3.0)
        
        let emojiImage = emojiImage(for: emoji)
        sphere.firstMaterial?.diffuse.contents = emojiImage
        
        node.geometry = sphere
        
        let action = SCNAction.rotate(by: .pi, around: SCNVector3(x: 0, y: 1, z: 0), duration: 2)
        node.runAction(SCNAction.repeatForever(action))
        
        scene.rootNode.addChildNode(node)
        return scene
    }
    
    func emojiImage(for emoji: String) -> UIImage {
        let size = CGSize(width: 500, height: 500)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (emoji as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 450)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

struct SceneKitView: UIViewRepresentable {
    let scene: SCNScene
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
    }
}
