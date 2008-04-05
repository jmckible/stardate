xml.graph :caption=>'In/Out for '+humanize_period(@period), :numberPrefix=>'$', :decimals=>0, :formatNumberScale=>0 do
  xml.categories do
    xml.category :label=>'Income'
    xml.category :label=>'Expenses'
  end
  
  xml.dataset do
    xml.set :value=>current_user.sum_income(@period), :color=>'00dd00'
    xml.set :value=>current_user.sum_expenses(@period)*-1, :color=>'ff0000'
  end
  
  xml.dataset do
    xml.set :value=>current_user.value_unpaid_tasks_on(@period)
  end
end