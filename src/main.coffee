$ ->
  level = new Level()
  level.load_from_file('l1038.lvl') # l9562.lvl  # l1287.lvl (snake) # l1038
  level.init_input()

  # Load assets for this level before doing anything else
  level.assets.load( ->
    update = ->
      level.world.Step(1 / 60,  10, 10)
      level.world.ClearForces()
      level.display()
      l#evel.world.DrawDebugData()

    # Render 2D environment
    setInterval(update, 1000 / 60)
  )
