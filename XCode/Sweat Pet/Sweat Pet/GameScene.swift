import Foundation
import SpriteKit

class GameScene : SKScene {
    
    var pet = SKSpriteNode()
    var petTargetLocation = CGVector(dx: 0, dy: 0)
    var touchLocation = CGVector()
    
    let spring = CGFloat(0.15)
    let damp = CGFloat(0.8                                                                  )
    var velocity = CGVector(dx: 0, dy: 0)
    var touching = false
    
    let petTextureAtlas = SKTextureAtlas(named: "petanim.atlas")
    var petSpriteArray = Array<SKTexture>()
    
    override func didMoveToView(view: SKView) {

        backgroundColor = UIColor(red: 0.58, green: 0.84, blue: 0.78, alpha: 1)

        setupPet()
        setupPetSprites()
        pet.texture = petSpriteArray[1]
        
    }
    
    func setupPet()
    {
        pet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.40)
        pet.size = CGSize(width: 387 * 0.6, height: 384 * 0.6)
        //        pet.userInteractionEnabled = true; // this is weird, need to research
        pet.name = "pet"
        petTargetLocation = CGVector(dx: pet.position.x, dy: pet.position.y)
        addChild(pet)
    }
    
    func setupPetSprites()
    {
        petSpriteArray.append(petTextureAtlas.textureNamed("pet_1"))
        petSpriteArray.append(petTextureAtlas.textureNamed("pet_2"))
        petSpriteArray.append(petTextureAtlas.textureNamed("pet_3"))
        petSpriteArray.append(petTextureAtlas.textureNamed("pet_4"))
    }
    
    override func update(currentTime: NSTimeInterval) {

    }
    
    override func didSimulatePhysics() {
        if (touching == false) {
            var dif  = CGVector(
                dx: pet.position.x - petTargetLocation.dx,
                dy: pet.position.y - petTargetLocation.dy
            )
            velocity.dx -= dif.dx * spring
            velocity.dy -= dif.dy * spring

            velocity.dx *= damp
            velocity.dy *= damp
     
            // apply velocity
            pet.position.x += velocity.dx
            pet.position.y += velocity.dy
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            touching = true
            let location = (touch as! UITouch).locationInNode(self)
            pet.position.x = location.x
            pet.position.y = location.y
            if (self.nodeAtPoint(location).name == "pet") // if touched pet
            {
                pet.texture = spriteArray[1]
            }
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            touching = true
            let location = (touch as! UITouch).locationInNode(self)
//            if (self.nodeAtPoint(location).name == "pet") // if touching pet
//            {
                pet.position.x = location.x
                pet.position.y = location.y
//            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        touching = false
    }
    
    func bounce() {
        
        let bounceHeight = CGFloat(30.0)
        let bounceDuration = NSTimeInterval(0.1)
        let actionBounce = SKAction.moveBy(CGVector(dx: 0, dy: bounceHeight), duration: bounceDuration)
        actionBounce.timingMode = SKActionTimingMode.EaseOut
        let actionBounceReturn = SKAction.moveBy(CGVector(dx: 0, dy: -bounceHeight), duration: bounceDuration)
        actionBounceReturn.timingMode = SKActionTimingMode.EaseIn

        pet.runAction(SKAction.sequence([
            actionBounce,
            SKAction.waitForDuration(0.1),
            actionBounceReturn
            ]))
    }

}
