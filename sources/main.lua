current_scene = "splash_screen" -- splash_screen, main_menu, game, end_game
total_elapsed_time = 0
DEBUG = false

config_sound_effect = 1.0
config_music = 0.25

function love.load(arg)
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
  load_assets()
  splash_screen_setup()
  main_menu_setup()
  game_setup()
  end_game_setup()
end

function load_assets()
  asset_background = love.graphics.newImage("assets/background/background.png")
  asset_background_cloud = love.graphics.newImage("assets/background/background_cloud.png")
  asset_background_stars_a = love.graphics.newImage("assets/background/background_stars_a.png")
  asset_background_stars_b = love.graphics.newImage("assets/background/background_stars_b.png")
  asset_background_stars_c = love.graphics.newImage("assets/background/background_stars_c.png")

  asset_font_bebas = love.graphics.newFont("assets/bebas.ttf", 26)
  asset_font_bebas_big = love.graphics.newFont("assets/bebas.ttf", 48)
end

-- Update ----------------------------------------------------------------------

function handle_input()
  key_up = love.keyboard.isDown("w")
  key_down = love.keyboard.isDown("s")
  key_left = love.keyboard.isDown("a")
  key_right = love.keyboard.isDown("d")

  key_attack = love.keyboard.isDown("space")
end

function love.update(delta_time)
  asset_loop:setVolume(config_music)
  handle_input()
  update_soundmanager()
  total_elapsed_time = total_elapsed_time + delta_time

  if current_scene == "splash_screen" then
    update_splash_screen(delta_time)
  elseif current_scene == "main_menu" then
    update_main_menu(delta_time)
  elseif current_scene == "game" then
    update_game(delta_time)
  elseif current_scene == "end_game" then
    update_end_game(delta_time)
  end
end

-- Draw ------------------------------------------------------------------------
function love.draw()

  love.graphics.setLineStyle("rough")

  height_scale_factor = love.graphics.getHeight() / 600
  width_scale_factor =  love.graphics.getWidth() / 800

  if current_scene == "splash_screen" then
    draw_splash_screen()
  elseif current_scene == "main_menu" then
    draw_main_menu()
  elseif current_scene == "game" then
    draw_game()
  elseif current_scene == "end_game" then
    draw_end_game()
  end
end

