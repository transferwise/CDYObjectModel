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
  row = 0
  lastTouchedCell = cell;
  numberOfScrolls = 0
  while(cell.count() === 0 && query("collectionViewCell")[row] != lastTouchedCell && numberOfScrolls < 10)	
  	lastTouchedCell = query("collectionViewCell")[row]
  	touch(lastTouchedCell)
  	sleep(STEP_PAUSE)
  	cell = query(cellQuery)
  	row = query("collectionViewCell").count() - 4
  	numberOfScrolls = numberOfScrolls + 1
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

Given /^I select pay in method (.*)$/ do |methodName|
  if (methodName != "-")
  	sleep(STEP_PAUSE)
  	tabQuery = "button marked:'#{methodName}'"
  	tab = query(tabQuery)
  	if(tab.count > 0)
  		touch(tab[0])
  		sleep(STEP_PAUSE)
  		sleep(STEP_PAUSE)
  	end
  end
end

Given /^I confirm the transfer$/ do
  sleep(STEP_PAUSE)
  touch(query("view marked:'Confirm'"))
  sleep(STEP_PAUSE)
  if(query("view marked:'Ok'").count() > 0)
  		touch(query("view marked:'Ok'"))
  end
  wait_for_elements_exist(["view marked:'Creating transfer'"], :timeout => 20)
end

