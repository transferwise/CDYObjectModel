Given /^I am on the Welcome Screen$/ do
  element_exists("view")
  sleep(STEP_PAUSE)
end

Given /^I am logged in$/ do
  	sleep(STEP_PAUSE)
	if element_exists("button marked:'Got it'")
    	touch ("button marked:'Got it'")
    	sleep(STEP_PAUSE)
    end
  	if(element_exists("button marked:'Register'"))
  		touch("button marked:'Register'")
  		touch(query("view marked:'Your email'"))
  		username = Time.now.to_i
  		keyboard_enter_text("#{username}@transferwise.com")
  		done
  		keyboard_enter_text("banana")
  		done
  		keyboard_enter_text("banana")
  		done
  		touch(query ("button marked:'Register'"))
  		wait_for_elements_do_not_exist(["view marked:'Register'"], :timeout => 20)
  		sleep(STEP_PAUSE)
  		if(query("view marked:'No'").count() > 0)
  			touch(query("view marked:'No'"))
  			sleep(STEP_PAUSE)
  		end
  		if(query("button marked:'CloseButton'").count() > 0)
  			touch(query("button marked:'CloseButton'"))
  			sleep(STEP_PAUSE)
  		end
  		touch(query("view marked:'Profile'"))
  		touch(query("view marked:'First name'"))
  		keyboard_enter_text("Glenn")
  		done
  		keyboard_enter_text("Fish")
  		done
  		keyboard_enter_text("gbr")
  		done
  		keyboard_enter_text("#{rand(200000)} street")
  		done
  		keyboard_enter_text("n#{rand(100)} #{rand(100)}qq")
  		done
  		keyboard_enter_text("London")
  		done
  		keyboard_enter_text("#{rand(100000000)}")
  		done
  		keyboard_enter_text("#{1+rand(31)}")
  		keyboard_enter_text("12")
  		keyboard_enter_text("19#{30+rand(50)}")
  		touch("button marked:'Save'")
  		wait_for_elements_exist(["view marked:'OK'"], :timeout => 60)
  		touch("view marked:'OK'")
  		touch("view marked:'Transfers'")
  	end
  	sleep(STEP_PAUSE)
  	wait_for_elements_exist( ["view marked:'Send'"], :timeout => 2)
  
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

	sleep(STEP_PAUSE)
	if (key != "-" and value != "-")
		if(key[0,1] == ">")
			keyName = key[1,key.length-2]
		    if(query("pickerTableView view marked:'#{value}'").count < 1)
		    	touch (query("view:'DropdownCell' view text:'#{keyName}'"))
		    	sleep(STEP_PAUSE)
		    end
			touch (query("pickerTableView view marked:'#{value}'"))
			sleep(STEP_PAUSE)
			touch (query("view:'DropdownCell' view text:'#{value}'"))
		else
			touch(query("textFieldLabel {text CONTAINS '#{key}'}"))
  			keyboard_enter_text(value)
  			done
  		end
  	end
end

Given /^I wait a bit$/ do
	sleep(STEP_PAUSE)
end

Given /^I scroll the table all the way (up|down)$/ do |direction|
	sections = query("tableView", "numberOfSections")[0]
	numberOfCells =0;
	for section in 0..sections-1
		 numberOfCells = numberOfCells + query("tableView", "numberOfRowsInSection:#{section}")[0].to_i
	end
	
	if (query("tableViewCell").count() < numberOfCells)
		max_scroll_tries = 10
   		numberOfVisibleCells = query("tableViewCell").count()
   		lastCell = query("tableViewCell")[numberOfVisibleCells-1]
   		[0..max_scroll_tries].each do
   	 		scroll("tableView", direction)
			numberOfVisibleCells = query("tableViewCell").count()
    		newLastCell =  query("tableViewCell")[numberOfVisibleCells-1]
      		break if (lastCell == newLastCell)
      		lastCell = newLastCell
   		end
   		sleep(STEP_PAUSE)
   	end
end