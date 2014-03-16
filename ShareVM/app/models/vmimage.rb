class Vmimage < ActiveRecord::Base
  acts_as_taggable  
  acts_as_taggable_on :skills, :interests
  
  attr_accessor :file
  
  before_create :store_file
  before_destroy :destroy_file

  def full_path
    return Rails.root.join('public').to_s + self.filepath
  end
  
  private
  def store_file
    #    p "self this"
    #   p self
    self.filepath = '/attachments/' + SecureRandom.urlsafe_base64(6)
    while File.exist?(full_path) do
      self.filepath = '/attachments/' + SecureRandom.urlsafe_base64(6)  
    end
    
    File.open(full_path, "wb") do |f|
      f.write self.file.read
    end
  end
  
  def destroy_file
    begin
      File.unlink full_path
    rescue
      nil
    end
  end
  

end

