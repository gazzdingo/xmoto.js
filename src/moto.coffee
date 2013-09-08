b2World             = Box2D.Dynamics.b2World
b2Vec2              = Box2D.Common.Math.b2Vec2
b2AABB              = Box2D.Collision.b2AABB
b2BodyDef           = Box2D.Dynamics.b2BodyDef
b2Body              = Box2D.Dynamics.b2Body
b2FixtureDef        = Box2D.Dynamics.b2FixtureDef
b2Fixture           = Box2D.Dynamics.b2Fixture
b2MassData          = Box2D.Collision.Shapes.b2MassData
b2PolygonShape      = Box2D.Collision.Shapes.b2PolygonShape
b2CircleShape       = Box2D.Collision.Shapes.b2CircleShape
b2DebugDraw         = Box2D.Dynamics.b2DebugDraw
b2MouseJointDef     = Box2D.Dynamics.Joints.b2MouseJointDef
b2PrismaticJointDef = Box2D.Dynamics.Joints.b2PrismaticJointDef
b2RevoluteJointDef  = Box2D.Dynamics.Joints.b2RevoluteJointDef

class Moto

  constructor: (level) ->
    @level  = level
    @assets = level.assets
    @scale  = @level.physics.scale

  display: ->
    @display_body()
    @display_wheel(@left_wheel)
    @display_wheel(@right_wheel)
    @display_left_axle()
    #@display_right_axle()

  init: ->
    # Assets
    textures = [ 'front1', 'lowerarm1', 'lowerleg1', 'playerbikerbody',
                 'playerbikerwheel', 'playerlowerarm', 'playerlowerleg',
                 'playertorso', 'playerupperarm', 'playerupperleg', 'rear1',
                 'upperarm1', 'upperleg1' ]
    for texture in textures
      @assets.moto.push(texture)

    # Creation of moto parts
    @player_start = @level.entities.player_start
    @bike_body    = @create_bike_body(@player_start.x, @player_start.y + 1.0)

    @left_wheel   = @create_wheel(@player_start.x - 0.7, @player_start.y + 0.45)
    @right_wheel  = @create_wheel(@player_start.x + 0.7, @player_start.y + 0.45)

    @left_axle    = @create_left_axle( @player_start.x, @player_start.y + 1.0)
    @right_axle   = @create_right_axle(@player_start.x, @player_start.y + 1.0)

    @left_revolute_join  = @create_left_revolute_joint()
    @left_prismatic_join = @create_left_prismatic_joint()

    @right_revolute_join  = @create_right_revolute_joint()
    @right_prismatic_join = @create_right_prismatic_joint()

  position: ->
    position = @bike_body.GetPosition()
    { x: position.x * @scale, y: position.y * @scale }

  create_bike_body: (x, y)  ->
    # Create fixture
    fixDef = new b2FixtureDef()

    fixDef.shape       = new b2PolygonShape()
    fixDef.density     = 0.1
    fixDef.restitution = 0.5
    fixDef.friction    = 1.0
    fixDef.filter.groupIndex = -1

    b2vertices = [ new b2Vec2(  1 / @scale, -0.5 / @scale),
                   new b2Vec2(  1 / @scale,  0.5 / @scale),
                   new b2Vec2( -1 / @scale,  0.5 / @scale),
                   new b2Vec2( -1 / @scale, -0.5 / @scale) ]

    fixDef.shape.SetAsArray(b2vertices)

    # Create body
    bodyDef = new b2BodyDef()

    # Assign body position
    bodyDef.position.x = x / @scale
    bodyDef.position.y = y / @scale

    bodyDef.type = b2Body.b2_dynamicBody
    #bodyDef.type = b2Body.b2_staticBody

    # Assign fixture to body and add body to 2D world
    body = @level.world.CreateBody(bodyDef)
    body.CreateFixture(fixDef)

    body

  create_wheel: (x, y) ->
    # Create fixture
    fixDef = new b2FixtureDef()

    fixDef.shape = new b2CircleShape(0.35 / @scale)
    fixDef.density     = 1.0
    fixDef.restitution = 0.5
    fixDef.friction    = 1.0
    fixDef.filter.groupIndex = -1

    # Create body
    bodyDef = new b2BodyDef()

    # Assign body position
    bodyDef.position.x = x / @scale
    bodyDef.position.y = y / @scale

    #bodyDef.type = b2Body.b2_staticBody
    bodyDef.type = b2Body.b2_dynamicBody

    # Assign fixture to body and add body to 2D world
    wheel = @level.world.CreateBody(bodyDef)
    wheel.CreateFixture(fixDef)

    wheel

  create_left_axle: (x, y) ->
    # Create fixture
    fixDef = new b2FixtureDef()

    fixDef.shape       = new b2PolygonShape()
    fixDef.density     = 1.0
    fixDef.restitution = 0.5
    fixDef.friction    = 1.0
    fixDef.filter.groupIndex = -1

    b2vertices = [ new b2Vec2( -0.10 / @scale,  -0.30 / @scale),
                   new b2Vec2( -0.25 / @scale,  -0.30 / @scale),
                   new b2Vec2( -0.80 / @scale,  -0.58 / @scale),
                   new b2Vec2( -0.65 / @scale,  -0.58 / @scale) ]

    fixDef.shape.SetAsArray(b2vertices)

    # Create body
    bodyDef = new b2BodyDef()

    # Assign body position
    bodyDef.position.x = x / @scale
    bodyDef.position.y = y / @scale

    bodyDef.type = b2Body.b2_dynamicBody
    #bodyDef.type = b2Body.b2_staticBody

    # Assign fixture to body and add body to 2D world
    body = @level.world.CreateBody(bodyDef)
    body.CreateFixture(fixDef)

    body

  create_right_axle: (x, y) ->
    # Create fixture
    fixDef = new b2FixtureDef()

    fixDef.shape       = new b2PolygonShape()
    fixDef.density     = 1.0
    fixDef.restitution = 0.5
    fixDef.friction    = 1.0
    fixDef.filter.groupIndex = -1

    b2vertices = [ new b2Vec2( 0.58 / @scale,  -0.02 / @scale),
                   new b2Vec2( 0.48 / @scale,  -0.02 / @scale),
                   new b2Vec2( 0.66 / @scale,  -0.58 / @scale),
                   new b2Vec2( 0.76 / @scale,  -0.58 / @scale) ]

    fixDef.shape.SetAsArray(b2vertices)

    # Create body
    bodyDef = new b2BodyDef()

    # Assign body position
    bodyDef.position.x = x / @scale
    bodyDef.position.y = y / @scale

    bodyDef.type = b2Body.b2_dynamicBody
    #bodyDef.type = b2Body.b2_staticBody

    # Assign fixture to body and add body to 2D world
    body = @level.world.CreateBody(bodyDef)
    body.CreateFixture(fixDef)

    body

  create_left_revolute_joint: ->
    jointDef = new b2RevoluteJointDef()
    jointDef.Initialize(@left_axle, @left_wheel, @left_wheel.GetWorldCenter())
    @level.world.CreateJoint(jointDef)

  create_right_revolute_joint: ->
    jointDef = new b2RevoluteJointDef()
    jointDef.Initialize(@right_axle, @right_wheel, @right_wheel.GetWorldCenter())
    @level.world.CreateJoint(jointDef)

  create_left_prismatic_joint: ->
    jointDef = new b2PrismaticJointDef()
    jointDef.Initialize(@bike_body, @left_axle, @bike_body.GetWorldCenter(), { x: 0.50, y: 0.50 } )
    jointDef.enableLimit = true
    jointDef.collideConnected = false
    @level.world.CreateJoint(jointDef)

  create_right_prismatic_joint: ->
    jointDef = new b2PrismaticJointDef()
    jointDef.Initialize(@bike_body, @right_axle, @bike_body.GetWorldCenter(), { x: 0.50, y: 0.50 } )
    jointDef.enableLimit = true
    jointDef.collideConnected = false
    @level.world.CreateJoint(jointDef)

  display_wheel: (wheel) ->
    # Position
    position = wheel.GetPosition()
    scaled_position =
      x: position.x*@scale
      y: position.y*@scale

    # Radius
    radius = wheel.GetFixtureList().GetShape().m_radius
    scaled_radius = radius*@scale

    # Angle
    angle = wheel.GetAngle()

    # Draw texture
    @level.ctx.save()
    @level.ctx.translate(scaled_position.x, scaled_position.y)
    @level.ctx.rotate(angle)

    @level.ctx.drawImage(
      @assets.get('playerbikerwheel'), # texture
      -scaled_radius, # x
      -scaled_radius, # y
       scaled_radius*2, # size-x
       scaled_radius*2  # size-y
    )

    @level.ctx.restore()

  display_body: ->
    # Position
    position = @position()

    # Angle
    angle = @bike_body.GetAngle()

    # Draw texture
    @level.ctx.save()
    @level.ctx.translate(position.x, position.y)
    @level.ctx.scale(1, -1)
    @level.ctx.rotate(-angle)

    @level.ctx.drawImage(
      @assets.get('playerbikerbody'), # texture
      -1.0,   # x
      -0.5,   # y
       2.0, # size-x
       1.0  # size-y
    )

    @level.ctx.restore()

  display_left_axle: ->
    # Position
    left_wheel_position = @left_wheel.GetPosition()
    left_wheel_position =
      x: left_wheel_position.x * @scale
      y: left_wheel_position.y * @scale

    left_axle_position =
      x: (@position().x - 0.17)
      y: (@position().y - 0.30)

    # Distance
    distance = Math.sqrt(  Math.pow(left_wheel_position.x - left_axle_position.x, 2)
                         + Math.pow(left_wheel_position.y - left_axle_position.y, 2) )

    # Angle
    angle = 0.785

    ## Draw texture
    @level.ctx.save()
    @level.ctx.translate(left_wheel_position.x, left_wheel_position.y)
    @level.ctx.scale(1, -1)
    @level.ctx.rotate(-angle)

    @level.ctx.drawImage(
      @assets.get('front1'), # texture
      0.0, # x
      0.0, # y
      distance, # size-x
      0.2  # size-y
    )

    @level.ctx.restore()
