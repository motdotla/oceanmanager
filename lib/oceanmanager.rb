class Oceanmanager
  def self.droplets
    droplets = Digitalocean::Droplet.all.try(:droplets)
    
    droplets
  end

  def self.droplets_count
    droplets.try(:length).try(:to_i) || 0
  end

  def self.images
    images = Digitalocean::Image.all(filter: "my_images").try(:images)
    
    images
  end

  def self.images_count
    images.try(:length).try(:to_i) || 0
  end
end
