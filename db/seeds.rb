Admin.destroy_all
Collection.destroy_all
Plate.destroy_all

begin
  Admin.create!(
    name: 'Admin',
    surname: 'User',
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password'
  )
  puts "Admin created successfully"
rescue => e
  puts "Error creating admin: #{e.message}"
end

begin
  collection = Collection.create!(
    title: '3D WALL DESIGN',
    description: 'Богатая гамма трехмерных покрытий для придания стенам элегантной и стильной многогранности. Коллекция 3D Wall Design украшает просто и изысканно любой тип интерьера. На ее плитках из белой глины рельефно выступают многообразные декоративные мотивы, и именно они под воздействием освещения рождают на стенах завораживающую игру света и тени. Яркие скульптурные эффекты плитки могут стать стильным и функциональным украшением стен в велнес-пространствах, СПА-салонах, гостиницах, кафе, ресторанах, магазинах.',
    publish: true
  )
  puts "Collection created successfully"

  hall_image_path = Rails.root.join("app", "assets", "images", "hall.png")

  if File.exist?(hall_image_path)
    begin
      collection.images.attach(
        io: File.open(hall_image_path),
        filename: 'hall.png',
        content_type: 'image/png'
      )
      puts "Collection image attached"
    rescue => e
      puts "Error attaching collection image: #{e.message}"
    end
  else
    puts "Warning: Collection image file not found at #{hall_image_path}"
  end

  %w[
      flash_night stars_white wind_white
      flake_white twist_sage plot_white_matt_110
      kite_white_matt_110 angle_white_matt_80 mesh_white_matt_80
      dune_sand_matt_80 ultra_blade_white ine_white_matt_56
  ].each_with_index do |image, index|
    begin
      plate = collection.plates.create!(
        title: image.gsub("_", " "),
        order: index
      )
      puts "Plate '#{plate.title}' created"

      image_path = Rails.root.join("app", "assets", "images", "#{image}.jpg")

      if File.exist?(image_path)
        begin
          plate.image.attach(
            io: File.open(image_path),
            filename: "#{image}.jpg",
            content_type: 'image/jpeg'
          )
          puts "Image attached to plate '#{plate.title}'"
        rescue => e
          puts "Error attaching image to plate '#{plate.title}': #{e.message}"
        end
      else
        puts "Warning: Plate image file not found at #{image_path}"
      end
    rescue => e
      puts "Error creating plate '#{image.gsub("_", " ")}': #{e.message}"
    end
  end
rescue => e
  puts "Error creating collection: #{e.message}"
end
