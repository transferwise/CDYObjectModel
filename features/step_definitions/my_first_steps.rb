Given /^I am on the Welcome Screen$/ do
  element_exists("view")
  sleep(STEP_PAUSE)
end

Given /^I am logged in$/ do
sleep(STEP_PAUSE)
  if(element_exists("button marked:'Log in'"))
  	touch("button marked:'Log in'")
  	touch(query("view marked:'Your email'"))
  	keyboard_enter_text("burkskinka@matsomatic.co.uk")
  	done
  	keyboard_enter_text "banana"
  	done
  	touch(query ("button marked:'Log in'"))
  	sleep(STEP_PAUSE)
  	wait_for_elements_exist( ["button marked:'Send'"], :timeout => 20)
  else
    if(element_exists("button marked:'Got it'"))
    	touch ("button marked:'Got it'")
    end
  end
  sleep(STEP_PAUSE)
  wait_for_elements_exist( ["view marked:'Send'"], :timeout => 2)
  
end

Given /^I select source (.*)$/ do |currencyCode|
  touch("tableViewCell index:0 button")
  sleep(STEP_PAUSE)
  selectCurrency(currencyCode)
end

Given /^I select target (.*)$/ do |currencyCode|
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
    sleep(STEP_PAUSE)	
  	touch(query(cellQuery)[0])
  	sleep(STEP_PAUSE)
  	touch(query("view marked:'Select'"))
  	sleep(STEP_PAUSE)
  else
  	fail(msg="Currency #{currencyCode} not found!")
  end
end