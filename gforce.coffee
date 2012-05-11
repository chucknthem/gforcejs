K = 100 # Coulomb's constant
D = .1  # Damping factor
S = 50  # length of spring
k = .05 # spring constant

class Node
  constructor: (@label, @x, @y) ->
    @outNodes = []
    @size = 10
    @charge = -1
    @velocity = [0, 0]

  addOutNode: (node) ->
    @outNodes.push(node)

  damp: (factor) ->
    xfactor = Math.min(factor, Math.abs(@velocity[0]))
    yfactor = Math.min(factor, Math.abs(@velocity[1]))
    xfactor = -xfactor if @velocity[0] > 0
    yfactor = -yfactor if @velocity[1] > 0

    @velocity[0] += xfactor
    @velocity[1] += yfactor

  update: ->
    @x += @velocity[0]
    @y += @velocity[1]
    @damp(D)

  render: (ctx) ->
    ctx.strokeStyle = '#000'
    ctx.beginPath()
    ctx.arc(@x, @y, @size, 0, Math.PI*2, true)
    ctx.stroke()

    for node in @outNodes
      ctx.beginPath()
      ctx.moveTo(node.x, node.y)
      ctx.lineTo(@x, @y)
      ctx.stroke()


class Graph
  constructor: ->
    @nodes = {}

  addNode: (label, x, y) ->
    @nodes[label] = new Node(label, x, y)

  addEdge: (from, to) ->
    @nodes[from].addOutNode(@nodes[to])
    @nodes[to].addOutNode(@nodes[from])
  
  prod: (x1, y1, x2, y2) ->
    return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)

  update: ->
    for label, node of @nodes
      direction = [0, 0]
      for label, otherNode of @nodes
        continue if node is otherNode
        # Coulomb's repulsion
        distSquared = @prod node.x, node.y, otherNode.x, otherNode.y
        force = K * node.charge * otherNode.charge / distSquared
        angle = Math.atan2(node.y - otherNode.y, node.x - otherNode.x)
        direction[0] += force * Math.cos(angle) if force
        direction[1] += force * Math.sin(angle) if force

      # Hooke's spring attraction
      for otherNode in node.outNodes
        distSquared = @prod node.x, node.y, otherNode.x, otherNode.y
        angle = Math.atan2(node.y - otherNode.y, node.x - otherNode.x)
        force = -.05 * (Math.sqrt(distSquared) - S)
        direction[0] += force * Math.cos(angle)
        direction[1] += force * Math.sin(angle)

      node.velocity[0] += direction[0]
      node.velocity[1] += direction[1]

      node.update()

  render: (ctx) ->
    for label, node of @nodes
      node.render(ctx)

