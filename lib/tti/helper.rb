class Tti
  module Helper
    def tti(text, options = {})
      Tti.new(text) do |t|
        options.each do |k,v|
          t.send("#{k}=", v)
        end
      end.to_html
    end
  end
end
