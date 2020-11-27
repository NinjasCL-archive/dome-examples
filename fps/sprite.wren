import "./texture" for Texture
import "math" for M, Vec
import "input" for Keyboard, Mouse
import "./keys" for InputGroup

var PI_RAD = Num.pi / 180

class Entity {
  construct new(position) {
    _pos = position
  }
  solid { false }
  pos { _pos }
  pos=(v) { _pos = v }

  update(context) {}
  draw() {}
}

class Player is Entity {
  construct new(position, angle) {
    super(position)
    _dir = Vec.new()
    this.angle = angle
  }

  angle { _angle }
  angle=(v) {
    _angle = v % 360
    if (_angle < 0) {
      _angle = _angle + 360
    }
    _dir.x = M.cos(_angle * PI_RAD)
    _dir.y = M.sin(_angle * PI_RAD)
  }

  update(context) {

  }

  dir { _dir }

}

class Sprite is Entity {
  construct new(pos, textures) {
    super(pos)
    if (!(textures is List)) {
      textures = [ textures ]
    }
    _textures = textures
    _octant = 0
  }

  textures { _textures }
  octant { _octant }
  octant=(v) { _octant = v % _textures.count }
  currentTex { _textures[octant] }

  uDiv { 1 }
  vDiv { 1 }
  vMove { 0 }
}

class DirectionalSprite is Sprite {
  construct new(pos, textures) {
    super(pos, textures)
    _segmentSize = 360 / textures.count
  }

  update(context) {
    super(context)
    var playerPos = pos - context.player.pos
    var angle = (playerPos.y.atan(playerPos.x) / PI_RAD + 360 - _segmentSize / 2) % 360
    octant = (angle / _segmentSize).round
  }
}

class Person is DirectionalSprite {
  construct new(pos) {
    super(pos, (8..1).map {|n| Texture.importImg("./DUMMY%(n).png")}.toList)
  }
  solid { true }
}
class Pillar is DirectionalSprite {
  construct new(pos) {
    super(pos, Texture.importImg("./column.png"))
  }
  solid { true }
  vMove { 0 }
  vDiv { 1 }
}
