module BlocRecord
  def self.connect_to(filename, platform)
    @database_filename = filename
    @database_platform = platform
  end

  def self.database_filename
    @database_filename
  end

  def self.database_platform
    @database_platform
  end
end
