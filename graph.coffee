nodes = [1, 2, 3, 4, 5, 6, 7]
edges = [
  [1, 2],
  [2, 3],
  [3, 4],
  [5, 6],
  [2, 5],
  [2, 7],
  [1, 5]]

g = new Graph()
g.addNode(label, 100 + 100 * Math.random(), 100 + 100 * Math.random()) for label in nodes
g.addEdge(edge[0], edge[1]) for edge in edges

canvas = document.getElementById('canvas')
ctx = canvas.getContext('2d')

run = ->
  g.update()
  ctx.save()
  ctx.setTransform(1, 0, 0, 1, 0, 0)
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  ctx.restore()
  g.render(ctx)
  setTimeout(run, 100)

run()
