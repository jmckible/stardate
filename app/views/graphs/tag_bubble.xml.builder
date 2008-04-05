xml.graph :showBorder=>0, :bgColor=>'ffffff', :showValues=>1, :numberPrefix=>'$', :baseFontColor=>'000000',  :outCnvBaseFontColor=>'666666' do  
  @data_points.sort.each_with_index do |point, index|
    xml.dataSet do
      xml.set :x=>index + 1 , :y=>point.value, :z=>point.number, :name=>point.name, :toolText=>"#{point.name}\n#{number_to_currency point.value}\n#{number_with_delimiter point.number} tags"
    end
  end
end