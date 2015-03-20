def enterTextToIframeInput(inputNumber, text)
	i = (uia_query :textField)[inputNumber]
	screenshot_and_raise if i.empty?
	touch(i)
	sleep(STEP_PAUSE)
	sleep(STEP_PAUSE)
	sleep(STEP_PAUSE)
	sleep(STEP_PAUSE)
	sleep(STEP_PAUSE)
	sleep(STEP_PAUSE)
	sleep(STEP_PAUSE)
	sleep(STEP_PAUSE)
end

Given /^I enter (.*) into iframe field number (.*)$/ do |value,number|
	enterTextToIframeInput(number.to_i, value)
end