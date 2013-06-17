class Oceanmanager
  def self.droplets
    droplets = Digitalocean::Droplet.all.try(:droplets)
    
    droplets.select { |droplet| droplet.name.starts_with?(OCEANMANAGER_LEADING_NAME) }
  end

  def self.droplets_count
    droplets.try(:length).try(:to_i) || 0
  end

  def self.images
    images = Digitalocean::Image.all(filter: "my_images").try(:images)
    
    images.select { |image| image.name.starts_with?(OCEANMANAGER_LEADING_NAME) }
  end

  def self.images_count
    images.try(:length).try(:to_i) || 0
  end

  def self.create_image(id=droplets.first.id)
    Digitalocean::Droplet.power_off(id)
    sleep 60
    
    Digitalocean::Droplet.snapshot(id)
  end

  def self.create_droplet(image_id=images.first.id)
    size_id     = 62 # 2 GB Server
    region_id   = 1 # new york
    ssh_key_id  = Digitalocean::SshKey.all.try(:ssh_keys).try(:first).try(:id)
    name        = [OCEANMANAGER_LEADING_NAME, Time.now.utc.to_i].join

    attrs = {
      :name           => name,
      :size_id        => size_id,
      :image_id       => image_id,
      :region_id      => region_id,
      :ssh_key_ids    => ssh_key_id
    }

    Digitalocean::Droplet.create(attrs)
  end

  def self.remove_droplet(id=droplets.first.id)
    if images_count <= 0
      raise "You shouldn't be deleting droplets when having no image of a droplet to re-create droplets from."
    else
      Digitalocean::Droplet.destroy(id)
    end
  end
end