function draw_paralax(background_location, speed)
  love.graphics.draw(asset_background, 0, math.floor(background_location * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background, 0, math.floor(background_location * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

  love.graphics.draw(asset_background_cloud, 0, math.floor(background_location * 1.1 * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background_cloud, 0, math.floor(background_location * 1.1 * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

  love.graphics.draw(asset_background_stars_a, 0, math.floor(background_location * 1.2 * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background_stars_a, 0, math.floor(background_location * 1.2 * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

  love.graphics.draw(asset_background_stars_b, 0, math.floor(background_location * 1.5 * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background_stars_b, 0, math.floor(background_location * 1.5 * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

  love.graphics.draw(asset_background_stars_c, 0, math.floor(background_location * 1.9 * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background_stars_c, 0, math.floor(background_location * 1.9 * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

end

-- splash screen -------------------------------------------------------------------

splash_time = 0

function splash_screen_setup()
  asset_maker_logo = love.graphics.newImage("assets/logos/maker.png")
end

function update_splash_screen(delta_time)
  splash_time = splash_time + delta_time

  if splash_time > 4 or key_attack then
    main_menu_switch()
  end
end

function draw_splash_screen()
  draw_paralax(total_elapsed_time, 32)
  love.graphics.rectangle("line", 4, 4, love.graphics.getWidth() - 8, love.graphics.getHeight() - 8)
  love.graphics.setColor(255,255,255, math.min(255, 255 * math.sin(splash_time)))
  love.graphics.draw(asset_maker_logo, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 0.5, 0.5, asset_maker_logo:getWidth() / 2, asset_maker_logo:getHeight() / 2)
  love.graphics.print("Present a game made in 48Hours for the 39th \"Ludum Dare\".", love.graphics.getWidth() / 2 - asset_maker_logo:getWidth() / 4 - 32, love.graphics.getHeight() / 2 + 64)
  love.graphics.setColor(255,255,255,255)
end

-- Main Menu -------------------------------------------------------------------
function main_menu_switch()
  asset_loop:setPitch(0.1)
  asset_loop:play()

  current_scene = "main_menu"
  menu_fade = 0
  fade_out = false
end

function main_menu_setup()
  asset_game_logo = love.graphics.newImage("assets/logos/game_logo.png")
  asset_help = love.graphics.newImage("assets/overlays/help.png")
  asset_loop = love.audio.newSource("assets/sound_effects/loop_b.wav")
end

function update_main_menu(delta_time)
  if fade_out then
    menu_fade = math.max(0, menu_fade - 5)
    asset_loop:setPitch( 0.6 + (menu_fade / 255) / 2)
  else
    menu_fade = math.min(255,menu_fade + 5)
    asset_loop:setPitch(0.1 + menu_fade / 255)
  end

  if menu_fade < 1 then
    game_switch()
  end
end

function draw_main_menu()
  draw_paralax(total_elapsed_time, 32)

  love.graphics.rectangle("line", 4, 4, love.graphics.getWidth() - 8, love.graphics.getHeight() - 8)
  love.graphics.setColor(255,255,255, math.min(255, menu_fade))
  love.graphics.draw(asset_game_logo, 32, 32)
  love.graphics.draw(asset_help, love.graphics.getWidth() - asset_help:getWidth(), love.graphics.getHeight() - asset_help:getHeight(), 0, 1, 1)

  if button("play", 32 + 76, asset_game_logo:getHeight() + 16, 400, 32) and not fade_out then
    fade_out = true
  end

  love.graphics.setColor(255,255,255, math.min(255, menu_fade))

  if button("exit", 32 + 76, asset_game_logo:getHeight() + 16 + 32 + 16, 400, 32) then
    love.event.quit()
  end

  love.graphics.setColor(255,255,255,255)
  love.graphics.print("Sounds effects:", 32, love.graphics.getHeight() - 64)
  config_sound_effect = slider(config_sound_effect, 1, 32, love.graphics.getHeight() - 48, 256, 16)

  love.graphics.setColor(255,255,255,255)
  love.graphics.print("Music:", 32 + 256 + 16, love.graphics.getHeight() - 64)
  config_music = slider(config_music, 1, 32 + 256 + 16 , love.graphics.getHeight() - 48, 256, 16)
  love.graphics.setColor(255,255,255,255)
end

-- Game ------------------------------------------------------------------------

function game_switch()
  current_scene = "game"
  setup_space_ship()


  game = {}
  game.progress = 0
  game.max_progress = 10000
  asset_speedup:setVolume(0)
  asset_speedup:play()
  asset_speedup:setLooping(true)
  game.entities = {}
  game.entities_count = 0
  game.score = 0
end

function game_setup()
  -- spaceship -----------------------------------------------------------------
  asset_spaceship = love.graphics.newImage("assets/spaceship/spaceship.png")
  asset_truster = love.graphics.newImage("assets/spaceship/truster.png")
  asset_bullet = love.graphics.newImage("assets/spaceship/bullet.png")
  asset_shield = love.graphics.newImage("assets/spaceship/shield.png")
  asset_damage_overlay = love.graphics.newImage("assets/overlays/damage_overlay.png")

  asset_speedup = love.audio.newSource("assets/sound_effects/speed_up.wav", "stream")

  entities_setup()
end

function update_game(delta_time)
  update_spawning(delta_time)
  update_spaceship_bullet(delta_time)
  update_entities(delta_time)
  update_spaceship(delta_time)

  if (spaceship.heal < 1) or (spaceship.power < 1) then
    end_game_switch()
  end

  if not asset_loop:isPlaying() then
    asset_loop = love.audio.newSource("assets/sound_effects/loop_b.wav", "stream")
    asset_loop:setLooping(true)
    asset_loop:play()
  end
end

function draw_game()
  draw_paralax(game.progress, 0.25)
  draw_spaceship_bullet()
  draw_spaceship()
  draw_entities()
  draw_gui()
  love.graphics.setColor(255, 255, 255, spaceship.damage_cooldown)
  love.graphics.draw(asset_damage_overlay, 0, 0, 0, width_scale_factor, height_scale_factor)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("line", 4, 4, love.graphics.getWidth() - 8, love.graphics.getHeight() - 8)
end

-- GUI -------------------------------------------------------------------------
function draw_gui()
  if DEBUG then
    love.graphics.print("Fps: ".. love.timer.getFPS(), 16, 16)
    love.graphics.print("Entities Count: ".. entities_counter, 16, 32)
  end

  local progress_bar_spacecing = 32
  local progress_bar_width = (love.graphics.getWidth() - 4 * progress_bar_spacecing) / 3
  local progress_bar_y = love.graphics.getHeight() - progress_bar_spacecing - 16

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("Heal:", progress_bar_spacecing, progress_bar_y - 16)
  love.graphics.print("Power:", progress_bar_spacecing * 2 + progress_bar_width, progress_bar_y - 16)
  love.graphics.print("Speed:", progress_bar_spacecing * 3 + progress_bar_width * 2, progress_bar_y - 16)

  local heal_raciot = spaceship.heal / spaceship.max_heal
  local power_raciot = spaceship.power / spaceship.max_power
  local speed_raciot = spaceship.speed.y / spaceship.max_speed.y

  if spaceship.fever then
    heal_raciot = 1
    love.graphics.setColor(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
  else
    love.graphics.setColor(255 - 255 * heal_raciot, 255 * heal_raciot, 0, 255)
  end

  progress_bar(heal_raciot, 1, progress_bar_spacecing, progress_bar_y, progress_bar_width, 16)

  love.graphics.setColor(255, 255, 255, 255)
  progress_bar(power_raciot, 1, progress_bar_spacecing * 2 + progress_bar_width, progress_bar_y, progress_bar_width, 16)

  love.graphics.setColor(255, 255, 255, 255)
  progress_bar(speed_raciot, 1, progress_bar_spacecing * 3 + progress_bar_width * 2, progress_bar_y, progress_bar_width, 16)

  love.graphics.setColor(255, 255, 255, 255)
end
-- Spaceship -------------------------------------------------------------------

function setup_space_ship()
  spaceship = {}

  spaceship.fever = false

  spaceship.heal = 50
  spaceship.max_heal = 100
  spaceship.max_fever_heal = 110

  spaceship.max_power = 10000
  spaceship.power = 10000

  spaceship.cooldown = 20
  spaceship.cooldown_time = 20

  spaceship.damage_cooldown = 0

  spaceship.shooted_bullet = {}
  spaceship.shooted_bullet_count = 1

  spaceship.speed = {}
  spaceship.speed.y = 0
  spaceship.speed.x = 0
  spaceship.speed_up_y = false
  spaceship.speed_up_x = false

  spaceship.max_speed = {}
  spaceship.max_speed.y = 10
  spaceship.max_speed.x = 10

  spaceship.x = love.graphics.getWidth() / 2 - 32
  spaceship.y = love.graphics.getHeight() - 128

  spaceship.width = 64
  spaceship.height = 64

  spaceship.bullet_speed = 10
end

function update_spaceship(delta_time)
  -- Moves ---------------------------------------------------------------------
  spaceship.speed_up_y = false
  spaceship.speed_up_x = false

  if key_up then
    spaceship.speed.y = spaceship.speed.y + 5 * delta_time
    spaceship.speed_up_y = true
  end

  if key_down then
    spaceship.speed.y = spaceship.speed.y - 5 * delta_time
    spaceship.speed_up_y = true
  end

  if key_left then
    spaceship.speed.x = spaceship.speed.x - 100 * delta_time
    -- spaceship.speed.x = -spaceship.max_speed.x
    spaceship.speed_up_x = true
  end

  if key_right then
    spaceship.speed.x = spaceship.speed.x + 100 * delta_time
    -- spaceship.speed.x = spaceship.max_speed.x
    spaceship.speed_up_x = true
  end

  -- check speed x -------------------------------------------------------------
  if not spaceship.speed_up_x then
    spaceship.speed.x = spaceship.speed.x * 0.75
  end

  if spaceship.speed.x > spaceship.max_speed.x then
    spaceship.speed.x = spaceship.max_speed.x
  end

  if spaceship.speed.x < -spaceship.max_speed.x then
    spaceship.speed.x = -spaceship.max_speed.x
  end

  -- Check speed y -------------------------------------------------------------
  if spaceship.speed.y > spaceship.max_speed.y then
    spaceship.speed.y = spaceship.max_speed.y
  end

  if spaceship.speed.y < 0 then
    spaceship.speed.y = 0
  end

  spaceship.x = spaceship.x + spaceship.speed.x
  game.progress = game.progress + spaceship.speed.y

  if spaceship.x < 0 then spaceship.x = 0 end
  if spaceship.x > love.graphics.getWidth() - spaceship.width then spaceship.x = love.graphics.getWidth() - spaceship.width end

  -- bullet shooting -----------------------------------------------------------
  if not (spaceship.cooldown == 0) then spaceship.cooldown = spaceship.cooldown - 1 end

  if key_attack and (spaceship.cooldown == 0) then
    spaceship_shoot_bullet(spaceship.x + spaceship.width / 2 - 2)
  end

  -- Damage cooldown -----------------------------------------------------------
  if spaceship.damage_cooldown > 0 then
    spaceship.damage_cooldown = spaceship.damage_cooldown * 0.9
  end

  -- Check heal ----------------------------------------------------------------
  if spaceship.heal > spaceship.max_fever_heal then
    spaceship.heal = spaceship.max_fever_heal
  end

  spaceship.fever = spaceship.heal > spaceship.max_heal

  -- update power lost ---------------------------------------------------------
  spaceship.power = spaceship.power - 60 * delta_time
  if spaceship.speed_up_y then
    spaceship.power = spaceship.power - spaceship.speed.y
  end

  -- sound effects -------------------------------------------------------------
  asset_speedup:setVolume(((spaceship.speed.y / spaceship.max_speed.y) / 2) * config_sound_effect)
  asset_speedup:setPitch(1 + (spaceship.speed.y / spaceship.max_speed.y) / 2)

  asset_loop:setPitch(0.1 + spaceship.heal / spaceship.max_heal)
end

function draw_spaceship()
  local size_factor = spaceship.speed.y / spaceship.max_speed.y

  -- Draw spaceship hitbox.
  if DEBUG then love.graphics.rectangle("line", spaceship.x, spaceship.y, spaceship.width, spaceship.height) end

  -- draw the spaceship
  love.graphics.push()
  love.graphics.translate(math.random(-50, 50) / 50 * size_factor, 0)
  love.graphics.draw(asset_spaceship, spaceship.x, spaceship.y, 0, 2, 2 - (size_factor) / 5)

  love.graphics.setColor(255,255,255,255 * size_factor)
  love.graphics.draw(asset_truster, spaceship.x, spaceship.y, 0, 2, 2  - (size_factor) / 5)

  love.graphics.setColor(255, 255, 255, spaceship.damage_cooldown)
  love.graphics.draw(asset_shield, spaceship.x, spaceship.y - 10, 0, 2, 2  - (size_factor) / 5)

  love.graphics.setColor(255,255,255,255)
  love.graphics.pop()
end

-- spaceship shoot -------------------------------------------------------------
function spaceship_shoot_bullet(x)
  soundmanager_play("assets/sound_effects/shoot.wav")

  spaceship.shooted_bullet[spaceship.shooted_bullet_count] = {x = x + math.random(0, 10) - 5, y = love.graphics.getHeight() - 100, size = 4}
  spaceship.shooted_bullet_count = spaceship.shooted_bullet_count + 1
  if spaceship.fever then
    spaceship.power = spaceship.power - 10
    spaceship.cooldown = spaceship.cooldown_time / 2
  else
    spaceship.power = spaceship.power - 30
    spaceship.cooldown = spaceship.cooldown_time
  end

end

function update_spaceship_bullet()
  for i,e in pairs(spaceship.shooted_bullet) do
    if e.y < -256 then spaceship.shooted_bullet[i] = nil
    else
      e.y = e.y - spaceship.bullet_speed

      for i=0,10 do
        local brightness = math.random(50, 100) / 100
        emite_particle("dot", e.x + 2, e.y, math.random(1, 2), (100 - math.random(0, 200)) / 500, (100 - math.random(0, 200)) / 100, math.random(1, 6) / 20, 255 * brightness, 255, 255)
      end

      for k,v in pairs(game.entities) do
        if CheckCollision (e.x,e.y,e.size,e.size, v.x,v.y,v.width,v.height ) then
          if entity_colide_spaceship_shoot(v, i) then
            for i=0,10 do
              local brightness = math.random(50, 100) / 100
              emite_particle("dot", e.x + 2, e.y, math.random(1, 3), (50 - math.random(0, 100)) / 10,(50 - math.random(0, 100)) / 10, math.random(0, 50) / 100, 255 * brightness, 255, 255)
            end
          end
        end
      end
    end
  end
end

function draw_spaceship_bullet()
  for i,e in pairs(spaceship.shooted_bullet) do
    love.graphics.draw(asset_bullet, e.x - 2, e.y - 2, 0, 2, 2)
    if DEBUG then love.graphics.rectangle("line", e.x, e.y, e.size, e.size) end
  end
end

-- Entities --------------------------------------------------------------------

function entities_setup()
  -- Load ressource ------------------------------------------------------------
  asset_asteroid = love.graphics.newImage("assets/ennemies/asteroid.png")
  asset_asteroid_frag = love.graphics.newImage("assets/particles/asteroid_frag.png")
  asset_ennemy_asteroid_frag = love.graphics.newImage("assets/ennemies/asteroid_frag.png")
  asset_heal_pack = love.graphics.newImage("assets/power_up/healpack.png")
  asset_power_pack = love.graphics.newImage("assets/power_up/powerpack.png")
  asset_spacestation = love.graphics.newImage("assets/ennemies/spacestation.png")
  asset_spacestation_big_frag = love.graphics.newImage("assets/ennemies/spacestation_big_frag.png")
  asset_spacestation_right = love.graphics.newImage("assets/ennemies/spacestation_right.png")
end

function create_entity(type, x, y, speed_x, speed_y, life_time, atribut)
  local entity = {id = game.entities_count,
                  type = type,
                  x = x,
                  y = y,
                  width = 64,
                  height = 64,
                  rotation = 0,
                  rotation_speed = 0,
                  speed = {x = speed_x,
                           y = speed_y},

                  life_time = 0,
                  max_life_time = life_time,
                  atribut = atribut,

                  is_coliding = false,
                  no_colide = false
                  }

  game.entities_count = game.entities_count + 1

  -- Define entity here --------------------------------------------------------
  if type == "asteroid" then
    entity.rotation_speed = math.random(-100, 100) / 1000
  end

  if type == "asteroid_frag" then
    entity.rotation_speed = math.random(-100, 100) / 1000
  end

  if type == "particle" then
    entity.width = 8
    entity.height = 8
    entity.no_colide = true
  end

  if (type == "heal_pack") or (type == "power_pack") then
    entity.width = 32
    entity.height = 32
    entity.rotation_speed = math.random(-100, 100) / 1000
  end

  if type == "spacestation" then
    entity.width = 652
    entity.height = 86
    entity.heal = 2
  end

  if type == "spacestation_big_frag" then
    entity.width = 194
    entity.height = 86
  end

  return entity
end

-- Entity spwning --------------------------------------------------------------

function update_spawning(delta_time)

  spawn_factor = ((spaceship.speed.y / spaceship.max_speed.y) * width_scale_factor)

  if (game.progress > game.max_progress * 0.01) then
    if (math.random(0, math.floor(25 / spawn_factor)) == 0) then
      add_entity(create_entity("asteroid", math.random(0, love.graphics.getWidth()), -128, 0, 0, 600))
    end

    if (math.random(0, math.floor(500 / spawn_factor)) == 0) then
      if math.random(0, 2) == 0 then --right
        add_entity(create_entity("spacestation", love.graphics.getWidth() - math.random(300, 652), -128, 0, 0, 600, "right"))
      else -- left
        add_entity(create_entity("spacestation", -math.random(0, 300), -128, 0, 0, 600, "left"))
      end
    end
  end
end

-- Draw entity -----------------------------------------------------------------
function draw_entities()
  for k,v in pairs(game.entities) do
    if DEBUG then
      if v.is_coliding then
        love.graphics.setColor(255,0,0,255)
      end

      love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
      love.graphics.setColor(255,255,255,255)
    end
    if v.type == "asteroid" then
      love.graphics.draw(asset_asteroid, v.x + 32, v.y + 32, v.rotation, 2, 2, 16, 16)
    end

    if v.type == "asteroid_frag" then
      love.graphics.draw(asset_ennemy_asteroid_frag, v.x + 32, v.y + 32, v.rotation, 2, 2, 16, 16)
    end

    if v.type == "particle" then
      love.graphics.setColor(v.atribut.red, v.atribut.green, v.atribut.blue, ((v.max_life_time - v.life_time) / v.max_life_time) * 255)
      if v.atribut.particle_type == "dot" then
        love.graphics.setPointSize(v.atribut.size)
        love.graphics.points(v.x, v.y)
        love.graphics.setPointSize(1)
      end

      if v.atribut.particle_type == "asteroid_frag" then
        love.graphics.draw(asset_asteroid_frag, v.x + 16, v.y + 16, v.rotation, 2, 2, 8, 8)
      end

      love.graphics.setColor(255,255,255,255)
    end

    if v.type == "power_pack" then
      love.graphics.draw(asset_power_pack, v.x + 16, v.y + 16, v.rotation, 2, 2, 8, 8)
    end

    if v.type == "heal_pack" then
      love.graphics.draw(asset_heal_pack, v.x + 16, v.y + 16, v.rotation, 2, 2, 8, 8)
    end

    if v.type == "spacestation_big_frag" then
      love.graphics.draw(asset_spacestation_big_frag, v.x, v.y, 0, 2, 2)
    end

    if v.type == "spacestation" then
      if v.atribut == "right" then
        love.graphics.draw(asset_spacestation_right, v.x, v.y, 0, 2, 2)
      else
        love.graphics.draw(asset_spacestation, v.x, v.y, 0, 2, 2)
      end
    end
  end
end

-- Update Entity ---------------------------------------------------------------
function update_entities(delta_time)
  for _,v in pairs(game.entities) do
    if v.life_time > v.max_life_time or v.y > love.graphics.getHeight() + 512 then
      remove_entity(v)
    else
      v.life_time = v.life_time + delta_time
      v.y = v.y + spaceship.speed.y + v.speed.y
      v.x = v.x + v.speed.x
      v.rotation = v.rotation + v.rotation_speed
      v.is_coliding = false
      -- Entity logic here -----------------------------------------------------
      if v.type == "asteroid" then

      end

      -- Check collision with the spaceship ------------------------------------
      if CheckCollision(v.x,v.y, v.width, v.height, spaceship.x, spaceship.y, spaceship.height, spaceship.width) and not v.no_colide then
        entity_colide_spaceship(v)
        v.is_coliding = true
      end

      -- Check collision with other entities -----------------------------------
      if not v.no_colide then
        for _,e in pairs(game.entities) do
          if CheckCollision(v.x,v.y, v.width, v.height, e.x, e.y, e.height, e.width) and not (e.id == v.id) and not e.no_colide then
            entity_colide_entity(v, e)
            v.is_coliding = true
          end
        end
      end
    end
  end
end

-- Entities interaction --------------------------------------------------------

function entity_colide_entity(entity_a, entity_b)

end

function entity_colide_spaceship(entity)
  if entity.type == "asteroid" then
    soundmanager_play("assets/sound_effects/explosion.wav")
    spaceship.heal = spaceship.heal - 10
    spaceship.power = spaceship.power - 100
    spaceship.damage_cooldown = 255
    destroy_entity(entity)
  end

  if entity.type == "spacestation_big_frag" then
    soundmanager_play("assets/sound_effects/explosion.wav")
    spaceship.heal = spaceship.heal - 10
    spaceship.power = spaceship.power - 100
    spaceship.damage_cooldown = 255
    destroy_entity(entity)
  end

  if entity.type == "asteroid_frag" then
    soundmanager_play("assets/sound_effects/explosion.wav")
    spaceship.heal = spaceship.heal - 1
    spaceship.power = spaceship.power - 10
    spaceship.damage_cooldown = 255
    destroy_entity(entity)
  end

  if entity.type == "heal_pack" then
    spaceship.heal = spaceship.heal + 10
    destroy_entity(entity)
  end

  if entity.type == "power_pack" then
    spaceship.power = spaceship.power + 500
    destroy_entity(entity)
  end

  if entity.type == "spacestation" then
    soundmanager_play("assets/sound_effects/explosion.wav")
    spaceship.heal = spaceship.heal / 3
    spaceship.power = spaceship.power - 300
    spaceship.damage_cooldown = 255
    destroy_entity(entity)
  end
end

function entity_colide_spaceship_shoot(entity, shoot)
  if entity.type == "asteroid" then
    soundmanager_play("assets/sound_effects/explosion.wav")
    destroy_entity(entity)
    if math.random(0, 5) == 0 then
      add_entity(create_entity("heal_pack", entity.x + 16, entity.y + 16,math.random(-100, 100) / 100,math.random(-100, 100) / 100 , 5))
    end

    add_entity(create_entity("asteroid_frag", entity.x + 16, entity.y + 16,math.random(-100, 100) / 100,math.random(-100, 100) / 100 , 5))


    if math.random(0, 5) == 0 then
      add_entity(create_entity("power_pack", entity.x + 16, entity.y + 16,math.random(-100, 100) / 100,math.random(-100, 100) / 100 , 5))
    end
    spaceship.shooted_bullet[shoot] = nil
    return true
  end

  if entity.type == "spacestation_big_frag" then
    soundmanager_play("assets/sound_effects/explosion.wav")
    destroy_entity(entity)
    if math.random(0, 2) == 0 then
      add_entity(create_entity("heal_pack", entity.x + 16, entity.y + 16,math.random(-100, 100) / 100,math.random(-100, 100) / 100 , 5))
    end
    if math.random(0, 2) == 0 then
      add_entity(create_entity("power_pack", entity.x + 16, entity.y + 16,math.random(-100, 100) / 100,math.random(-100, 100) / 100 , 5))
    end
    spaceship.shooted_bullet[shoot] = nil
    return true
  end

  if entity.type == "asteroid_frag" then
    if math.random(0, 5) == 0 then
      add_entity(create_entity("heal_pack", entity.x + 16, entity.y + 16,math.random(-100, 100) / 100,math.random(-100, 100) / 100 , 5))
    end
    if math.random(0, 5) == 0 then
      add_entity(create_entity("power_pack", entity.x + 16, entity.y + 16,math.random(-100, 100) / 100,math.random(-100, 100) / 100 , 5))
    end
    soundmanager_play("assets/sound_effects/explosion.wav")
    destroy_entity(entity)
    spaceship.shooted_bullet[shoot] = nil
    return true
  end

  if entity.type == "spacestation" then
    soundmanager_play("assets/sound_effects/explosion.wav")
    entity.heal = entity.heal - 1

    if entity.heal == 0 then
      destroy_entity(entity)

      for i=0,math.random(0, 5) do
        add_entity(create_entity("spacestation_big_frag", entity.x + math.random(0, 657), entity.y, math.random(-100, 100) / 100, math.random(-100, 100) / 100 , 500))
      end
    end

    spaceship.shooted_bullet[shoot] = nil
    return true
  end
end

function destroy_entity(entity)
  -- asteroid ------------------------------------------------------------------
  if entity.type == "asteroid" then
    remove_entity(entity)

    for i=1,10 do
      local brightness = math.random(50, 100) / 100
      emite_particle("dot", entity.x + 32, entity.y + 32, 4, math.random(-100, 100) / 100, (-math.random(0, 500)) / 100, 1 * math.random(50, 100) / 100, 86 * brightness, 68 * brightness, 58 * brightness)
    end
    for i=1,4 do
      emite_particle("asteroid_frag", entity.x + 32, entity.y + 32, 4, math.random(-100, 100) / 100, (-math.random(0, 500)) / 100, 1 * math.random(50, 100) / 100, 255, 255, 255)
    end
  end

  if entity.type == "asteroid_frag" then
    remove_entity(entity)

    for i=1,50 do
      local brightness = math.random(50, 100) / 100
      emite_particle("dot", entity.x + 32, entity.y + 32, math.random(0, 10), math.random(-100, 100) / 100, (-math.random(0, 500)) / 100, 1 * math.random(50, 100) / 100, 86 * brightness, 68 * brightness, 58 * brightness)
    end
  end

  if entity.type == "heal_pack" then
    soundmanager_play("assets/sound_effects/healpack.wav")
    remove_entity(entity)


    for i=1,10 do
      local brightness = math.random(50, 100) / 100
      emite_particle("dot", entity.x + 32, entity.y + 32, 4, math.random(-100, 100) / 100, (-math.random(-100, 100)) / 100, 1 * math.random(50, 100) / 100, 255 * brightness, 255 * brightness, 255 * brightness)
    end

    for i=1,10 do
      local brightness = math.random(50, 100) / 100
      emite_particle("dot", entity.x + 32, entity.y + 32, 4, math.random(-100, 100) / 100, (math.random(-100, 100)) / 100, 1 * math.random(50, 100) / 100, 255 * brightness, 0, 0)
    end
  end

  if entity.type == "power_pack" then
    soundmanager_play("assets/sound_effects/powerpack.wav")
    remove_entity(entity)

    for i=1,10 do
      local brightness = math.random(50, 100) / 100
      emite_particle("dot", entity.x + 32, entity.y + 32, 4, math.random(-100, 100) / 100, (-math.random(0, 500)) / 100, 1 * math.random(50, 100) / 100, 255 * brightness, 255 * brightness, 0)
    end
  end

  if entity.type == "spacestation" then
    remove_entity(entity)

    for i=1,100 do
      local brightness = math.random(50, 100) / 100
      emite_particle("dot", entity.x + math.random(0, 652), entity.y + 32, 4, math.random(-100, 100) / 100, (-math.random(0, 500)) / 100, 1 * math.random(50, 100) / 100, 255 * brightness, 255 * brightness, 255 * brightness)
    end
  end

  if entity.type == "spacestation_big_frag" then
    remove_entity(entity)

    for i=1,50 do
      local brightness = math.random(50, 100) / 100
      emite_particle("dot", entity.x + math.random(0, 194), entity.y + 32, 4, math.random(-100, 100) / 100, (-math.random(0, 500)) / 100, 1 * math.random(50, 100) / 100, 255 * brightness, 255 * brightness, 255 * brightness)
    end
  end
end

-- Entity managment ------------------------------------------------------------
entities_counter = 0
function add_entity(entity)
  entities_counter = entities_counter + 1
  game.entities[entity.id] = entity
end

function remove_entity(entity)
  entities_counter = entities_counter - 1
  game.entities[entity.id] = nil
end

function emite_particle(type, x, y, size, speed_x, speed_y, life_time, red, green, blue)
  add_entity(create_entity("particle", x, y, speed_x, speed_y, life_time, {particle_type = type, size = size, red = red, green = green, blue = blue}))
end

-- End Game Screen -------------------------------------------------------------
function end_game_switch()
  current_scene = "end_game"
  asset_speedup:stop()
end

function end_game_setup()

    text_game_over = love.graphics.newText( asset_font_bebas_big, "Game Over" )

end

function update_end_game()

end

function draw_end_game()
  draw_paralax(game.progress, 0.25)
  draw_spaceship_bullet()
  draw_entities()

  love.graphics.draw(text_game_over, love.graphics.getWidth() / 2 - text_game_over:getWidth() / 2, love.graphics.getHeight() / 2 - text_game_over:getHeight() / 2)
  love.graphics.rectangle("line", love.graphics.getWidth() / 2 - text_game_over:getWidth() / 2 - 16, love.graphics.getHeight() / 2 - text_game_over:getHeight() / 2 - 6 - 16, text_game_over:getWidth() + 32, text_game_over:getHeight() + 32)

  love.graphics.rectangle("line", 4, 4, love.graphics.getWidth() - 8, love.graphics.getHeight() - 8)

  if button("Try Egain", love.graphics.getWidth() / 2 - text_game_over:getWidth() / 2 - 16, love.graphics.getHeight() / 2 + 64, text_game_over:getWidth() + 32, 32) then
    game_switch()
  end

  if button("Main Menu", love.graphics.getWidth() / 2 - text_game_over:getWidth() / 2 - 16, love.graphics.getHeight() / 2 + 64 + 64, text_game_over:getWidth() + 32, 32) then
    main_menu_switch()
  end
end

-- GUI -------------------------------------------------------------------------

function progress_bar(value, max_value, x, y, width, height)
  love.graphics.rectangle("line", x + 1, y + 1, width - 1, height - 1)
  love.graphics.rectangle("fill", x + 4, y + 4, (width - 8) * (value / max_value), height - 8)
end

function slider(value, max_value, x, y, width, height)
  new_value = value
  if CheckCollision(x, y, width, height, love.mouse.getX(), love.mouse.getY(), 1, 1) then
    love.graphics.setColor(255, 216, 0, 255)

    if love.mouse.isDown(1) then
      new_value = (love.mouse.getX() - x) / width * max_value
    end
  end

  love.graphics.rectangle("line", x + 1, y + 1, width - 1, height - 1)
  love.graphics.rectangle("fill", x + 4, y + 4, (width - 8) * (value / max_value), height - 8)

  love.graphics.setColor(255, 255, 255, 255)

  return new_value
end

function button(text, x, y, width, height)

  if CheckCollision(x, y, width, height, love.mouse.getX(), love.mouse.getY(), 1, 1) then
    love.graphics.setColor(255, 216, 0, 255)
  end

  love.graphics.rectangle("line", x, y, width, height)
  local text = love.graphics.newText( asset_font_bebas, text )
  love.graphics.draw(text, x + width / 2 - text:getWidth() / 2, y + height / 2 - text:getHeight() / 2 + 2)
  love.graphics.setColor(255, 255, 255, 255)

  return CheckCollision(x, y, width, height, love.mouse.getX(), love.mouse.getY(), 1, 1) and love.mouse.isDown(1)
end

-- Sound Manager ---------------------------------------------------------------

soundmanager_sources = {}

function update_soundmanager()

  local remove = {}
  for _,s in pairs(soundmanager_sources) do
      if s:isStopped() then
          remove[#remove + 1] = s
      end
  end

  for i,s in ipairs(remove) do
      soundmanager_sources[s] = nil
  end
end

function soundmanager_play(source)
  src = love.audio.newSource(source, "stream")
  src:setVolume(config_sound_effect)
  src:play()
  soundmanager_sources[source] = src
end

-- Utils -----------------------------------------------------------------------
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
