class Tti
  module Helper
    def tti(*args)
      Tti.new(*args).to_html
    end
  end
end
