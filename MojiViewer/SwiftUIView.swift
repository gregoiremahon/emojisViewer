import SwiftUI
import SceneKit

struct ContentView: View {
    // Liste des emojis
    let emojis = ["😀","😃","😄","😁","😆","🥹","😅","😂","🤣","🥲","☺️","😊","😇","🙂","🙃","😉","😌","😍","🥰","😘","😙","😗","😚","😋","😛","😝","😜","🤪","🤨","🧐","🤓","😎","🥸","🤩","🥳"]
    
    // Emoji actuellement affiché en 3D
    @State private var currentEmoji = "😁"
    
    var body: some View {
        VStack {
            // Liste des emojis
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
            
            // Vue 3D
            SceneKitView(scene: makeScene(for: currentEmoji))
                .id(currentEmoji)
                .frame(width: 300, height: 300)
        }
    }
    
    func makeScene(for emoji: String) -> SCNScene {
        let scene = SCNScene()
        let node = SCNNode()

        // Créez une sphère
        let sphere = SCNSphere(radius: 3.0)
        
        // Appliquez la texture d'emoji à la sphère
        let emojiImage = emojiImage(for: emoji)
        sphere.firstMaterial?.diffuse.contents = emojiImage
        
        // Ajoutez la sphère au nœud
        node.geometry = sphere
        
        // Faites tourner le modèle 3D
        let action = SCNAction.rotate(by: .pi, around: SCNVector3(x: 0, y: 1, z: 0), duration: 2)
        node.runAction(SCNAction.repeatForever(action))
        
        // Ajoutez le nœud à la scène
        scene.rootNode.addChildNode(node)
        return scene
    }
    
    func emojiImage(for emoji: String) -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (emoji as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 90)])
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
