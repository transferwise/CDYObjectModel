Given /^I am logged in as an american$/ do
	passWelcomeScreen()
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
		closePaymentScreen()
		if(query("button marked:'CloseButton'").count() > 0)
			touch(query("button marked:'CloseButton'"))
			sleep(STEP_PAUSE)
		end
		wait_for_elements_exist(["view marked:'Profile"], :timeout => 10)
		sleep(STEP_PAUSE)
		touch(query("view marked:'Profile'"))
		wait_for_elements_exist(["view marked:'First name'"], :timeout => 10)
		sleep(STEP_PAUSE)
		touch(query("view marked:'First name'"))
		keyboard_enter_text("Murrica")
		done
		keyboard_enter_text("Truck-Yeah")
		done
		keyboard_enter_text("usa")
		touch(query("view marked:'United States'"))
		keyboard_enter_text("ny")
		done
		keyboard_enter_text("#{rand(200000)} street")
		done
		keyboard_enter_text("1022#{rand(9)}")
		done
		keyboard_enter_text("New York")
		done
		keyboard_enter_text("#{rand(100000000)}")
		done
		keyboard_enter_text("#{10+rand(20)}")
		keyboard_enter_text("12")
		keyboard_enter_text("19#{30+rand(50)}")
		touch("button marked:'Save'")
		macro 'I wait and dismiss alert'
		touch("view marked:'Transfers'")
		sleep(STEP_PAUSE)
		wait_for_elements_exist( ["view marked:'Send'"], :timeout => 2)
	else
		macro 'I log out'
		macro 'I am logged in as an american'
	end
end
