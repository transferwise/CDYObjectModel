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
  	keyboard_enter_text("banana")
  	done
  	touch(query ("button marked:'Log in'"))
  	wait_for_elements_do_not_exist(["view marked:'Log in'"], :timeout => 20)
  	if(query("view marked:'No'").count() > 0)
  		touch(query("view marked:'No'"))
  		sleep(STEP_PAUSE)
  	end
  else
    if(element_exists("button marked:'Got it'"))
    	touch ("button marked:'Got it'")
    end
  end
  sleep(STEP_PAUSE)
  wait_for_elements_exist( ["view marked:'Send'"], :timeout => 2)
  
end

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

Given /^I grant access to Address Book in form field (.*)$/ do |key|

# This is tricky. The typing triggers the Addressbook dialog, but also blocks pressing OK.
# By accident I found that typing a longer string seems to accept the dialog. So let's do that.

  touch(query("label {text CONTAINS '#{key}'}"))
  keyboard_enter_text("ooooooo")
  
  if(uia_query(:alert).count >0)
    uia_tap_mark 'OK'
  end
  
  sleep(STEP_PAUSE)

  keyboard_enter_char "Delete"
  keyboard_enter_char "Delete"
  keyboard_enter_char "Delete"
  keyboard_enter_char "Delete"
  keyboard_enter_char "Delete"
  keyboard_enter_char "Delete"
  keyboard_enter_char "Delete"
end	

Given /^I enter (.*) into form field (.*)$/ do |value,key|
    touch(query("label {text CONTAINS '#{key}'}"))
  	keyboard_enter_text(value)
  	done
end

Given /^I wait a bit$/ do
	sleep(STEP_PAUSE)
end