import Foundation
import SpriteKit

class GameScene : SKScene {
    
    var audioOn = false;
    
    var pet = SKSpriteNode()
    var petMouth = SKSpriteNode()
    var petNose = SKSpriteNode()
    var petPupilL = SKSpriteNode()
    var petPupilR = SKSpriteNode()
    var petWhiteL = SKSpriteNode()
    var petWhiteR = SKSpriteNode()
    var petTongue = SKSpriteNode()
    var petTargetLocation = CGVector(dx: 0, dy: 0)
    var touchLocation = CGVector()
    let touchOffsetY: CGFloat = 30.0
    
    var pupilSize = 15.0
    var whiteSize = 40
    var eyeHeight = 15.0
    var eyeSpread = 65.0
    var mouthHeight = -40.0
    var noseHeight = -2.0
    
    let spring = CGFloat(0.15)
    let damp = CGFloat(0.8)
    var velocity = CGVector(dx: 0, dy: 0)
    var touching = false
    
    var spinTongue = false
    let tongueSpinSpeed = CGFloat(0.2)
    
    let petTextureAtlas = SKTextureAtlas(named: "petanim.atlas")
    var petSpriteArray = Array<SKTexture>()
    let petBodyTextureAtlas = SKTextureAtlas(named: "pet_body.atlas")
    var petBodySpriteArray = Array<SKTexture>()
    let petMouthTextureAtlas = SKTextureAtlas(named: "pet_mouth.atlas")
    var petMouthSpriteArray = Array<SKTexture>()
    let petNoseTextureAtlas = SKTextureAtlas(named: "pet_nose.atlas")
    var petNoseSpriteArray = Array<SKTexture>()
    let petPupilTextureAtlas = SKTextureAtlas(named: "pet_pupil.atlas")
    var petPupilSpriteArray = Array<SKTexture>()
    let petWhiteTextureAtlas = SKTextureAtlas(named: "pet_white_of_eye.atlas")
    var petWhiteSpriteArray = Array<SKTexture>()
    let petTongueTextureAtlas = SKTextureAtlas(named: "pet_tongue.atlas")
    var petTongueSpriteArray = Array<SKTexture>()
        
    override func didMoveToView(view: SKView) {

        backgroundColor = UIColor(red: 0.58, green: 0.84, blue: 0.78, alpha: 1)

        setupPet()
        setupPetSprites()
        setupPetPartsSprites()
        pet.texture = petBodySpriteArray[0]

        pet.addChild(petNose)
        pet.addChild(petWhiteL)
        petWhiteL.addChild(petPupilL)
        pet.addChild(petWhiteR)
        petWhiteR.addChild(petPupilR)
        pet.addChild(petMouth)
        petMouth.addChild(petTongue)
        
        petMouth.texture = petMouthSpriteArray[0]
        petMouth.position = CGPoint(x: 0, y: mouthHeight)
        petMouth.size = CGSize(width: 40, height: 25)
        petTongue.texture = petTongueSpriteArray[0]
        petTongue.position = CGPoint(x: 0, y: 0)
        petTongue.size = CGSize(width: 73, height: 99)
        petTongue.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        petTongue.alpha = 0.0
        
        petNose.texture = petNoseSpriteArray[0]
        petNose.position = CGPoint(x: 0, y: noseHeight)
        petNose.size = CGSize(width: 50,height: 30)
        petWhiteL.texture = petWhiteSpriteArray[0]
        petWhiteL.position = CGPoint(x: -eyeSpread, y: eyeHeight)
        petWhiteL.size = CGSize(width: whiteSize, height: whiteSize)
        petPupilL.texture = petPupilSpriteArray[0]
        petPupilL.position = CGPoint(x: 10, y: 0)
        petPupilL.size = CGSize(width: pupilSize, height: pupilSize)
        petWhiteR.texture = petWhiteSpriteArray[0]
        petWhiteR.position = CGPoint(x: eyeSpread, y: eyeHeight)
        petWhiteR.size = CGSize(width: whiteSize, height: whiteSize)
        petPupilR.texture = petPupilSpriteArray[0]
        petPupilR.position = CGPoint(x: -10, y: 0)
        petPupilR.size = CGSize(width: pupilSize, height: pupilSize)
    }
    
    func setupPetPartsSprites ()
    {
        petBodySpriteArray.append(petBodyTextureAtlas.textureNamed("body_1"))
        petMouthSpriteArray.append(petMouthTextureAtlas.textureNamed("mouth_1"))
        petTongueSpriteArray.append(petTongueTextureAtlas.textureNamed("tongue_1"))
        petNoseSpriteArray.append(petNoseTextureAtlas.textureNamed("nose_1"))
        petPupilSpriteArray.append(petPupilTextureAtlas.textureNamed("pupil_1"))
        petPupilSpriteArray.append(petPupilTextureAtlas.textureNamed("pupil_2"))
        petWhiteSpriteArray.append(petWhiteTextureAtlas.textureNamed("white_of_eye_1"))
        petWhiteSpriteArray.append(petWhiteTextureAtlas.textureNamed("white_of_eye_2"))
        petWhiteSpriteArray.append(petWhiteTextureAtlas.textureNamed("white_of_eye_3"))

    }
    
    func setupPet()
    {
        pet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.45)
        pet.size = CGSize(width: 387 * 0.6, height: 384 * 0.6)
        //        pet.userInteractionEnabled = true; // this is weird, need to research
        pet.name = "pet"
        petTargetLocation = CGVector(dx: pet.position.x, dy: pet.position.y + 10)
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
        if (spinTongue == true)
        {
            petTongue.zRotation += tongueSpinSpeed
        }
    }
    
    override func didSimulatePhysics() {
        if (touching == false) {
            mainPetSpring()
        }
        
        
    }
    
    func mainPetSpring ()
    {
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            touching = true
            let location = (touch as! UITouch).locationInNode(self)
            pet.position.x = location.x
            pet.position.y = location.y + touchOffsetY
            petTongue.alpha = 1.0
            if (audioOn)
            {
                runAction(SKAction.sequence([
                    SKAction.playSoundFileNamed("lick.wav", waitForCompletion: false)  ,
                    SKAction.playSoundFileNamed("lick_synth.wav", waitForCompletion: false)
                    ]))
            }
            blink()
            spinTongue = true
            if (self.nodeAtPoint(location).name == "pet") // if touched pet
            {
//                pet.texture = petBodySpriteArray[0]
            }
            
            
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        touching = false
        spinTongue = false
        petTongue.alpha = 0.0
        unBlink()
    }
    
    func blink()
    {
        petPupilL.alpha = 0.0
        petWhiteL.texture = petWhiteSpriteArray[2]
        petWhiteL.size = CGSize(width: whiteSize, height: 5)
        petPupilR.alpha = 0.0
        petWhiteR.texture = petWhiteSpriteArray[2]
        petWhiteR.size = CGSize(width: -whiteSize, height: 5)
    }
    
    func unBlink()
    {
        petPupilL.alpha = 1.0
        petWhiteL.texture = petWhiteSpriteArray[0]
        petWhiteL.size = CGSize(width: whiteSize, height: whiteSize)

        petPupilR.alpha = 1.0
        petWhiteR.texture = petWhiteSpriteArray[0]
        petWhiteR.size = CGSize(width: whiteSize, height: whiteSize)
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            touching = true
            let location = (touch as! UITouch).locationInNode(self)
            pet.position.x = location.x
            pet.position.y = location.y + touchOffsetY
            
            if (self.nodeAtPoint(location).name == "pet") // if touching pet
            {
                
            }
            
        }
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
