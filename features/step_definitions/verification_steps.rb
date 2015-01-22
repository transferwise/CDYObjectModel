Given /^I skip verification if needed$/ do
  wait_for_elements_do_not_exist(["view marked:'Creating transfer'"], :timeout => 20)
	#wait for animation
	sleep(STEP_PAUSE)	
  if(query("label {text CONTAINS 'Skip'}").count > 0)
 	 touch(query("label {text CONTAINS 'Skip'}"))
    sleep(STEP_PAUSE)	
  end	
end