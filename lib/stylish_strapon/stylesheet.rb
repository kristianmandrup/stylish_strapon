module StylishStrapon
  class Stylesheet
    attr_reader :name, :path

    def initialize name, path
      @name, @path = [name, path] 
    end

    def to_s
      "name: #{name}, path: #{path}"
    end

    def import_path
      File.join path, name
    end
  end
end