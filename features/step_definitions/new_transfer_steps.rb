Given /^I select source (.*)$/ do |currencyCode|
  sleep(STEP_PAUSE)
  touch("tableViewCell index:0 button")
  selectCurrency(currencyCode)
end

Given /^I select target (.*)$/ do |currencyCode|
  sleep(STEP_PAUSE)
  touch("tableViewCell index:1 button")
  sleep(STEP_PAUSE)
  selectCurrency(currencyCode)
end

def selectCurrency(currencyCode)
  cellQuery = "collectionViewCell label marked:'#{currencyCode}'"	
  cell = query(cellQuery)
  numberOfRows = query("collectionView index:0", "numberOfItemsInSection:")[0] #
  row = 0
  while(cell.count() === 0 && row < numberOfRows)	
  	touch(query("collectionViewCell index:row"))
  	sleep(STEP_PAUSE)
  	cell = query(cellQuery)
  	row = row + 3
  end
  
  if (cell.count() > 0)
  	touch(query(cellQuery)[0])
  	sleep(STEP_PAUSE)
  	if(query("view marked:'Select'").count() > 0)
  		touch(query("view marked:'Select'"))
  	end
  	sleep(STEP_PAUSE)
  else
  	fail(msg="Currency #{currencyCode} not found!")
  end
end
